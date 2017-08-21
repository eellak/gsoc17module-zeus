import random
import ilin2

def make_s_randoms(n, order):
    return [[order.random() for j in range(2)] for i in range(n)]

def random_permutation(n):
    system_random = random.SystemRandom()
    s = list(range(n))
    random.shuffle(s, random=system_random.random)
    return s

def encrypt(order, pk1, pk2, m):
    s1 = order.random()
    s2 = order.random()
    c1 = ilin2.enc(pk1, s1, s2, m)
    c2 = ilin2.enc(pk2, s1, s2, m)
    return c1, c2

def decrypt(cs, secret, tables):
    m1 = ilin2.dec(cs[0], secret, tables[0])
    m2 = ilin2.dec(cs[1], secret, tables[1])
    return m1, m2

def encrypt_messages(order, pk1, pk2, messages):
    return [encrypt(order, pk1, pk2, message) for message in messages]

def decrypt_messages(secret, tables, ciphertexts):
    return [decrypt(cs, secret, tables) for cs in ciphertexts]

def make_tables(pk1, pk2, n):
    table1 = ilin2.make_table(pk1[0], n)
    table2 = ilin2.make_table(pk2[0], n)
    return table1, table2

def inverse_perm(s):
    r = [None] * len(s)
    for index, value in enumerate(s):
        r[value] = index
    return r
