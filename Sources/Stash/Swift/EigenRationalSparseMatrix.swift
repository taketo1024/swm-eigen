//
//  File.swift
//
//
//  Created by Taketo Sano on 2021/05/11.
//

import SwmCore
import SwmMatrixTools

public struct EigenRationalSparseMatrix: EigenMatrix, SparseMatrixImpl, LUFactorizable {
    public typealias ObjCMatrix = ObjCEigenRationalSparseMatrix
    public typealias BaseRing = RationalNumber

    public var objCMatrix: ObjCMatrix

    public init(_ objCMatrix: ObjCMatrix) {
        self.objCMatrix = objCMatrix
    }
    
    public init(size: MatrixSize, initializer: (Initializer) -> Void) {
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
        let objCMatrix = ObjCMatrix(rows: n, cols: m, triplets: &triplets, count: triplets.count)
        self.init(objCMatrix)
    }
    
    public var numberOfNonZeros: Int {
        objCMatrix.countNonZeros()
    }
    
    public var nonZeroEntries: AnySequence<MatrixEntry<BaseRing>> {
        let l = numberOfNonZeros
        let p = UnsafeMutableBufferPointer<rational_triplet_t>.allocate(capacity: l)
        objCMatrix.copyNonZeros(into: p.baseAddress!)
        
        return AnySequence(
            p.map{ t in MatrixEntry(t.row, t.col, BaseRing(fromCType: t.value) ) }
        )
    }
}

extension ObjCEigenRationalSparseMatrix: ObjCEigenMatrix_LU {
    public typealias Coeff = RationalNumber.CType
}
