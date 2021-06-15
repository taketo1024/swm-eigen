//
//  File.swift
//  
//
//  Created by Taketo Sano on 2021/06/11.
//

import SwmCore
import CEigenBridge

extension 𝐅₂: CTypeCompatible {
    public typealias CType = UInt8
    
    @inlinable
    public init(fromCType a: CType) {
        self.init(a)
    }
    
    @inlinable
    public func toCType() -> CType {
        representative
    }
}

extension 𝐅₂: EigenMatrixCompatible {
    public static var eigen_init = eigen_f2_init
    public static var eigen_free = eigen_f2_free
    public static var eigen_copy = eigen_f2_copy
    public static var eigen_get_entry = eigen_f2_get_entry
    public static var eigen_set_entry = eigen_f2_set_entry
    public static var eigen_copy_entries = eigen_f2_copy_entries
    public static var eigen_rows = eigen_f2_rows
    public static var eigen_cols = eigen_f2_cols
    public static var eigen_is_zero = eigen_f2_is_zero
    public static var eigen_det = eigen_f2_det
    public static var eigen_trace = eigen_f2_trace
    public static var eigen_inv = eigen_f2_inv
    public static var eigen_transpose = eigen_f2_transpose
    public static var eigen_submatrix = eigen_f2_submatrix
    public static var eigen_concat = eigen_f2_concat
    public static var eigen_stack = eigen_f2_stack
    public static var eigen_perm_rows = eigen_f2_perm_rows
    public static var eigen_perm_cols = eigen_f2_perm_cols
    public static var eigen_eq = eigen_f2_eq
    public static var eigen_add = eigen_f2_add
    public static var eigen_neg = eigen_f2_neg
    public static var eigen_minus = eigen_f2_minus
    public static var eigen_mul = eigen_f2_mul
    public static var eigen_scal_mul = eigen_f2_scal_mul
    public static var eigen_dump = eigen_f2_dump
}

extension 𝐅₂: EigenMatrixCompatible_LU {
    public static var eigen_lu = eigen_f2_lu
    public static var eigen_solve_lt = eigen_f2_solve_lt
    public static var eigen_solve_ut = eigen_f2_solve_ut
}

extension 𝐅₂: EigenSparseMatrixCompatible {
    public static var eigen_s_init = eigen_s_f2_init
    public static var eigen_s_free = eigen_s_f2_free
    public static var eigen_s_copy = eigen_s_f2_copy
    public static var eigen_s_copy_from_dense = eigen_s_f2_copy_from_dense
    public static var eigen_s_copy_to_dense = eigen_s_f2_copy_to_dense
    public static var eigen_s_set_entries = eigen_s_f2_set_entries
    public static var eigen_s_get_entry = eigen_s_f2_get_entry
    public static var eigen_s_set_entry = eigen_s_f2_set_entry
    public static var eigen_s_rows = eigen_s_f2_rows
    public static var eigen_s_cols = eigen_s_f2_cols
    public static var eigen_s_transpose = eigen_s_f2_transpose
    public static var eigen_s_submatrix = eigen_s_f2_submatrix
    public static var eigen_s_concat = eigen_s_f2_concat
    public static var eigen_s_perm_rows = eigen_s_f2_perm_rows
    public static var eigen_s_perm_cols = eigen_s_f2_perm_cols
    public static var eigen_s_eq = eigen_s_f2_eq
    public static var eigen_s_add = eigen_s_f2_add
    public static var eigen_s_neg = eigen_s_f2_neg
    public static var eigen_s_minus = eigen_s_f2_minus
    public static var eigen_s_mul = eigen_s_f2_mul
    public static var eigen_s_scal_mul = eigen_s_f2_scal_mul
    public static var eigen_s_nnz = eigen_s_f2_nnz
    public static var eigen_s_copy_nz = eigen_s_f2_copy_nz
    public static var eigen_s_dump = eigen_s_f2_dump
}

extension 𝐅₂: EigenSparseMatrixCompatible_LU {
    public static var eigen_s_solve_lt = eigen_s_f2_solve_lt
    public static var eigen_s_solve_ut = eigen_s_f2_solve_ut
}

