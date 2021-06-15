//
//  File.cpp
//  
//
//  Created by Taketo Sano on 2021/06/10.
//

#import "eigen_s_dbl.h"

#import <iostream>
#import <Eigen/Eigen>

using namespace std;
using namespace Eigen;

using R = double;
using Mat = SparseMatrix<R>;

void *eigen_s_dbl_init(int_t rows, int_t cols) {
    Mat *A = new Mat(rows, cols);
    A->setZero();
    return static_cast<void *>(A);
}

void eigen_s_dbl_free(void *ptr) {
    Mat *A = static_cast<Mat *>(ptr);
    delete A;
}

void eigen_s_dbl_copy(void *from, void *to) {
    Mat *A = static_cast<Mat *>(from);
    Mat *B = static_cast<Mat *>(to);
    *B = *A;
}

void eigen_s_dbl_copy_from_dense(void *from, void *to) {
    using DMat = Matrix<R, Dynamic, Dynamic>;
    DMat *A = static_cast<DMat *>(from);
    Mat *B = static_cast<Mat *>(to);
    *B = A->sparseView();
}

void eigen_s_dbl_copy_to_dense(void *from, void *to) {
    using DMat = Matrix<R, Dynamic, Dynamic>;
    Mat *A = static_cast<Mat *>(from);
    DMat *B = static_cast<DMat *>(to);
    *B = *A;
}

void eigen_s_dbl_set_entries(void *a, int_t *r, int_t *c, double *v, int_t count) {
    Mat *A = static_cast<Mat *>(a);
    
    vector<Triplet<R>> vec;
    for (int_t i = 0; i < count; ++i, ++r, ++c, ++v) {
        Triplet<R> t(*r, *c, *v);
        vec.push_back(t);
    }
    
    A->setFromTriplets(vec.begin(), vec.end());
}

double eigen_s_dbl_get_entry(void *a, int_t i, int_t j) {
    Mat *A = static_cast<Mat *>(a);
    return A->coeff(i, j);
}

void eigen_s_dbl_set_entry(void *a, int_t i, int_t j, double r) {
    Mat *A = static_cast<Mat *>(a);
    A->coeffRef(i, j) = r;
}

int_t eigen_s_dbl_rows(void *a) {
    Mat *A = static_cast<Mat *>(a);
    return A->rows();
}

int_t eigen_s_dbl_cols(void *a) {
    Mat *A = static_cast<Mat *>(a);
    return A->cols();
}

void eigen_s_dbl_transpose(void *a, void *b) {
    Mat *A = static_cast<Mat *>(a);
    Mat *B = static_cast<Mat *>(b);
    *B = A->transpose();
}

void eigen_s_dbl_submatrix(void *a, int_t i, int_t j, int_t h, int_t w, void *b) {
    Mat *A = static_cast<Mat *>(a);
    Mat *B = static_cast<Mat *>(b);
    *B = A->block(i, j, h, w);
}

void eigen_s_dbl_concat(void *a, void *b, void *c) {
    Mat *A = static_cast<Mat *>(a);
    Mat *B = static_cast<Mat *>(b);
    Mat *C = static_cast<Mat *>(c);
    
    C->leftCols(A->cols()) = *A;
    C->rightCols(B->cols()) = *B;
}

void eigen_s_dbl_perm_rows(void *a, perm_t p, void *b) {
    Mat *A = static_cast<Mat *>(a);
    Mat *B = static_cast<Mat *>(b);
    Eigen::VectorXi indices(p.length);
    for(int_t i = 0; i < p.length; ++i) {
        indices[i] = p.indices[i];
    }
    PermutationMatrix<Eigen::Dynamic> P(indices);
    *B = P * (*A);
}

void eigen_s_dbl_perm_cols(void *a, perm_t p, void *b) {
    Mat *A = static_cast<Mat *>(a);
    Mat *B = static_cast<Mat *>(b);
    Eigen::VectorXi indices(p.length);
    for(int_t i = 0; i < p.length; ++i) {
        indices[i] = p.indices[i];
    }
    PermutationMatrix<Eigen::Dynamic> P(indices);
    *B = (*A) * P.transpose();
}

bool eigen_s_dbl_eq(void *a, void *b) {
    Mat *A = static_cast<Mat *>(a);
    Mat *B = static_cast<Mat *>(b);
    return A->isApprox(*B);
}

void eigen_s_dbl_add(void *a, void *b, void *c) {
    Mat *A = static_cast<Mat *>(a);
    Mat *B = static_cast<Mat *>(b);
    Mat *C = static_cast<Mat *>(c);
    *C = *A + *B;
}

void eigen_s_dbl_neg(void *a, void *b) {
    Mat *A = static_cast<Mat *>(a);
    Mat *B = static_cast<Mat *>(b);
    *B = -(*A);
}

void eigen_s_dbl_minus(void *a, void *b, void *c) {
    Mat *A = static_cast<Mat *>(a);
    Mat *B = static_cast<Mat *>(b);
    Mat *C = static_cast<Mat *>(c);
    *C = *A - *B;
}

void eigen_s_dbl_mul(void *a, void *b, void *c) {
    Mat *A = static_cast<Mat *>(a);
    Mat *B = static_cast<Mat *>(b);
    Mat *C = static_cast<Mat *>(c);
    *C = (*A) * (*B);
}

void eigen_s_dbl_scal_mul(double r, void *a, void *b) {
    Mat *A = static_cast<Mat *>(a);
    Mat *B = static_cast<Mat *>(b);
    *B = r * (*A);
}

int_t eigen_s_dbl_nnz(void *a) {
    Mat *A = static_cast<Mat *>(a);
    A->prune(0.0);
    return A->nonZeros();
}

void eigen_s_dbl_copy_nz(void *a, int_t *rows, int_t *cols, double *vals) {
    Mat *A = static_cast<Mat *>(a);
    A->prune(0.0);
    for (int k = 0; k < A->outerSize(); ++k) {
        for (Mat::InnerIterator it(*A, k); it; ++it) {
            *(rows++) = it.row();
            *(cols++) = it.col();
            *(vals++) = it.value();
        }
    }
}

void eigen_s_dbl_solve_lt(void *l, void *b, void *x) {
    Mat *L = static_cast<Mat *>(l);
    Mat *B = static_cast<Mat *>(b);
    Mat *X = static_cast<Mat *>(x);
    
    using DMat = Matrix<R, Dynamic, Dynamic>;
    DMat b_ = *B;
    DMat x_ = L->triangularView<Lower>().solve(b_);
    
    *X = x_.sparseView();
}

void eigen_s_dbl_solve_ut(void *u, void *b, void *x) {
    Mat *U = static_cast<Mat *>(u);
    Mat *B = static_cast<Mat *>(b);
    Mat *X = static_cast<Mat *>(x);
    
    using DMat = Matrix<R, Dynamic, Dynamic>;
    DMat b_ = *B;
    DMat x_ = U->triangularView<Upper>().solve(b_);
    
    *X = x_.sparseView();
}

void eigen_s_dbl_dump(void *ptr) {
    Mat *m = static_cast<Mat *>(ptr);
    cout << *m << endl;
}

