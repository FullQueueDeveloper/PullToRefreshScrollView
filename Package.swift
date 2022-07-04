// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "PullToRefreshScrollView",
    platforms: [
        .iOS(.v14),
    ],
    products: [
        .library(
            name: "PullToRefreshScrollView",
            targets: ["PullToRefreshScrollView"]),
    ],
    dependencies: [],
    targets: [
      .target(name: "PullToRefreshScrollView",
        dependencies: [],
        path: "PullToRefreshScrollView")
    ])
