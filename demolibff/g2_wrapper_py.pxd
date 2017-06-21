#language: c++

cdef extern from "g2_wrapper.h":
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

    cdef cppclass G2Elem:
        G2Elem() except +
        G2Elem(G2[curve] *el) except +

        void init(int n) except +
        G2Elem *mul(Fr[curve] s) except +
        G2Elem *add(G2Elem *other) except +
        G2[curve] get_elem()

    cdef cppclass G1Elem:
        G1Elem() except +
        G1Elem(G1[curve] *el) except +

        void init(int n) except +
        G1Elem *mul(Fr[curve] s) except +
        G1Elem *add(G1Elem *other) except +
        G1[curve] get_elem() except +

    cdef cppclass GTElem:
        GTElem() except +
        GTElem(GT[curve] *el) except +

        GT[curve] get_elem() except +
        GTElem *pair(G1Elem g1, G2Elem g2) except +

    cdef cppclass BigNum:
        BigNum() except +
        Fr[curve] get_elem() except +
