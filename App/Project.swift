//
//  Project.swift
//  App
//
//  Created by 백래훈 on 10/24/25.
//

import ProjectDescription

let project = Project(
    name: "App",
    settings: .settings(
        base: [
            "SWIFT_VERSION": "5.10",
            "DEVELOPMENT_TEAM": "DD66GTY4AT",
            "CODE_SIGN_STYLE": "Automatic"
        ],
        configurations: [
            .debug(name: .debug, xcconfig: "../Configs/Debug-Dev.xcconfig"),
            .release(name: .release, xcconfig: "../Configs/Release-Prod.xcconfig")
        ]
    ),
    targets: [
        // App
        .target(
            name: "App",
            destinations: .iOS,
            product: .app,
            bundleId: "com.raehoon.Showcase.app",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .extendingDefault(with: [
                "UILaunchScreen": [
                    "UIColorName": "",
                    "UIImageName": "",
                ],
                "APP_ENV": "$(APP_ENV)",
                "TMDB_API_KEY": "$(TMDB_API_KEY)",
                "TMDB_READ_ACCESS_TOKEN": "$(TMDB_READ_ACCESS_TOKEN)",
                "TMDB_BASE_URL_STRING": "$(TMDB_BASE_URL_STRING)",
            ]),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .project(target: "Network", path: "../Core/Network"),
                .project(target: "Model", path: "../Core/Model"),
                .project(target: "HomePresentation", path: "../Features/Home/HomePresentation"),
                .project(target: "HomeData", path: "../Features/Home/HomeData"),
                .project(target: "HomeDomain", path: "../Features/Home/HomeDomain")
            ]
        ),
        // Unit Tests
        .target(
            name: "ShowcaseTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.raehoon.ShowcaseTests",
            infoPlist: .default,
            sources: ["Tests/**"],
            dependencies: [.target(name: "App")]
        ),
    ]
)
