import datetime
cimport g2_wrapper_py

cdef class G1Py:
    cdef G1Elem *_thisptr

    def __cinit__(self, int n):
        self._thisptr = new G1Elem()
        self._thisptr[0].init(n)

    def __dealloc__(self):
        if self._thisptr != NULL:
            del self._thisptr

    cdef G1Elem getElem(self):
        return self._thisptr[0]

cdef class G2Py:
    cdef G2Elem *_thisptr

    def __cinit__(self, int n):
        self._thisptr = new G2Elem()
        self._thisptr[0].init(n)

    def __dealloc__(self):
        if self._thisptr != NULL:
            del self._thisptr

    cdef G2Elem getElem(self):
        return self._thisptr[0]


cdef class GTPy:
    cdef GTElem *_thisptr

    def __cinit__(self):
        self._thisptr = new GTElem()

    def __dealloc__(self):
        if self._thisptr != NULL:
            del self._thisptr

    def pair(self, G1Py g1, G2Py g2):
        cdef G1Elem g1_elem = g1.getElem()
        cdef G2Elem g2_elem = g2.getElem()

        cdef GTElem *newptr;

        newptr = self._thisptr[0].pair(g1_elem, g2_elem)
        self._thisptr = newptr


cdef class LibffPy:
    cdef G1Py g1
    cdef G2Py g2

    def __init__(self, int n):
        init_public_params()
        self.g1 = G1Py(n)
        self.g2 = G2Py(n)

    def gen1(self):
        return self.g1

    def gen2(self):
        return self.g2

    def pair(self, G1Py g1, G2Py g2):
        gt = GTPy()
        gt.pair(g1, g2)
        return gt
