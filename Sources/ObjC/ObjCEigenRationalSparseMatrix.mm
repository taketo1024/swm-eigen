#import "ObjCEigenRationalSparseMatrix.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdocumentation"
#import <Eigen/Core>
#import <Eigen/Sparse>
#pragma clang diagnostic pop

#import <iostream>
#import "Rational/Rational.hpp"

using Coeff = RationalNum;
using Matrix = Eigen::SparseMatrix<Coeff>;
using Triplet = Eigen::Triplet<Coeff>;
using Map = Eigen::Map<Matrix>;

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

- (bool)equals:(ObjCEigenRationalSparseMatrix *)other {
    return _matrix.isApprox(other.matrix);
}

- (ObjCEigenRationalSparseMatrix *)add:(ObjCEigenRationalSparseMatrix *)other {
    return [[ObjCEigenRationalSparseMatrix alloc]initWithMatrix:_matrix + other.matrix];
}

- (ObjCEigenRationalSparseMatrix *)negate {
    return [[ObjCEigenRationalSparseMatrix alloc]initWithMatrix:-_matrix];
}

- (ObjCEigenRationalSparseMatrix *)sub:(ObjCEigenRationalSparseMatrix *)other {
    return [[ObjCEigenRationalSparseMatrix alloc]initWithMatrix:_matrix - other.matrix];
}

- (ObjCEigenRationalSparseMatrix *)mulLeft:(rational_t)r {
    return [[ObjCEigenRationalSparseMatrix alloc]initWithMatrix:RationalNum(r) * _matrix];
}

- (ObjCEigenRationalSparseMatrix *)mulRight:(rational_t)r {
    return [[ObjCEigenRationalSparseMatrix alloc]initWithMatrix:_matrix * RationalNum(r)];
}

- (ObjCEigenRationalSparseMatrix *)mul:(ObjCEigenRationalSparseMatrix *)other {
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

@end
