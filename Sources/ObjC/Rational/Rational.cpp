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
    return b == int_t(0) ? a : gcd(b, a % b);
}

//friend functions definitions
RationalNum operator+(const RationalNum& left, const RationalNum& right) {
    return RationalNum(left.numerator * right.denominator + left.denominator * right.numerator, left.denominator * right.denominator);
}

RationalNum operator-(const RationalNum& left, const RationalNum& right) {
    return RationalNum(left.numerator * right.denominator - left.denominator * right.numerator, left.denominator * right.denominator);
}

RationalNum operator*(const RationalNum& left, const RationalNum& right) {
    return RationalNum(left.numerator * right.numerator, left.denominator * right.denominator);
}

RationalNum operator/(const RationalNum& left, const RationalNum& right) {
    return RationalNum(left.numerator * right.denominator, left.denominator * right.numerator);
}

bool operator==(const RationalNum& left, const RationalNum& right) {
    return (left.numerator == right.numerator && left.denominator == right.denominator);
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

//member function definition
RationalNum::RationalNum() {
    numerator = 0;
    denominator = 1;
}

RationalNum::RationalNum(rational_t r) {
    if (r.q == 0) {
        cout << "[warn] Denominator is 0." << endl;
    }
    numerator = r.p;
    denominator = r.q;
    simplify();
}

RationalNum::RationalNum(int_t numerator_, int_t denominator_) {
    if (denominator_ == 0) {
        cout << "[warn] Denominator is 0." << endl;
    }
    numerator = numerator_;
    denominator = denominator_;
    simplify();
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

int_t RationalNum::getNumerator() const {
    return numerator;
}

int_t RationalNum::getDenominator() const {
    return denominator;
}

void RationalNum::simplify() {
    if (denominator < 0) {
        numerator = -numerator;
        denominator = -denominator;
    }
    int_t d = absInt(gcd(numerator, denominator));
    if (d > 1) {
        numerator = numerator / d;
        denominator = denominator / d;
    }
}
