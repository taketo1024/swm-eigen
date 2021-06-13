//
//  File.hpp
//  
//
//  Created by Taketo Sano on 2021/06/10.
//

#ifndef eigen_int_h
#define eigen_int_h

#import "basic.h"

#ifdef __cplusplus
extern "C" {
#endif

#pragma clang assume_nonnull begin

void *eigen_int_init(int_t rows, int_t cols);
void eigen_int_free(void *ptr);
void eigen_int_copy(void *from, void *to);
int_t eigen_int_get_entry(void *a, int_t i, int_t j);
void eigen_int_set_entry(void *a, int_t i, int_t j, int_t r);
void eigen_int_copy_entries(void *a, int_t *values);

int_t eigen_int_rows(void *a);
int_t eigen_int_cols(void *a);
bool eigen_int_is_zero(void *a);
int_t eigen_int_det(void *a);
int_t eigen_int_trace(void *a);
void eigen_int_inv(void *a, void *b);
void eigen_int_transpose(void *a, void *b);
void eigen_int_submatrix(void *a, int_t i, int_t j, int_t h, int_t w, void *b);
void eigen_int_concat(void *a, void *b, void *c);
void eigen_int_stack(void *a, void *b, void *c);
void eigen_int_perm_rows(void *a, perm_t p, void *b);
void eigen_int_perm_cols(void *a, perm_t p, void *b);

bool eigen_int_eq(void *a, void *b);
void eigen_int_add(void *a, void *b, void *c);
void eigen_int_neg(void *a, void *b);
void eigen_int_minus(void *a, void *b, void *c);
void eigen_int_mul(void *a, void *b, void *c);
void eigen_int_scal_mul(int_t r, void *a, void *b);

void eigen_int_lu(void *a, perm_t p, perm_t q, void *l, void *u);
void eigen_int_solve_lt(void *l, void *b, void *x);
void eigen_int_solve_ut(void *u, void *b, void *x);

void eigen_int_dump(void *ptr);

#pragma clang assume_nonnull end

#ifdef __cplusplus
}
#endif

#endif /* File_hpp */
