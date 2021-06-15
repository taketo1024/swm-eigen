//
//  CTypeCompatible.swift
//  
//
//  Created by Taketo Sano on 2021/06/13.
//

public protocol CTypeCompatible {
    associatedtype CType
    init(fromCType r: CType)
    func toCType() -> CType
}
