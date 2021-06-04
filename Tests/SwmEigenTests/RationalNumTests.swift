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
    typealias R = MatrixIF<EigenRationalMatrix, _1, _1>
    
    func testSum1() {
        let a: R = [1]
        let b: R = [2]
        XCTAssertEqual(a + b, [3])
    }

    func testSum2() {
        let a: R = [1./2]
        let b: R = [2./3]
        XCTAssertEqual(a + b, [7./6])
    }
    
    func testNeg() {
        let a: R = [1./2]
        XCTAssertEqual(-a, [-1./2])
    }
    
    func testSub() {
        let a: R = [1./2]
        let b: R = [3./4]
        XCTAssertEqual(a - b, [-1./4])
    }
    
    func testMul() {
        let a: R = [1./2]
        let b: R = [5./3]
        XCTAssertEqual(a * b, [5./6])
    }
    
    func testMul2() {
        let a: R = [1./2]
        let b: R = [4./3]
        XCTAssertEqual(a * b, [2./3])
    }
    
    func testInverse() {
        let a: R = [2./3]
        XCTAssertEqual(a.inverse!, [3./2])
    }
    
    func testAssign() {
        let a: R = [2./3]
        let b = a
        XCTAssertEqual(a, b)
    }
}
