//
//  File.swift
//  
//
//  Created by Taketo Sano on 2021/06/10.
//

import SwmCore
import SwmMatrixTools
import CEigenBridge

extension EigenMatrixImpl: LUFactorizable where R: EigenMatrixCompatible_LU {
    public func LUfactorize() -> (P: Permutation<anySize>, Q: Permutation<anySize>, L: Self, U: Self) {
        let p = perm_init(self.size.rows)
        let q = perm_init(self.size.cols)
        defer {
            perm_free(p)
            perm_free(q)
        }
        let L = Self.init(size: size)
        let U = Self.init(size: size)
        
        R.eigen_lu(ptr, p, q, L.ptr, U.ptr) // L, U are resized appropriately.
        
        return (
            P: Permutation(fromCType: p),
            Q: Permutation(fromCType: q).inverse!,
            L: L,
            U: U
        )
    }

    public static func solveLowerTriangular(_ L: Self, _ b: Self) -> Self {
        let x = Self(size: (L.size.cols, b.size.cols))
        R.eigen_solve_lt(L.ptr, b.ptr, x.ptr)
        return x
    }

    public static func solveUpperTriangular(_ U: Self, _ b: Self) -> Self {
        let x = Self(size: (U.size.cols, b.size.cols))
        R.eigen_solve_ut(U.ptr, b.ptr, x.ptr)
        return x
    }
}
