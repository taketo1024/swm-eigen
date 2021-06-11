//
//  File.swift
//  
//
//  Created by Taketo Sano on 2021/06/10.
//

import SwmCore
import CEigenBridge

public typealias EigenMatrixPointer = UnsafeMutableRawPointer

public typealias EigenSparseMatrix<R, n, m> = MatrixIF<EigenSparseMatrixImpl<R>, n, m>
where R: EigenSparseMatrixCompatible, n: SizeType, m: SizeType

public typealias EigenSparseVector<R, n> = EigenSparseMatrix<R, n, _1>
where R: EigenSparseMatrixCompatible, n: SizeType

public protocol EigenSparseMatrixCompatible: Ring {
    associatedtype CType
    init(fromCType r: CType)
    func toCType() -> CType
    
    static var eigen_s_init: (Int, Int) -> EigenMatrixPointer { get }
    static var eigen_s_free: (EigenMatrixPointer) -> Void { get }
    static var eigen_s_copy: (EigenMatrixPointer, EigenMatrixPointer) -> Void { get }
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

public struct EigenSparseMatrixImpl<R: EigenSparseMatrixCompatible>: MatrixImpl {
    public typealias BaseRing = R
    
    private var ptr: EigenMatrixPointer
    private var destr: Destructor
    
    private init(_ ptr: EigenMatrixPointer) {
        self.ptr = ptr
        self.destr = Destructor {
            R.eigen_s_free(ptr)
        }
    }
    
    private init(size: MatrixSize) {
        let ptr = R.eigen_s_init(size.rows, size.cols)
        self.init(ptr)
    }
    
    public init(size: MatrixSize, initializer: ((Int, Int, R) -> Void) -> Void) {
        self.init(size: size)
        
        let (n, m) = size
        var rows = Array<Int>()
        var cols = Array<Int>()
        var vals = Array<R.CType>()
        
        initializer { (i, j, a) in
            assert( 0 <= i && i < n )
            assert( 0 <= j && j < m )
            if !a.isZero {
                rows.append(i)
                cols.append(j)
                vals.append(a.toCType())
            }
        }
        
        R.eigen_s_set_entries(ptr, &rows, &cols, &vals, vals.count)
    }
    
    public mutating func copyOnWrite() {
        if !isKnownUniquelyReferenced(&destr) {
            let new = R.eigen_s_init(size.rows, size.cols)
            R.eigen_s_copy(ptr, new)
            
            self.ptr = new
            self.destr = Destructor {
                R.eigen_s_free(new)
            }
        }
    }

    public subscript(i: Int, j: Int) -> R {
        get {
            R(fromCType: R.eigen_s_get_entry(ptr, i, j))
        }
        set {
            copyOnWrite()
            R.eigen_s_set_entry(ptr, i, j, newValue.toCType())
        }
    }
    
    public var size: (rows: Int, cols: Int) {
        (R.eigen_s_rows(ptr), R.eigen_s_cols(ptr))
    }
    
    public var transposed: Self {
        let b = Self(size: (size.cols, size.rows))
        R.eigen_s_transpose(ptr, b.ptr)
        return b
    }
    
    public func submatrix(rowRange: Range<Int>, colRange: Range<Int>) -> Self {
        let i = rowRange.lowerBound
        let j = colRange.lowerBound
        let h = rowRange.upperBound - rowRange.lowerBound
        let w = colRange.upperBound - colRange.lowerBound
        let b = Self(size: (h, w))
        R.eigen_s_submatrix(ptr, i, j, h, w, b.ptr)
        return b
    }
    
    public func concat(_ B: Self) -> Self {
        let c = Self(size: (size.rows, size.cols + B.size.cols))
        R.eigen_s_concat(ptr, B.ptr, c.ptr)
        return c
    }
    
    public func permuteRows(by P: Permutation<anySize>) -> Self {
        let b = Self(size: size)
        let p = perm_init(P.length)
        defer { perm_free(p) }
        P.copy(into: p)
        R.eigen_s_perm_rows(ptr, p, b.ptr)
        return b
    }
    
    public func permuteCols(by P: Permutation<anySize>) -> Self {
        let b = Self(size: size)
        let p = perm_init(P.length)
        defer { perm_free(p) }
        P.copy(into: p)
        R.eigen_s_perm_cols(ptr, p, b.ptr)
        return b
    }
    
    public func permute(rowsBy p: Permutation<anySize>, colsBy q: Permutation<anySize>) -> Self {
        permuteRows(by: p).permuteCols(by: q)
    }
    
    public var nonZeroEntries: AnySequence<MatrixEntry<R>> {
        let l = R.eigen_s_nnz(ptr)
        let rows = UnsafeMutableBufferPointer<Int>.allocate(capacity: l)
        let cols = UnsafeMutableBufferPointer<Int>.allocate(capacity: l)
        let vals = UnsafeMutableBufferPointer<R.CType>.allocate(capacity: l)

        R.eigen_s_copy_nz(ptr, rows.baseAddress!, cols.baseAddress!, vals.baseAddress!)

        return AnySequence((0 ..< l).compactMap { i -> MatrixEntry<BaseRing>? in
            let r = rows[i]
            let c = cols[i]
            let v = R(fromCType: vals[i])
            return v.isZero ? nil : MatrixEntry(r, c, v)
        })
    }
    
    public static func == (a: Self, b: Self) -> Bool {
        R.eigen_s_eq(a.ptr, b.ptr)
    }
    
    public static func + (a: Self, b: Self) -> Self {
        let c = Self(size: a.size)
        R.eigen_s_add(a.ptr, b.ptr, c.ptr)
        return c
    }
    
    public static prefix func - (a: Self) -> Self {
        let b = Self(size: a.size)
        R.eigen_s_neg(a.ptr, b.ptr)
        return b
    }
    
    public static func - (a: Self, b: Self) -> Self {
        let c = Self(size: a.size)
        R.eigen_s_minus(a.ptr, b.ptr, c.ptr)
        return c
    }
    
    public static func * (a: Self, b: Self) -> Self {
        let c = Self(size: (a.size.rows, b.size.cols))
        R.eigen_s_mul(a.ptr, b.ptr, c.ptr)
        return c
    }
    
    public static func * (r: R, a: Self) -> Self {
        let b = Self(size: a.size)
        R.eigen_s_scal_mul(r.toCType(), a.ptr, b.ptr)
        return b
    }
    
    public static func * (a: Self, r: R) -> Self {
        let b = Self(size: a.size)
        R.eigen_s_scal_mul(r.toCType(), a.ptr, b.ptr)
        return b
    }
    
    public func dump() {
        R.eigen_s_dump(ptr)
    }
}

// conforms to LUFactorizable
extension EigenSparseMatrixImpl where R: EigenSparseMatrixCompatible_LU {
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
