#pragma once

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ObjCEigenIntMatrix: NSObject

@property (readonly) ptrdiff_t rows;
@property (readonly) ptrdiff_t cols;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)copy;

+ (instancetype)matrixWithZeros:(ptrdiff_t)rows cols:(ptrdiff_t)cols
NS_SWIFT_NAME(zeros(rows:cols:));
+ (instancetype)matrixWithIdentity:(ptrdiff_t)rows cols:(ptrdiff_t)cols
NS_SWIFT_NAME(identity(rows:cols:));

- (ptrdiff_t)valueAtRow:(ptrdiff_t)row col:(ptrdiff_t)col
NS_SWIFT_NAME(value(row:col:));
- (void)setValue:(ptrdiff_t)value row:(ptrdiff_t)row col:(ptrdiff_t)col
NS_SWIFT_NAME(setValue(_:row:col:));

- (bool)isZero;
- (instancetype)transposed;
- (instancetype)inverse;

- (ptrdiff_t)determinant;
- (ptrdiff_t)trace;
- (instancetype)submatrixFromRow:(ptrdiff_t)i col:(ptrdiff_t)j width:(ptrdiff_t)w height:(ptrdiff_t)h;
- (void)serializeInto:(ptrdiff_t *)array;

- (bool)equals:(id)other;
- (instancetype)add:(id)other;
- (instancetype)negate;
- (instancetype)sub:(id)other;
- (instancetype)mulLeft:(ptrdiff_t) r;
- (instancetype)mulRight:(ptrdiff_t) r;
- (instancetype)mul:(id)other;

@end

NS_ASSUME_NONNULL_END
