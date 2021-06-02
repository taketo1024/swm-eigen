#pragma once

#import <Foundation/Foundation.h>
#import "basic.h"

NS_ASSUME_NONNULL_BEGIN

@interface ObjCEigenDoubleMatrix: NSObject

@property (readonly) int_t rows;
@property (readonly) int_t cols;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)copy;

+ (instancetype)matrixWithZeros:(int_t)rows cols:(int_t)cols
NS_SWIFT_NAME(zeros(rows:cols:));
+ (instancetype)matrixWithIdentity:(int_t)rows cols:(int_t)cols
NS_SWIFT_NAME(identity(rows:cols:));

- (double)valueAtRow:(int_t)row col:(int_t)col
NS_SWIFT_NAME(value(row:col:));
- (void)setValue:(double)value row:(int_t)row col:(int_t)col
NS_SWIFT_NAME(setValue(_:row:col:));

- (bool)isZero;
- (instancetype)transposed;
- (nullable instancetype)inverse;

- (double)determinant;
- (double)trace;

- (instancetype)submatrixFromRow:(int_t)i col:(int_t)j width:(int_t)w height:(int_t)h;
- (instancetype)concat:(id)other;
- (instancetype)stack:(id)other;

- (instancetype)permuteRows:(perm_t)p;
- (instancetype)permuteCols:(perm_t)p;

- (bool)equals:(id)other;
- (instancetype)add:(id)other;
- (instancetype)negate;
- (instancetype)sub:(id)other;
- (instancetype)mulLeft:(double) r;
- (instancetype)mulRight:(double) r;
- (instancetype)mul:(id) other;

- (void)serializeInto:(double *)array;

@end

NS_ASSUME_NONNULL_END
