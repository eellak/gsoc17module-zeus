from libffpy import LibffPy, BigNum

import unittest

MAX = 100

class BigNumTest(unittest.TestCase):
    def setUp(self):
        l = LibffPy(MAX)

    def test_get_order(self):
        order = BigNum(num=0)
        self.assertEqual(BigNum.getOrder(), order)

    def test_add(self):
        first = 100
        second = 337
        bg1 = BigNum(first)
        bg2 = BigNum(second)

        self.assertEqual(bg1 + bg2, BigNum(first + second))

    def test_add_int(self):
        first = 100
        second = 337

        bg1 = BigNum(first)
        self.assertEqual(bg1 + second, BigNum(first + second))

    def test_sub(self):
        first = 100
        second = 337
        bg1 = BigNum(first)
        bg2 = BigNum(second)

        self.assertEqual(bg1 - bg2, BigNum(first - second))
        self.assertEqual(bg2 - bg1, BigNum(second - first))

    def test_sub_int(self):
        first = 100
        second = 337
        bg1 = BigNum(first)

        self.assertEqual(bg1 - second, BigNum(first - second))
        self.assertEqual(second - bg1, BigNum(second - first))

    def test_eq(self):
        first = 100
        second = 337
        bg1 = BigNum(first)
        bg2 = BigNum(second)

        self.assertEqual(bg1, BigNum(first))
        self.assertNotEqual(bg1, bg2)

    def test_pow(self):
        num = 2
        p = 2
        bg = BigNum(num) ** p

        self.assertEqual(bg, BigNum(num ** p))

    def test_mod_inverse(self):
        bg = BigNum()

        self.assertEqual(bg * bg.mod_inverse(), BigNum(1))

    def test_mul(self):
        first = 10
        second = 20

        bg1 = BigNum(first)
        bg2 = BigNum(second)

        self.assertEqual(bg1 * bg2, BigNum(first * second))

    def test_mul_int(self):
        first = 10
        second = 20

        bg = BigNum(first)

        self.assertEqual(bg * second, BigNum(first * second))

    def test_neg(self):
        num = 10

        bg = BigNum(num)

        self.assertEqual(-bg, BigNum(-num))


if __name__ == '__main__':
    unittest.main()
