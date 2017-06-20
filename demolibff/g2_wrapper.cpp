#include "g2_wrapper.h"

G2Elem::G2Elem() {
    elem = G2<curve>::one();
}

G2Elem::G2Elem(G2<curve> el) {
    elem = el;
}

void G2Elem::init(int n) {
    curve::init_public_params();
    g2_exp_count = n + 6;
    g2_window_size = get_exp_window_size<G2<curve>>(g2_exp_count);
    g2_table = get_window_table(Fr<curve>::size_in_bits(), g2_window_size, elem);
}

G2<curve> G2Elem::get_elem() {
    return elem;
}

G2Elem *G2Elem::mul(Fr<curve> s) {
    G2<curve> res = G2<curve>::one();
    res = windowed_exp(Fr<curve>::size_in_bits(), g2_window_size, g2_table, s);
    G2Elem *elem_res = new G2Elem(res);
    return elem_res;
}

BigNum::BigNum() {
    elem = Fr<curve>::one();
}

Fr<curve> BigNum::get_elem() {
    return elem;
}
