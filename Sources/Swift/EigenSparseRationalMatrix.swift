//
//  File.swift
//  
//
//  Created by Taketo Sano on 2021/06/10.
//

import SwmCore
import CEigenBridge

internal final class Destructor {
    private let destructor: () -> Void
    init(_ destructor: @escaping () -> Void) {
        self.destructor = destructor
    }
    
    deinit {
        destructor()
    }
}

public struct EigenSparseRationalMatrix: MatrixImpl {
    public typealias BaseRing = RationalNumber
    
    private typealias Pointer = UnsafeMutableRawPointer
    
    private var ptr: Pointer
    private var destr: Destructor
    
    private init(_ ptr: Pointer) {
        self.ptr = ptr
        self.destr = Destructor {
            eigen_rat_s_free(ptr)
        }
    }
    
    private init(size: MatrixSize) {
        let ptr = eigen_rat_s_init(size.rows, size.cols)
        self.init(ptr)
    }
    
    public init(size: MatrixSize, initializer: ((Int, Int, RationalNumber) -> Void) -> Void) {
        self.init(size: size)
        
        let (n, m) = size
        var triplets = Array<rational_triplet_t>()
        triplets.reserveCapacity(n * m / 10) // TODO
        
        initializer { (i, j, a) in
            assert( 0 <= i && i < n )
            assert( 0 <= j && j < m )
            if !a.isZero {
                triplets.append(rational_triplet_t(row: i, col: j, value: a.toCType))
            }
        }
        
        eigen_rat_s_set_triplets(ptr, &triplets, triplets.count)
    }
    
    public mutating func copyOnWrite() {
        if !isKnownUniquelyReferenced(&destr) {
            let new = eigen_rat_s_init(size.rows, size.cols)
            eigen_rat_s_copy(ptr, new)
            
            self.ptr = new
            self.destr = Destructor {
                eigen_rat_s_free(new)
            }
        }
    }

    public subscript(i: Int, j: Int) -> RationalNumber {
        get {
            RationalNumber(fromCType: eigen_rat_s_get(ptr, i, j))
        }
        set {
            copyOnWrite()
            eigen_rat_s_set(ptr, i, j, newValue.toCType)
        }
    }
    
    public var size: (rows: Int, cols: Int) {
        (eigen_rat_s_rows(ptr), eigen_rat_s_cols(ptr))
    }
    
    public var nonZeroEntries: AnySequence<MatrixEntry<BaseRing>> {
        let l = eigen_rat_s_nnz(ptr)
        let p = UnsafeMutableBufferPointer<rational_triplet_t>.allocate(capacity: l)
        
        eigen_rat_s_copy_nz(ptr, p.baseAddress!)
        
        return AnySequence(p.compactMap { t -> MatrixEntry<BaseRing>? in
            let r = BaseRing(fromCType: t.value)
            return r.isZero ? nil : MatrixEntry(t.row, t.col, r)
        })
    }
    
    public static func == (a: EigenSparseRationalMatrix, b: EigenSparseRationalMatrix) -> Bool {
        eigen_rat_s_eq(a.ptr, b.ptr)
    }
    
    public static func + (a: EigenSparseRationalMatrix, b: EigenSparseRationalMatrix) -> EigenSparseRationalMatrix {
        let c = EigenSparseRationalMatrix(size: a.size)
        eigen_rat_s_add(a.ptr, b.ptr, c.ptr)
        return c
    }
    
    public static prefix func - (a: EigenSparseRationalMatrix) -> EigenSparseRationalMatrix {
        let b = EigenSparseRationalMatrix(size: a.size)
        eigen_rat_s_neg(a.ptr, b.ptr)
        return b
    }
    
    public static func - (a: EigenSparseRationalMatrix, b: EigenSparseRationalMatrix) -> EigenSparseRationalMatrix {
        let c = EigenSparseRationalMatrix(size: a.size)
        eigen_rat_s_minus(a.ptr, b.ptr, c.ptr)
        return c
    }
    
    public static func * (a: EigenSparseRationalMatrix, b: EigenSparseRationalMatrix) -> EigenSparseRationalMatrix {
        let c = EigenSparseRationalMatrix(size: (a.size.rows, b.size.cols))
        eigen_rat_s_mul(a.ptr, b.ptr, c.ptr)
        return c
    }
    
    public static func * (r: RationalNumber, a: EigenSparseRationalMatrix) -> EigenSparseRationalMatrix {
        let b = EigenSparseRationalMatrix(size: a.size)
        eigen_rat_s_scal_mul(r.toCType, a.ptr, b.ptr)
        return b
    }
    
    public static func * (a: EigenSparseRationalMatrix, r: RationalNumber) -> EigenSparseRationalMatrix {
        let b = EigenSparseRationalMatrix(size: a.size)
        eigen_rat_s_scal_mul(r.toCType, a.ptr, b.ptr)
        return b
    }
    
    public func dump() {
        eigen_rat_s_dump(ptr)
    }
}
