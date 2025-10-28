//
//  Project.swift
//  Network
//
//  Created by 백래훈 on 10/24/25.
//

import ProjectDescription

let project = Project(
    name: "NetworkLive",
    settings: .settings(
        base: [
            "SWIFT_VERSION": "5.10",
            "DEVELOPMENT_TEAM": "DD66GTY4AT",
            "CODE_SIGN_STYLE": "Automatic"
        ],
        configurations: [
            .debug(name: .debug, xcconfig: "../../Configs/Debug-Dev.xcconfig"),
            .release(name: .release, xcconfig: "../../Configs/Release-Prod.xcconfig")
        ]
    ),
    targets: [
        .target(
            name: "NetworkLive",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.raehoon.Showcase.networkLive",
            deploymentTargets: .iOS("17.0"),
            sources: ["Sources/**"],
            dependencies: [
                .project(target: "NetworkInterface", path: "../NetworkInterface")
            ]
        ),
        .target(
            name: "NetworkLiveTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.raehoon.Showcase.networkLive.tests",
            infoPlist: .default,
            sources: ["Tests/**"],
            dependencies: [
                .target(name: "NetworkLive")
            ]
        )
    ]
)
