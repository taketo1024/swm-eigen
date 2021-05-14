//
//  main.swift
//  
//
//  Created by Taketo Sano on 2021/05/11.
//

import SwiftyMath
import SwiftyEigen

typealias Impl = EigenRationalMatrix
typealias M<n: SizeType, m: SizeType> = MatrixInterface<Impl, n, m>

let A: M<_4, _2> =
    [1, 2,
     3, 4,
     5, 6,
     7, 8,
    ]

let (n, m) = A.size
let e = A.luDecomposition()

let r = e.rank
let (L, U) = e.LU
let (P, Q) = e.PQ

print("A = \n", A.detailDescription)
print("L = \n", L.detailDescription)
print("U = \n", U.detailDescription)

print("LU = \n", (L * U).detailDescription)
print("P^-1 LU Q^-1 = \n", (P.inverse! * L * U * Q.inverse!).detailDescription)

let b: M<_4, _1> = [-2,0,2,4]
let x = e.solve(b)

print("solve Ax =", b)
print("x =", x)
