#include <vector>
#include "gmp.h"
#include "algebra/fields/bigint.hpp"
#include "algebra/curves/public_params.hpp"
#include "algebra/curves/bn128/bn128_pp.hpp"
#include "algebra/scalar_multiplication/multiexp.hpp"

using namespace libff;

typedef bn128_pp curve;

size_t get_g2_exp_window_size(size_t g2_exp_count);
window_table<G2<curve>> get_g2_window_table(size_t window_size, G2<curve> elem);
G2<curve> g2_mul(size_t window_size, window_table<G2<curve>> *g2_table, Fr<curve> other);

size_t get_g1_exp_window_size(size_t g1_exp_count);
window_table<G1<curve>> get_g1_window_table(size_t window_size, G1<curve> elem);
G1<curve> g1_mul(size_t window_size, window_table<G1<curve>> *g1_table, Fr<curve> other);

Fr<curve> Fr_get_random_nonzero();
Fr<curve> Fr_get_random_nonorder();
