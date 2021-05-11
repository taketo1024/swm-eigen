#pragma once

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ObjCEigenDoubleMatrix: NSObject

@property (readonly) ptrdiff_t rows;
@property (readonly) ptrdiff_t cols;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)matrixWithZeros:(ptrdiff_t)rows cols:(ptrdiff_t)cols
NS_SWIFT_NAME(zeros(rows:cols:));
+ (instancetype)matrixWithIdentity:(ptrdiff_t)rows cols:(ptrdiff_t)cols
NS_SWIFT_NAME(identity(rows:cols:));

- (double)valueAtRow:(ptrdiff_t)row col:(ptrdiff_t)col
NS_SWIFT_NAME(value(row:col:));
- (void)setValue:(double)value row:(ptrdiff_t)row col:(ptrdiff_t)col
NS_SWIFT_NAME(setValue(_:row:col:));

- (bool)isZero;
- (instancetype)transposed;
- (instancetype)inverse;

- (double)determinant;
- (double)trace;
- (ObjCEigenDoubleMatrix *)submatrixFromRow:(ptrdiff_t)i col:(ptrdiff_t)j width:(ptrdiff_t)w height:(ptrdiff_t)h;
- (void)serializeInto:(double *)array;

- (bool)equals:(ObjCEigenDoubleMatrix *)other;
- (ObjCEigenDoubleMatrix *)add:(ObjCEigenDoubleMatrix *)other;
- (ObjCEigenDoubleMatrix *)negate;
- (ObjCEigenDoubleMatrix *)sub:(ObjCEigenDoubleMatrix *)other;
- (ObjCEigenDoubleMatrix *)mulLeft:(double) r;
- (ObjCEigenDoubleMatrix *)mulRight:(double) r;
- (ObjCEigenDoubleMatrix *)mul:(ObjCEigenDoubleMatrix *) other;

@end

NS_ASSUME_NONNULL_END
