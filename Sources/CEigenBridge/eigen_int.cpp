//
//  File.cpp
//  
//
//  Created by Taketo Sano on 2021/06/10.
//

#import "eigen_int.h"
#import "types/Rational.hpp"

#import <iostream>
#import <Eigen/Eigen>

using namespace std;
using namespace Eigen;

using R = int_t;
using Mat = Matrix<R, Dynamic, Dynamic>;

void *eigen_int_init(int_t rows, int_t cols) {
    Mat *A = new Mat(rows, cols);
    A->setZero();
    return static_cast<void *>(A);
}

void eigen_int_free(void *ptr) {
    Mat *A = static_cast<Mat *>(ptr);
    delete A;
}

void eigen_int_copy(void *from, void *to) {
    Mat *A = static_cast<Mat *>(from);
    Mat *B = static_cast<Mat *>(to);
    *B = *A;
}

int_t eigen_int_get_entry(void *a, int_t i, int_t j) {
    Mat *A = static_cast<Mat *>(a);
    return int_t(A->coeff(i, j));
}

void eigen_int_set_entry(void *a, int_t i, int_t j, int_t r) {
    Mat *A = static_cast<Mat *>(a);
    A->coeffRef(i, j) = r;
}

void eigen_int_copy_entries(void *a, int_t *vals) {
    Mat *A = static_cast<Mat *>(a);
    for(int_t i = 0; i < A->rows(); i++) {
        for(int_t j = 0; j < A->cols(); j++) {
            *(vals++) = A->coeff(i, j);
        }
    }
}

int_t eigen_int_rows(void *a) {
    Mat *A = static_cast<Mat *>(a);
    return A->rows();
}

int_t eigen_int_cols(void *a) {
    Mat *A = static_cast<Mat *>(a);
    return A->cols();
}

bool eigen_int_is_zero(void *a) {
    Mat *A = static_cast<Mat *>(a);
    return A->isZero();
}

int_t eigen_int_det(void *a) {
    Mat *A = static_cast<Mat *>(a);
    RationalNum det = A->cast<RationalNum>().determinant();
    return det.getNumerator();
}

int_t eigen_int_trace(void *a) {
    Mat *A = static_cast<Mat *>(a);
    return int_t(A->trace());
}

void eigen_int_inv(void *a, void *b) {
    Mat *A = static_cast<Mat *>(a);
    Mat *B = static_cast<Mat *>(b);
    
    using RMat = Matrix<RationalNum, Dynamic, Dynamic>;
    RMat rmat = A->cast<RationalNum>();
    *B = rmat.inverse().cast<int_t>();
}

void eigen_int_transpose(void *a, void *b) {
    Mat *A = static_cast<Mat *>(a);
    Mat *B = static_cast<Mat *>(b);
    *B = A->transpose();
}

void eigen_int_submatrix(void *a, int_t i, int_t j, int_t h, int_t w, void *b) {
    Mat *A = static_cast<Mat *>(a);
    Mat *B = static_cast<Mat *>(b);
    *B = A->block(i, j, h, w);
}

void eigen_int_concat(void *a, void *b, void *c) {
    Mat *A = static_cast<Mat *>(a);
    Mat *B = static_cast<Mat *>(b);
    Mat *C = static_cast<Mat *>(c);
    
    C->leftCols(A->cols()) = *A;
    C->rightCols(B->cols()) = *B;
}

void eigen_int_stack(void *a, void *b, void *c) {
    Mat *A = static_cast<Mat *>(a);
    Mat *B = static_cast<Mat *>(b);
    Mat *C = static_cast<Mat *>(c);
    
    C->topRows(A->rows()) = *A;
    C->bottomRows(B->rows()) = *B;
}

void eigen_int_perm_rows(void *a, perm_t p, void *b) {
    Mat *A = static_cast<Mat *>(a);
    Mat *B = static_cast<Mat *>(b);
    Eigen::VectorXi indices(p.length);
    for(int_t i = 0; i < p.length; ++i) {
        indices[i] = p.indices[i];
    }
    PermutationMatrix<Eigen::Dynamic> P(indices);
    *B = P * (*A);
}

void eigen_int_perm_cols(void *a, perm_t p, void *b) {
    Mat *A = static_cast<Mat *>(a);
    Mat *B = static_cast<Mat *>(b);
    Eigen::VectorXi indices(p.length);
    for(int_t i = 0; i < p.length; ++i) {
        indices[i] = p.indices[i];
    }
    PermutationMatrix<Eigen::Dynamic> P(indices);
    *B = (*A) * P.transpose();
}

bool eigen_int_eq(void *a, void *b) {
    Mat *A = static_cast<Mat *>(a);
    Mat *B = static_cast<Mat *>(b);
    return *A == *B;
}

void eigen_int_add(void *a, void *b, void *c) {
    Mat *A = static_cast<Mat *>(a);
    Mat *B = static_cast<Mat *>(b);
    Mat *C = static_cast<Mat *>(c);
    *C = *A + *B;
}

void eigen_int_neg(void *a, void *b) {
    Mat *A = static_cast<Mat *>(a);
    Mat *B = static_cast<Mat *>(b);
    *B = -(*A);
}

void eigen_int_minus(void *a, void *b, void *c) {
    Mat *A = static_cast<Mat *>(a);
    Mat *B = static_cast<Mat *>(b);
    Mat *C = static_cast<Mat *>(c);
    *C = *A - *B;
}

void eigen_int_mul(void *a, void *b, void *c) {
    Mat *A = static_cast<Mat *>(a);
    Mat *B = static_cast<Mat *>(b);
    Mat *C = static_cast<Mat *>(c);
    *C = (*A) * (*B);
}

void eigen_int_scal_mul(int_t r, void *a, void *b) {
    Mat *A = static_cast<Mat *>(a);
    Mat *B = static_cast<Mat *>(b);
    *B = r * (*A);
}

void eigen_int_dump(void *ptr) {
    Mat *m = static_cast<Mat *>(ptr);
    cout << *m << endl;
}

