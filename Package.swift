// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "VaporShell",
  dependencies: [
    
  ],
  targets: [
    // Targets are the basic building blocks of a package. A target can define a module or a test suite.
    // Targets can depend on other targets in this package, and on products in packages which this package depends on.
    .target(name: "CBase32"),
    .target(name: "CBcrypt"),
    
    .target(name: "VaporShell", dependencies: [
                                  .target(name: "CBase32"),
                                  .target(name: "CBcrypt")
                                ])
  ]
)
