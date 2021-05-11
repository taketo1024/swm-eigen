//
//  File.swift
//  
//
//  Created by Taketo Sano on 2021/05/11.
//

import SwiftyMath

public protocol EigenMatrixProtocol: MatrixImpl where BaseRing == ObjCType.BaseRing {
    associatedtype ObjCType: AnyObject, ObjCEigenMatrixProtocol
    init(_ objCMatrix: ObjCType)
    
    mutating func copyOnWrite()
    
    var objCMatrix: ObjCType { get set } // rename to objCMatrix
    var transposed: Self { get }
}

extension EigenMatrixProtocol {
    public init(size: (Int, Int), initializer: (Initializer) -> Void) {
        let objCMatrix = ObjCType.zeros(rows: size.0, cols: size.1)
        initializer { (i, j, a) in
            assert( 0 <= i && i < size.0 )
            assert( 0 <= j && j < size.1 )
            if !a.isZero {
                objCMatrix.setValue(a, row: i, col: j)
            }
        }
        self.init(objCMatrix)
    }
    
    public mutating func copyOnWrite() {
        if !isKnownUniquelyReferenced(&objCMatrix) {
            self.objCMatrix = objCMatrix.copy()
        }
    }
    
    public static func zero(size: (Int, Int)) -> Self {
        let matrix = ObjCType.zeros(rows: size.0, cols: size.1)
        return self.init(matrix)
    }
    
    public static func identity(size: (Int, Int)) -> Self {
        let matrix = ObjCType.identity(rows: size.0, cols: size.1)
        return self.init(matrix)
    }

    public subscript(i: Int, j: Int) -> BaseRing {
        get {
            objCMatrix.value(row: i, col: j)
        } set {
            copyOnWrite()
            objCMatrix.setValue(newValue, row: i, col: j)
        }
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

    public var determinant: BaseRing {
        objCMatrix.determinant()
    }

    public var trace: BaseRing {
        objCMatrix.trace()
    }

    public func submatrix(rowRange: CountableRange<Int>,  colRange: CountableRange<Int>) -> Self {
        .init(objCMatrix.submatrix(fromRow: rowRange.startIndex, col: colRange.startIndex, width: rowRange.endIndex - rowRange.startIndex, height: colRange.endIndex - colRange.startIndex))
    }

    public func serialize() -> [BaseRing] {
        let l = size.rows * size.cols
        var array = [BaseRing](repeating: .zero, count: l)
        objCMatrix.serialize(into: &array)
        return array
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

    public static func *(r: BaseRing, a: Self) -> Self {
        .init(a.objCMatrix.mulLeft(r))
    }

    public static func *(a: Self, r: BaseRing) -> Self {
        .init(a.objCMatrix.mulRight(r))
    }

    public static func *(a: Self, b: Self) -> Self {
        .init(a.objCMatrix.mul(b.objCMatrix))
    }
}
