#import "ObjCEigenIntMatrix.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdocumentation"
#import <Eigen/Core>
#import <Eigen/LU>
#pragma clang diagnostic pop

#import <iostream>

using Ring = int_t;
using Matrix = Eigen::Matrix<Ring, Eigen::Dynamic, Eigen::Dynamic>;
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

- (Ring)valueAtRow:(int_t)row col:(int_t)col {
    return _matrix(row, col);
}

- (void)setValue:(Ring)value row:(int_t)row col:(int_t)col {
    _matrix(row, col) = value;
}

- (bool)isZero {
    _matrix.isZero(0);
}

- (instancetype)transposed {
    return [[ObjCEigenIntMatrix alloc] initWithMatrix:_matrix.transpose()];
}

- (Ring)determinant {
    NSAssert(false, @"unavailable");
}

- (Ring)trace {
    return _matrix.trace();
}

- (instancetype)inverse {
    NSAssert(false, @"unavailable");
}

-(instancetype)submatrixFromRow:(int_t)i col:(int_t)j width:(int_t)w height:(int_t)h {
    return [[ObjCEigenIntMatrix alloc] initWithMatrix:_matrix.block(i, j, w, h)];
}

- (void)serializeInto:(Ring *)array {
    Map(array, _matrix.rows(), _matrix.cols()) = _matrix.transpose();
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

- (ObjCEigenIntMatrix *)mulLeft:(Ring)r {
    return [[ObjCEigenIntMatrix alloc]initWithMatrix:r * _matrix];
}

- (ObjCEigenIntMatrix *)mulRight:(Ring)r {
    return [[ObjCEigenIntMatrix alloc]initWithMatrix:_matrix * r];
}

- (ObjCEigenIntMatrix *)mul:(ObjCEigenIntMatrix *)other {
    return [[ObjCEigenIntMatrix alloc]initWithMatrix:_matrix * other.matrix];
}

- (NSString*)description {
    std::stringstream buffer;
    buffer << _matrix;
    const std::string string = buffer.str();
    return [NSString stringWithUTF8String:string.c_str()];
}

@end
