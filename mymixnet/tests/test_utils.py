import unittest

from libffpy.libffpy import LibffPy, BigNum
from utils import make_tables, encrypt, decrypt

class UtilsTest(unittest.TestCase):
    def setUp(self):
        self.MAX = 1000
        self.lff = LibffPy(self.MAX)

    def key_gen(self, g, sk):
        h = g * sk
        return (g, h)

    def test_make_tables(self):
        sk = BigNum.getOrder().random()
        pk1 = self.key_gen(self.lff.gen1(), sk)
        pk2 = self.key_gen(self.lff.gen2(), sk)
        table1, table2 = make_tables(pk1, pk2, self.MAX)

        self.assertEqual(table1[666 * pk1[0]], 666)
        self.assertEqual(table2[666 * pk2[0]], 666)

        self.assertNotEqual(table1[2 * pk1[0]], 666)
        self.assertNotEqual(table2[3 * pk2[0]], 666)

    def test_encdec(self):
        sk = BigNum.getOrder().random()

        pk1 = self.key_gen(self.lff.gen1(), sk)
        pk2 = self.key_gen(self.lff.gen2(), sk)

        order = BigNum.getOrder()
        c1, c2 = encrypt(order, pk1, pk2, 666)

        tables = make_tables(pk1, pk2, self.MAX)
        self.assertEqual(decrypt((c1, c2), sk, tables), (666, 666))

        import random
        ps = random.sample(range(self.MAX), 100)
        for i in range(100):
            c1, c2 = encrypt(order, pk1, pk2, ps[i])
            self.assertEqual(decrypt((c1, c2), sk, tables), (ps[i], ps[i]))
