//
//  File.hpp
//  
//
//  Created by Taketo Sano on 2021/06/10.
//

#ifndef eigen_s_dbl_h
#define eigen_s_dbl_h

#import "basic.h"

#ifdef __cplusplus
extern "C" {
#endif

#pragma clang assume_nonnull begin

void *eigen_s_dbl_init(int_t rows, int_t cols);
void eigen_s_dbl_free(void *ptr);
void eigen_s_dbl_copy(void *from, void *to);
void eigen_s_dbl_copy_from_dense(void *from, void *to);
void eigen_s_dbl_copy_to_dense(void *from, void *to);

void eigen_s_dbl_set_entries(void *a, int_t *rows, int_t *cols, double *values, int_t count);
double eigen_s_dbl_get_entry(void *a, int_t i, int_t j);
void eigen_s_dbl_set_entry(void *a, int_t i, int_t j, double r);

int_t eigen_s_dbl_rows(void *a);
int_t eigen_s_dbl_cols(void *a);
void eigen_s_dbl_transpose(void *a, void *b);
void eigen_s_dbl_submatrix(void *a, int_t i, int_t j, int_t h, int_t w, void *b);
void eigen_s_dbl_concat(void *a, void *b, void *c);
void eigen_s_dbl_perm_rows(void *a, perm_t p, void *b);
void eigen_s_dbl_perm_cols(void *a, perm_t p, void *b);

bool eigen_s_dbl_eq(void *a, void *b);
void eigen_s_dbl_add(void *a, void *b, void *c);
void eigen_s_dbl_neg(void *a, void *b);
void eigen_s_dbl_minus(void *a, void *b, void *c);
void eigen_s_dbl_mul(void *a, void *b, void *c);
void eigen_s_dbl_scal_mul(double r, void *a, void *b);

int_t eigen_s_dbl_nnz(void *a);
void eigen_s_dbl_copy_nz(void *a, int_t *rows, int_t *cols, double *values);

void eigen_s_dbl_solve_lt(void *l, void *b, void *x);
void eigen_s_dbl_solve_ut(void *u, void *b, void *x);

void eigen_s_dbl_dump(void *ptr);

#pragma clang assume_nonnull end

#ifdef __cplusplus
}
#endif

#endif /* File_hpp */
