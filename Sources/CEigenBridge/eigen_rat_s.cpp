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

void eigen_rat_s_set_triplets(void *a, rational_triplet_t *triplets, int_t count) {
    Mat *A = static_cast<Mat *>(a);
    
    vector<Triplet<R>> v;
    rational_triplet_t *p = triplets;
    for (int_t i = 0; i < count; ++i, ++p) {
        Triplet<R> t(p->row, p->col, p->value);
        v.push_back(t);
    }
    
    A->setFromTriplets(v.begin(), v.end());
}

int_t eigen_rat_s_rows(void *a) {
    Mat *A = static_cast<Mat *>(a);
    return A->rows();
}

int_t eigen_rat_s_cols(void *a) {
    Mat *A = static_cast<Mat *>(a);
    return A->cols();
}

rational_t eigen_rat_s_get(void *a, int_t i, int_t j) {
    Mat *A = static_cast<Mat *>(a);
    return to_rational_t(A->coeff(i, j));
}

void eigen_rat_s_set(void *a, int_t i, int_t j, rational_t r) {
    Mat *A = static_cast<Mat *>(a);
    A->coeffRef(i, j) = RationalNum(r);
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

void eigen_rat_s_copy_nz(void *a, rational_triplet_t *array) {
    Mat *A = static_cast<Mat *>(a);
    for (int k = 0; k < A->outerSize(); ++k) {
        for (Mat::InnerIterator it(*A, k); it; ++it) {
            rational_triplet_t t = {it.row(), it.col(), to_rational_t(it.value())};
            *(array++) = t;
        }
    }
}

void eigen_rat_s_dump(void *ptr) {
    Mat *m = static_cast<Mat *>(ptr);
    cout << *m << endl;
}

