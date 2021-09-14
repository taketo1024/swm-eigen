//
//  File.swift
//  
//
//  Created by Taketo Sano on 2021/06/11.
//

import SwmCore
import CEigenBridge

extension Permutation where n == anySize {
    public init(fromCType r: perm_t) {
        let indices = UnsafeBufferPointer(start: r.indices, count: r.length)
        self.init(indices: indices)
    }
    
    public func copy(into p: perm_t) {
        for i in 0 ..< length {
            p.indices[i] = self[i]
        }
    }
}
