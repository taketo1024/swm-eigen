//
//  File.swift
//  
//
//  Created by Taketo Sano on 2021/05/11.
//

import SwmCore
import SwmMatrixTools

public struct EigenRationalMatrix: EigenMatrix, LUFactorizable {
    public typealias ObjCMatrix = ObjCEigenRationalMatrix
    public typealias BaseRing = RationalNumber

    public var objCMatrix: ObjCMatrix

    public init(_ objCMatrix: ObjCMatrix) {
        self.objCMatrix = objCMatrix
    }
    
    // overrides default impl.
    public func LUfactorize() -> (P: Permutation<anySize>, Q: Permutation<anySize>, L: Self, U: Self) {
        LUfactorize_native()
    }
}

extension ObjCEigenRationalMatrix: ObjCEigenMatrix_LU, ObjCEigenMatrix_nativeLU {
    public typealias Coeff = RationalNumber.CType
}
