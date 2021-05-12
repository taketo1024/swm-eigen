#import "ObjCEigenDoubleMatrix.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdocumentation"
#import <Eigen/Core>
#import <Eigen/LU>
#pragma clang diagnostic pop

#import <iostream>

using Coeff = double;
using Matrix = Eigen::Matrix<Coeff, Eigen::Dynamic, Eigen::Dynamic>;
using Map = Eigen::Map<Matrix>;

@interface ObjCEigenDoubleMatrix ()

@property (readonly) Matrix matrix;

- (instancetype)initWithMatrix:(Matrix)matrix;

@end

@implementation ObjCEigenDoubleMatrix

- (instancetype)initWithMatrix:(Matrix)matrix {
    self = [super init];
    _matrix = matrix;
    return self;
}

- (instancetype)copy {
    Matrix copy = _matrix;
    return [[ObjCEigenDoubleMatrix alloc] initWithMatrix:copy];
}

- (int_t)rows {
    return _matrix.rows();
}

- (int_t)cols {
    return _matrix.cols();
}

+ (instancetype)matrixWithZeros:(int_t)rows cols:(int_t)cols {
    return [[ObjCEigenDoubleMatrix alloc] initWithMatrix:Matrix::Zero(rows, cols)];
}

+ (instancetype)matrixWithIdentity:(int_t)rows cols:(int_t)cols {
    return [[ObjCEigenDoubleMatrix alloc] initWithMatrix:Matrix::Identity(rows, cols)];
}

- (Coeff)valueAtRow:(int_t)row col:(int_t)col {
    return _matrix(row, col);
}

- (void)setValue:(Coeff)value row:(int_t)row col:(int_t)col {
    _matrix(row, col) = value;
}

- (bool)isZero {
    _matrix.isZero(0);
}

- (instancetype)transposed {
    return [[ObjCEigenDoubleMatrix alloc] initWithMatrix:_matrix.transpose()];
}

- (Coeff)determinant {
    return _matrix.determinant();
}

- (Coeff)trace {
    return _matrix.trace();
}

- (instancetype)inverse {
    return [[ObjCEigenDoubleMatrix alloc] initWithMatrix:_matrix.inverse()];
}

-(instancetype)submatrixFromRow:(int_t)i col:(int_t)j width:(int_t)w height:(int_t)h {
    return [[ObjCEigenDoubleMatrix alloc] initWithMatrix:_matrix.block(i, j, w, h)];
}

- (bool)equals:(ObjCEigenDoubleMatrix *)other {
    return _matrix == other.matrix;
}

- (ObjCEigenDoubleMatrix *)add:(ObjCEigenDoubleMatrix *)other {
    return [[ObjCEigenDoubleMatrix alloc]initWithMatrix:_matrix + other.matrix];
}

- (ObjCEigenDoubleMatrix *)negate {
    return [[ObjCEigenDoubleMatrix alloc]initWithMatrix:-_matrix];
}

- (ObjCEigenDoubleMatrix *)sub:(ObjCEigenDoubleMatrix *)other {
    return [[ObjCEigenDoubleMatrix alloc]initWithMatrix:_matrix - other.matrix];
}

- (ObjCEigenDoubleMatrix *)mulLeft:(Coeff)r {
    return [[ObjCEigenDoubleMatrix alloc]initWithMatrix:r * _matrix];
}

- (ObjCEigenDoubleMatrix *)mulRight:(Coeff)r {
    return [[ObjCEigenDoubleMatrix alloc]initWithMatrix:_matrix * r];
}

- (ObjCEigenDoubleMatrix *)mul:(ObjCEigenDoubleMatrix *)other {
    return [[ObjCEigenDoubleMatrix alloc]initWithMatrix:_matrix * other.matrix];
}

- (void)serializeInto:(Coeff *)array {
    Map(array, _matrix.rows(), _matrix.cols()) = _matrix.transpose();
}

@end
