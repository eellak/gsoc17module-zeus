from libffpy import LibffPy, G1Py, BigNum

import unittest

MAX = 100
class G1Test(unittest.TestCase):
    def setUp(self):
        LibffPy(MAX)

    def test_inf(self):
        inf = G1Py.inf()
        elem = G1Py()
        elem2 = elem * 10

        self.assertEqual(inf + elem, elem)
        self.assertEqual(inf + elem2, elem2)

    def mul_test(self, g1):
        # create N - 1 BigNum
        bg = [BigNum() for _ in xrange(MAX - 1)]
        # get the sum of the BigNums
        s = reduce((lambda x, y: x + y), bg)
        # Nth element of bg is order + 1 - s, so sum(bg) = order + 1
        # so g1 * bg[0] + g1 * bg[1] + ... + g1 * bg[N] == g1 * sum(bg) ==
        # == g1 * (order + 1) == g1
        bg.append(bg[0].getOrder() + 1 - s)

        res = [g1 * e for e in bg]
        s = reduce((lambda x, y: x + y), res)

        self.assertEqual(s, g1)

    def test_mul_without_window_table(self):
        # get generator
        g1 = G1Py()

        self.mul_test(g1)

    def test_mul_with_window_table(self):
        g1 = G1Py()
        g1.initWindowTable(MAX)

        self.mul_test(g1)

    def test_mul_with_int(self):
        g1 = G1Py()
        g2 = G1Py()

        self.assertEqual(g1 * 2, g2 * 2)

    def test_addition(self):
        g1 = G1Py()
        g2 = G1Py()

        self.assertEqual(g1 + g1, g2 + g2)

        self.assertNotEqual(g1, g2 + g2)

    def test_sub(self):
        g1 = G1Py()
        g2 = G1Py()
        g3 = g1 * 2 # == g2 * 2

        self.assertEqual(g3 - g1, g3 - g2)
        self.assertEqual(g1 - g3, g2 - g3)
        self.assertNotEqual(g3 - g1, g2)

    def test_hash(self):
        g1 = G1Py()
        g2 = G1Py()
        g3 = g1 * 2

        self.assertEqual(hash(g1), hash(g2))

        self.assertNotEqual(hash(g1), hash(g3))


if __name__ == '__main__':
    unittest.main()
