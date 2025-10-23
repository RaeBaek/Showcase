import ProjectDescription

let project = Project(
    name: "Showcase",
    settings: .settings(
        base: [
            "SWIFT_VERSION": "5.10",
            "DEVELOPMENT_TEAM": "DD66GTY4AT",
            "CODE_SIGN_STYLE": "Automatic"
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
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            buildableFolders: [
                "Showcase/Sources",
                "Showcase/Resources",
            ],
            dependencies: []
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
