//
//  File.swift
//  
//
//  Created by Taketo Sano on 2021/06/11.
//

import SwmCore
import CEigenBridge

extension Double: CTypeCompatible {
    public typealias CType = Self
    
    @inlinable
    public init(fromCType r: CType) {
        self.init(r)
    }
    
    @inlinable
    public func toCType() -> CType {
        self
    }
}

extension Double: EigenMatrixCompatible {
    public static var eigen_init = eigen_dbl_init
    public static var eigen_free = eigen_dbl_free
    public static var eigen_copy = eigen_dbl_copy
    public static var eigen_get_entry = eigen_dbl_get_entry
    public static var eigen_set_entry = eigen_dbl_set_entry
    public static var eigen_copy_entries = eigen_dbl_copy_entries
    public static var eigen_rows = eigen_dbl_rows
    public static var eigen_cols = eigen_dbl_cols
    public static var eigen_is_zero = eigen_dbl_is_zero
    public static var eigen_det = eigen_dbl_det
    public static var eigen_trace = eigen_dbl_trace
    public static var eigen_inv = eigen_dbl_inv
    public static var eigen_transpose = eigen_dbl_transpose
    public static var eigen_submatrix = eigen_dbl_submatrix
    public static var eigen_concat = eigen_dbl_concat
    public static var eigen_stack = eigen_dbl_stack
    public static var eigen_perm_rows = eigen_dbl_perm_rows
    public static var eigen_perm_cols = eigen_dbl_perm_cols
    public static var eigen_eq = eigen_dbl_eq
    public static var eigen_add = eigen_dbl_add
    public static var eigen_neg = eigen_dbl_neg
    public static var eigen_minus = eigen_dbl_minus
    public static var eigen_mul = eigen_dbl_mul
    public static var eigen_scal_mul = eigen_dbl_scal_mul
    public static var eigen_dump = eigen_dbl_dump
}

extension Double: EigenMatrixCompatible_LU {
    public static var eigen_lu = eigen_dbl_lu
    public static var eigen_solve_lt = eigen_dbl_solve_lt
    public static var eigen_solve_ut = eigen_dbl_solve_ut
}

extension Double: EigenSparseMatrixCompatible {
    public static var eigen_s_init = eigen_s_dbl_init
    public static var eigen_s_free = eigen_s_dbl_free
    public static var eigen_s_copy = eigen_s_dbl_copy
    public static var eigen_s_copy_from_dense = eigen_s_dbl_copy_from_dense
    public static var eigen_s_copy_to_dense = eigen_s_dbl_copy_to_dense
    public static var eigen_s_set_entries = eigen_s_dbl_set_entries
    public static var eigen_s_get_entry = eigen_s_dbl_get_entry
    public static var eigen_s_set_entry = eigen_s_dbl_set_entry
    public static var eigen_s_rows = eigen_s_dbl_rows
    public static var eigen_s_cols = eigen_s_dbl_cols
    public static var eigen_s_transpose = eigen_s_dbl_transpose
    public static var eigen_s_submatrix = eigen_s_dbl_submatrix
    public static var eigen_s_concat = eigen_s_dbl_concat
    public static var eigen_s_perm_rows = eigen_s_dbl_perm_rows
    public static var eigen_s_perm_cols = eigen_s_dbl_perm_cols
    public static var eigen_s_eq = eigen_s_dbl_eq
    public static var eigen_s_add = eigen_s_dbl_add
    public static var eigen_s_neg = eigen_s_dbl_neg
    public static var eigen_s_minus = eigen_s_dbl_minus
    public static var eigen_s_mul = eigen_s_dbl_mul
    public static var eigen_s_scal_mul = eigen_s_dbl_scal_mul
    public static var eigen_s_nnz = eigen_s_dbl_nnz
    public static var eigen_s_copy_nz = eigen_s_dbl_copy_nz
    public static var eigen_s_dump = eigen_s_dbl_dump
}

extension Double: EigenSparseMatrixCompatible_LU {
    public static var eigen_s_solve_lt = eigen_s_dbl_solve_lt
    public static var eigen_s_solve_ut = eigen_s_dbl_solve_ut
}

