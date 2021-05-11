//
//  main.swift
//  
//
//  Created by Taketo Sano on 2021/05/11.
//

import SwiftyMath
import SwiftyEigen

typealias M = MatrixInterface<EigenRationalMatrix, _3, _3, RationalNumber>
let a: M = [
    1,1,0,
    0,2,0,
    3,0,1
]
let b = a.inverse!
print(b.detailDescription)
