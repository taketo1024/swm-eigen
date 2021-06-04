//
//  File.swift
//  
//
//  Created by Taketo Sano on 2021/05/11.
//

import SwmCore

public struct EigenIntMatrix: EigenMatrix {
    public typealias ObjCMatrix = ObjCEigenIntMatrix
    public typealias BaseRing = Int
    
    public var objCMatrix: ObjCMatrix
    
    public init(_ objCMatrix: ObjCMatrix) {
        self.objCMatrix = objCMatrix
    }
}

extension ObjCEigenIntMatrix: ObjCEigenMatrix {
    public typealias Coeff = Int
}
