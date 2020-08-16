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
        .package(url: "https://github.com/yonaskolb/Mint.git", from: "0.10.0"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.2.0"),
        .package(url: "https://github.com/onevcat/Rainbow", from: "3.0.0")
    ],
    targets: [
        .target(
            name: "ChainCore",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "MintKit", package: "Mint"),
                .product(name: "Rainbow", package: "Rainbow")
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
