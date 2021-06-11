//
//  Rational.hpp
//  
//
//  https://gist.github.com/sklaw/10473569
//

#ifndef F2_H
#define F2_H

#include <iostream>
#include <stdint.h>
#include <Eigen/Dense>
#include "../basic.h"

class F2 {
    friend F2 operator+(const F2& left, const F2& right);
    friend F2 operator-(const F2& left, const F2& right);
    friend F2 operator*(const F2& left, const F2& right);
    friend F2 operator/(const F2& left, const F2& right);
    friend bool operator==(const F2& left, const F2& right);
    friend bool operator!=(const F2& left, const F2& right);
    friend bool operator<(const F2& left, const F2& right);
    friend bool operator>(const F2& left, const F2& right);
    friend bool operator<=(const F2& left, const F2& right);
    friend bool operator>=(const F2& left, const F2& right);
    friend std::ostream& operator<<(std::ostream& out, const F2& obj);
    friend std::istream& operator>>(std::istream& in, F2& obj);
    
public:
    F2(): value(0) {}
    F2(int_t x): value(x) {}
    
    F2& operator=(const F2& obj);
    F2& operator+=(const F2& obj);
    F2& operator-=(const F2& obj);
    F2& operator*=(const F2& obj);
    F2& operator/=(const F2& obj);
    F2 operator+() const;
    F2 operator-() const;
    
    uint8_t getValue() const { return value; }
    
private:
    uint8_t value; // 0 or 1
};

namespace Eigen {
template<> struct NumTraits<F2>
 : NumTraits<int_t> // permits to get the epsilon, dummy_precision, lowest, highest functions
{
  typedef F2 Real;
  typedef F2 NonInteger;
  typedef F2 Nested;
  enum {
    IsComplex = 0,
    IsInteger = 0,
    IsSigned = 0,
    RequireInitialization = 0,
    ReadCost = 1,
    AddCost = 2,
    MulCost = 2
  };
    static inline Real epsilon() { return 0; }
    static inline Real dummy_precision() { return 0; }
};
}

#endif
