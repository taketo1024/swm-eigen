//
//  File.swift
//  
//
//  Created by Taketo Sano on 2021/06/10.
//

import SwmCore
import SwmMatrixTools
import CEigenBridge

extension EigenSparseMatrixImpl: LUFactorizable where R: EigenSparseMatrixCompatible_LU & ComputationalRing {

    // MEMO: Eigen does not provide LU factorization for sparse matrices.
    // The default implementation of SwmMatrixTools is used.
    
    public static func solveLowerTriangular(_ L: Self, _ b: Self) -> Self {
        let x = Self(size: (L.size.cols, b.size.cols))
        R.eigen_s_solve_lt(L.ptr, b.ptr, x.ptr)
        return x
    }

    public static func solveUpperTriangular(_ U: Self, _ b: Self) -> Self {
        let x = Self(size: (U.size.cols, b.size.cols))
        R.eigen_s_solve_ut(U.ptr, b.ptr, x.ptr)
        return x
    }
}
