#import "ObjCEigenDoubleMatrix.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdocumentation"
#import <Eigen/Core>
#import <Eigen/LU>
#pragma clang diagnostic pop

#import <iostream>

using Self = ObjCEigenDoubleMatrix;
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
    return _matrix.isZero(0);
}

- (instancetype)transposed {
    return [[Self alloc] initWithMatrix:_matrix.transpose()];
}

- (Coeff)determinant {
    return _matrix.determinant();
}

- (Coeff)trace {
    return _matrix.trace();
}

- (instancetype)inverse {
    if(_matrix.determinant() != 0) {
        return [[Self alloc] initWithMatrix:_matrix.inverse()];
    } else {
        return nil;
    }
}

-(instancetype)submatrixFromRow:(int_t)i col:(int_t)j width:(int_t)w height:(int_t)h {
    return [[Self alloc] initWithMatrix:_matrix.block(i, j, w, h)];
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

#include <stdlib.h>
#include "basic.h"

perm_t init_perm(int_t length) {
    int_t *indices = (int_t *)calloc(length, sizeof(int_t));
    for(int_t i = 0; i < length; ++i)
        indices[i] = i;
    
    perm_t p = {length, indices};
    return p;
}

void free_perm(perm_t p) {
    free(p.indices);
}
