// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "swm-eigen",
    products: [
        .library(
            name: "SwmEigen",
            targets: ["SwmEigen"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/taketo1024/swm-core.git",
            from: "1.2.4"
//            path: "../swm-core/"
        ),
        .package(
            url: "https://github.com/taketo1024/swm-matrix-tools.git",
            from: "1.1.2"
//            path: "../swm-matrix-tools/"
        )
    ],
    targets: [
        .target(
            name: "ObjCEigen",
            path: "Sources/ObjC",
            cxxSettings: [
                .headerSearchPath("../Eigen/"),
                .define("EIGEN_MPL2_ONLY"),
                .define("EIGEN_NO_DEBUG"),
            ]
        ),
        .target(
            name: "SwmEigen",
            dependencies: [
                "ObjCEigen",
                .product(name: "SwmCore", package: "swm-core"),
                .product(name: "SwmMatrixTools", package: "swm-matrix-tools")
            ],
            path: "Sources/Swift"
        ),
        .testTarget(
            name: "SwmEigenTests",
            dependencies: ["SwmEigen"]
        ),
    ],
	cxxLanguageStandard: .cxx11
)
