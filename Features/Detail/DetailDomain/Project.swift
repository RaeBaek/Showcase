//
//  Project.swift
//  Features
//
//  Created by 백래훈 on 10/24/25.
//

import ProjectDescription

let project = Project(
    name: "DetailDomain",
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
            name: "DetailDomain",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.raehoon.Showcase.detail.domain",
            deploymentTargets: .iOS("17.0"),
            sources: ["Sources/**"],
            dependencies: [
                .project(target: "NetworkModel", path: "../../../Core/NetworkModel"),
                .project(target: "Localization", path: "../../../Core/Localization"),
                .project(target: "DomainInterface", path: "../../../Interface/DomainInterface")
            ]
        ),
        .target(
            name: "DetailDomainTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.raehoon.Showcase.detail.domain.tests",
            infoPlist: .default,
            sources: ["Tests/**"],
            dependencies: [
                .target(name: "DetailDomain")
            ]
        )
    ]
)
