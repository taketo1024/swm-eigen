//
//  Rational.cpp
//  
//
//  Created by Taketo Sano on 2021/05/11.
//

#include "Rational.hpp"

#include <iostream>
#include <string>
#include <cmath>
#include <vector>
#include <limits.h>

using namespace std;

int_t gcd(int_t a, int_t b) {
    return b == 0 ? a : gcd(b, a % b);
}

RationalNum& RationalNum::simplify() {
    if (denominator < 0) {
        numerator = -numerator;
        denominator = -denominator;
    }
    if (denominator > 1) {
        int_t d = absInt(gcd(numerator, denominator));
        if (d > 1) {
            numerator = numerator / d;
            denominator = denominator / d;
        }
    }
    return *this;
}

//friend functions definitions
RationalNum operator+(const RationalNum& left, const RationalNum& right) {
    return RationalNum(left.numerator * right.denominator + left.denominator * right.numerator, left.denominator * right.denominator).simplify();
}

RationalNum operator-(const RationalNum& left, const RationalNum& right) {
    return RationalNum(left.numerator * right.denominator - left.denominator * right.numerator, left.denominator * right.denominator).simplify();
}

RationalNum operator*(const RationalNum& left, const RationalNum& right) {
    return RationalNum(left.numerator * right.numerator, left.denominator * right.denominator).simplify();
}

RationalNum operator/(const RationalNum& left, const RationalNum& right) {
    return RationalNum(left.numerator * right.denominator, left.denominator * right.numerator).simplify();
}

bool operator==(const RationalNum& left, const RationalNum& right) {
    return (left.numerator * right.denominator == right.numerator * left.denominator);
}

bool operator!=(const RationalNum& left, const RationalNum& right) {
    return !(left == right);
}

bool operator<(const RationalNum& left, const RationalNum& right) {
    return (left.numerator * right.denominator < left.denominator * right.numerator);
}

bool operator>(const RationalNum& left, const RationalNum& right) {
    return (left.numerator * right.denominator > left.denominator * right.numerator);
}

bool operator<=(const RationalNum& left, const RationalNum& right) {
    return ( (left < right) || (left == right) );
}

bool operator>=(const RationalNum& left, const RationalNum& right) {
    return ( (left > right) || (left == right) );
}

ostream& operator<<(ostream& out, const RationalNum& obj) {
    out << obj.numerator;
    if (obj.numerator != 0 && obj.denominator != 1) {
        out << "/" << obj.denominator;
    }
    return out;
}

RationalNum& RationalNum::operator=(const RationalNum& obj) {
    numerator = obj.numerator;
    denominator = obj.denominator;
    return *this;
}

RationalNum& RationalNum::operator+=(const RationalNum& obj) {
    *this = *this+obj;
    return *this;
}

RationalNum& RationalNum::operator-=(const RationalNum& obj) {
    *this = *this-obj;
    return *this;
}

RationalNum& RationalNum::operator*=(const RationalNum& obj) {
    *this = *this*obj;
    return *this;
}

RationalNum& RationalNum::operator/=(const RationalNum& obj) {
    *this = *this/obj;
    return *this;
}

RationalNum& RationalNum::operator++() {
    *this = *this+int_t(1);
    return *this;
}

RationalNum RationalNum::operator++(int) {
    RationalNum before = *this;
    *this = *this+int_t(1);
    return before;
}

RationalNum& RationalNum::operator--() {
    *this = *this-int_t(1);
    return *this;
}

RationalNum RationalNum::operator--(int) {
    RationalNum before = *this;
    *this = *this-int_t(1);
    return before;
}

RationalNum RationalNum::operator+() const {
    return *this;
}

RationalNum RationalNum::operator-() const {
    return RationalNum(-numerator, denominator);
}

RationalNum::operator int_t() const {
    return numerator / denominator;
}
