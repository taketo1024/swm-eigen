//
//  File.swift
//  
//
//  Created by Taketo Sano on 2021/06/10.
//

import SwmCore
import CEigenBridge

public final class EigenSparseRationalMatrix {
    private typealias Pointer = UnsafeMutableRawPointer
    private let ptr: Pointer
    
    private init(_ ptr: Pointer) {
        self.ptr = ptr
    }
    
    public init(size: MatrixSize) {
        self.ptr = eigen_init_rat_s(size.rows, size.cols)
    }
    
    deinit {
        eigen_free_rat_s(ptr)
    }
    
    public func dump() {
        eigen_dump_rat_s(ptr)
    }
}
