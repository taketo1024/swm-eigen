//
//  File.swift
//  
//
//  Created by Taketo Sano on 2021/06/10.
//

import SwmCore
import CEigenBridge

public typealias EigenMatrix<R, n, m> = MatrixIF<EigenMatrixImpl<R>, n, m>
where R: EigenMatrixCompatible, n: SizeType, m: SizeType

public typealias EigenVector<R, n> = EigenMatrix<R, n, _1>
where R: EigenMatrixCompatible, n: SizeType

public struct EigenMatrixImpl<R: EigenMatrixCompatible>: MatrixImpl {
    public typealias BaseRing = R
    
    private var ptr: EigenMatrixPointer
    private var destr: Destructor
    
    private init(_ ptr: EigenMatrixPointer) {
        self.ptr = ptr
        self.destr = Destructor {
            R.eigen_free(ptr)
        }
    }
    
    public init(size: MatrixSize) {
        let ptr = R.eigen_init(size.rows, size.cols)
        self.init(ptr)
    }
    
    public init(size: MatrixSize, initializer: ((Int, Int, R) -> Void) -> Void) {
        self.init(size: size)
        
        let (n, m) = size
        initializer { (i, j, a) in
            assert( 0 <= i && i < n )
            assert( 0 <= j && j < m )
            if !a.isZero {
                R.eigen_set_entry(ptr, i, j, a.toCType())
            }
        }
    }
    
    internal var pointer: EigenMatrixPointer {
        ptr
    }
    
    public mutating func copyOnWrite() {
        if !isKnownUniquelyReferenced(&destr) {
            let new = R.eigen_init(size.rows, size.cols)
            R.eigen_copy(ptr, new)
            
            self.ptr = new
            self.destr = Destructor {
                R.eigen_free(new)
            }
        }
    }

    public subscript(i: Int, j: Int) -> R {
        get {
            R(fromCType: R.eigen_get_entry(ptr, i, j))
        }
        set {
            copyOnWrite()
            R.eigen_set_entry(ptr, i, j, newValue.toCType())
        }
    }
        
    public var size: (rows: Int, cols: Int) {
        (R.eigen_rows(ptr), R.eigen_cols(ptr))
    }
    
    public var isZero: Bool {
        R.eigen_is_zero(ptr)
    }
    
    public var determinant: R {
        assert(isSquare)
        return R(fromCType: R.eigen_det(ptr))
    }
    
    public var trace: R {
        assert(isSquare)
        return R(fromCType: R.eigen_trace(ptr))
    }
    
    public var inverse: EigenMatrixImpl<R>? {
        assert(isSquare)
        if determinant != .zero {
            let b = Self(size: size)
            R.eigen_inv(ptr, b.ptr)
            return b
        } else {
            return nil
        }
    }
    
    public var transposed: Self {
        let b = Self(size: (size.cols, size.rows))
        R.eigen_transpose(ptr, b.ptr)
        return b
    }
    
    public func submatrix(rowRange: Range<Int>, colRange: Range<Int>) -> Self {
        let i = rowRange.lowerBound
        let j = colRange.lowerBound
        let h = rowRange.upperBound - rowRange.lowerBound
        let w = colRange.upperBound - colRange.lowerBound
        let b = Self(size: (h, w))
        R.eigen_submatrix(ptr, i, j, h, w, b.ptr)
        return b
    }
    
    public func concat(_ B: Self) -> Self {
        let c = Self(size: (size.rows, size.cols + B.size.cols))
        R.eigen_concat(ptr, B.ptr, c.ptr)
        return c
    }
    
    public func stack(_ B: Self) -> Self {
        let c = Self(size: (size.rows + B.size.rows, size.cols))
        R.eigen_stack(ptr, B.ptr, c.ptr)
        return c
    }
    
    public func permuteRows(by P: Permutation<anySize>) -> Self {
        let b = Self(size: size)
        let p = perm_init(P.length)
        defer { perm_free(p) }
        P.copy(into: p)
        R.eigen_perm_rows(ptr, p, b.ptr)
        return b
    }
    
    public func permuteCols(by P: Permutation<anySize>) -> Self {
        let b = Self(size: size)
        let p = perm_init(P.length)
        defer { perm_free(p) }
        P.copy(into: p)
        R.eigen_perm_cols(ptr, p, b.ptr)
        return b
    }
    
    public func permute(rowsBy p: Permutation<anySize>, colsBy q: Permutation<anySize>) -> Self {
        permuteRows(by: p).permuteCols(by: q)
    }
    
    public var nonZeroEntries: AnySequence<MatrixEntry<R>> {
        let l = size.rows * size.cols
        var vals = Array(repeating: R.zero.toCType(), count: l)
        vals.withUnsafeMutableBufferPointer { p in
            R.eigen_copy_entries(ptr, p.baseAddress!)
        }
        return AnySequence(NonZeroEntryIterator(size, vals))
    }
    
    public func serialize() -> [R] {
        let l = size.rows * size.cols
        var vals = Array(repeating: R.zero.toCType(), count: l)
        vals.withUnsafeMutableBufferPointer { p in
            R.eigen_copy_entries(ptr, p.baseAddress!)
        }
        return vals.map{ R(fromCType: $0) }
    }
    
    public static func == (a: Self, b: Self) -> Bool {
        R.eigen_eq(a.ptr, b.ptr)
    }
    
    public static func + (a: Self, b: Self) -> Self {
        let c = Self(size: a.size)
        R.eigen_add(a.ptr, b.ptr, c.ptr)
        return c
    }
    
    public static prefix func - (a: Self) -> Self {
        let b = Self(size: a.size)
        R.eigen_neg(a.ptr, b.ptr)
        return b
    }
    
    public static func - (a: Self, b: Self) -> Self {
        let c = Self(size: a.size)
        R.eigen_minus(a.ptr, b.ptr, c.ptr)
        return c
    }
    
    public static func * (a: Self, b: Self) -> Self {
        let c = Self(size: (a.size.rows, b.size.cols))
        R.eigen_mul(a.ptr, b.ptr, c.ptr)
        return c
    }
    
    public static func * (r: R, a: Self) -> Self {
        let b = Self(size: a.size)
        R.eigen_scal_mul(r.toCType(), a.ptr, b.ptr)
        return b
    }
    
    public static func * (a: Self, r: R) -> Self {
        let b = Self(size: a.size)
        R.eigen_scal_mul(r.toCType(), a.ptr, b.ptr)
        return b
    }
    
    public func dump() {
        R.eigen_dump(ptr)
    }
    
    private struct NonZeroEntryIterator: Sequence, IteratorProtocol {
        let size: MatrixSize
        let values: [R.CType]
        var index: Int
        
        init(_ size: MatrixSize, _ values: [R.CType]) {
            self.size = size
            self.values = values
            self.index = 0
        }
        
        mutating func next() -> MatrixEntry<R>? {
            if index >= values.count {
                return nil
            }
            while index < values.count {
                defer { index += 1 }
                let value = R(fromCType: values[index])
                if !value.isZero {
                    let i = index / size.cols
                    let j = index % size.cols
                    return (i, j, value)
                }
            }
            return nil
        }
    }
}

extension EigenMatrixImpl where R: EigenSparseMatrixCompatible {
    public func toSparse() -> EigenSparseMatrixImpl<R> {
        let sparse = EigenSparseMatrixImpl<R>(size: size)
        R.eigen_s_copy_from_dense(ptr, sparse.pointer)
        return sparse
    }
}

extension MatrixIF {
    public func toSparse<R: EigenSparseMatrixCompatible>() -> EigenSparseMatrix<R, n, m> where Impl == EigenMatrixImpl<R> {
        .init(impl.toSparse())
    }
}

// MEMO
// conforms to LUFactorizable
extension EigenMatrixImpl where R: EigenMatrixCompatible_LU {
    public func LUfactorize() -> (P: Permutation<anySize>, Q: Permutation<anySize>, L: Self, U: Self) {
        denseLUfactorize()
    }
    
    public func denseLUfactorize() -> (P: Permutation<anySize>, Q: Permutation<anySize>, L: Self, U: Self) {
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
