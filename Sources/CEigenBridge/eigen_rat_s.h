//
//  File.hpp
//  
//
//  Created by Taketo Sano on 2021/06/10.
//

#ifndef File_hpp
#define File_hpp

#import "basic.h"

#ifdef __cplusplus
extern "C" {
#endif

#pragma clang assume_nonnull begin

void *eigen_init_rat_s(int_t rows, int_t cols);
void eigen_dump_rat_s(void *ptr);
void eigen_free_rat_s(void *ptr);

#pragma clang assume_nonnull end

#ifdef __cplusplus
}
#endif

#endif /* File_hpp */
