#import "ObjCEigenRationalMatrix.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdocumentation"
#import <Eigen/Core>
#import <Eigen/LU>
#pragma clang diagnostic pop

#import <iostream>
#import "Rational/Rational.hpp"

using Self = ObjCEigenRationalMatrix;
using Coeff = RationalNum;
using Matrix = Eigen::Matrix<Coeff, Eigen::Dynamic, Eigen::Dynamic>;
using Map = Eigen::Map<Matrix>;
using LU = Eigen::FullPivLU<Matrix>;

@interface ObjCEigenRationalMatrix () {
    LU _solver;
    bool _solver_initialized;
}

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
    return [[Self alloc] initWithMatrix:_matrix.transpose()];
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
    return [[Self alloc] initWithMatrix:result];
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

- (Self *)mulLeft:(rational_t)r {
    return [[Self alloc]initWithMatrix:RationalNum(r) * _matrix];
}

- (Self *)mulRight:(rational_t)r {
    return [[Self alloc]initWithMatrix:_matrix * RationalNum(r)];
}

- (Self *)mul:(Self *)other {
    return [[Self alloc]initWithMatrix:_matrix * other.matrix];
}

- (void)serializeInto:(rational_t *)array {
    for(int_t i = 0; i < self.rows; i++) {
        for(int_t j = 0; j < self.cols; j++) {
            *(array++) = [self valueAtRow:i col:j];
        }
    }
}

@end

@implementation ObjCEigenRationalMatrix(LU)

- (LU)solver {
    if (!_solver_initialized) {
        _solver = LU(_matrix);
        _solver_initialized = true;
    }
    return _solver;
}

- (Self *)getL {
    auto solver = [self solver];
    auto lu = solver.matrixLU();
    auto l = lu.triangularView<Eigen::Lower>();
    for(int_t i = 0; i < self.cols; i++) {
        l(i, i) = 1;
    }
    return [[Self alloc] initWithMatrix:l];
}

- (Self *)getU {
    auto solver = [self solver];
    auto lu = solver.matrixLU();
    return [[Self alloc] initWithMatrix:lu.triangularView<Eigen::Upper>()];
}

- (Self *)getP {
    auto solver = [self solver];
    auto P = solver.permutationP();
    return [[Self alloc] initWithMatrix:solver.permutationP()];
}

- (Self *)getQ {
    auto solver = [self solver];
    return [[Self alloc] initWithMatrix:solver.permutationQ()];
}

- (int_t)rank {
    return [self solver].rank();
}

- (int_t)nullity {
    return [self solver].dimensionOfKernel();
}

- (Self *)image {
    auto solver = [self solver];
    return [[Self alloc] initWithMatrix:solver.image(_matrix)];
}

- (Self *)kernel {
    auto solver = [self solver];
    return [[Self alloc] initWithMatrix:solver.kernel()];
}

- (Self *)solve: (Self *)b_ {
    auto solver = [self solver];
    auto b = b_.matrix;
    auto x = solver.solve(b);
    return [[Self alloc] initWithMatrix:x];
}

@end
