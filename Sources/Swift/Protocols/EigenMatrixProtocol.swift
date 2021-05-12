//
//  File.swift
//  
//
//  Created by Taketo Sano on 2021/05/11.
//

import SwiftyMath

public protocol EigenMatrixProtocol: MatrixImpl {
    associatedtype ObjCMatrix: AnyObject, ObjCEigenMatrixProtocol
    
    init(_ objCMatrix: ObjCMatrix)
    
    mutating func copyOnWrite()
    
    var objCMatrix: ObjCMatrix { get set } // rename to objCMatrix
}

extension EigenMatrixProtocol {
    public mutating func copyOnWrite() {
        if !isKnownUniquelyReferenced(&objCMatrix) {
            self.objCMatrix = objCMatrix.copy()
        }
    }
    
    public static func zero(size: (Int, Int)) -> Self {
        let matrix = ObjCMatrix.zeros(rows: size.0, cols: size.1)
        return self.init(matrix)
    }
    
    public static func identity(size: (Int, Int)) -> Self {
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

    public var inverse: Self? {
        isInvertible ? .init(objCMatrix.inverse()) : nil
    }

    public func submatrix(rowRange: CountableRange<Int>,  colRange: CountableRange<Int>) -> Self {
        .init(objCMatrix.submatrix(fromRow: rowRange.startIndex, col: colRange.startIndex, width: rowRange.endIndex - rowRange.startIndex, height: colRange.endIndex - colRange.startIndex))
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

extension EigenMatrixProtocol where BaseRing == ObjCMatrix.Coeff {
    public init(size: (Int, Int), initializer: (Initializer) -> Void) {
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
        let p = UnsafeMutablePointer<BaseRing>.allocate(capacity: l)
        objCMatrix.serialize(into: p)
        return Array(UnsafeBufferPointer(start: p, count: l))
    }
}

extension EigenMatrixProtocol where BaseRing: CTypeConvertible, BaseRing.CType == ObjCMatrix.Coeff {
    public init(size: (Int, Int), initializer: (Initializer) -> Void) {
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
        let p = UnsafeMutablePointer<BaseRing.CType>.allocate(capacity: l)
        objCMatrix.serialize(into: p)
        let buff = UnsafeBufferPointer(start: p, count: l)
        return buff.map{ BaseRing(fromCType: $0) }
    }
}
