//
//  File.swift
//  
//
//  Created by Taketo Sano on 2021/05/11.
//

import SwmCore
import SwmMatrixTools

public protocol EigenMatrix: MatrixImpl {
    associatedtype ObjCMatrix: ObjCEigenMatrix
    
    init(_ objCMatrix: ObjCMatrix)
    
    mutating func copyOnWrite()
    
    var objCMatrix: ObjCMatrix { get set } // rename to objCMatrix
}

extension EigenMatrix {
    public mutating func copyOnWrite() {
        if !isKnownUniquelyReferenced(&objCMatrix) {
            self.objCMatrix = objCMatrix.copy()
        }
    }
    
    public static func zero(size: MatrixSize) -> Self {
        let matrix = ObjCMatrix.zeros(rows: size.0, cols: size.1)
        return self.init(matrix)
    }
    
    public static func identity(size: MatrixSize) -> Self {
        let matrix = ObjCMatrix.identity(rows: size.0, cols: size.1)
        return self.init(matrix)
    }
    
    public var size: (rows: Int, cols: Int) {
        (objCMatrix.rows, objCMatrix.cols)
    }
    
    public var isZero: Bool {
        objCMatrix.isZero()
    }
    
    public var transposed: Self {
        .init(objCMatrix.transposed())
    }
    
    public var isInvertible: Bool {
        determinant.isInvertible
    }
    
    public var inverse: Self? {
        objCMatrix.inverse().flatMap { .init($0) }
    }
    
    public func submatrix(rowRange: CountableRange<Int>,  colRange: CountableRange<Int>) -> Self {
        .init(objCMatrix.submatrix(fromRow: rowRange.startIndex, col: colRange.startIndex, width: rowRange.endIndex - rowRange.startIndex, height: colRange.endIndex - colRange.startIndex))
    }
    
    public func concat(_ B: Self) -> Self {
        .init(objCMatrix.concat(B.objCMatrix))
    }
    
    public func stack(_ B: Self) -> Self {
        .init(objCMatrix.stack(B.objCMatrix))
    }
    
    public func permute(rowsBy p: Permutation<anySize>, colsBy q: Permutation<anySize>) -> Self {
        permuteRows(by: p).permuteCols(by: q)
    }
    
    public func permuteRows(by σ: Permutation<anySize>) -> Self {
        let p = init_perm(σ.length)
        σ.copy(into: p)
        defer { free_perm(p) }
        
        return .init(objCMatrix.permuteRows(p))
    }
    
    public func permuteCols(by σ: Permutation<anySize>) -> Self {
        let p = init_perm(σ.length)
        σ.copy(into: p)
        defer { free_perm(p) }
        
        return .init(objCMatrix.permuteCols(p))
    }
    
    public var nonZeroEntries: AnySequence<MatrixEntry<BaseRing>> {
        let m = size.cols
        return AnySequence(serialize().enumerated().compactMap { (idx, a) in
            a.isZero ? nil : (idx / m, idx % m, a)
        })
    }
    
    public static func ==(a: Self, b: Self) -> Bool {
        a.objCMatrix.equals(b.objCMatrix)
    }
    
    public static func +(a: Self, b: Self) -> Self {
        .init(a.objCMatrix.add(b.objCMatrix))
    }
    
    public static prefix func -(a: Self) -> Self {
        .init(a.objCMatrix.negate())
    }
    
    public static func -(a: Self, b: Self) -> Self {
        .init(a.objCMatrix.sub(b.objCMatrix))
    }
    
    public static func *(a: Self, b: Self) -> Self {
        .init(a.objCMatrix.mul(b.objCMatrix))
    }
}

extension EigenMatrix where BaseRing == ObjCMatrix.Coeff {
    public init(size: MatrixSize, initializer: (Initializer) -> Void) {
        let objCMatrix = ObjCMatrix.zeros(rows: size.0, cols: size.1)
        initializer { (i, j, a) in
            assert( 0 <= i && i < size.0 )
            assert( 0 <= j && j < size.1 )
            if !a.isZero {
                objCMatrix.setValue(a, row: i, col: j)
            }
        }
        self.init(objCMatrix)
    }
    
    public subscript(i: Int, j: Int) -> BaseRing {
        get {
            objCMatrix.value(row: i, col: j)
        } set {
            copyOnWrite()
            objCMatrix.setValue(newValue, row: i, col: j)
        }
    }
    
    public var determinant: BaseRing {
        objCMatrix.determinant()
    }
    
    public var trace: BaseRing {
        objCMatrix.trace()
    }
    
    public static func *(r: BaseRing, a: Self) -> Self {
        .init(a.objCMatrix.mulLeft(r))
    }
    
    public static func *(a: Self, r: BaseRing) -> Self {
        .init(a.objCMatrix.mulRight(r))
    }
    
    public func serialize() -> [BaseRing] {
        let l = size.rows * size.cols
        var array = [BaseRing](repeating: .zero, count: l)
        objCMatrix.serialize(into: &array)
        return array
    }
}

extension EigenMatrix where BaseRing: CTypeConvertible, BaseRing.CType == ObjCMatrix.Coeff {
    public init(size: MatrixSize, initializer: (Initializer) -> Void) {
        let objCMatrix = ObjCMatrix.zeros(rows: size.0, cols: size.1)
        initializer { (i, j, a) in
            assert( 0 <= i && i < size.0 )
            assert( 0 <= j && j < size.1 )
            if !a.isZero {
                objCMatrix.setValue(a.toCType, row: i, col: j)
            }
        }
        self.init(objCMatrix)
    }
    
    public subscript(i: Int, j: Int) -> BaseRing {
        get {
            BaseRing(fromCType: objCMatrix.value(row: i, col: j))
        } set {
            copyOnWrite()
            objCMatrix.setValue(newValue.toCType, row: i, col: j)
        }
    }
    
    public var determinant: BaseRing {
        BaseRing(fromCType: objCMatrix.determinant())
    }
    
    public var trace: BaseRing {
        BaseRing(fromCType: objCMatrix.trace())
    }
    
    public static func *(r: BaseRing, a: Self) -> Self {
        .init(a.objCMatrix.mulLeft(r.toCType))
    }
    
    public static func *(a: Self, r: BaseRing) -> Self {
        .init(a.objCMatrix.mulRight(r.toCType))
    }
    
    public func serialize() -> [BaseRing] {
        let l = size.rows * size.cols
        var array = [BaseRing.CType](repeating: BaseRing.zero.toCType, count: l)
        objCMatrix.serialize(into: &array)
        return array.map{ BaseRing(fromCType: $0) }
    }
}

extension EigenMatrix where ObjCMatrix: ObjCEigenMatrix_LU {
    public static func solveLowerTriangular(_ L: Self, _ b: Self) -> Self {
        assert(L.isSquare)
        assert(L.isLowerTriangular)
        assert(L.hasInvertibleDiagonal)
        assert(L.size.rows == b.size.rows)
        return .init(ObjCMatrix.solveLowerTriangular(L.objCMatrix, b.objCMatrix))
    }
    
    public static func solveUpperTriangular(_ U: Self, _ b: Self) -> Self {
        assert(U.isSquare)
        assert(U.isUpperTriangular)
        assert(U.hasInvertibleDiagonal)
        assert(U.size.rows == b.size.rows)
        return .init(ObjCMatrix.solveUpperTriangular(U.objCMatrix, b.objCMatrix))
    }
}

extension EigenMatrix where ObjCMatrix: ObjCEigenMatrix_nativeLU {
    public func LUfactorize_native() -> (P: Permutation<anySize>, Q: Permutation<anySize>, L: Self, U: Self) {
        
        func getPermutation(_ rawValue: NSValue) -> Permutation<anySize> {
            let pPtr = UnsafeMutablePointer<perm_t>.allocate(capacity: 1)
            rawValue.getValue(pPtr)
            defer { free_perm(pPtr.pointee) }
            return .init(fromCType: pPtr.pointee)
        }
        
        let result = objCMatrix.lufactorize()
        let P = getPermutation(result["P"]! as! NSValue)
        let Q = getPermutation(result["Q"]! as! NSValue).inverse!
        let L = Self( result["L"]! as! ObjCMatrix )
        let U = Self( result["U"]! as! ObjCMatrix )
        
        return (P, Q, L, U)
    }
}
