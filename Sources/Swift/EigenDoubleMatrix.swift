//
//  File.swift
//  
//
//  Created by Taketo Sano on 2021/05/11.
//

import SwmCore

public struct EigenDoubleMatrix: EigenMatrix {
    public typealias ObjCMatrix = ObjCEigenDoubleMatrix
    public typealias BaseRing = Double
    
    public var objCMatrix: ObjCMatrix
    
    public init(_ objCMatrix: ObjCMatrix) {
        self.objCMatrix = objCMatrix
    }
}

extension ObjCEigenDoubleMatrix: ObjCEigenMatrix {
    public typealias Coeff = Double
}
