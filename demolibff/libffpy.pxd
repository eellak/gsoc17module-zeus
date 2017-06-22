#language: c++
from libcpp cimport bool

cdef extern from "libff_wrapper.h":
    cdef cppclass curve:
        pass

    cdef void init_public_params "curve::init_public_params"()

    cdef cppclass Fr[curve]:
        pass

    cdef cppclass G2[curve]:
        pass

    cdef cppclass G1[curve]:
        pass

    cdef cppclass GT[curve]:
        pass

    cdef cppclass BigNum:
        BigNum() except +

        BigNum *add(BigNum *other) except +
        BigNum *sub(BigNum *other) except +

    cdef BigNum *get_order "BigNum::get_order"()

    cdef cppclass G2Elem:
        G2Elem() except +
        G2Elem(G2[curve] *el) except +

        void init(int n) except +
        G2Elem *mul(BigNum *s) except +
        G2Elem *add(G2Elem *other) except +
        bool eq(G2Elem *other) except +

    cdef cppclass G1Elem:
        G1Elem() except +
        G1Elem(G1[curve] *el) except +

        void init(int n) except +
        G1Elem *mul(BigNum *s) except +
        G1Elem *add(G1Elem *other) except +

    cdef cppclass GTElem:
        GTElem() except +
        GTElem(GT[curve] *el) except +

        GTElem *pair(G1Elem *g1, G2Elem *g2) except +
