import unittest

from crs import CRS
from prover import Prover
from verifier import Verifier
from utils import make_s_randoms, random_permutation,\
        encrypt_messages, make_tables, decrypt_messages

class ProverVerifierTest(unittest.TestCase):
    def setUp(self):
        n = 10

        crs = CRS(n)
        s_randoms = make_s_randoms(n, crs.order)
        sigma = random_permutation(n)
        ciphertexts = encrypt_messages(crs.order, crs.pk1, crs.pk2, list(range(n)))
        prover = Prover(crs)
        self.proof = prover.prove(n, ciphertexts, sigma, s_randoms)
        self.crs = crs
        self.ciphertexts = ciphertexts

    def test_verifier(self):
        verifier = Verifier(self.crs)

        self.assertEqual(verifier.verify(self.ciphertexts, self.proof), (True, True, True))

        prevshuffle = self.proof['shuffled_ciphertexts']
        g1 = self.crs.lff.gen1()
        g2 = self.crs.lff.gen2()
        self.proof['shuffled_ciphertexts'][3] = ((g1, g1, g1), (g2, g2, g2))

        self.assertEqual(verifier.verify(self.ciphertexts, self.proof), (True, False, False))

        self.proof['shuffled_ciphertexts'] = prevshuffle
        self.crs.g1alpha = self.crs.g1alpha * 2
        verifier = Verifier(self.crs)

        self.assertEqual(verifier.verify(self.ciphertexts, self.proof), (False, False, False))
