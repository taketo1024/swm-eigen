#import "ObjCEigenDoubleMatrix.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdocumentation"
#import <Eigen/Dense>
#pragma clang diagnostic pop

#import <iostream>

using Ring = double;
using Matrix = Eigen::Matrix<Ring, Eigen::Dynamic, Eigen::Dynamic>;
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

- (ptrdiff_t)rows {
    return _matrix.rows();
}

- (ptrdiff_t)cols {
    return _matrix.cols();
}

+ (instancetype)matrixWithZeros:(ptrdiff_t)rows cols:(ptrdiff_t)cols {
    return [[ObjCEigenDoubleMatrix alloc] initWithMatrix:Matrix::Zero(rows, cols)];
}

+ (instancetype)matrixWithIdentity:(ptrdiff_t)rows cols:(ptrdiff_t)cols {
    return [[ObjCEigenDoubleMatrix alloc] initWithMatrix:Matrix::Identity(rows, cols)];
}

- (Ring)valueAtRow:(ptrdiff_t)row col:(ptrdiff_t)col {
    return _matrix(row, col);
}

- (void)setValue:(Ring)value row:(ptrdiff_t)row col:(ptrdiff_t)col {
    _matrix(row, col) = value;
}

- (bool)isZero {
    _matrix.isZero(0);
}

- (instancetype)transposed {
    return [[ObjCEigenDoubleMatrix alloc] initWithMatrix:_matrix.transpose()];
}

- (Ring)determinant {
    return _matrix.determinant();
}

- (Ring)trace {
    return _matrix.trace();
}

- (instancetype)inverse {
    const Matrix result = _matrix.inverse();
    return [[ObjCEigenDoubleMatrix alloc] initWithMatrix:result];
}

-(instancetype)submatrixFromRow:(ptrdiff_t)i col:(ptrdiff_t)j width:(ptrdiff_t)w height:(ptrdiff_t)h {
    return [[ObjCEigenDoubleMatrix alloc] initWithMatrix:_matrix.block(i, j, w, h)];
}

- (void)serializeInto:(Ring *)array {
    Map(array, _matrix.rows(), _matrix.cols()) = _matrix.transpose();
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

- (ObjCEigenDoubleMatrix *)mulLeft:(Ring)r {
    return [[ObjCEigenDoubleMatrix alloc]initWithMatrix:r * _matrix];
}

- (ObjCEigenDoubleMatrix *)mulRight:(Ring)r {
    return [[ObjCEigenDoubleMatrix alloc]initWithMatrix:_matrix * r];
}

- (ObjCEigenDoubleMatrix *)mul:(ObjCEigenDoubleMatrix *)other {
    return [[ObjCEigenDoubleMatrix alloc]initWithMatrix:_matrix * other.matrix];
}

- (NSString*)description {
    std::stringstream buffer;
    buffer << _matrix;
    const std::string string = buffer.str();
    return [NSString stringWithUTF8String:string.c_str()];
}

@end
