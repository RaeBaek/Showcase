import ProjectDescription

let project = Project(
    name: "Showcase",
    settings: .settings(
        base: [
            "SWIFT_VERSION": "5.10",
            "DEVELOPMENT_TEAM": "DD66GTY4AT",
            "CODE_SIGN_STYLE": "Automatic"
        ],
        configurations: [
            .debug(name: .debug, xcconfig: "Configs/Debug-Dev.xcconfig"),
            .release(name: .release, xcconfig: "Configs/Release-Prod.xcconfig")
        ]
    ),
    targets: [
        // App
        .target(
            name: "Showcase",
            destinations: .iOS,
            product: .app,
            bundleId: "com.raehoon.Showcase",
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
            buildableFolders: [
                "Showcase/Sources",
                "Showcase/Resources",
            ],
            dependencies: [

            ]
        ),
        // Unit Tests
        .target(
            name: "ShowcaseTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.raehhon.ShowcaseTests",
            infoPlist: .default,
            buildableFolders: [
                "Showcase/Tests"
            ],
            dependencies: [.target(name: "Showcase")]
        ),
    ]
)
