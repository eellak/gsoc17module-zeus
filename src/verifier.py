from prover import Prover

from libffpy import GTPy

class Verifier:
    def __init__(self, crs):
        self.crs = crs

    def get_infT(self):
        return GTPy.one()

    def step1(self, prover, A1, A2):
        return prover.step1c(A1, A2)

    def step2(self):
        crs = self.crs

        p1 = [crs.order.random() for i in range(crs.n)]
        p2 = [crs.order.random() for j in range(3)]
        p3 = [[crs.order.random() for j in range(3)]
              for i in range(crs.n)]
        p4 = [crs.order.random() for j in range(3)]
        return p1, p2, p3, p4

    def step3(self, prover, A1, A2, p1, pi_1sp):
        crs = self.crs

        inf1, inf2 = prover.get_infs()
        infT = self.get_infT()
        prodT = infT
        prod1 = inf1
        sum_p = 0
        for (Ai1, Ai2, p1i, pi_1spi) in zip(A1, A2, p1, pi_1sp):
            prodT *= crs.pair(p1i * (Ai1 + crs.g1alpha), Ai2 + crs.g2alpha)
            prod1 += p1i * pi_1spi
            sum_p = sum_p + p1i
        right = crs.pair(prod1, crs.g2rho) * (crs.pair_alpha ** sum_p)
        return prodT == right

    def step4(self, prover, p2, p3, pi_c2_1, pi_c2_2, v_primes):
        crs = self.crs

        inf1, inf2 = prover.get_infs()

        def pi_c_prod(inf, pi_c2_):
            prod_c2_ = inf
            for (p2j, pi_c2_j) in zip(p2, pi_c2_):
                prod_c2_ += p2j * pi_c2_j
            return prod_c2_

        def nested_prods(inf, flag):
            outer_prod = inf
            for vi_prime, p3i in zip(v_primes, p3):
                inner_prod = inf
                vi_f_prime = vi_prime[flag]
                for (vi_f_prime_j, p3ij) in zip(vi_f_prime, p3i):
                    inner_prod += p3ij * vi_f_prime_j
                outer_prod += inner_prod
            return outer_prod

        left = crs.pair(crs.g1rho, pi_c_prod(inf2, pi_c2_2) + nested_prods(inf2, 1))
        right = crs.pair(pi_c_prod(inf1, pi_c2_1) + nested_prods(inf1, 0), crs.g2beta)
        return left == right

    def step5(self, prover, pi_c1_1, pi_c1_2, pi_c2_1, p4):
        crs = self.crs

        inf1, _ = prover.get_infs()
        g1hat, h1 = crs.pk1
        pair1 = crs.pair(g1hat, p4[1] * pi_c1_2 + p4[2] * (pi_c1_1 + pi_c1_2))
        pair2 = crs.pair(h1, p4[0] * pi_c1_1 + p4[1] * pi_c1_2)
        prod = inf1
        for (p4j, pi_c2_1j) in zip(p4, pi_c2_1):
            prod += p4j * pi_c2_1j
        pair3 = crs.pair(prod, crs.g2rho)
        return pair1 * pair2 * pair3.inv()

    def step6(self, prover, ciphertexts, v_primes, A2, p4, R):
        crs = self.crs
        def do_inner(vi):
            vi1 = vi[0]
            inf1, _ = prover.get_infs()
            inner_prod = inf1
            for (p4j, vi1j) in zip(p4, vi1):
                inner_prod += p4j * vi1j
            return inner_prod

        infT = self.get_infT()
        outer_numer = infT
        for (vi_prime, g2_poly_i) in zip(v_primes, crs.g2_polys):
            outer_numer *= crs.pair(do_inner(vi_prime), g2_poly_i)

        outer_denom = infT
        for (vi, Ai2) in zip(ciphertexts, A2):
            outer_denom *= crs.pair(do_inner(vi), Ai2)

        return outer_numer * outer_denom.inv() == R

    def verify(self, ciphertexts, proof):
        prover = Prover(self.crs)

        A1, A2 = self.step1(prover, proof['A1'], proof['A2'])
        p1, p2, p3, p4 = self.step2()
        perm_ok = self.step3(prover, A1, A2, p1, proof['pi_1sp'])
        valid = self.step4(prover, p2, p3, proof['pi_c2_1'],\
                proof['pi_c2_2'], proof['shuffled_ciphertexts'])
        R = self.step5(prover, proof['pi_c1_1'], proof['pi_c1_2'], proof['pi_c2_1'], p4)
        consistent = self.step6(prover, ciphertexts,\
                proof['shuffled_ciphertexts'], A2, p4, R)
        return perm_ok, valid, consistent
