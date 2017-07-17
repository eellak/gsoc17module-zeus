from libcpp cimport bool, string


cdef extern from "libff_wrapper.h":
    cdef cppclass curve:
        pass

    cdef cppclass bignum:
        pass

    cdef cppclass fp1"bn::Fp":
        string.string toString(int)

    cdef cppclass fp2"bn::Fp2":
        string.string toString(int)

    cdef cppclass window_table[G]:
        window_table() except +
        window_table(window_table f) except +

    cdef void init_public_params "curve::init_public_params"()

    cdef cppclass Fr[curve]:
        Fr() except +
        Fr(Fr[curve] f) except +
        Fr(long long n) except +
        Fr(bignum b) except +

        Fr[curve] operator+(Fr[curve] other) except +
        Fr[curve] operator+(long long int other) except +
        Fr[curve] operator-(Fr[curve] other) except +
        Fr[curve] operator-(long long int other) except +
        Fr[curve] operator-() except +
        Fr[curve] operator*(Fr[curve] other) except +
        Fr[curve] operator*(long long other) except +
        Fr[curve] operator^(unsigned long other) except +
        bool operator==(Fr[curve] other) except +
        Fr[curve] inverse() except +
        void cprint"print"() except +

    cdef cppclass G2[curve]:
        G2() except +
        G2(G2[curve] g) except +

        G2[curve] operator+(G2[curve] other) except +
        G2[curve] operator-(G2[curve] other) except +
        bool operator==(G2[curve] other) except +
        void cprint"print"() except +
        void to_affine_coordinates() except +
        fp2 *coord

    cdef cppclass G1[curve]:
        G1() except +
        G1(G1[curve] g) except +

        G1[curve] operator+(G1[curve] other) except +
        G1[curve] operator-(G1[curve] other) except +
        bool operator==(G1 other) except +
        void cprint"print"() except +
        void to_affine_coordinates() except +
        fp1 *coord

    cdef cppclass GT[curve]:
        GT() except +
        GT(GT[curve] g) except +

        GT[curve] operator^(Fr[curve] fr) except +
        GT[curve] operator*(GT[curve] other) except +
        GT[curve] unitary_inverse() except +
        bool operator==(GT other) except +
        void cprint"print"() except +

    G1[curve] operator*(Fr[curve], G1[curve]) except +
    G2[curve] operator*(Fr[curve], G2[curve]) except +

    cdef size_t get_g2_exp_window_size(size_t g2_exp_count)
    cdef G2[curve] g2_mul(size_t window_size, window_table[G2[curve]] *g2_table, Fr[curve] other)
    cdef window_table[G2[curve]] get_g2_window_table(size_t window_size, G2[curve] elem)

    cdef size_t get_g1_exp_window_size(size_t g1_exp_count)
    cdef G1[curve] g1_mul(size_t window_size, window_table[G1[curve]] *g1_table, Fr[curve] other)
    cdef window_table[G1[curve]] get_g1_window_table(size_t window_size, G1[curve] elem)
    cdef GT[curve] reduced_pairing "curve::reduced_pairing"(G1[curve] g1, G2[curve] g2)

    cdef bignum get_order "Fr<curve>::field_char"()
    cdef Fr[curve] Fr_get_random "Fr<curve>::random_element"()
    cdef Fr[curve] Fr_get_random_nonzero()
    cdef Fr[curve] Fr_get_random_nonorder()

    cdef G1[curve] get_g1_gen "G1<curve>::one"()
    cdef G2[curve] get_g2_gen "G2<curve>::one"()

    cdef G1[curve] get_g1_zero "G1<curve>::zero"()
    cdef G2[curve] get_g2_zero "G2<curve>::zero"()

    cdef GT[curve] get_gt_one "GT<curve>::one"()
