//
//  File.swift
//  
//
//  Created by Taketo Sano on 2021/05/11.
//

import SwiftyMath

public protocol ObjCEigenMatrixProtocol {
    associatedtype BaseRing
    
    static func zeros(rows: Int, cols: Int) -> Self
    static func identity(rows: Int, cols: Int) -> Self

    func copy() -> Self
    
    var rows: Int { get }
    var cols: Int { get }

    func value(row: Int, col: Int) -> BaseRing
    func setValue(_ value: BaseRing, row: Int, col: Int)
    
    func isZero() -> Bool
    func transposed() -> Self
    func inverse() -> Self

    func determinant() -> BaseRing
    func trace() -> BaseRing
    
    func submatrix(fromRow i: Int, col j: Int, width w: Int, height h: Int) -> Self
    func serialize(into array: UnsafeMutablePointer<BaseRing>)
    
    func equals(_ other: Any) -> Bool
    func add(_ other: Any) -> Self
    func negate() -> Self
    func sub(_ other: Any) -> Self
    func mulLeft(_ r: BaseRing) -> Self
    func mulRight(_ r: BaseRing) -> Self
    func mul(_ other: Any) -> Self
}
