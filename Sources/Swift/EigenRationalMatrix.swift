//
//  File.swift
//  
//
//  Created by Taketo Sano on 2021/05/11.
//

import SwiftyMath

public struct EigenRationalMatrix: EigenMatrixProtocol {
    public typealias ObjCType = ObjCEigenRationalMatrix
    public typealias BaseRing = RationalNumber

    public var objCMatrix: ObjCType

    public init(_ objCMatrix: ObjCType) {
        self.objCMatrix = objCMatrix
    }
}

extension ObjCEigenRationalMatrix: ObjCEigenMatrixProtocol {
    public typealias BaseRing = RationalNumber
    
    public func value(row: Int, col: Int) -> RationalNumber {
        .init(fromCType: value(row: row, col: col))
    }
    
    public func setValue(_ value: RationalNumber, row: Int, col: Int) {
        setValue(value.toCType, row: row, col: col)
    }
    
    public func determinant() -> RationalNumber {
        .init(fromCType: determinant())
    }
    
    public func trace() -> RationalNumber {
        .init(fromCType: trace())
    }
    
    public func serialize(into array: UnsafeMutablePointer<RationalNumber>) {
        let (n, m) = (rows, cols)
        
        let zero = rational_t(p: 0, q: 0)
        var raw = [rational_t](repeating: zero, count: n * m)
        self.serialize(into: &raw)
        
        var p = array
        for r in raw {
            p.pointee = RationalNumber(fromCType: r)
            p += 1
        }
    }
    
    public func mulLeft(_ r: RationalNumber) -> Self {
        mulLeft(r.toCType)
    }
    
    public func mulRight(_ r: RationalNumber) -> Self {
        mulRight(r.toCType)
    }
}

private extension RationalNumber {
    init(fromCType r: rational_t) {
        self.init(r.p, r.q)
    }
    
    var toCType: rational_t {
        rational_t(p: numerator, q: denominator)
    }
}
