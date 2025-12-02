import ProjectDescription

let project = Project(
    name: "DataInterface",
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
        .target(
            name: "DataInterface",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.raehoon.Showcase.DataInterface",
            deploymentTargets: .iOS("17.0"),
            sources: ["Sources/**"],
            dependencies: [
                .project(target: "DomainInterface", path: "../DomainInterface"),
                .project(target: "NetworkInterface", path: "../Core/NetworkInterface"),
            ]
        )
    ]
)
