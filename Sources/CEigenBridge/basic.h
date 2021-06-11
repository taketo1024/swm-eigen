//
//  Header.h
//  
//
//  Created by Taketo Sano on 2021/05/11.
//

#ifndef Basic_h
#define Basic_h

#import <stdbool.h>

typedef signed long int_t;

inline int_t absInt(int_t x) { return x >= 0 ? x : -x; }

typedef struct {
    int_t p;
    int_t q;
} rational_t;

typedef struct {
    int_t row;
    int_t col;
    rational_t value;
} rational_triplet_t;

typedef struct {
    int_t length;
    int_t *indices;
} perm_t;

perm_t init_perm(int_t length);
void free_perm(perm_t p);

#endif /* Header_h */
