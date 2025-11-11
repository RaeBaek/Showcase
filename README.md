# 🎬 Showcase

#### TMDB API 기반 영화·TV·인물 탐색 앱
#### SwiftUI + Combine + Tuist 기반의 Clean Architecture 프로젝트

---

## 📖 소개 (Introduction)

- Showcase는 영화, TV 시리즈, 배우 정보를 통합적으로 탐색할 수 있는 iOS 앱입니다.  
- TMDB(The Movie Database) API를 활용해 최신 콘텐츠를 제공합니다.
- Clean Architecture 기반 및 Tuist를 활용한 멀티 모듈화 구조로 설계되어 유지보수성과 확장성이 높은 구조를 목표로 합니다.

---

## 🚀 MVP 주요 화면

| 홈화면 | 영화 상세 화면 | 인물 상세 화면 | TV 상세 화면 |
|:--:|:--:|:--:|:--:|
| <img src="https://github.com/user-attachments/assets/65e70057-45ca-4286-b7c4-5ecfafe5acf5" width="250"/> | <img src="https://github.com/user-attachments/assets/5776c3f0-4e51-42da-89e3-a70a0d77db00" width="250"/> | <img src="https://github.com/user-attachments/assets/ecce6c16-b2ee-4186-a344-6ccb2ec8c26d" width="250"/> | <img src="https://github.com/user-attachments/assets/a6f2f448-1a81-4d87-af74-1fadd7e6d5d2" width="250"/> |

---

## ✨ 핵심 기능 (Key Features)

- 🎞️ **영화 / TV / 인물 탐색**
  - 홈 화면 (TMDB API를 활용한 인기 콘텐츠 조회)
  - 상세 화면 (Movie, People, Tv)
    - MovieDetailView / PeopleDetailView / TVDetailView
- 🧭 **Navigation 구조 통합**
  - Home → Detail → Sub-detail (인물/유사작품)까지 라우팅 연속 지원
- 🎨 **공용 DesignSystem**
  - `CustomBackToolbar`, `ActionBar`, `CreditSection` `HeaderBackdrop`, `LoadingSkeleton`, `OverviewSecion`, `SimilarSecion`, `VideoSecion` 일원화
- ⚙️ **클린 아키텍처 / 모듈화**
  - Domain / Data / Presentation 레이어로 분리
  - Tuist를 이용한 App/Core/Features/DesignSystem 독립 관리
- 📱 **SwiftUI + Combine 기반 MVVM**
  - 비동기 데이터 로드 및 상태 관리 통합
- 🔗 **Tuist Workspace 구성**
  - 각 Feature 모듈은 독립적으로 테스트 및 빌드 가능  
  - Domain, Data, Presentation 3-Layer 구조 적용
- 🔍 **의존성 방향**
  - `Presentation → Domain ← Data`
  - `Features`는 `Core`와 `DesignSystem`에 의존
  - `Tests`는 생성된 모듈을 의존
  - `HomePresentation`, `DetailPresentaion`은 외부 의존성 `Kingfisher`을 의존

---

## 🧩 Module Architecture
<p align="center">
  <img src="https://github.com/user-attachments/assets/08af38ab-7c87-4a21-b8cb-df7e2bdf52e0" width="1000" />
</p>

---

## 📂 Module Structure
```
Showcase
├── README.md
├── Workspace.swift
├── App                                : 앱 엔트리, AppNavigator, DIContainer
├── Core
│   ├── NetworkInterface/              : 네트워크 프로토콜/모델
│   ├── NetworkLive/                   : URLSession 기반 구현체
│   └── NavigaionInterface/            : 화면전환 프로토콜/열거형
├── Features
│   ├── Home                           : Home(Data/Domain/Presentation)
│   │   ├── HomeData/
│   │   ├── HomeDomain/
│   │   └── HomePresentation/
│   └── Detail (Movie, People, TV)    : Detail(Data/Domain/Presentation)
│       ├── DetailData/
│       ├── DetailDomain/
│       └── DetailPresentation/
└── DesignSystem/                    : 공용 UI (CustomBackToolbar, ActionBar, CreditSection 등)
├── Configs/
└── Tuist/
```

### 레이어 규칙
- Presentation → Domain ← Data (단방향)
- 모든 Feature는 Core(예: NetworkInterface/Live)와 DesignSystem에 의존
- App은 Feature들의 Presentation만 의존하고, DI로 결합

### Tuist 구성 파일
- Workspace.swift
  - 워크스페이스와 포함 프로젝트를 선언

```swift
import ProjectDescription

let workspace = Workspace(
    name: "Showcase",
    projects: [
        "App/**",
        "DesignSystem/**",
        "Core/**",
        "Features/**"
    ]
)
```

- 각 모듈의 Project.swift
  - 타깃(Production/Tests), 번들 ID, 의존성, 리소스, 설정을 코드로 관리

```swift
import ProjectDescription

let project = Project(
    name: "App",
    settings: .settings(
        base: [
            "SWIFT_VERSION": "5.10",
            "DEVELOPMENT_TEAM": "",
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
            bundleId: "",
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
                .project(target: "NavigationInterface", path: "../Core/NavigationInterface"),
                .project(target: "NetworkLive", path: "../Core/NetworkLive"),
                .project(target: "HomeData", path: "../Features/Home/HomeData"),
                .project(target: "HomeDomain", path: "../Features/Home/HomeDomain"),
                .project(target: "HomePresentation", path: "../Features/Home/HomePresentation"),
                .project(target: "DetailData", path: "../Features/Detail/DetailData"),
                .project(target: "DetailDomain", path: "../Features/Detail/DetailDomain"),
                .project(target: "DetailPresentation", path: "../Features/Detail/DetailPresentation")
            ]
        ),
        // Unit Tests
        .target(
            name: "ShowcaseTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "",
            infoPlist: .default,
            sources: ["Tests/**"],
            dependencies: [.target(name: "App")]
        ),
    ]
)
```
---

## 💡 테스트 전략
- 각 레이어/모듈에 대응 테스트 타깃을 둡니다. (예: HomeDataTests, HomeDomainTests, HomePresentationTests)
- 네트워크는 NetworkInterface의 프로토콜을 Mock으로 대체해 단위 테스트를 수행
- 주요 시나리오: UseCase 입출력, Repository 변환( DTO → Entity ), ViewModel 상태 전이
