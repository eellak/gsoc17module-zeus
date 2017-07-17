def enc(pk, s1, s2, m):
    g, h = pk
    return (s1*h, s2*(g + h), (m + s1 + s2) * g)

def dec(c, sk, table):
    c1, c2, c3 = c
    e1 = (-sk).mod_inverse()
    e2 = (-(sk + 1)).mod_inverse()
    v = (c3 + e2*c2 + e1*c1)
    return table[v]

def make_table(g, n):
    table = {}
    for i in range(n):
        elem = (i * g)
        table[elem] = i
    return table
