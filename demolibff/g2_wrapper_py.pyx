import datetime
cimport g2_wrapper_py

cpdef mul(int n):
    cdef G2Elem *g2 = new G2Elem(), *res
    cdef BigNum* bg = new BigNum()

    g2[0].init(n)

    cdef Fr[curve] elem = bg[0].get_elem()

    start = datetime.datetime.now()

    for i in range(n):
        res = g2[0].mul(elem)

    end = datetime.datetime.now()

    return end - start
