//
//  File.cpp
//  
//
//  Created by Taketo Sano on 2021/06/10.
//

#import "eigen_rat_s.h"
#import "Rational/Rational.hpp"
#import <iostream>
#import <Eigen/Eigen>

using namespace std;
using namespace Eigen;

using R = RationalNum;
using Mat = Eigen::SparseMatrix<R>;

void *eigen_rat_s_init(int_t rows, int_t cols) {
    Mat *A = new Mat(rows, cols);
    return static_cast<void *>(A);
}

void eigen_rat_s_free(void *ptr) {
    Mat *A = static_cast<Mat *>(ptr);
    delete A;
}

void eigen_rat_s_copy(void *from, void *to) {
    Mat *A = static_cast<Mat *>(from);
    Mat *B = static_cast<Mat *>(to);
    *B = *A;
}

void eigen_rat_s_set_entries(void *a, int_t *r, int_t *c, rational_t *v, int_t count) {
    Mat *A = static_cast<Mat *>(a);
    
    vector<Triplet<R>> vec;
    for (int_t i = 0; i < count; ++i, ++r, ++c, ++v) {
        Triplet<R> t(*r, *c, *v);
        vec.push_back(t);
    }
    
    A->setFromTriplets(vec.begin(), vec.end());
}

rational_t eigen_rat_s_get_entry(void *a, int_t i, int_t j) {
    Mat *A = static_cast<Mat *>(a);
    return to_rational_t(A->coeff(i, j));
}

void eigen_rat_s_set_entry(void *a, int_t i, int_t j, rational_t r) {
    Mat *A = static_cast<Mat *>(a);
    A->coeffRef(i, j) = RationalNum(r);
}

int_t eigen_rat_s_rows(void *a) {
    Mat *A = static_cast<Mat *>(a);
    return A->rows();
}

int_t eigen_rat_s_cols(void *a) {
    Mat *A = static_cast<Mat *>(a);
    return A->cols();
}

bool eigen_rat_s_eq(void *a, void *b) {
    Mat *A = static_cast<Mat *>(a);
    Mat *B = static_cast<Mat *>(b);
    return A->isApprox(*B);
}

void eigen_rat_s_add(void *a, void *b, void *c) {
    Mat *A = static_cast<Mat *>(a);
    Mat *B = static_cast<Mat *>(b);
    Mat *C = static_cast<Mat *>(c);
    *C = *A + *B;
}

void eigen_rat_s_neg(void *a, void *b) {
    Mat *A = static_cast<Mat *>(a);
    Mat *B = static_cast<Mat *>(b);
    *B = -(*A);
}

void eigen_rat_s_minus(void *a, void *b, void *c) {
    Mat *A = static_cast<Mat *>(a);
    Mat *B = static_cast<Mat *>(b);
    Mat *C = static_cast<Mat *>(c);
    *C = *A - *B;
}

void eigen_rat_s_mul(void *a, void *b, void *c) {
    Mat *A = static_cast<Mat *>(a);
    Mat *B = static_cast<Mat *>(b);
    Mat *C = static_cast<Mat *>(c);
    *C = (*A) * (*B);
}

void eigen_rat_s_scal_mul(rational_t r, void *a, void *b) {
    RationalNum r_ = RationalNum(r);
    Mat *A = static_cast<Mat *>(a);
    Mat *B = static_cast<Mat *>(b);
    *B = r_ * (*A);
}

int_t eigen_rat_s_nnz(void *a) {
    Mat *A = static_cast<Mat *>(a);
    return A->nonZeros();
}

void eigen_rat_s_copy_nz(void *a, int_t *rows, int_t *cols, rational_t *vals) {
    Mat *A = static_cast<Mat *>(a);
    for (int k = 0; k < A->outerSize(); ++k) {
        for (Mat::InnerIterator it(*A, k); it; ++it) {
            *(rows++) = it.row();
            *(cols++) = it.col();
            *(vals++) = to_rational_t(it.value());
        }
    }
}

void eigen_rat_s_dump(void *ptr) {
    Mat *m = static_cast<Mat *>(ptr);
    cout << *m << endl;
}

