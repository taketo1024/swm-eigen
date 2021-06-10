//
//  File.cpp
//  
//
//  Created by Taketo Sano on 2021/06/10.
//

#import "eigen_rat_s.h"
#import "Rational/Rational.hpp"
#import <iostream>
#import <Eigen/Eigen>

using namespace std;
using namespace Eigen;

using R = RationalNum;
using M = Eigen::Matrix<R, Dynamic, Dynamic>;

void *eigen_init_rat_s(int_t rows, int_t cols) {
    M *m = new M(rows, cols);
    (*m)(0,0) = 1;
    return static_cast<void*>(m);
}

void eigen_dump_rat_s(void *ptr) {
    M *m = static_cast<M *>(ptr);
    cout << *m << endl;
}

void eigen_free_rat_s(void *ptr) {
    M *m = static_cast<M *>(ptr);
    delete m;
}
