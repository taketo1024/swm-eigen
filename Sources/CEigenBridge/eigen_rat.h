//
//  File.hpp
//  
//
//  Created by Taketo Sano on 2021/06/10.
//

#ifndef eigen_rat_h
#define eigen_rat_h

#import "basic.h"

#ifdef __cplusplus
extern "C" {
#endif

#pragma clang assume_nonnull begin

void *eigen_rat_init(int_t rows, int_t cols);
void eigen_rat_free(void *ptr);
void eigen_rat_copy(void *from, void *to);
rational_t eigen_rat_get_entry(void *a, int_t i, int_t j);
void eigen_rat_set_entry(void *a, int_t i, int_t j, rational_t r);
void eigen_rat_copy_entries(void *a, rational_t *values);

int_t eigen_rat_rows(void *a);
int_t eigen_rat_cols(void *a);
bool eigen_rat_is_zero(void *a);
rational_t eigen_rat_det(void *a);
rational_t eigen_rat_trace(void *a);
void eigen_rat_inv(void *a, void *b);
void eigen_rat_transpose(void *a, void *b);
void eigen_rat_submatrix(void *a, int_t i, int_t j, int_t h, int_t w, void *b);
void eigen_rat_concat(void *a, void *b, void *c);
void eigen_rat_stack(void *a, void *b, void *c);
void eigen_rat_perm_rows(void *a, perm_t p, void *b);
void eigen_rat_perm_cols(void *a, perm_t p, void *b);

bool eigen_rat_eq(void *a, void *b);
void eigen_rat_add(void *a, void *b, void *c);
void eigen_rat_neg(void *a, void *b);
void eigen_rat_minus(void *a, void *b, void *c);
void eigen_rat_mul(void *a, void *b, void *c);
void eigen_rat_scal_mul(rational_t r, void *a, void *b);

void eigen_rat_lu(void *a, perm_t p, perm_t q, void *l, void *u);
void eigen_rat_solve_lt(void *l, void *b, void *x);
void eigen_rat_solve_ut(void *u, void *b, void *x);

void eigen_rat_dump(void *ptr);

#pragma clang assume_nonnull end

#ifdef __cplusplus
}
#endif

#endif /* File_hpp */
