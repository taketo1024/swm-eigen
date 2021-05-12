//
//  File.swift
//  
//
//  Created by Taketo Sano on 2021/05/11.
//

import SwiftyMath

public struct EigenIntMatrix: EigenMatrixProtocol {
    public typealias ObjCMatrix = ObjCEigenIntMatrix
    public typealias BaseRing = Int
    
    public var objCMatrix: ObjCMatrix
    
    public init(_ objCMatrix: ObjCMatrix) {
        self.objCMatrix = objCMatrix
    }
}

extension ObjCEigenIntMatrix: ObjCEigenMatrixProtocol {
    public typealias Coeff = Int
}
