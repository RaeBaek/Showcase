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
            "STRING_CATALOG_GENERATE_SYMBOLS": "YES",
            "ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS": "YES",
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
                "NSLocalNetworkUsageDescription": "개발 중 React Native 화면을 불러오기 위해 Mac의 개발 서버에 연결합니다.",
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
            scripts: [
                .post(
                    script: """
                    set -e

                    if [ "$CONFIGURATION" = "Debug" ]; then
                      METRO_IP="localhost"
                      if [ "$PLATFORM_NAME" != "iphonesimulator" ]; then
                        INTERFACES=$({
                          echo 'show State:/Network/Global/IPv4' | /usr/sbin/scutil | /usr/bin/awk '/PrimaryInterface/ {print $3}'
                          /usr/sbin/networksetup -listallhardwareports | /usr/bin/awk '/^Device: / {print $2}'
                        } | /usr/bin/awk '!seen[$0]++')
                        for INTERFACE in $INTERFACES; do
                          case "$INTERFACE" in
                            en*) ;;
                            *) continue ;;
                          esac
                          ADDRESS=$(/usr/sbin/ipconfig getifaddr "$INTERFACE" 2>/dev/null || true)
                          case "$ADDRESS" in
                            ""|169.254.*) continue ;;
                          esac
                          METRO_IP="$ADDRESS"
                          break
                        done
                        if [ "$METRO_IP" = "localhost" ]; then
                          echo "warning: Could not detect the Mac's LAN IPv4 address. Check the network and rebuild before using Metro on a device."
                        fi
                      fi
                      mkdir -p "$TARGET_BUILD_DIR/$UNLOCALIZED_RESOURCES_FOLDER_PATH"
                      echo "$METRO_IP" > "$TARGET_BUILD_DIR/$UNLOCALIZED_RESOURCES_FOLDER_PATH/ip.txt"
                      echo "Debug loads JavaScript from Metro; skipping embedded bundle generation."
                      exit 0
                    fi

                    rm -f "$TARGET_BUILD_DIR/$UNLOCALIZED_RESOURCES_FOLDER_PATH/ip.txt"
                    export PODFILE_DIR="$SRCROOT/.."
                    export PROJECT_ROOT="$PODFILE_DIR/ReactNative"
                    export REACT_NATIVE_PATH="$PROJECT_ROOT/node_modules/react-native"
                    export ENTRY_FILE="index.js"
                    unset SKIP_BUNDLING

                    if [ ! -f "$REACT_NATIVE_PATH/scripts/react-native-xcode.sh" ]; then
                      echo "error: React Native dependencies are missing. Run npm --prefix ReactNative ci from the repository root."
                      exit 1
                    fi

                    /bin/bash "$REACT_NATIVE_PATH/scripts/xcode/with-environment.sh" \
                      "$REACT_NATIVE_PATH/scripts/react-native-xcode.sh"
                    """,
                    name: "Bundle React Native code and images",
                    outputPaths: ["$(CONFIGURATION_BUILD_DIR)/$(UNLOCALIZED_RESOURCES_FOLDER_PATH)/main.jsbundle"],
                    basedOnDependencyAnalysis: false,
                    shellPath: "/bin/bash"
                )
            ],
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
            ],
            settings: .settings(base: [
                // RN scripts read node_modules and generate resources beyond declared outputs.
                "ENABLE_USER_SCRIPT_SANDBOXING": "NO",
                // Match RN's Swift-side suppression for incomplete prebuilt umbrella headers.
                "OTHER_CFLAGS": ["$(inherited)", "-Wno-incomplete-umbrella"]
            ])
        ),
        // Unit Tests
        .target(
            name: "AppTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.raehoon.Showcase.tests",
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
                ["AppTests"],
                configuration: .debug,
                options: .options(
                    coverage: true,
                    codeCoverageTargets: ["App"])
            ),
            runAction: .runAction(configuration: .debug),
            archiveAction: .archiveAction(configuration: .release),
            profileAction: .profileAction(configuration: .debug),
            analyzeAction: .analyzeAction(configuration: .debug)
        )
    ]
)
