#include <vector>
#include "gmp.h"
#include "algebra/fields/bigint.hpp"
#include "algebra/curves/public_params.hpp"
#include "algebra/curves/bn128/bn128_pp.hpp"
#include "algebra/scalar_multiplication/multiexp.hpp"

using namespace libff;

typedef bn128_pp curve;
typedef bn128_G2 curveG2;

class G2Elem {
    public:
        G2Elem();
        G2Elem(G2<curve> el);

        void init(int n);
        G2Elem *mul(Fr<curve> s);
        G2Elem *add(G2Elem *other);
        G2<curve> get_elem();
    private:
        G2<curve> elem;
        size_t g2_exp_count;
        size_t g2_window_size;
        window_table<G2<curve>> g2_table;
};

class G1Elem {
    public:
        G1Elem();
        G1Elem(G1<curve> el);

        void init(int n);
        G1Elem *mul(Fr<curve> s);
        G1Elem *add(G1Elem *other);
        G1<curve> get_elem();
    private:
        G1<curve> elem;
        size_t g1_exp_count;
        size_t g1_window_size;
        window_table<G1<curve>> g1_table;
};

class GTElem {
    public:
        GTElem();
        GTElem(GT<curve> el);

        GT<curve> get_elem();
    private:
        GT<curve> elem;
};

class BigNum {
    public:
        BigNum();
        Fr<curve> get_elem();
    private:
        Fr<curve> elem;
};
