//
//  File.swift
//  
//
//  Created by Taketo Sano on 2021/05/11.
//

import SwiftyMath

public protocol ObjCEigenMatrix: AnyObject {
    associatedtype Coeff
    
    static func zeros(rows: Int, cols: Int) -> Self
    static func identity(rows: Int, cols: Int) -> Self

    func copy() -> Self
    
    var rows: Int { get }
    var cols: Int { get }

    func value(row: Int, col: Int) -> Coeff
    func setValue(_ value: Coeff, row: Int, col: Int)
    
    func isZero() -> Bool
    func transposed() -> Self
    func inverse() -> Self?

    func determinant() -> Coeff
    func trace() -> Coeff
    
    func submatrix(fromRow i: Int, col j: Int, width w: Int, height h: Int) -> Self
    func permuteRows(_ p: perm_t) -> Self
    func permuteCols(_ p: perm_t) -> Self

    func equals(_ other: Any) -> Bool
    func add(_ other: Any) -> Self
    func negate() -> Self
    func sub(_ other: Any) -> Self
    func mulLeft(_ r: Coeff) -> Self
    func mulRight(_ r: Coeff) -> Self
    func mul(_ other: Any) -> Self
    
    func serialize(into array: UnsafeMutablePointer<Coeff>)
}

public protocol ObjCEigenMatrix_LU: ObjCEigenMatrix {
    func getL() -> Self
    func getU() -> Self
    func getP() -> perm_t
    func getQ() -> perm_t
    func rank() -> Int
    func nullity() -> Int
    func kernel() -> Self
    func image() -> Self
    func solve(_ b: Any) -> Self?
}

