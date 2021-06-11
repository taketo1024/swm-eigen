//
//  File.swift
//  
//
//  Created by Taketo Sano on 2021/06/11.
//

import SwmCore
import CEigenBridge

extension RationalNumber: EigenSparseMatrixCompatible_LU {
    public typealias CType = rational_t
    
    @inlinable
    public init(fromCType r: rational_t) {
        self.init(r.p, r.q)
    }
    
    @inlinable
    public func toCType() -> rational_t {
        rational_t(p: numerator, q: denominator)
    }
    
    public static var eigen_init = eigen_rat_s_init
    public static var eigen_free = eigen_rat_s_free
    public static var eigen_copy = eigen_rat_s_copy
    public static var eigen_set_entries = eigen_rat_s_set_entries
    public static var eigen_get_entry = eigen_rat_s_get_entry
    public static var eigen_set_entry = eigen_rat_s_set_entry
    public static var eigen_rows = eigen_rat_s_rows
    public static var eigen_cols = eigen_rat_s_cols
    public static var eigen_transpose = eigen_rat_s_transpose
    public static var eigen_submatrix = eigen_rat_s_submatrix
    public static var eigen_concat = eigen_rat_s_concat
    public static var eigen_perm_rows = eigen_rat_s_perm_rows
    public static var eigen_perm_cols = eigen_rat_s_perm_cols
    public static var eigen_eq = eigen_rat_s_eq
    public static var eigen_add = eigen_rat_s_add
    public static var eigen_neg = eigen_rat_s_neg
    public static var eigen_minus = eigen_rat_s_minus
    public static var eigen_mul = eigen_rat_s_mul
    public static var eigen_scal_mul = eigen_rat_s_scal_mul
    public static var eigen_nnz = eigen_rat_s_nnz
    public static var eigen_copy_nz = eigen_rat_s_copy_nz
    public static var eigen_dump = eigen_rat_s_dump
    public static var eigen_solve_lt = eigen_rat_s_solve_lt
    public static var eigen_solve_ut = eigen_rat_s_solve_ut
}

