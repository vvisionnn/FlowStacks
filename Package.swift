// swift-tools-version: 5.10

import PackageDescription

let package = Package(
  name: "FlowStacks",
  platforms: [
    .iOS(.v16), .watchOS(.v9), .macOS(.v13), .tvOS(.v16),
  ],
  products: [
    .library(
      name: "FlowStacks",
      targets: ["FlowStacks"]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/vvisionnn/swiftui-presentation", from: "0.3.3"),
    .package(url: "https://github.com/siteline/swiftui-introspect", from: "1.3.0"),
  ],
  targets: [
    .target(
      name: "FlowStacks",
      dependencies: [
				.product(
					name: "SwiftUIIntrospect",
					package: "swiftui-introspect",
					condition: .when(platforms: [.iOS, .macOS, .tvOS])
				),
        .product(
          name: "Presentation",
          package: "swiftui-presentation",
          condition: .when(platforms: [.iOS])
        ),
      ]
    ),
    .testTarget(
      name: "FlowStacksTests",
      dependencies: ["FlowStacks"]
    ),
  ]
)
