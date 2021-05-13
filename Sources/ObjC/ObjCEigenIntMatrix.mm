#import "ObjCEigenIntMatrix.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdocumentation"
#import <Eigen/Core>
#import <Eigen/LU>
#pragma clang diagnostic pop

#import <iostream>
#import "Rational/Rational.hpp"

using Self = ObjCEigenIntMatrix;
using Coeff = int_t;
using Matrix = Eigen::Matrix<Coeff, Eigen::Dynamic, Eigen::Dynamic>;
using Map = Eigen::Map<Matrix>;

@interface ObjCEigenIntMatrix ()

@property (readonly) Matrix matrix;

- (instancetype)initWithMatrix:(Matrix)matrix;

@end

@implementation ObjCEigenIntMatrix

- (instancetype)initWithMatrix:(Matrix)matrix {
    self = [super init];
    _matrix = matrix;
    return self;
}

- (instancetype)copy {
    Matrix copy = _matrix;
    return [[Self alloc] initWithMatrix:copy];
}

- (int_t)rows {
    return _matrix.rows();
}

- (int_t)cols {
    return _matrix.cols();
}

+ (instancetype)matrixWithZeros:(int_t)rows cols:(int_t)cols {
    return [[Self alloc] initWithMatrix:Matrix::Zero(rows, cols)];
}

+ (instancetype)matrixWithIdentity:(int_t)rows cols:(int_t)cols {
    return [[Self alloc] initWithMatrix:Matrix::Identity(rows, cols)];
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
    return [[Self alloc] initWithMatrix:_matrix.transpose()];
}

- (Coeff)determinant {
    auto det = _matrix.cast<RationalNum>().determinant();
    if (det.getDenominator() != 1) {
        @throw [NSException exceptionWithName:@"Runtime Exception" reason:@"invalid calculation result." userInfo:nil];
    }
    return det.getNumerator();
}

- (Coeff)trace {
    return _matrix.trace();
}

- (instancetype)inverse {
    auto rinv = _matrix.cast<RationalNum>().inverse();
    return [[Self alloc] initWithMatrix:rinv.cast<int_t>()];
}

-(instancetype)submatrixFromRow:(int_t)i col:(int_t)j width:(int_t)w height:(int_t)h {
    return [[Self alloc] initWithMatrix:_matrix.block(i, j, w, h)];
}

- (bool)equals:(Self *)other {
    return _matrix == other.matrix;
}

- (Self *)add:(Self *)other {
    return [[Self alloc]initWithMatrix:_matrix + other.matrix];
}

- (Self *)negate {
    return [[Self alloc]initWithMatrix:-_matrix];
}

- (Self *)sub:(Self *)other {
    return [[Self alloc]initWithMatrix:_matrix - other.matrix];
}

- (Self *)mulLeft:(Coeff)r {
    return [[Self alloc]initWithMatrix:r * _matrix];
}

- (Self *)mulRight:(Coeff)r {
    return [[Self alloc]initWithMatrix:_matrix * r];
}

- (Self *)mul:(Self *)other {
    return [[Self alloc]initWithMatrix:_matrix * other.matrix];
}

- (void)serializeInto:(Coeff *)array {
    Map(array, _matrix.rows(), _matrix.cols()) = _matrix.transpose();
}

@end
