from libffpy import LibffPy, BigNum, GTPy

import unittest

MAX = 100

class BigNumTest(unittest.TestCase):
    def setUp(self):
        self.libff = LibffPy(MAX)
        self.g1 = self.libff.gen1()
        self.g2 = self.libff.gen2()

    def test_pair(self):
        gt1 = self.libff.pair(self.g1, self.g2)
        gt2= self.libff.pair(self.g1, self.g2)
        gt3= self.libff.pair(self.g1, self.g2 * 2)

        self.assertEqual(gt1, gt2)
        self.assertNotEqual(gt1, gt3)

    def test_pow(self):
        gt = self.libff.pair(self.g1, self.g2)
        bg = BigNum(3)

        self.assertEqual(gt ** bg, gt * gt * gt)


if __name__ == '__main__':
    unittest.main()
