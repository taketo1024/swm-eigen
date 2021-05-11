// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "SwiftyEigen",
    products: [
        .library(
            name: "SwiftyEigen",
            targets: ["ObjCEigen", "SwiftyEigen"]
        )
    ],
    dependencies: [
	    .package(
            name:"SwiftyMath",
            url: "https://github.com/taketo1024/SwiftyMath.git",
            from:"2.1.1"
        )
	],
    targets: [
        .target(
            name: "ObjCEigen",
            path: "Sources/ObjC",
            cxxSettings: [
                .headerSearchPath("../CPP/"),
                .define("EIGEN_MPL2_ONLY")
            ]
        ),
        .target(
            name: "SwiftyEigen",
            dependencies: ["ObjCEigen", "SwiftyMath"],
            path: "Sources/Swift"
        ),
        .target(
            name: "SwiftyEigen-Sample",
            dependencies: ["SwiftyEigen", "SwiftyMath"],
            path: "Sources/Sample"
        ),
        .testTarget(
            name: "SwiftyEigenTests",
            dependencies: ["SwiftyEigen", "SwiftyMath"]
        ),
    ]
)
