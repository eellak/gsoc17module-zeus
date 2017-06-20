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

G2Elem *G2Elem::add(G2Elem *other) {
    G2Elem *elem_res = new G2Elem(other->elem + this->elem);
    return elem_res;
}

G1Elem::G1Elem() {
    elem = G1<curve>::one();
}

G1Elem::G1Elem(G1<curve> el) {
    elem = el;
}

void G1Elem::init(int n) {
    curve::init_public_params();
    g1_exp_count = 4 * n + 7;
    g1_window_size = get_exp_window_size<G1<curve>>(g1_exp_count);
    g1_table = get_window_table(Fr<curve>::size_in_bits(), g1_window_size, elem);
}

G1<curve> G1Elem::get_elem() {
    return elem;
}

G1Elem *G1Elem::mul(Fr<curve> s) {
    G1<curve> res = G1<curve>::one();
    res = windowed_exp(Fr<curve>::size_in_bits(), g1_window_size, g1_table, s);
    G1Elem *elem_res = new G1Elem(res);
    return elem_res;
}

G1Elem *G1Elem::add(G1Elem *other) {
    G1Elem *elem_res = new G1Elem(other->elem + this->elem);
    return elem_res;
}

GTElem::GTElem() {}

GTElem::GTElem(GT<curve> el) {
    elem = el;
}

GT<curve> GTElem::get_elem() {
    return elem;
}

BigNum::BigNum() {
    elem = Fr<curve>::one();
}

Fr<curve> BigNum::get_elem() {
    return elem;
}
