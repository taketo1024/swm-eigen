//
//  SwmCoreTests.swift
//  SwmCoreTests
//
//  Created by Taketo Sano on 2017/05/03.
//  Copyright © 2017年 Taketo Sano. All rights reserved.
//

import XCTest
import SwmCore
@testable import SwmEigen

class EigenRationalSparseMatrixTests: XCTestCase {
    
    typealias M<n: SizeType, m: SizeType> = MatrixIF<EigenRationalSparseMatrix, n, m>
    typealias M2 = M<_2, _2>
    
    func testInitByInitializer() {
        let a = M2 { setEntry in
            setEntry(0, 1, 2)
            setEntry(1, 0, 5)
        }
        XCTAssertEqual(a.serialize(), [0,2,5,0])
    }
    
    func testInitByGrid() {
        let a = M2(grid: [1,2,3,4])
        XCTAssertEqual(a.serialize(), [1,2,3,4])
    }
    
    func testInitByArrayLiteral() {
        let a: M2 = [1,2,3,4]
        XCTAssertEqual(a.serialize(), [1,2,3,4])
    }
    
    func testEquality() {
        let a: M2 = [1,2,3,4]
        let b: M2 = [1,2,3,4]
        XCTAssertEqual(a, b)
    }
    
    func testInequality() {
        let a: M2 = [1,2,3,4]
        let b: M2 = [1,3,2,4]
        XCTAssertNotEqual(a, b)
    }
    
    func testInitWithMissingGrid() {
        let a: M2 = [1,2,3]
        XCTAssertEqual(a, [1,2,3,0])
    }

    func testSubscript() {
        let a: M2 = [1,2,0,4]
        XCTAssertEqual(a[0, 0], 1)
        XCTAssertEqual(a[0, 1], 2)
        XCTAssertEqual(a[1, 0], 0)
        XCTAssertEqual(a[1, 1], 4)
    }
    
    func testSubscriptSet() {
        var a: M2 = [1,2,0,4]
        a[0, 0] = 0
        a[0, 1] = 0
        a[1, 1] = 2
        XCTAssertEqual(a[0, 0], 0)
        XCTAssertEqual(a[0, 1], 0)
        XCTAssertEqual(a[1, 0], 0)
        XCTAssertEqual(a[1, 1], 2)
    }
    
    func testCopyOnMutate() {
        let a: M2 = [1,2,0,4]
        var b = a
        
        b[0, 0] = 0
        
        XCTAssertEqual(a[0, 0], 1)
        XCTAssertEqual(b[0, 0], 0)
    }
    
    func testSum() {
        let a: M2 = [1,2,3,4]
        let b: M2 = [2,3,4,5]
        XCTAssertEqual(a + b, [3,5,7,9])
    }
    
    func testIsZero() {
        var a: M2 = [0,0,0,0]
        XCTAssertTrue(a.isZero)
        
        a[0, 0] = 1
        a[0, 0] = 0
        
        XCTAssertTrue(a.isZero)
    }
    
    func testZero() {
        let a: M2 = [1,2,3,4]
        let o = M2.zero
        XCTAssertEqual(a + o, a)
        XCTAssertEqual(o + a, a)
    }

    func testNeg() {
        let a: M2 = [1,2,3,4]
        XCTAssertEqual(-a, [-1,-2,-3,-4])
        XCTAssertEqual(a - a, M2.zero)
    }

    func testSub() {
        let a: M2 = [1,2,3,4]
        let b: M2 = [2,1,7,2]
        XCTAssertEqual(a - b, [-1,1,-4,2])
    }
    
    func testMul() {
        let a: M2 = [1,2,3,4]
        let b: M2 = [2,3,4,5]
        XCTAssertEqual(a * b, [10,13,22,29])
    }
    
    func testMul2() {
        let a: M2 = [1,1,-1,1]
        let b: M2 = [1,1,1,-1]
        XCTAssertEqual(a * b, [2, 0, 0, -2])
    }
    
    func testScalarMul() {
        let a: M2 = [1,2,3,4]
        XCTAssertEqual(2 * a, [2,4,6,8])
        XCTAssertEqual(a * 3, [3,6,9,12])
    }
    
    func testId() {
        let a: M2 = [1,2,3,4]
        let e = M2.identity
        XCTAssertEqual(a * e, a)
        XCTAssertEqual(e * a, a)
    }
    
//    func testInv() {
//        let a: M2 = [1,2,2,3]
//        XCTAssertEqual(a.inverse!, [-3,2,2,-1])
//    }

//    func testNonInvertible() {
//        let b: M2 = [1, 0, 0, 0]
//        XCTAssertFalse(b.isInvertible)
//        XCTAssertNil(b.inverse)
//    }
    
    func testPow() {
        let a: M2 = [1,2,3,4]
        XCTAssertEqual(a.pow(0), M2.identity)
        XCTAssertEqual(a.pow(1), a)
        XCTAssertEqual(a.pow(2), [7,10,15,22])
        XCTAssertEqual(a.pow(3), [37,54,81,118])
    }
    
//    func testTrace() {
//        let a: M2 = [1,2,3,4]
//        XCTAssertEqual(a.trace, 5)
//    }
    
//    func testDet() {
//        let a: M2 = [1,2,3,4]
//        XCTAssertEqual(a.determinant, -2)
//    }

//    func testDet4() {
//        let a: M<_4, _4> =
//            [3,-1,2,4,
//             2,1,1,3,
//             -2,0,3,-1,
//             0,-2,1,3]
//        XCTAssertEqual(a.determinant, 66)
//    }
    
    func testTransposed() {
        let a: M2 = [1,2,3,4]
        XCTAssertEqual(a.transposed, [1,3,2,4])
    }
    
    func testAsStatic() {
        let a = M<anySize, anySize>(size: (2, 3), grid: [1,2,3,4,5,6])
        let b = a.as(M<_2, _3>.self)
        XCTAssertEqual(b, M<_2, _3>(grid: [1,2,3,4,5,6]))
    }
    
    func testAsDynamic() {
        let a = M<_2, _3>(grid: [1,2,3,4,5,6])
        let b = a.as(M<anySize, anySize>.self)
        XCTAssertEqual(b, M<anySize, anySize>(size: (2, 3), grid: [1,2,3,4,5,6]))
    }
    
    func testSubmatrixRow() {
        let a: M2 = [1,2,3,4]
        let a1 = a.submatrix(rowRange: 0 ..< 1).as(M<_1, _2>.self)
        XCTAssertEqual(a1, [1, 2])
    }
    
    func testSubmatrixCol() {
        let a: M2 = [1,2,3,4]
        let a2 = a.submatrix(colRange: 1 ..< 2).as(M<_2, _1>.self)
        XCTAssertEqual(a2, [2, 4])
    }
    
    func testSubmatrixBoth() {
        let a: M2 = [1,2,3,4]
        let a3 = a.submatrix(rowRange: 1 ..< 2, colRange: 0 ..< 1).as(M<_1, _1>.self)
        XCTAssertEqual(a3, [3])
    }
    
    func testSubmatrixCopyOnWrite() {
        let a: M2 = [1,2,3,4]
        var b = a.submatrix(rowRange: 0 ..< 2, colRange: 0 ..< 1)
        b[0, 0] = 10
        XCTAssertEqual(a[0, 0], 1)
        XCTAssertEqual(b[0, 0], 10)
    }
}
