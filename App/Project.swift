//
//  Project.swift
//  App
//
//  Created by 백래훈 on 10/24/25.
//

import ProjectDescription

let project = Project(
    name: "App",
    options: .options(
        defaultKnownRegions: ["en", "ko", "ja"],
        developmentRegion: "ko"
    ),
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
                "CFBundleDisplayName": "Showcase",
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
                .project(target: "Localization", path: "../Core/Localization"),
                .project(target: "NavigationInterface", path: "../Core/NavigationInterface"),
                .project(target: "NetworkLive", path: "../Core/NetworkLive"),
                .project(target: "HomeData", path: "../Features/Home/HomeData"),
                .project(target: "HomeDomain", path: "../Features/Home/HomeDomain"),
                .project(target: "HomePresentation", path: "../Features/Home/HomePresentation"),
                .project(target: "DetailData", path: "../Features/Detail/DetailData"),
                .project(target: "DetailDomain", path: "../Features/Detail/DetailDomain"),
                .project(target: "DetailPresentation", path: "../Features/Detail/DetailPresentation"),
                .project(target: "StreamingData", path: "../Features/Streaming/StreamingData"),
                .project(target: "StreamingDomain", path: "../Features/Streaming/StreamingDomain"),
                .project(target: "StreamingPresentation", path: "../Features/Streaming/StreamingPresentation")
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
    ],
    schemes: [
        .scheme(
            name: "App",
            shared: true,  // CI에서 사용하려면 반드시 true
            buildAction: .buildAction(targets: ["App"]),
            testAction: .targets(
                [
                    "AppTests",
                    "NetworkLiveTests",
                    "MovieDetailRepositoryImplTests",
                    "PeopleDetailRepositoryImplTests",
                    "TVDetailRepositoryImplTests",
                    "MovieDetailUseCaseImplTests",
                    "PeopleDetailUseCaseImplTests",
                    "TVDetailUseCaseImplTests",
                    "MovieDetailViewModelTests",
                    "PeopleDetailViewModelTests",
                    "TVDetailViewModelTests",
                    "HomeRepositoryImplTests",
                    "BasePagingUseCaseTests",
                    "MoviesPagingUseCaseTests",
                    "PeoplePagingUseCaseTests",
                    "TVsPagingUseCaseTests",
                    "HomeViewModelTests",
                    "StreamingDataTests",
                    "StreamingDomainTests",
                    "StreamingPresentationTests"
                ],
                configuration: .debug,
                options: .options(
                    coverage: true,
                    codeCoverageTargets: [
                        "App",
                        "NetworkLive",
                        "DetailData",
                        "DetailDomain",
                        "DetailPresentation",
                        "HomeData",
                        "HomeDomain",
                        "HomePresentation",
                        "StreamingData",
                        "StreamingDomain",
                        "StreamingPresentation"
                    ])
            ),
            runAction: .runAction(configuration: .debug),
            archiveAction: .archiveAction(configuration: .release),
            profileAction: .profileAction(configuration: .debug),
            analyzeAction: .analyzeAction(configuration: .debug)
        )
    ]
)
