//
//  File.swift
//  
//
//  Created by Taketo Sano on 2021/05/13.
//

import SwiftyMath

public protocol EigenMatrix_LU: EigenMatrix, MatrixImpl_LU {}

extension EigenMatrix_LU where ObjCMatrix: ObjCEigenMatrix_LU {
    public var L: Self {
        .init(objCMatrix.getL())
    }
    
    public var U: Self {
        .init(objCMatrix.getU())
    }
    
    public var P: Self {
        .init(objCMatrix.getP())
    }

    public var Q: Self {
        .init(objCMatrix.getQ())
    }
    
    public var rank: Int {
        objCMatrix.rank()
    }

    public var nullity: Int {
        objCMatrix.nullity()
    }

    public var image: Self {
        .init(objCMatrix.image())
    }
    
    public var kernel: Self {
        .init(objCMatrix.kernel())
    }
    
    public func solve(_ b: Self) -> Self? {
        objCMatrix.solve(b.objCMatrix).flatMap{ .init($0) }
    }
}

