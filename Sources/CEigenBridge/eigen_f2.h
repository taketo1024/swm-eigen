//
//  File.hpp
//  
//
//  Created by Taketo Sano on 2021/06/10.
//

#ifndef eigen_f2_h
#define eigen_f2_h

#import "basic.h"

#ifdef __cplusplus
extern "C" {
#endif

#pragma clang assume_nonnull begin

void *eigen_f2_init(int_t rows, int_t cols);
void eigen_f2_free(void *ptr);
void eigen_f2_copy(void *from, void *to);
uint8_t eigen_f2_get_entry(void *a, int_t i, int_t j);
void eigen_f2_set_entry(void *a, int_t i, int_t j, uint8_t r);
void eigen_f2_copy_entries(void *a, uint8_t *values);

int_t eigen_f2_rows(void *a);
int_t eigen_f2_cols(void *a);
bool eigen_f2_is_zero(void *a);
uint8_t eigen_f2_det(void *a);
uint8_t eigen_f2_trace(void *a);
void eigen_f2_inv(void *a, void *b);
void eigen_f2_transpose(void *a, void *b);
void eigen_f2_submatrix(void *a, int_t i, int_t j, int_t h, int_t w, void *b);
void eigen_f2_concat(void *a, void *b, void *c);
void eigen_f2_stack(void *a, void *b, void *c);
void eigen_f2_perm_rows(void *a, perm_t p, void *b);
void eigen_f2_perm_cols(void *a, perm_t p, void *b);

bool eigen_f2_eq(void *a, void *b);
void eigen_f2_add(void *a, void *b, void *c);
void eigen_f2_neg(void *a, void *b);
void eigen_f2_minus(void *a, void *b, void *c);
void eigen_f2_mul(void *a, void *b, void *c);
void eigen_f2_scal_mul(uint8_t r, void *a, void *b);

void eigen_f2_lu(void *a, perm_t p, perm_t q, void *l, void *u);
void eigen_f2_solve_lt(void *l, void *b, void *x);
void eigen_f2_solve_ut(void *u, void *b, void *x);

void eigen_f2_dump(void *ptr);

#pragma clang assume_nonnull end

#ifdef __cplusplus
}
#endif

#endif /* File_hpp */
