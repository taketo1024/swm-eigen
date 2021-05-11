//
//  File.swift
//  
//
//  Created by Taketo Sano on 2021/05/11.
//

import SwiftyMath

public struct EigenDoubleMatrix: EigenMatrixProtocol {
    public typealias ObjCType = ObjCEigenDoubleMatrix
    public typealias BaseRing = Double
    
    public var objCMatrix: ObjCEigenDoubleMatrix
    
    public init(_ objCMatrix: ObjCType) {
        self.objCMatrix = objCMatrix
    }
}

extension ObjCEigenDoubleMatrix: ObjCEigenMatrixProtocol {
    public typealias BaseRing = Double
}
