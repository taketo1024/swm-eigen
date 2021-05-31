//
//  File.swift
//  
//
//  Created by Taketo Sano on 2021/05/11.
//

import SwmCore

public struct EigenRationalMatrix: EigenMatrix {
    public typealias ObjCMatrix = ObjCEigenRationalMatrix
    public typealias BaseRing = RationalNumber

    public var objCMatrix: ObjCMatrix

    public init(_ objCMatrix: ObjCMatrix) {
        self.objCMatrix = objCMatrix
    }
}

extension ObjCEigenRationalMatrix: ObjCEigenMatrix {
    public typealias Coeff = RationalNumber.CType
}
