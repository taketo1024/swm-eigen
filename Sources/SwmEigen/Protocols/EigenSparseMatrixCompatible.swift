//
//  File.swift
//  
//
//  Created by Taketo Sano on 2021/06/13.
//

import SwmCore
import CEigenBridge

public protocol EigenSparseMatrixCompatible: Ring, CTypeCompatible  {
    static var eigen_s_init: (Int, Int) -> EigenMatrixPointer { get }
    static var eigen_s_free: (EigenMatrixPointer) -> Void { get }
    static var eigen_s_copy: (EigenMatrixPointer, EigenMatrixPointer) -> Void { get }
    static var eigen_s_copy_from_dense: (EigenMatrixPointer, EigenMatrixPointer) -> Void { get }
    static var eigen_s_copy_to_dense: (EigenMatrixPointer, EigenMatrixPointer) -> Void { get }
    static var eigen_s_set_entries: (EigenMatrixPointer, UnsafeMutablePointer<Int>, UnsafeMutablePointer<Int>, UnsafeMutablePointer<CType>, Int) -> Void { get }
    static var eigen_s_get_entry: (EigenMatrixPointer, Int, Int) -> CType { get }
    static var eigen_s_set_entry: (EigenMatrixPointer, Int, Int, CType) -> Void { get }
    static var eigen_s_rows: (EigenMatrixPointer) -> Int { get }
    static var eigen_s_cols: (EigenMatrixPointer) -> Int { get }
    static var eigen_s_transpose: (EigenMatrixPointer, EigenMatrixPointer) -> Void { get }
    static var eigen_s_submatrix: (EigenMatrixPointer, int_t, int_t, int_t, int_t, EigenMatrixPointer) -> Void { get }
    static var eigen_s_concat: (EigenMatrixPointer, EigenMatrixPointer, EigenMatrixPointer) -> Void { get }
    static var eigen_s_perm_rows: (EigenMatrixPointer, perm_t, EigenMatrixPointer) -> Void { get }
    static var eigen_s_perm_cols: (EigenMatrixPointer, perm_t, EigenMatrixPointer) -> Void { get }
    static var eigen_s_eq: (EigenMatrixPointer, EigenMatrixPointer) -> Bool { get }
    static var eigen_s_add: (EigenMatrixPointer, EigenMatrixPointer, EigenMatrixPointer) -> Void { get }
    static var eigen_s_neg: (EigenMatrixPointer, EigenMatrixPointer) -> Void { get }
    static var eigen_s_minus: (EigenMatrixPointer, EigenMatrixPointer, EigenMatrixPointer) -> Void { get }
    static var eigen_s_mul: (EigenMatrixPointer, EigenMatrixPointer, EigenMatrixPointer) -> Void { get }
    static var eigen_s_scal_mul: (CType, EigenMatrixPointer, EigenMatrixPointer) -> Void { get }
    static var eigen_s_nnz: (EigenMatrixPointer) -> Int { get }
    static var eigen_s_copy_nz: (EigenMatrixPointer, UnsafeMutablePointer<Int>, UnsafeMutablePointer<Int>, UnsafeMutablePointer<CType>) -> Void { get }
    static var eigen_s_dump: (EigenMatrixPointer) -> Void { get }
}

public protocol EigenSparseMatrixCompatible_LU: EigenSparseMatrixCompatible {
    static var eigen_s_solve_lt: (EigenMatrixPointer, EigenMatrixPointer, EigenMatrixPointer) -> Void { get }
    static var eigen_s_solve_ut: (EigenMatrixPointer, EigenMatrixPointer, EigenMatrixPointer) -> Void { get }
}

