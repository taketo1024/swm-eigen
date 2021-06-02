#import "ObjCEigenRationalSparseMatrix.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdocumentation"
#import <Eigen/Core>
#import <Eigen/Sparse>
#import <Eigen/SparseLU>
#pragma clang diagnostic pop

#import <iostream>
#import "Rational/Rational.hpp"

using namespace std;

using Self = ObjCEigenRationalSparseMatrix;
using Coeff = RationalNum;
using Matrix = Eigen::SparseMatrix<Coeff>;
using Triplet = Eigen::Triplet<Coeff>;
using Map = Eigen::Map<Matrix>;
using DenseMatrix = Eigen::Matrix<Coeff, Eigen::Dynamic, Eigen::Dynamic>;

@interface ObjCEigenRationalSparseMatrix ()

@property (readonly) Matrix matrix;

- (instancetype)initWithMatrix:(Matrix)matrix;

@end

@implementation ObjCEigenRationalSparseMatrix

- (instancetype)initWithMatrix:(Matrix)matrix {
    self = [super init];
    _matrix = matrix;
    return self;
}

- (instancetype)initWithRows:(int_t)rows cols:(int_t)cols triplets: (rational_triplet_t *)triplets count:(int_t) count {
    vector<Triplet> v;
    auto p = triplets;
    for (int_t i = 0; i < count; ++i, ++p) {
        Triplet t(p->row, p->col, p->value);
        v.push_back(t);
    }
    
    auto matrix = Matrix(rows, cols);
    matrix.setFromTriplets(v.begin(), v.end());
    return [self initWithMatrix:matrix];
}

- (instancetype)copy {
    Matrix copy = _matrix;
    return [[ObjCEigenRationalSparseMatrix alloc] initWithMatrix:copy];
}

- (int_t)rows {
    return _matrix.rows();
}

- (int_t)cols {
    return _matrix.cols();
}

+ (instancetype)matrixWithZeros:(int_t)rows cols:(int_t)cols {
    auto matrix = Matrix(rows, cols);
    matrix.setZero();
    return [[ObjCEigenRationalSparseMatrix alloc] initWithMatrix:matrix];
}

+ (instancetype)matrixWithIdentity:(int_t)rows cols:(int_t)cols {
    auto matrix = Matrix(rows, cols);
    matrix.setIdentity();
    return [[ObjCEigenRationalSparseMatrix alloc] initWithMatrix:matrix];
}

- (rational_t)valueAtRow:(int_t)row col:(int_t)col {
    return to_rational_t(_matrix.coeff(row, col));
}

- (void)setValue:(rational_t)value row:(int_t)row col:(int_t)col {
    _matrix.coeffRef(row, col) = RationalNum(value);
}

- (bool)isZero {
    _matrix = _matrix.pruned();
    return _matrix.nonZeros() == 0;
}

- (instancetype)transposed {
    return [[ObjCEigenRationalSparseMatrix alloc] initWithMatrix:_matrix.transpose()];
}

- (rational_t)determinant {
    @throw [NSException exceptionWithName:@"Unsupported method call" reason:nil userInfo:nil];
}

- (rational_t)trace {
    @throw [NSException exceptionWithName:@"Unsupported method call" reason:nil userInfo:nil];
}

- (instancetype)inverse {
    @throw [NSException exceptionWithName:@"Unsupported method call" reason:nil userInfo:nil];
}

-(instancetype)submatrixFromRow:(int_t)i col:(int_t)j width:(int_t)w height:(int_t)h {
    return [[ObjCEigenRationalSparseMatrix alloc] initWithMatrix:_matrix.block(i, j, w, h)];
}

- (instancetype)permuteRows:(perm_t)p {
    @throw [NSException exceptionWithName:@"Not yet implemented." reason:nil userInfo:nil];
}

- (instancetype)permuteCols:(perm_t)p {
    @throw [NSException exceptionWithName:@"Not yet implemented." reason:nil userInfo:nil];
}

- (bool)equals:(Self *)other {
    return _matrix.isApprox(other.matrix);
}

- (Self *)add:(Self *)other {
    return [[ObjCEigenRationalSparseMatrix alloc]initWithMatrix:_matrix + other.matrix];
}

- (Self *)negate {
    return [[ObjCEigenRationalSparseMatrix alloc]initWithMatrix:-_matrix];
}

- (Self *)sub:(Self *)other {
    return [[ObjCEigenRationalSparseMatrix alloc]initWithMatrix:_matrix - other.matrix];
}

- (Self *)mulLeft:(rational_t)r {
    return [[ObjCEigenRationalSparseMatrix alloc]initWithMatrix:RationalNum(r) * _matrix];
}

- (Self *)mulRight:(rational_t)r {
    return [[ObjCEigenRationalSparseMatrix alloc]initWithMatrix:_matrix * RationalNum(r)];
}

- (Self *)mul:(Self *)other {
    return [[ObjCEigenRationalSparseMatrix alloc]initWithMatrix:_matrix * other.matrix];
}

- (int_t)countNonZeros {
    return _matrix.nonZeros();
}

- (void)copyNonZerosInto:(rational_triplet_t *)array {
    for (int k = 0; k < _matrix.outerSize(); ++k) {
        for (Matrix::InnerIterator it(_matrix, k); it; ++it) {
            rational_triplet_t t = {it.row(), it.col(), to_rational_t(it.value())};
            *(array++) = t;
        }
    }
}

- (void)serializeInto:(rational_t *)array {
    int_t m = self.cols;
    for (int k = 0; k < _matrix.outerSize(); ++k) {
        for (Matrix::InnerIterator it(_matrix, k); it; ++it) {
            int idx = it.row() * m + it.col();
            array[idx] = to_rational_t(it.value());
        }
    }
}

+ (instancetype)solveLowerTriangular:(Self *)L :(Self *)b {
    auto L_ = L.matrix;
    auto b_ = DenseMatrix(b.matrix);
    auto x_ = L_.triangularView<Eigen::Lower>().solve(b_);
    auto x = x_.sparseView();
    return [[ObjCEigenRationalSparseMatrix alloc] initWithMatrix:x];
}

+ (instancetype)solveUpperTriangular:(Self *)U :(Self *)b {
    auto U_ = U.matrix;
    auto b_ = DenseMatrix(b.matrix);
    auto x_ = U_.triangularView<Eigen::Upper>().solve(b_);
    auto x = x_.sparseView();
    return [[ObjCEigenRationalSparseMatrix alloc] initWithMatrix:x];
}

@end
