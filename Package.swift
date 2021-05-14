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
            url: "../SwiftyMath/",
			.branch("matrix-improve")
        )
	],
    targets: [
        .target(
            name: "ObjCEigen",
            path: "Sources/ObjC",
            cxxSettings: [
                .headerSearchPath("../Eigen/"),
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
