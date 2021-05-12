//
//  File.swift
//  
//
//  Created by Taketo Sano on 2021/05/11.
//

import SwiftyMath

public struct EigenDoubleMatrix: EigenMatrixProtocol {
    public typealias ObjCMatrix = ObjCEigenDoubleMatrix
    public typealias BaseRing = Double
    
    public var objCMatrix: ObjCMatrix
    
    public init(_ objCMatrix: ObjCMatrix) {
        self.objCMatrix = objCMatrix
    }
}

extension ObjCEigenDoubleMatrix: ObjCEigenMatrixProtocol {
    public typealias Coeff = Double
}
