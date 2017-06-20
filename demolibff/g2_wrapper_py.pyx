import datetime
cimport g2_wrapper_py

def demoG2(int n):
    cdef G2Elem *g2 = new G2Elem(), *other = new G2Elem(), *res
    cdef BigNum* bg = new BigNum()

    g2[0].init(n)

    cdef Fr[curve] elem = bg[0].get_elem()

    start = datetime.datetime.now()

    for i in range(n):
        res = g2[0].mul(elem)

    end = datetime.datetime.now()

    print ("multiplication - G2: %s" % (end - start))

    start = datetime.datetime.now()

    for i in range(n):
        res = g2[0].add(other)

    end = datetime.datetime.now()

    print ("addition - G2: %s" % (end - start))

def demoG1(int n):
    cdef G1Elem *g1 = new G1Elem(), *other = new G1Elem(), *res
    cdef BigNum* bg = new BigNum()

    g1[0].init(n)

    cdef Fr[curve] elem = bg[0].get_elem()

    start = datetime.datetime.now()

    for i in range(n):
        res = g1[0].mul(elem)

    end = datetime.datetime.now()

    print ("multiplication - G1: %s" % (end - start))

    start = datetime.datetime.now()

    for i in range(n):
        res = g1[0].add(other)

    end = datetime.datetime.now()

    print ("addition - G1: %s" % (end - start))
