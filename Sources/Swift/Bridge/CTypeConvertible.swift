//
//  CTypeConvertible.swift
//  
//
//  Created by Taketo Sano on 2021/05/13.
//

import SwmCore
import CEigenBridge

public protocol CTypeConvertible {
    associatedtype CType
    
    init(fromCType r: CType)
    var toCType: CType { get }
}

extension RationalNumber: CTypeConvertible {
    @_transparent
    public init(fromCType r: rational_t) {
        self.init(r.p, r.q)
    }
    
    @_transparent
    public var toCType: rational_t {
        rational_t(p: numerator, q: denominator)
    }
}

extension Permutation where n == anySize {
    public init(fromCType r: perm_t) {
        let indices = UnsafeBufferPointer(start: r.indices, count: r.length)
        self.init(length: r.length, indices: indices)
    }
    
    public func copy(into p: perm_t) {
        for i in 0 ..< length {
            p.indices[i] = self[i]
        }
    }
}
