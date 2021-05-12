//
//  main.swift
//  
//
//  Created by Taketo Sano on 2021/05/11.
//

import SwiftyMath
import SwiftyEigen

typealias M = MatrixInterface<EigenRationalSparseMatrix, _3, _3, RationalNumber>
let a: M = [1] * 9
print(a)
print(a.serialize())
