//
//  File.hpp
//  
//
//  Created by Taketo Sano on 2021/06/10.
//

#ifndef File_hpp
#define File_hpp

#import "basic.h"

#ifdef __cplusplus
extern "C" {
#endif

#pragma clang assume_nonnull begin

void *eigen_rat_s_init(int_t rows, int_t cols);
void eigen_rat_s_free(void *ptr);
void eigen_rat_s_copy(void *from, void *to);
void eigen_rat_s_set_entries(void *a, int_t *rows, int_t *cols, rational_t *values, int_t count);
rational_t eigen_rat_s_get_entry(void *a, int_t i, int_t j);
void eigen_rat_s_set_entry(void *a, int_t i, int_t j, rational_t r);

int_t eigen_rat_s_rows(void *a);
int_t eigen_rat_s_cols(void *a);

bool eigen_rat_s_eq(void *a, void *b);
void eigen_rat_s_add(void *a, void *b, void *c);
void eigen_rat_s_neg(void *a, void *b);
void eigen_rat_s_minus(void *a, void *b, void *c);
void eigen_rat_s_mul(void *a, void *b, void *c);
void eigen_rat_s_scal_mul(rational_t r, void *a, void *b);

int_t eigen_rat_s_nnz(void *a);
void eigen_rat_s_copy_nz(void *a, int_t *rows, int_t *cols, rational_t *values);

void eigen_rat_s_solve_lt(void *l, void *b, void *x);
void eigen_rat_s_solve_ut(void *u, void *b, void *x);

void eigen_rat_s_dump(void *ptr);

#pragma clang assume_nonnull end

#ifdef __cplusplus
}
#endif

#endif /* File_hpp */
