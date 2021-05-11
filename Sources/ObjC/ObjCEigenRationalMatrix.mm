#import "ObjCEigenRationalMatrix.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdocumentation"
#import <Eigen/Dense>
#pragma clang diagnostic pop

#import <iostream>
#import "Rational/Rational.hpp"

using Ring = RationalNum;
using Matrix = Eigen::Matrix<Ring, Eigen::Dynamic, Eigen::Dynamic>;
using Map = Eigen::Map<Matrix>;

@interface ObjCEigenRationalMatrix ()

@property (readonly) Matrix matrix;

- (instancetype)initWithMatrix:(Matrix)matrix;

@end

@implementation ObjCEigenRationalMatrix

- (instancetype)initWithMatrix:(Matrix)matrix {
    self = [super init];
    _matrix = matrix;
    return self;
}

- (instancetype)copy {
    Matrix copy = _matrix;
    return [[ObjCEigenRationalMatrix alloc] initWithMatrix:copy];
}

- (int_t)rows {
    return _matrix.rows();
}

- (int_t)cols {
    return _matrix.cols();
}

+ (instancetype)matrixWithZeros:(int_t)rows cols:(int_t)cols {
    return [[ObjCEigenRationalMatrix alloc] initWithMatrix:Matrix::Zero(rows, cols)];
}

+ (instancetype)matrixWithIdentity:(int_t)rows cols:(int_t)cols {
    return [[ObjCEigenRationalMatrix alloc] initWithMatrix:Matrix::Identity(rows, cols)];
}

- (rational_t)valueAtRow:(int_t)row col:(int_t)col {
    return to_rational_t(_matrix(row, col));
}

- (void)setValue:(rational_t)value row:(int_t)row col:(int_t)col {
    _matrix(row, col) = RationalNum(value);
}

- (bool)isZero {
    _matrix.isZero(0);
}

- (instancetype)transposed {
    return [[ObjCEigenRationalMatrix alloc] initWithMatrix:_matrix.transpose()];
}

- (rational_t)determinant {
    return to_rational_t(_matrix.determinant());
}

- (rational_t)trace {
    return to_rational_t(_matrix.trace());
}

- (instancetype)inverse {
    const Matrix result =
    _matrix.inverse();
    return [[ObjCEigenRationalMatrix alloc] initWithMatrix:result];
}

-(instancetype)submatrixFromRow:(int_t)i col:(int_t)j width:(int_t)w height:(int_t)h {
    return [[ObjCEigenRationalMatrix alloc] initWithMatrix:_matrix.block(i, j, w, h)];
}

- (void)serializeInto:(rational_t *)array {
    for(int_t i = 0; i < self.rows; i++) {
        for(int_t j = 0; j < self.cols; j++) {
            *(array++) = [self valueAtRow:i col:j];
        }
    }
}

- (bool)equals:(ObjCEigenRationalMatrix *)other {
    return _matrix == other.matrix;
}

- (ObjCEigenRationalMatrix *)add:(ObjCEigenRationalMatrix *)other {
    return [[ObjCEigenRationalMatrix alloc]initWithMatrix:_matrix + other.matrix];
}

- (ObjCEigenRationalMatrix *)negate {
    return [[ObjCEigenRationalMatrix alloc]initWithMatrix:-_matrix];
}

- (ObjCEigenRationalMatrix *)sub:(ObjCEigenRationalMatrix *)other {
    return [[ObjCEigenRationalMatrix alloc]initWithMatrix:_matrix - other.matrix];
}

- (ObjCEigenRationalMatrix *)mulLeft:(rational_t)r {
    return [[ObjCEigenRationalMatrix alloc]initWithMatrix:RationalNum(r) * _matrix];
}

- (ObjCEigenRationalMatrix *)mulRight:(rational_t)r {
    return [[ObjCEigenRationalMatrix alloc]initWithMatrix:_matrix * RationalNum(r)];
}

- (ObjCEigenRationalMatrix *)mul:(ObjCEigenRationalMatrix *)other {
    return [[ObjCEigenRationalMatrix alloc]initWithMatrix:_matrix * other.matrix];
}

- (NSString*)description {
    std::stringstream buffer;
    buffer << _matrix;
    const std::string string = buffer.str();
    return [NSString stringWithUTF8String:string.c_str()];
}

@end
