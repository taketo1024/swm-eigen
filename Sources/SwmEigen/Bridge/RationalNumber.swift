//
//  File.swift
//  
//
//  Created by Taketo Sano on 2021/06/11.
//

import SwmCore
import CEigenBridge

extension RationalNumber: CTypeCompatible {
    public typealias CType = rational_t
    
    @inlinable
    public init(fromCType r: CType) {
        self.init(r.p, r.q)
    }
    
    @inlinable
    public func toCType() -> CType {
        rational_t(p: numerator, q: denominator)
    }
}

extension RationalNumber: EigenMatrixCompatible {
    public static var eigen_init = eigen_rat_init
    public static var eigen_free = eigen_rat_free
    public static var eigen_copy = eigen_rat_copy
    public static var eigen_get_entry = eigen_rat_get_entry
    public static var eigen_set_entry = eigen_rat_set_entry
    public static var eigen_copy_entries = eigen_rat_copy_entries
    public static var eigen_rows = eigen_rat_rows
    public static var eigen_cols = eigen_rat_cols
    public static var eigen_is_zero = eigen_rat_is_zero
    public static var eigen_det = eigen_rat_det
    public static var eigen_trace = eigen_rat_trace
    public static var eigen_inv = eigen_rat_inv
    public static var eigen_transpose = eigen_rat_transpose
    public static var eigen_submatrix = eigen_rat_submatrix
    public static var eigen_concat = eigen_rat_concat
    public static var eigen_stack = eigen_rat_stack
    public static var eigen_perm_rows = eigen_rat_perm_rows
    public static var eigen_perm_cols = eigen_rat_perm_cols
    public static var eigen_eq = eigen_rat_eq
    public static var eigen_add = eigen_rat_add
    public static var eigen_neg = eigen_rat_neg
    public static var eigen_minus = eigen_rat_minus
    public static var eigen_mul = eigen_rat_mul
    public static var eigen_scal_mul = eigen_rat_scal_mul
    public static var eigen_dump = eigen_rat_dump
}

extension RationalNumber: EigenMatrixCompatible_LU {
    public static var eigen_lu = eigen_rat_lu
    public static var eigen_solve_lt = eigen_rat_solve_lt
    public static var eigen_solve_ut = eigen_rat_solve_ut
}

extension RationalNumber: EigenSparseMatrixCompatible {
    public static var eigen_s_init = eigen_s_rat_init
    public static var eigen_s_free = eigen_s_rat_free
    public static var eigen_s_copy = eigen_s_rat_copy
    public static var eigen_s_copy_from_dense = eigen_s_rat_copy_from_dense
    public static var eigen_s_copy_to_dense = eigen_s_rat_copy_to_dense
    public static var eigen_s_set_entries = eigen_s_rat_set_entries
    public static var eigen_s_get_entry = eigen_s_rat_get_entry
    public static var eigen_s_set_entry = eigen_s_rat_set_entry
    public static var eigen_s_rows = eigen_s_rat_rows
    public static var eigen_s_cols = eigen_s_rat_cols
    public static var eigen_s_transpose = eigen_s_rat_transpose
    public static var eigen_s_submatrix = eigen_s_rat_submatrix
    public static var eigen_s_concat = eigen_s_rat_concat
    public static var eigen_s_perm_rows = eigen_s_rat_perm_rows
    public static var eigen_s_perm_cols = eigen_s_rat_perm_cols
    public static var eigen_s_eq = eigen_s_rat_eq
    public static var eigen_s_add = eigen_s_rat_add
    public static var eigen_s_neg = eigen_s_rat_neg
    public static var eigen_s_minus = eigen_s_rat_minus
    public static var eigen_s_mul = eigen_s_rat_mul
    public static var eigen_s_scal_mul = eigen_s_rat_scal_mul
    public static var eigen_s_nnz = eigen_s_rat_nnz
    public static var eigen_s_copy_nz = eigen_s_rat_copy_nz
    public static var eigen_s_dump = eigen_s_rat_dump
}

extension RationalNumber: EigenSparseMatrixCompatible_LU {
    public static var eigen_s_solve_lt = eigen_s_rat_solve_lt
    public static var eigen_s_solve_ut = eigen_s_rat_solve_ut
}

