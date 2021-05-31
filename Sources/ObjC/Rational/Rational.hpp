//
//  Rational.hpp
//  
//
//  https://gist.github.com/sklaw/10473569
//

#ifndef RATIONAL_NUM
#define RATIONAL_NUM

#include <iostream>
#include <Eigen/Dense>
#include "../basic.h"

class RationalNum {
    friend RationalNum operator+(const RationalNum& left, const RationalNum& right);
    friend RationalNum operator-(const RationalNum& left, const RationalNum& right);
    friend RationalNum operator*(const RationalNum& left, const RationalNum& right);
    friend RationalNum operator/(const RationalNum& left, const RationalNum& right);
    friend bool operator==(const RationalNum& left, const RationalNum& right);
    friend bool operator!=(const RationalNum& left, const RationalNum& right);
    friend bool operator<(const RationalNum& left, const RationalNum& right);
    friend bool operator>(const RationalNum& left, const RationalNum& right);
    friend bool operator<=(const RationalNum& left, const RationalNum& right);
    friend bool operator>=(const RationalNum& left, const RationalNum& right);
    friend std::ostream& operator<<(std::ostream& out, const RationalNum& obj);
    friend std::istream& operator>>(std::istream& in, RationalNum& obj);
    
public:
    RationalNum(): numerator(0), denominator(1) {}
    RationalNum(rational_t x): numerator(x.p), denominator(x.q) {}
    RationalNum(int_t numerator_, int_t denominator_ = 1): numerator(numerator_), denominator(denominator_) {}
    
    RationalNum& operator=(const RationalNum& obj);
    RationalNum& operator+=(const RationalNum& obj);
    RationalNum& operator-=(const RationalNum& obj);
    RationalNum& operator*=(const RationalNum& obj);
    RationalNum& operator/=(const RationalNum& obj);
    RationalNum& operator++();
    RationalNum operator++(int);
    RationalNum& operator--();
    RationalNum operator--(int);
    RationalNum operator+() const;
    RationalNum operator-() const;
    
    explicit operator int_t() const;
    
    int_t getNumerator() const { return numerator; }
    int_t getDenominator() const { return denominator; }
    
private:
    int_t numerator;
    int_t denominator;
    RationalNum& simplify();
};

namespace Eigen {
template<> struct NumTraits<RationalNum>
 : NumTraits<int_t> // permits to get the epsilon, dummy_precision, lowest, highest functions
{
  typedef RationalNum Real;
  typedef RationalNum NonInteger;
  typedef RationalNum Nested;
  enum {
    IsComplex = 0,
    IsInteger = 0,
    IsSigned = 1,
    RequireInitialization = 1,
    ReadCost = 1,
    AddCost = 3,
    MulCost = 3
  };
    static inline Real epsilon() { return 0; }
    static inline Real dummy_precision() { return 0; }
//    static inline int digits10() { return 0; }

};
}

inline const RationalNum& conj(const RationalNum& x)  { return x; }
inline const RationalNum& real(const RationalNum& x)  { return x; }
inline RationalNum imag(const RationalNum&)    { return RationalNum(); }
inline RationalNum abs(const RationalNum&  x)  { return RationalNum(absInt(x.getNumerator()), absInt(x.getDenominator())); }
inline RationalNum abs2(const RationalNum& x)  { return x*x; }

inline rational_t to_rational_t(const RationalNum& x) { return {x.getNumerator(), x.getDenominator()}; }

#endif
