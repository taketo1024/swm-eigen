//
//  File.swift
//  
//
//  Created by Taketo Sano on 2021/06/02.
//

import XCTest
import SwmCore
@testable import SwmEigen

class RationalNumTests: XCTestCase {
    func testConvert() {
        let a = RationalNumber.random(in: 0 ... 10)
        let b = a.toCType()
        let c = RationalNumber(fromCType: b)
        XCTAssertEqual(a, c)
    }
}
