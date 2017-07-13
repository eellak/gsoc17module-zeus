from libffpy import G1Py, G2Py
from utils import inverse_perm
from ilin2 import enc

class Prover:
    def __init__(self, crs):
        self.crs = crs

    def get_infs(self):
        inf1 = G1Py.inf()
        inf2 = G2Py.inf()
        return inf1, inf2

    def tuple_map(self, func, tpl):
        return tuple(map(func, tpl))


    def tuple_add(self, tpl1, tpl2):
        zipped = zip(tpl1, tpl2)
        return tuple(z[0] + z[1] for z in zipped)

    def step1a(self, sigma):
        crs = self.crs
        randoms = [crs.order.random() for i in range(crs.n - 1)]
        inverted_sigma = inverse_perm(sigma)

        A1 = []
        A2 = []
        for inv_i, ri in zip(inverted_sigma, randoms):
            p1_value = crs.g1_polys[inv_i]
            p2_value = crs.g2_polys[inv_i]
            a1i = p1_value + ri * crs.g1rho
            a2i = p2_value + ri * crs.g2rho
            A1.append(a1i)
            A2.append(a2i)

        return randoms, A1, A2

    def step1b(self, randoms):
        rand_n = - sum(randoms)
        randoms.append(rand_n)
        return randoms

    def step1c(self, A1, A2):
        inf1, inf2 = self.get_infs()

        prod1 = sum(A1, inf1)
        prod2 = sum(A2, inf2)

        a1n = self.crs.g1_sum - prod1
        a2n = self.crs.g2_sum - prod2

        A1.append(a1n)
        A2.append(a2n)

        return A1, A2

    def step2a(self, sigma, A1, randoms):
        crs = self.crs

        pi_1sp = []
        inverted_sigma = inverse_perm(sigma)

        for inv_i, ri, Ai1 in zip(inverted_sigma, randoms, A1):
            g1i_poly_sq = crs.g1_poly_squares[inv_i]
            v = (2 * ri) * Ai1 + (2 * ri) * crs.g1_poly_zero - (ri * ri) * crs.g1rho + g1i_poly_sq
            pi_1sp.append(v)

        return pi_1sp

    def step3a(self, sigma, ciphertexts, s_randoms):
        crs = self.crs

        v1s_prime = []
        v2s_prime = []
        for perm_i, s_random in zip(sigma, s_randoms):
            (v1, v2) = ciphertexts[perm_i]
            v1s_prime.append(self.tuple_add(v1, enc(self.crs.pk1, s_random[0], s_random[1], 0)))
            v2s_prime.append(self.tuple_add(v2, enc(self.crs.pk2, s_random[0], s_random[1], 0)))

        return list(zip(v1s_prime, v2s_prime))

    def step4a(self, s_randoms):
        crs = self.crs

        rs = tuple([crs.order.random() for i in range(2)])
        (rs1, rs2) = rs
        pi_c1_1 = rs1 * crs.g2rho
        pi_c1_2 = rs2 * crs.g2rho
        for si, g2_polyi in zip(s_randoms, crs.g2_polys):
            si1, si2 = si
            pi_c1_1 += si1 * g2_polyi
            pi_c1_2 += si2 * g2_polyi

        return rs, (pi_c1_1, pi_c1_2)

    def step4b(self, ciphertexts, rs, randoms):
        crs = self.crs

        pi_c2_1 = enc(crs.pk1, rs[0], rs[1], 0)
        pi_c2_2 = enc(crs.pk2, rs[0], rs[1], 0)
        for ciphertext, ri in zip(ciphertexts, randoms):
            v1, v2 = ciphertext
            pi_c2_1 = self.tuple_add(pi_c2_1, self.tuple_map(lambda x: ri * x, v1))
            pi_c2_2 = self.tuple_add(pi_c2_2, self.tuple_map(lambda x: ri * x, v2))

        return pi_c2_1, pi_c2_2

    def prove(self, n, ciphertexts, sigma, s_randoms):
        proof = dict.fromkeys(['shuffled_ciphertexts', 'pi_1sp', 'pi_c1_1',\
                'pi_c1_2', 'pi_c2_1', 'pi_c2_2', 'A1', 'A2'])
        randoms, A1, A2 = self.step1a(sigma)
        randoms = self.step1b(randoms)
        A1, A2 = self.step1c(A1, A2)
        proof['pi_1sp'] = self.step2a(sigma, A1, randoms)
        proof['shuffled_ciphertexts'] = self.step3a(sigma, ciphertexts, s_randoms)
        rs, (proof['pi_c1_1'], proof['pi_c1_2']) = self.step4a(s_randoms)
        proof['pi_c2_1'], proof['pi_c2_2'] = self.step4b(ciphertexts, rs, randoms)

        proof['A1'] = A1[:-1]
        proof['A2'] = A2[:-1]

        return proof
