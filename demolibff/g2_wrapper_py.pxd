#language: c++

cdef extern from "g2_wrapper.h":
    cdef cppclass curve:
        pass

    cdef cppclass Fr[curve]:
        pass

    cdef cppclass G2[curve]:
        pass

    cdef cppclass G2Elem:
        G2Elem() except +
        G2Elem(G2[curve] *el) except +

        void init(int n) except +
        G2Elem *mul(Fr[curve] s) except +
        G2[curve] *get_elem();

    cdef cppclass BigNum:
        BigNum();
        Fr[curve] get_elem();
