//
//  File.hpp
//  
//
//  Created by Taketo Sano on 2021/06/10.
//

#ifndef eigen_s_rat_h
#define eigen_s_rat_h

#import "basic.h"

#ifdef __cplusplus
extern "C" {
#endif

#pragma clang assume_nonnull begin

void *eigen_s_rat_init(int_t rows, int_t cols);
void eigen_s_rat_free(void *ptr);
void eigen_s_rat_copy(void *from, void *to);
void eigen_s_rat_set_entries(void *a, int_t *rows, int_t *cols, rational_t *values, int_t count);
rational_t eigen_s_rat_get_entry(void *a, int_t i, int_t j);
void eigen_s_rat_set_entry(void *a, int_t i, int_t j, rational_t r);

int_t eigen_s_rat_rows(void *a);
int_t eigen_s_rat_cols(void *a);
void eigen_s_rat_transpose(void *a, void *b);
void eigen_s_rat_submatrix(void *a, int_t i, int_t j, int_t h, int_t w, void *b);
void eigen_s_rat_concat(void *a, void *b, void *c);
void eigen_s_rat_perm_rows(void *a, perm_t p, void *b);
void eigen_s_rat_perm_cols(void *a, perm_t p, void *b);

bool eigen_s_rat_eq(void *a, void *b);
void eigen_s_rat_add(void *a, void *b, void *c);
void eigen_s_rat_neg(void *a, void *b);
void eigen_s_rat_minus(void *a, void *b, void *c);
void eigen_s_rat_mul(void *a, void *b, void *c);
void eigen_s_rat_scal_mul(rational_t r, void *a, void *b);

int_t eigen_s_rat_nnz(void *a);
void eigen_s_rat_copy_nz(void *a, int_t *rows, int_t *cols, rational_t *values);

void eigen_s_rat_solve_lt(void *l, void *b, void *x);
void eigen_s_rat_solve_ut(void *u, void *b, void *x);

void eigen_s_rat_dump(void *ptr);

#pragma clang assume_nonnull end

#ifdef __cplusplus
}
#endif

#endif /* File_hpp */
