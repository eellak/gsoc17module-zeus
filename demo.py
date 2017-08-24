import datetime, sys

from flz16.crs import CRS
from flz16.prover import Prover
from flz16.verifier import Verifier
from flz16.utils import make_s_randoms, random_permutation,\
        encrypt_messages, make_tables, decrypt_messages

n = int(sys.argv[1])

start = datetime.datetime.now()

crs = CRS(n)
s_randoms = make_s_randoms(n, crs.order)
sigma = random_permutation(n)
ciphertexts = encrypt_messages(crs.order, crs.pk1, crs.pk2, list(range(n)))
prover = Prover(crs)
proof = prover.prove(n, ciphertexts, sigma, s_randoms)

verifier = Verifier(crs)
print verifier.verify(ciphertexts, proof)

TABLES = make_tables(crs.pk1, crs.pk2, crs.n)
shuffled_ms = decrypt_messages(crs.gamma, TABLES, proof['shuffled_ciphertexts'])

end = datetime.datetime.now()
print "ellapsed: %s" % (end - start)
