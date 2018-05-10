# ActiveDays

## Installation

You can only install the extension with Swift Package Manager right now. Please add

    // swift-tools-version:4.0

    import PackageDescription

    let package = Package(
        name: "YourTargetName",
        products: [
            .executable(name: "YourTargetName", targets: ["YourTargetName"])
        ],
        dependencies: [
            .package(url: "https://github.com/zonble/ActiveDays", .upToNextMinor(from: "1.0.0"))
        ],
        targets: [
            .target(name: "YourTargetName", dependencies: ["KKBOXOpenAPISwift"], path: "./Path/To/Your/Sources")
        ]
    )