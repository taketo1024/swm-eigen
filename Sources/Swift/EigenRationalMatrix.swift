//
//  File.swift
//  
//
//  Created by Taketo Sano on 2021/05/11.
//

import SwiftyMath

public struct EigenRationalMatrix: EigenMatrix_LU {
    public typealias ObjCMatrix = ObjCEigenRationalMatrix
    public typealias BaseRing = RationalNumber

    public var objCMatrix: ObjCMatrix

    public init(_ objCMatrix: ObjCMatrix) {
        self.objCMatrix = objCMatrix
    }
}

extension ObjCEigenRationalMatrix: ObjCEigenMatrix_LU {
    public typealias Coeff = RationalNumber.CType
}

extension RationalNumber: CTypeConvertible {
    @_transparent
    public init(fromCType r: rational_t) {
        self.init(r.p, r.q)
    }
    
    @_transparent
    public var toCType: rational_t {
        rational_t(p: numerator, q: denominator)
    }
}
