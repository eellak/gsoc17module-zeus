from libffpy import LibffPy, BigNum

class CRS:
    def __init__(self, n):
        self.n = n
        self.lff = LibffPy(n)
        self.order = self.lff.order()
        self.gen1 = self.lff.gen1()
        self.gen2 = self.lff.gen2()
        self.gt = self.lff.pair(self.gen1, self.gen2)
        self.pair = self.lff.pair

        chi = self.order.random()
        alpha = self.order.random()
        rho = self.order.random(nonzero=True)
        beta = self.order.random(nonzero=True)
        self.gamma = self.order.random(nonorder=True)

        polys_all = self.generate_pis(chi, n)
        poly_zero = polys_all[0]
        polys = polys_all[1:]

        self.g1_polys = [poly * self.gen1 for poly in polys]
        self.g1rho = rho * self.gen1
        # init window table for g1rho
        self.g1rho.initWindowTable(n)

        self.g1alpha = (alpha + poly_zero) * self.gen1
        self.g1_poly_zero = poly_zero * self.gen1
        self.g1_poly_zero.initWindowTable(n)

        inv_rho = rho.mod_inverse()
        self.g1_poly_squares = []
        for poly in polys:
            nom = (poly + poly_zero) ** 2 - 1
            self.g1_poly_squares.append((nom * inv_rho) * self.gen1)

        inv_beta = beta.mod_inverse()
        g1hat = (rho * inv_beta) * self.gen1
        h1 = self.gamma * g1hat

        g1hat.initWindowTable(n)
        h1.initWindowTable(n)
        self.pk1 = (g1hat, h1)

        self.g2_polys = [poly * self.gen2 for poly in polys]
        self.g2rho = rho * self.gen2
        # init window table for g2rho
        self.g2rho.initWindowTable(n)

        self.g2alpha = (-alpha + poly_zero) * self.gen2
        h2 = self.gamma * self.gen2

        h2.initWindowTable(n)
        self.pk2 = (self.gen2, h2)

        self.g2beta = beta * self.gen2

        self.pair_alpha = self.gt ** (1 - alpha ** 2)
        poly_sum = sum([poly for poly in polys])
        self.g1_sum = poly_sum * self.gen1
        self.g2_sum = poly_sum * self.gen2

    def generate_pis(self, chi, n):
        if chi <= n + 1:
            raise ValueError(
                "chi should be greater than n + 1, chi=%s n+1=%s" % (chi, n + 1)
            )

        pis = []

        prod = BigNum(1)
        # prod = (x - w_1) (x - w_2) ... (x - w_{n+1})
        for j in range(1, n + 2):
            prod = prod * (chi - j)

        # denoms[0] = 1 / (w_1 - w_2) (w_1 - w_3) ... (w_1 - w_{n + 1})
        # denoms[1] = 1 / (w_2 - w_1) (w_2 - w_3) ... (w_2 - w_{n + 1})
        # denoms[n] = 1 / (w_{n+1}- w_1) (w_{n+1} - w_2) ... (w_{n+1} - w_n)
        denoms = self.compute_denominators(n + 1)

        missing_factor = chi - (n + 1)

        ln_plus1 = prod * missing_factor.mod_inverse()
        ln_plus1 = ln_plus1 * denoms[n].mod_inverse()

        # P_0 is special
        pis.append(ln_plus1 - BigNum(1))

        two = BigNum(2)
        for i in range(1, n + 1):
            missing_factor = chi - i
            l_i = prod * missing_factor.mod_inverse()
            l_i = l_i * denoms[i - 1].mod_inverse()
            pis.append(two * l_i + ln_plus1)

        return pis

    def compute_denominators(self, k):
        denominators = []
        temp = BigNum(1)
        for i in range(1, k + 1):
            if i == 1:
                for j in range(2, k + 1):
                    elem = i - j;
                    temp = temp * elem
            elif i == k:
                elem = 1 - k;
                temp = temp * elem
            else:
                inverse = BigNum(i - 1 - k)
                inverse = inverse.mod_inverse()
                elem = i - 1
                temp = temp * elem
                temp = temp * inverse
            denominators.append(temp)

        return denominators
