#import "ObjCEigenIntMatrix.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdocumentation"
#import <Eigen/Core>
#import <Eigen/LU>
#pragma clang diagnostic pop

#import <iostream>
#import "Rational/Rational.hpp"

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
    return [[ObjCEigenIntMatrix alloc] initWithMatrix:copy];
}

- (int_t)rows {
    return _matrix.rows();
}

- (int_t)cols {
    return _matrix.cols();
}

+ (instancetype)matrixWithZeros:(int_t)rows cols:(int_t)cols {
    return [[ObjCEigenIntMatrix alloc] initWithMatrix:Matrix::Zero(rows, cols)];
}

+ (instancetype)matrixWithIdentity:(int_t)rows cols:(int_t)cols {
    return [[ObjCEigenIntMatrix alloc] initWithMatrix:Matrix::Identity(rows, cols)];
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
    return [[ObjCEigenIntMatrix alloc] initWithMatrix:_matrix.transpose()];
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
    return [[ObjCEigenIntMatrix alloc] initWithMatrix:rinv.cast<int_t>()];
}

-(instancetype)submatrixFromRow:(int_t)i col:(int_t)j width:(int_t)w height:(int_t)h {
    return [[ObjCEigenIntMatrix alloc] initWithMatrix:_matrix.block(i, j, w, h)];
}

- (bool)equals:(ObjCEigenIntMatrix *)other {
    return _matrix == other.matrix;
}

- (ObjCEigenIntMatrix *)add:(ObjCEigenIntMatrix *)other {
    return [[ObjCEigenIntMatrix alloc]initWithMatrix:_matrix + other.matrix];
}

- (ObjCEigenIntMatrix *)negate {
    return [[ObjCEigenIntMatrix alloc]initWithMatrix:-_matrix];
}

- (ObjCEigenIntMatrix *)sub:(ObjCEigenIntMatrix *)other {
    return [[ObjCEigenIntMatrix alloc]initWithMatrix:_matrix - other.matrix];
}

- (ObjCEigenIntMatrix *)mulLeft:(Coeff)r {
    return [[ObjCEigenIntMatrix alloc]initWithMatrix:r * _matrix];
}

- (ObjCEigenIntMatrix *)mulRight:(Coeff)r {
    return [[ObjCEigenIntMatrix alloc]initWithMatrix:_matrix * r];
}

- (ObjCEigenIntMatrix *)mul:(ObjCEigenIntMatrix *)other {
    return [[ObjCEigenIntMatrix alloc]initWithMatrix:_matrix * other.matrix];
}

- (void)serializeInto:(Coeff *)array {
    Map(array, _matrix.rows(), _matrix.cols()) = _matrix.transpose();
}

@end
