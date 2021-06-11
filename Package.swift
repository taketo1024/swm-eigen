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
        )
    ],
    targets: [
        .target(
            name: "CEigenBridge",
            path: "Sources/CEigenBridge",
            cxxSettings: [
                .headerSearchPath("../Eigen/"),
                .define("EIGEN_MPL2_ONLY"),
                .define("EIGEN_NO_DEBUG"),
            ]
        ),
        .target(
            name: "SwmEigen",
            dependencies: [
                "CEigenBridge",
                .product(name: "SwmCore", package: "swm-core"),
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
