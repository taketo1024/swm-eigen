//
//  File.swift
//
//
//  Created by Taketo Sano on 2021/05/11.
//

import SwiftyMath

public struct EigenRationalSparseMatrix: EigenMatrix {
    public typealias ObjCMatrix = ObjCEigenRationalSparseMatrix
    public typealias BaseRing = RationalNumber

    public var objCMatrix: ObjCMatrix

    public init(_ objCMatrix: ObjCMatrix) {
        self.objCMatrix = objCMatrix
    }
    
    public init(size: (Int, Int), initializer: (Initializer) -> Void) {
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
    
    public var nonZeroComponents: [MatrixComponent<BaseRing>] {
        let l = numberOfNonZeros
        let p = UnsafeMutableBufferPointer<rational_triplet_t>.allocate(capacity: l)
        objCMatrix.copyNonZeros(into: p.baseAddress!)
        return p.map{ t in  MatrixComponent(t.row, t.col, BaseRing(fromCType: t.value) ) }
    }
    
    public func solve(_ b: Self) -> Self? {
        objCMatrix.solve(b.objCMatrix).flatMap{ .init($0) }
    }
}

extension ObjCEigenRationalSparseMatrix: ObjCEigenMatrix {
    public typealias Coeff = RationalNumber.CType
}

extension MatrixInterface where Impl == EigenRationalSparseMatrix {
    public func solve(_ b: MatrixInterface<Impl, m, _1, BaseRing>) -> MatrixInterface<Impl, n, _1, BaseRing>? {
        impl.solve(b.impl).flatMap{ .init(impl: $0) }
    }
}
