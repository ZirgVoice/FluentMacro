// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import CompilerPluginSupport
import PackageDescription

let package = Package(
    name: "FluentMacro",
    platforms: [.macOS(.v15)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "FluentMacro",
            targets: ["FluentMacro"]
        ),
        .executable(
            name: "FluentMacroClient",
            targets: ["FluentMacroClient"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-syntax", "509.0.0"..<"601.0.0-prerelease"),
        .package(url: "https://github.com/pointfreeco/swift-macro-testing", from: "0.6.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        // Macro implementation that performs the source transformation of a macro.
        .macro(
            name: "FluentMacroMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
            ]
        ),

        // Library that exposes a macro as part of its API, which is used in client programs.
        .target(
            name: "FluentMacro",
            dependencies: [
                "FluentMacroMacros",
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
            ]
        ),

        // A client of the library, which is able to use the macro in its own code.
        .executableTarget(name: "FluentMacroClient", dependencies: ["FluentMacro"]),

        // A test target used to develop the macro implementation.
        .testTarget(
            name: "FluentMacroTests",
            dependencies: [
                "FluentMacroMacros",
                .product(name: "MacroTesting", package: "swift-macro-testing"),
            ]
        ),
    ]
)
