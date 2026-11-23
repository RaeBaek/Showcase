import ProjectDescription

let project = Project(
    name: "PresentationInterface",
    settings: .settings(
        base: [
            "SWIFT_VERSION": "5.10",
            "ENABLE_MODULE_VERIFIER": "YES",
            "MODULE_VERIFIER_SUPPORTED_LANGUAGES": ["objective-c", "objective-c++"],
            "MODULE_VERIFIER_SUPPORTED_LANGUAGE_STANDARDS": ["gnu11", "gnu++14"],
            "ENABLE_USER_SCRIPT_SANDBOXING": "YES",
            "STRING_CATALOG_GENERATE_SYMBOLS": "YES",
            "ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS": "YES",
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
            name: "PresentationInterface",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.raehoon.Showcase.PresentationInterface",
            deploymentTargets: .iOS("17.0"),
            sources: ["Sources/**"],
            dependencies: [
                .project(target: "DomainInterface", path: "../DomainInterface")
            ]
        )
    ]
)
