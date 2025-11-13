//
//  Project.swift
//  Features
//
//  Created by 백래훈 on 10/24/25.
//

import ProjectDescription

let project = Project(
    name: "StreamingDomain",
    settings: .settings(
        base: [
            "SWIFT_VERSION": "5.10",
            "DEVELOPMENT_TEAM": "DD66GTY4AT",
            "CODE_SIGN_STYLE": "Automatic"
        ],
        configurations: [
            .debug(name: .debug, xcconfig: "../../../Configs/Debug-Dev.xcconfig"),
            .release(name: .release, xcconfig: "../../../Configs/Release-Prod.xcconfig")
        ]
    ),
    targets: [
        .target(
            name: "StreamingDomain",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.raehoon.Showcase.streaming.domain",
            deploymentTargets: .iOS("17.0"),
            sources: ["Sources/**"],
            dependencies: []
        ),
        .target(
            name: "StreamingDomainTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.raehoon.Showcase.streaming.domain.tests",
            infoPlist: .default,
            sources: ["Tests/**"],
            dependencies: []
        )
    ]
)
