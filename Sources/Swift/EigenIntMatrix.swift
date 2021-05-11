//
//  File.swift
//  
//
//  Created by Taketo Sano on 2021/05/11.
//

import SwiftyMath

public struct EigenIntMatrix: EigenMatrixProtocol {
    public typealias ObjCType = ObjCEigenIntMatrix
    public typealias BaseRing = Int
    
    public var objCMatrix: ObjCEigenIntMatrix
    
    public init(_ objCMatrix: ObjCType) {
        self.objCMatrix = objCMatrix
    }
}

extension ObjCEigenIntMatrix: ObjCEigenMatrixProtocol {
    public typealias BaseRing = Int
}
