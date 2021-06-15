//
//  File.hpp
//  
//
//  Created by Taketo Sano on 2021/06/10.
//

#ifndef eigen_dbl_h
#define eigen_dbl_h

#import "basic.h"

#ifdef __cplusplus
extern "C" {
#endif

#pragma clang assume_nonnull begin

void *eigen_dbl_init(int_t rows, int_t cols);
void eigen_dbl_free(void *ptr);
void eigen_dbl_copy(void *from, void *to);
double eigen_dbl_get_entry(void *a, int_t i, int_t j);
void eigen_dbl_set_entry(void *a, int_t i, int_t j, double r);
void eigen_dbl_copy_entries(void *a, double *values);

int_t eigen_dbl_rows(void *a);
int_t eigen_dbl_cols(void *a);
bool eigen_dbl_is_zero(void *a);
double eigen_dbl_det(void *a);
double eigen_dbl_trace(void *a);
void eigen_dbl_inv(void *a, void *b);
void eigen_dbl_transpose(void *a, void *b);
void eigen_dbl_submatrix(void *a, int_t i, int_t j, int_t h, int_t w, void *b);
void eigen_dbl_concat(void *a, void *b, void *c);
void eigen_dbl_stack(void *a, void *b, void *c);
void eigen_dbl_perm_rows(void *a, perm_t p, void *b);
void eigen_dbl_perm_cols(void *a, perm_t p, void *b);

bool eigen_dbl_eq(void *a, void *b);
void eigen_dbl_add(void *a, void *b, void *c);
void eigen_dbl_neg(void *a, void *b);
void eigen_dbl_minus(void *a, void *b, void *c);
void eigen_dbl_mul(void *a, void *b, void *c);
void eigen_dbl_scal_mul(double r, void *a, void *b);

void eigen_dbl_lu(void *a, perm_t p, perm_t q, void *l, void *u);
void eigen_dbl_solve_lt(void *l, void *b, void *x);
void eigen_dbl_solve_ut(void *u, void *b, void *x);

void eigen_dbl_dump(void *ptr);

#pragma clang assume_nonnull end

#ifdef __cplusplus
}
#endif

#endif /* File_hpp */
