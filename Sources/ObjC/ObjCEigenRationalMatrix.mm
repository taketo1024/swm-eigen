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
    return _matrix.isZero(0);
}

- (bool)isZeroSize {
    return (self.rows * self.cols == 0);
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
    if(_matrix.determinant() != 0) {
        return [[Self alloc] initWithMatrix:_matrix.inverse()];
    } else {
        return nil;
    }
}

-(instancetype)submatrixFromRow:(int_t)i col:(int_t)j width:(int_t)w height:(int_t)h {
    return [[Self alloc] initWithMatrix:_matrix.block(i, j, w, h)];
}

- (instancetype)concat:(Self *)other {
    Matrix C(self.rows, self.cols + other.cols);
    C.leftCols(self.cols) = self.matrix;
    C.rightCols(other.cols) = other.matrix;
    return [[Self alloc] initWithMatrix:C];
}

- (instancetype)stack:(Self *)other {
    Matrix C(self.rows + other.rows, self.cols);
    C.topRows(self.rows) = self.matrix;
    C.bottomRows(other.rows) = other.matrix;
    return [[Self alloc] initWithMatrix:C];
}

- (instancetype)permuteRows:(perm_t)p {
    Eigen::VectorXi indices(p.length);
    for(int_t i = 0; i < p.length; ++i) {
        indices[i] = p.indices[i];
    }
    Eigen::PermutationMatrix<Eigen::Dynamic> P(indices);
    return [[Self alloc] initWithMatrix:P * _matrix];
}

- (instancetype)permuteCols:(perm_t)p {
    Eigen::VectorXi indices(p.length);
    for(int_t i = 0; i < p.length; ++i) {
        indices[i] = p.indices[i];
    }
    Eigen::PermutationMatrix<Eigen::Dynamic> P(indices);
    return [[Self alloc] initWithMatrix:_matrix * P.transpose()];
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

+ (instancetype)solveLowerTriangular:(Self *)L :(Self *)b {
    Matrix x = L.matrix.triangularView<Eigen::Lower>().solve(b.matrix);
    return [[Self alloc] initWithMatrix:x];
}

+ (instancetype)solveUpperTriangular:(Self *)U :(Self *)b {
    Matrix x = U.matrix.triangularView<Eigen::Upper>().solve(b.matrix);
    return [[Self alloc] initWithMatrix:x];
}

- (NSDictionary *)lufactorize {
    int_t n = self.rows;
    int_t m = self.cols;
    
    // P, Q must be freed by the caller.
    perm_t P = init_perm(n);
    perm_t Q = init_perm(m);
    Self *L;
    Self *U;

    if(self.isZeroSize) {
        L = [Self matrixWithZeros:n cols:0];
        U = [Self matrixWithZeros:0 cols:m];
    } else {
        using LU = Eigen::FullPivLU<Matrix>;
        LU lu(_matrix);
        int_t r = lu.rank();
        
        // make P
        LU::PermutationPType p = lu.permutationP();
        for(int_t i = 0; i < n; ++i) {
            P.indices[i] = p.indices()[i];
        }
        
        // make Q
        LU::PermutationQType q = lu.permutationQ();
        for(int_t i = 0; i < m; ++i) {
            Q.indices[i] = q.indices()[i];
        }
        
        // make L
        Matrix l = Matrix::Identity(n, r);
        l.triangularView<Eigen::StrictlyLower>() = lu.matrixLU().block(0, 0, n, r);
        L = [[Self alloc] initWithMatrix:l];
        
        // make U
        Matrix u = Matrix::Zero(r, m);
        u.triangularView<Eigen::Upper>() = lu.matrixLU().block(0, 0, r, m);
        U = [[Self alloc] initWithMatrix:u];
    }
    
    return @{
        @"P": [NSValue valueWithBytes:&P objCType:@encode(perm_t)],
        @"Q": [NSValue valueWithBytes:&Q objCType:@encode(perm_t)],
        @"L": L,
        @"U": U
    };
}

@end
