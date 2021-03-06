//
//  basic.c
//  
//
//  Created by Taketo Sano on 2021/05/16.
//

#include <stdlib.h>
#include "basic.h"

perm_t perm_init(int_t length) {
    int_t *indices = (int_t *)calloc(length, sizeof(int_t));
    for(int_t i = 0; i < length; ++i)
        indices[i] = i;
    
    perm_t p = {length, indices};
    return p;
}

void perm_free(perm_t p) {
    free(p.indices);
}
