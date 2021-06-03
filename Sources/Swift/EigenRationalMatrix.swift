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
}

extension ObjCEigenRationalMatrix: ObjCEigenMatrix_LU {
    public typealias Coeff = RationalNumber.CType
}
