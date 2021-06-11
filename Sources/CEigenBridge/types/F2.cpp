//
//  Rational.cpp
//  
//
//  Created by Taketo Sano on 2021/05/11.
//

#include "F2.hpp"

#include <iostream>
#include <string>
#include <stdint.h>
#include <cmath>
#include <vector>
#include <limits.h>

using namespace std;

F2 operator+(const F2& left, const F2& right) {
    return F2(left.value ^ right.value);
}

F2 operator-(const F2& left, const F2& right) {
    return F2(left.value ^ right.value);
}

F2 operator*(const F2& left, const F2& right) {
    return F2(left.value & right.value);
}

F2 operator/(const F2& left, const F2& right) {
    if(right.value == 0)
        throw std::runtime_error("division by 0.");
    
    return F2(left.value & right.value);
}

bool operator==(const F2& left, const F2& right) {
    return left.value == right.value;
}

bool operator!=(const F2& left, const F2& right) {
    return !(left == right);
}

bool operator<(const F2& left, const F2& right) {
    return left.value < right.value;
}

bool operator>(const F2& left, const F2& right) {
    return left.value > right.value;
}

bool operator<=(const F2& left, const F2& right) {
    return left.value <= right.value;
}

bool operator>=(const F2& left, const F2& right) {
    return left.value >= right.value;
}

ostream& operator<<(ostream& out, const F2& obj) {
    return out << obj.value;
}

F2& F2::operator=(const F2& obj) {
    value = obj.value;
    return *this;
}

F2& F2::operator+=(const F2& obj) {
    value ^= obj.value;
    return *this;
}

F2& F2::operator-=(const F2& obj) {
    value ^= obj.value;
    return *this;
}

F2& F2::operator*=(const F2& obj) {
    value &= obj.value;
    return *this;
}

F2& F2::operator/=(const F2& obj) {
    if(obj.value == 0)
        throw std::runtime_error("division by 0.");

    value &= obj.value;
    return *this;
}

F2 F2::operator+() const {
    return *this;
}

F2 F2::operator-() const {
    return *this;
}
