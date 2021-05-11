#pragma once

#import <Foundation/Foundation.h>
#import "basic.h"

NS_ASSUME_NONNULL_BEGIN

@interface ObjCEigenRationalMatrix: NSObject

@property (readonly) int_t rows;
@property (readonly) int_t cols;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)copy;

+ (instancetype)matrixWithZeros:(int_t)rows cols:(int_t)cols
NS_SWIFT_NAME(zeros(rows:cols:));
+ (instancetype)matrixWithIdentity:(int_t)rows cols:(int_t)cols
NS_SWIFT_NAME(identity(rows:cols:));

- (rational_t)valueAtRow:(int_t)row col:(int_t)col
NS_SWIFT_NAME(value(row:col:));
- (void)setValue:(rational_t)value row:(int_t)row col:(int_t)col
NS_SWIFT_NAME(setValue(_:row:col:));

- (bool)isZero;
- (instancetype)transposed;
- (instancetype)inverse;

- (rational_t)determinant;
- (rational_t)trace;
- (instancetype)submatrixFromRow:(int_t)i col:(int_t)j width:(int_t)w height:(int_t)h;
- (void)serializeInto:(rational_t *)array;

- (bool)equals:(id)other;
- (instancetype)add:(id)other;
- (instancetype)negate;
- (instancetype)sub:(id)other;
- (instancetype)mulLeft:(rational_t) r;
- (instancetype)mulRight:(rational_t) r;
- (instancetype)mul:(id) other;

+ (void)hehe;

@end

NS_ASSUME_NONNULL_END
