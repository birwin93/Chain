// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Chain",
    products: [
        .executable(name: "chain", targets: ["ChainApp"]),
        .library(name: "ChainCore", targets: ["ChainCore"]),
        .library(name: "Chains", targets: ["Chains"])
    ],
    dependencies: [
        // External
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.2.0"),
    ],
    targets: [
        .target(
            name: "ChainCore",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]
        ),
        .target(
            name: "Chains",
            dependencies: [
                .target(name: "ChainCore")
            ]
        ),
        .target(
            name: "ChainApp",
            dependencies: [
                .target(name: "ChainCore"),
                .target(name: "Chains")
            ]
        ),
         .testTarget(
             name: "ChainTests",
             dependencies: [
                 .target(name: "ChainCore"),
                 .target(name: "Chains")
             ]
         )
    ]
)
