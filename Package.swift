// swift-tools-version:4.0
//
// Package.swift
// RomeBuild
//
// Created by Yehor Popovych on 22/09/2017.
// Copyright © 2017 Yehor Popovych. All rights reserved.
//

import PackageDescription

let package = Package(
    name: "RomeBuild",
    products: [
        .executable(name: "romebuild", targets: ["RomeBuild"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ypopovych/RomeKit.git", from: "0.4.0"),
        .package(url: "https://github.com/jatoben/CommandLine.git", .branch("master")),
        .package(url: "https://github.com/sharplet/Regex.git", from: "1.1.0"),
        .package(url: "https://github.com/jkandzi/Progress.swift.git", from: "0.2.0")
    ],
    targets: [
        .target(name: "RomeBuild", dependencies: ["RomeKit", "CommandLine", "Regex", "Progress"])
    ]
)
