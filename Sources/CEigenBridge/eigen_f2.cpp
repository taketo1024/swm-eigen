//
//  File.cpp
//  
//
//  Created by Taketo Sano on 2021/06/10.
//

#import "eigen_f2.h"
#import "types/F2.hpp"

#import <iostream>
#import <Eigen/Eigen>

using namespace std;
using namespace Eigen;

using R = F2;
using Mat = Matrix<R, Dynamic, Dynamic>;

void *eigen_f2_init(int_t rows, int_t cols) {
    Mat *A = new Mat(rows, cols);
    A->setZero();
    return static_cast<void *>(A);
}

void eigen_f2_free(void *ptr) {
    Mat *A = static_cast<Mat *>(ptr);
    delete A;
}

void eigen_f2_copy(void *from, void *to) {
    Mat *A = static_cast<Mat *>(from);
    Mat *B = static_cast<Mat *>(to);
    *B = *A;
}

uint8_t eigen_f2_get_entry(void *a, int_t i, int_t j) {
    Mat *A = static_cast<Mat *>(a);
    return A->coeff(i, j).getValue();
}

void eigen_f2_set_entry(void *a, int_t i, int_t j, uint8_t r) {
    Mat *A = static_cast<Mat *>(a);
    A->coeffRef(i, j) = F2(r);
}

void eigen_f2_copy_entries(void *a, uint8_t *vals) {
    Mat *A = static_cast<Mat *>(a);
    for(int_t i = 0; i < A->rows(); i++) {
        for(int_t j = 0; j < A->cols(); j++) {
            *(vals++) = A->coeff(i, j).getValue();
        }
    }
}

int_t eigen_f2_rows(void *a) {
    Mat *A = static_cast<Mat *>(a);
    return A->rows();
}

int_t eigen_f2_cols(void *a) {
    Mat *A = static_cast<Mat *>(a);
    return A->cols();
}

bool eigen_f2_is_zero(void *a) {
    Mat *A = static_cast<Mat *>(a);
    return A->isZero();
}

uint8_t eigen_f2_det(void *a) {
    Mat *A = static_cast<Mat *>(a);
    return A->determinant().getValue();
}

uint8_t eigen_f2_trace(void *a) {
    Mat *A = static_cast<Mat *>(a);
    return A->trace().getValue();
}

void eigen_f2_inv(void *a, void *b) {
    Mat *A = static_cast<Mat *>(a);
    Mat *B = static_cast<Mat *>(b);
    *B = A->inverse();
}


void eigen_f2_transpose(void *a, void *b) {
    Mat *A = static_cast<Mat *>(a);
    Mat *B = static_cast<Mat *>(b);
    *B = A->transpose();
}

void eigen_f2_submatrix(void *a, int_t i, int_t j, int_t h, int_t w, void *b) {
    Mat *A = static_cast<Mat *>(a);
    Mat *B = static_cast<Mat *>(b);
    *B = A->block(i, j, h, w);
}

void eigen_f2_concat(void *a, void *b, void *c) {
    Mat *A = static_cast<Mat *>(a);
    Mat *B = static_cast<Mat *>(b);
    Mat *C = static_cast<Mat *>(c);
    
    C->leftCols(A->cols()) = *A;
    C->rightCols(B->cols()) = *B;
}

void eigen_f2_stack(void *a, void *b, void *c) {
    Mat *A = static_cast<Mat *>(a);
    Mat *B = static_cast<Mat *>(b);
    Mat *C = static_cast<Mat *>(c);
    
    C->topRows(A->rows()) = *A;
    C->bottomRows(B->rows()) = *B;
}

void eigen_f2_perm_rows(void *a, perm_t p, void *b) {
    Mat *A = static_cast<Mat *>(a);
    Mat *B = static_cast<Mat *>(b);
    Eigen::VectorXi indices(p.length);
    for(int_t i = 0; i < p.length; ++i) {
        indices[i] = p.indices[i];
    }
    PermutationMatrix<Eigen::Dynamic> P(indices);
    *B = P * (*A);
}

void eigen_f2_perm_cols(void *a, perm_t p, void *b) {
    Mat *A = static_cast<Mat *>(a);
    Mat *B = static_cast<Mat *>(b);
    Eigen::VectorXi indices(p.length);
    for(int_t i = 0; i < p.length; ++i) {
        indices[i] = p.indices[i];
    }
    PermutationMatrix<Eigen::Dynamic> P(indices);
    *B = (*A) * P.transpose();
}

bool eigen_f2_eq(void *a, void *b) {
    Mat *A = static_cast<Mat *>(a);
    Mat *B = static_cast<Mat *>(b);
    return *A == *B;
}

void eigen_f2_add(void *a, void *b, void *c) {
    Mat *A = static_cast<Mat *>(a);
    Mat *B = static_cast<Mat *>(b);
    Mat *C = static_cast<Mat *>(c);
    *C = *A + *B;
}

void eigen_f2_neg(void *a, void *b) {
    Mat *A = static_cast<Mat *>(a);
    Mat *B = static_cast<Mat *>(b);
    *B = -(*A);
}

void eigen_f2_minus(void *a, void *b, void *c) {
    Mat *A = static_cast<Mat *>(a);
    Mat *B = static_cast<Mat *>(b);
    Mat *C = static_cast<Mat *>(c);
    *C = *A - *B;
}

void eigen_f2_mul(void *a, void *b, void *c) {
    Mat *A = static_cast<Mat *>(a);
    Mat *B = static_cast<Mat *>(b);
    Mat *C = static_cast<Mat *>(c);
    *C = (*A) * (*B);
}

void eigen_f2_scal_mul(uint8_t r, void *a, void *b) {
    F2 r_(r);
    Mat *A = static_cast<Mat *>(a);
    Mat *B = static_cast<Mat *>(b);
    *B = r_ * (*A);
}

void eigen_f2_lu(void *a, perm_t p, perm_t q, void *l, void *u) {
    Mat *A = static_cast<Mat *>(a);
    Mat *L = static_cast<Mat *>(l);
    Mat *U = static_cast<Mat *>(u);
    
    int_t n = A->rows();
    int_t m = A->cols();
    
    if(n == 0 || m == 0) {
        L->resize(n, 0);
        U->resize(0, m);
    } else {
        using LU = FullPivLU<Mat>;
        LU lu(*A);
        int_t r = lu.rank();

        // make P
        LU::PermutationPType::IndicesType P = lu.permutationP().indices();
        for(int_t i = 0; i < n; ++i) {
            p.indices[i] = P[i];
        }

        // make Q
        LU::PermutationQType::IndicesType Q = lu.permutationQ().indices();
        for(int_t i = 0; i < m; ++i) {
            q.indices[i] = Q[i];
        }

        // make L
        L->resize(n, r);
        L->setIdentity();
        L->triangularView<StrictlyLower>() = lu.matrixLU().block(0, 0, n, r);

        // make U
        U->resize(r, m);
        U->triangularView<Upper>() = lu.matrixLU().block(0, 0, r, m);
    }
}

void eigen_f2_solve_lt(void *l, void *b, void *x) {
    Mat *L = static_cast<Mat *>(l);
    Mat *B = static_cast<Mat *>(b);
    Mat *X = static_cast<Mat *>(x);
    
    using DMat = Matrix<R, Dynamic, Dynamic>;
    DMat b_ = *B;
    DMat x_ = L->triangularView<Lower>().solve(b_);
    
    *X = x_.sparseView();
}

void eigen_f2_solve_ut(void *u, void *b, void *x) {
    Mat *U = static_cast<Mat *>(u);
    Mat *B = static_cast<Mat *>(b);
    Mat *X = static_cast<Mat *>(x);
    
    using DMat = Matrix<R, Dynamic, Dynamic>;
    DMat b_ = *B;
    DMat x_ = U->triangularView<Upper>().solve(b_);
    
    *X = x_.sparseView();
}

void eigen_f2_dump(void *ptr) {
    Mat *m = static_cast<Mat *>(ptr);
    cout << *m << endl;
}

