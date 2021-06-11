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
