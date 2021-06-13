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

public struct EigenSparseMatrixImpl<R: EigenSparseMatrixCompatible>: SparseMatrixImpl {
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
    
    public var numberOfNonZeros: Int {
        R.eigen_s_nnz(ptr)
    }
    
    public var nonZeroEntries: AnySequence<MatrixEntry<R>> {
        let l = R.eigen_s_nnz(ptr)
        var rows = Array(repeating: 0, count: l)
        var cols = Array(repeating: 0, count: l)
        var vals = Array(repeating: R.zero.toCType(), count: l)
        
        rows.withUnsafeMutableBufferPointer { p1 in
            cols.withUnsafeMutableBufferPointer { p2 in
                vals.withUnsafeMutableBufferPointer { p3 in
                    R.eigen_s_copy_nz(ptr, p1.baseAddress!, p2.baseAddress!, p3.baseAddress!)
                }
            }
        }
        
        return AnySequence(NonZeroEntryIterator(rows, cols, vals))
    }
    
    public static func == (a: Self, b: Self) -> Bool {
        DefaultMatrixImpl<R>(size: a.size, entries: a.nonZeroEntries)
            == DefaultMatrixImpl<R>(size: b.size, entries: b.nonZeroEntries)
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
    
    private struct NonZeroEntryIterator: Sequence, IteratorProtocol {
        let rows: [Int]
        let cols: [Int]
        let values: [R.CType]
        var index: Int
        
        init(_ rows: [Int], _ cols: [Int], _ values: [R.CType]) {
            self.rows = rows
            self.cols = cols
            self.values = values
            self.index = 0
        }
        
        mutating func next() -> MatrixEntry<R>? {
            if index >= values.count {
                return nil
            }
            defer { index += 1 }
            let value = R(fromCType: values[index])
            
            assert(!value.isZero)
            
            return (rows[index], cols[index], value)
        }
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
