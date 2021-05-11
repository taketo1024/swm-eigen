//
//  File.swift
//  
//
//  Created by Taketo Sano on 2021/05/11.
//

import SwiftyMath

public struct EigenDoubleMatrix: MatrixImpl {
    private typealias ObjCType = ObjCEigenDoubleMatrix
    public typealias BaseRing = Double
    
    private var matrix: ObjCEigenDoubleMatrix
    
    private init(_ matrix: ObjCType) {
        self.matrix = matrix
    }
    
    public init(size: (Int, Int), initializer: (Initializer) -> Void) {
        let matrix = ObjCType.zeros(rows: size.0, cols: size.1)
        initializer { (i, j, a) in
            assert( 0 <= i && i < size.0 )
            assert( 0 <= j && j < size.1 )
            if !a.isZero {
                matrix.setValue(a, row: i, col: j)
            }
        }
        self.init(matrix)
    }
    
    private mutating func copyOnWrite() {
        if !isKnownUniquelyReferenced(&matrix) {
            self.matrix = matrix.copy()
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
            matrix.value(row: i, col: j)
        } set {
            copyOnWrite()
            matrix.setValue(newValue, row: i, col: j)
        }
    }

    public var size: (rows: Int, cols: Int) {
        (matrix.rows, matrix.cols)
    }

    public var isZero: Bool {
        matrix.isZero()
    }

    public var transposed: Self {
        .init(matrix.transposed())
    }

    public var inverse: Self? {
        isInvertible ? .init(matrix.inverse()) : nil
    }

    public var determinant: BaseRing {
        matrix.determinant()
    }

    public var trace: BaseRing {
        matrix.trace()
    }

    public func submatrix(rowRange: CountableRange<Int>,  colRange: CountableRange<Int>) -> Self {
        .init(matrix.submatrix(fromRow: rowRange.startIndex, col: colRange.startIndex, width: rowRange.endIndex - rowRange.startIndex, height: colRange.endIndex - colRange.startIndex))
    }

    public func serialize() -> [BaseRing] {
        let l = size.rows * size.cols
        var array = [BaseRing](repeating: .zero, count: l)
        matrix.serialize(into: &array)
        return array
    }

    public static func ==(a: Self, b: Self) -> Bool {
        a.matrix.equals(b.matrix) 
    }

    public static func +(a: Self, b: Self) -> Self {
        .init(a.matrix.add(b.matrix))
    }

    public static prefix func -(a: Self) -> Self {
        .init(a.matrix.negate())
    }

    public static func -(a: Self, b: Self) -> Self {
        .init(a.matrix.sub(b.matrix))
    }

    public static func *(r: BaseRing, a: Self) -> Self {
        .init(a.matrix.mulLeft(r))
    }

    public static func *(a: Self, r: BaseRing) -> Self {
        .init(a.matrix.mulRight(r))
    }

    public static func *(a: Self, b: Self) -> Self {
        .init(a.matrix.mul(b.matrix))
    }
}

extension ObjCEigenDoubleMatrix {
    public subscript(i: Int, j: Int) -> Double {
        get { return value(row: i, col: j) }
        set { setValue(newValue, row: i, col: j) }
    }
}
