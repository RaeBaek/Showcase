//
//  Project.swift
//  Model
//
//  Created by 백래훈 on 10/24/25.
//

import ProjectDescription

let project = Project(
    name: "NetworkModel",
    settings: .settings(
        base: [
            "SWIFT_VERSION": "5.10",
            "ENABLE_MODULE_VERIFIER": "YES",
            "ENABLE_USER_SCRIPT_SANDBOXING": "YES",
            "STRING_CATALOG_GENERATE_SYMBOLS": "YES",
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
            name: "NetworkModel",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.raehoon.Showcase.networkModel",
            deploymentTargets: .iOS("17.0"),
            sources: ["Sources/**"],
            dependencies: []
        )
    ]
)
