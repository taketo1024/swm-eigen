//
//  File.swift
//  
//
//  Created by Taketo Sano on 2021/06/13.
//

import SwmCore
import CEigenBridge

public typealias EigenMatrixPointer = UnsafeMutableRawPointer

public protocol EigenMatrixCompatible: Ring, CTypeCompatible {
    static var eigen_init: (Int, Int) -> EigenMatrixPointer { get }
    static var eigen_free: (EigenMatrixPointer) -> Void { get }
    static var eigen_copy: (EigenMatrixPointer, EigenMatrixPointer) -> Void { get }
    static var eigen_get_entry: (EigenMatrixPointer, Int, Int) -> CType { get }
    static var eigen_set_entry: (EigenMatrixPointer, Int, Int, CType) -> Void { get }
    static var eigen_rows: (EigenMatrixPointer) -> Int { get }
    static var eigen_cols: (EigenMatrixPointer) -> Int { get }
    static var eigen_is_zero: (EigenMatrixPointer) -> Bool { get }
    static var eigen_det: (EigenMatrixPointer) -> CType { get }
    static var eigen_trace: (EigenMatrixPointer) -> CType { get }
    static var eigen_inv: (EigenMatrixPointer, EigenMatrixPointer) -> Void { get }
    static var eigen_transpose: (EigenMatrixPointer, EigenMatrixPointer) -> Void { get }
    static var eigen_submatrix: (EigenMatrixPointer, int_t, int_t, int_t, int_t, EigenMatrixPointer) -> Void { get }
    static var eigen_concat: (EigenMatrixPointer, EigenMatrixPointer, EigenMatrixPointer) -> Void { get }
    static var eigen_stack: (EigenMatrixPointer, EigenMatrixPointer, EigenMatrixPointer) -> Void { get }
    static var eigen_perm_rows: (EigenMatrixPointer, perm_t, EigenMatrixPointer) -> Void { get }
    static var eigen_perm_cols: (EigenMatrixPointer, perm_t, EigenMatrixPointer) -> Void { get }
    static var eigen_eq: (EigenMatrixPointer, EigenMatrixPointer) -> Bool { get }
    static var eigen_add: (EigenMatrixPointer, EigenMatrixPointer, EigenMatrixPointer) -> Void { get }
    static var eigen_neg: (EigenMatrixPointer, EigenMatrixPointer) -> Void { get }
    static var eigen_minus: (EigenMatrixPointer, EigenMatrixPointer, EigenMatrixPointer) -> Void { get }
    static var eigen_mul: (EigenMatrixPointer, EigenMatrixPointer, EigenMatrixPointer) -> Void { get }
    static var eigen_scal_mul: (CType, EigenMatrixPointer, EigenMatrixPointer) -> Void { get }
    static var eigen_copy_entries: (EigenMatrixPointer, UnsafeMutablePointer<CType>) -> Void { get }
    static var eigen_dump: (EigenMatrixPointer) -> Void { get }
}

public protocol EigenMatrixCompatible_LU: EigenMatrixCompatible {
    static var eigen_lu: (EigenMatrixPointer, perm_t, perm_t, EigenMatrixPointer, EigenMatrixPointer) -> Void { get }
    static var eigen_solve_lt: (EigenMatrixPointer, EigenMatrixPointer, EigenMatrixPointer) -> Void { get }
    static var eigen_solve_ut: (EigenMatrixPointer, EigenMatrixPointer, EigenMatrixPointer) -> Void { get }
}
