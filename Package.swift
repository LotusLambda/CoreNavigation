import PackageDescription

let package = Package(
    name: "CoreNavigation",
    products: [
        .library(name: "CoreNavigation", targets: ["CoreNavigation"]),
    ],
    targets: [
        .target(
            name: "CoreNavigation",
            dependencies: [])
    ]
)
