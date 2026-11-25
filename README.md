# 🎬 Showcase

> **TMDB API 기반 영화·TV·인물 탐색 앱**</br>**SwiftUI + Combine + Tuist 기반의 Clean Architecture 프로젝트**

---

## 📖 소개 (Introduction)

- Showcase는 영화, TV 시리즈, 배우 정보를 통합적으로 탐색할 수 있는 iOS 앱입니다.  
- TMDB(The Movie Database) API를 활용해 최신 콘텐츠를 제공합니다.
- Clean Architecture 기반 및 Tuist를 활용한 멀티 모듈화 구조로 설계되어 유지보수성과 확장성이 높은 구조를 목표로 합니다.
- Localization에 맞춰 TMDB API의 `language` 파라미터를 동적으로 설정하여, 한국어/영어/일본어 등 지역 기반으로 콘텐츠 정보를 제공합니다.
- 추가적으로, HLS(HTTP Live Streaming) 미디어 스트림 재생 기능을 통해 AVPlayer 기반 스트리밍 데모도 제공합니다.

---

## 🚀 MVP 주요 화면

| 홈 화면 | 영화 상세화면 | 인물 상세화면 | TV 상세화면 | HLS 리스트 화면 |
|:--:|:--:|:--:|:--:|:--:|
| <img src="https://github.com/user-attachments/assets/65e70057-45ca-4286-b7c4-5ecfafe5acf5" width="220"/> | <img src="https://github.com/user-attachments/assets/5776c3f0-4e51-42da-89e3-a70a0d77db00" width="220"/> | <img src="https://github.com/user-attachments/assets/ecce6c16-b2ee-4186-a344-6ccb2ec8c26d" width="220"/> | <img src="https://github.com/user-attachments/assets/a6f2f448-1a81-4d87-af74-1fadd7e6d5d2" width="220"/> | <img src="https://github.com/user-attachments/assets/5b918e45-8214-4819-bf60-6a65ca6c23f9" width="220"/> |
| **홈 화면 → 영화 상세화면** | **홈 화면 → 인물 상세화면** | **홈 화면 → TV 상세화면** | **영화 상세화면 → 예고편(YouTube) 재생** | **HLS 리스트 화면 → HLS 스트림 재생** |
| <img src="https://github.com/user-attachments/assets/ff414825-47cf-4466-95ef-9df7fd0a197b" width="220"/> | <img src="https://github.com/user-attachments/assets/a11a93d1-ac99-4938-9a0a-c464ba881915" width="220"/> | <img src="https://github.com/user-attachments/assets/1e8c4c15-81b7-426e-953b-78d857b5b50c" width="220"/> | <img src="https://github.com/user-attachments/assets/293711ec-95c9-4e24-ab75-2ea7d069b219" width="220"/> | <img src="https://github.com/user-attachments/assets/02f078b6-03e7-40b9-b046-c0ae2b2d0039" width="220"/> |

---

## ✨ 핵심 기능 (Key Features)

- 🎞️ **영화 / TV / 인물 탐색**
  - 홈 화면 (TMDB API를 활용한 인기 콘텐츠 조회)
  - 상세 화면 (Movie, People, TV)
    - MovieDetailView / PeopleDetailView / TVDetailView
- 🌐 **지역 기반 API 언어 자동화(Localization)**
  - `Locale.current.identifier` 기반 자동 설정
  - 다국어 환경에서 동일한 구조로 확장 가능한 API 호출 방식
- 🎥 **HLS 미디어 스트림 재생 데모**
  - HLS(HTTP Live Streaming) 기반 영상 목록 제공
  - `.m3u8` manifest 로드 → 세그먼트 스트리밍 → AVPlayer 재생 과정 구현
  - 썸네일 생성(가능한 URL 대상)
  - 네트워크 상태 변화에 따른 스트림 해상도 적응(Auto Bitrate Switching 관찰 가능)
- 🧭 **Navigation 구조 통합**
  - Home → Detail → Sub-detail (인물 정보/비슷한 작품)까지 라우팅 연속 지원
  - Route case 관리 (movieDetail, personDetail, tvDetail)
- 🎨 **공용 DesignSystem**
  - DetailPage, HomePage, StreamingPage 전반에서 사용하는 UI를 일원화
  - `CustomBackToolbar`, `LoadingSkeleton`, `HeaderBackdrop`, `ActionBar`, `OverviewSecion`, `CreditSection`, `VideoSecion`, `SimilarSecion` 일원화
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

## 🔄 네트워크/캐싱/에러 처리
- 네트워크
  - URLSession + 전용 HTTPClient/Endpoint
- 이미지 캐시
  - AsyncImage, Kingfisher (DesignSystem 내부에서만 사용)
- 에러 정책
  - .networkError → 캐시 유지 시도, 재시도 버튼 노출
  - .decodingError → 사용자 친화 텍스트 + 로그 남김

---

## 🧱 Configs & 환경 변수 (Info.plist 연동)
- TMDB Key·Access Token·Base URL 등을 Configs/*.xcconfig에서 관리하고, Info.plist에 노출 키만 안전하게 주입해 런타임 접근

```
Folder, File Structure

App/
Core/
Features/
DesignSystem/
Configs/
├─ Debug-Dev.xcconfig
└─ Release-Prod.xcconfig
```

```swift
Config/*.xcconfig

APP_ENV=PROD
TMDB_API_KEY=1A2B3C4D
TMDB_READ_ACCESS_TOKEN=1A2B3C4D
TMDB_BASE_URL_STRING=api.themoviedb.org/3
```

```xml
info.plist

<plist version="1.0">
<dict>
  <key>TMDB_API_KEY</key>
	<string>$(TMDB_API_KEY)</string>
	<key>TMDB_BASE_URL_STRING</key>
	<string>$(TMDB_BASE_URL_STRING)</string>
	<key>TMDB_READ_ACCESS_TOKEN</key>
	<string>$(TMDB_READ_ACCESS_TOKEN)</string>
</dict>
</plist>
```

---

## 🧩 Module Architecture
<p align="center">
  <img src="https://github.com/user-attachments/assets/e6d5b329-41d4-4970-9ee7-8f7d93d08852" width="1000" />
</p>

---

## 📂 Module Structure
```
Showcase
├── README.md
├── Workspace.swift
├── App                                : 앱 엔트리, AppNavigator, DIContainer
├── Core
│   ├── Localization/                  : 지역화
│   ├── NetworkModel/                  : 네트워크 모델
│   ├── NetworkInterface/              : 네트워크 프로토콜
│   ├── NetworkLive/                   : URLSession 기반 구현체
│   └── NavigaionInterface/            : 화면전환 프로토콜/열거형
├── Features
│   ├── Streaming                      : Streaming(Data/Domain/Presentation)
│   │   ├── StreamingData/
│   │   ├── StreamingDomain/
│   │   └── StreamingPresentation/
│   ├── Home                           : Home(Data/Domain/Presentation)
│   │   ├── HomeData/
│   │   ├── HomeDomain/
│   │   └── HomePresentation/
│   └── Detail (Movie, People, TV)    : Detail(Data/Domain/Presentation)
│       ├── DetailData/
│       ├── DetailDomain/
│       └── DetailPresentation/
└── DesignSystem/                     : 공용 UI (CustomBackToolbar, ActionBar, CreditSection 등)
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

## 📱 기존 iOS 앱에 React Native 연동 (Brownfield)

영화 상세의 **비슷한 작품 → 더보기**를 Debug와 Release 모두 React Native 화면으로 표시합니다. SwiftUI가 TMDB에서 가져온 작품 데이터를 전달하고, React Native가 목록 표시와 선택을 담당합니다.

- Debug: Metro에서 개발용 JS(`dev=true`)를 불러와 Fast Refresh와 RN 개발 도구를 사용합니다.
- Release: 빌드할 때 JS와 이미지 리소스를 앱에 포함하고 `dev=false`로 실행합니다. 앱 실행 시 Metro 서버가 필요하지 않습니다.

### 로컬 실행

사전에 mise, Node.js 22.11.0 이상, CocoaPods를 준비하고, 위의 환경 변수 섹션에 따라 TMDB 설정을 구성합니다. 저장소 루트에서 아래 순서대로 실행합니다.

```bash
mise install
npm --prefix ReactNative ci
mise exec -- tuist install
mise exec -- tuist generate --no-open
pod install --deployment
```

`tuist generate`가 Xcode 프로젝트와 워크스페이스를 다시 생성합니다. 새 네이티브 파일을 추가하거나 Tuist 설정을 수정해 재생성했다면, 그 직후 `pod install --deployment`를 실행해 React Native와 Hermes를 다시 연결합니다.

별도 터미널에서 Metro를 실행한 뒤 `Showcase.xcworkspace`를 열고 `App` Scheme을 Debug로 실행합니다.

```bash
npm --prefix ReactNative start -- --host 0.0.0.0
```

**실기기에서 실행할 때**

1. 맥과 iPhone을 같은 Wi-Fi에 연결합니다. iPhone Safari에서 `http://<맥의 Wi-Fi IP>:8081/status`를 열어 `packager-status:running`을 확인합니다.
2. Debug 빌드 시 맥의 기본 네트워크 인터페이스를 우선 확인하고, 활성 Ethernet·Wi-Fi 인터페이스의 IPv4 주소를 `ip.txt`로 앱에 포함합니다. 시뮬레이터 빌드는 `localhost`를 사용합니다.
3. 별도의 Scheme IP 실행 인자나 xcconfig 설정 없이 빌드·실행합니다. 네트워크를 변경했다면 다시 빌드해 주소를 갱신합니다. Metro 포트는 기본값인 8081을 사용합니다.
4. 로컬 네트워크 접근을 묻는 창이 뜨면 허용합니다. LAN 주소를 찾지 못하면 빌드 경고가 표시되므로 네트워크 연결을 확인하고 다시 빌드합니다. VPN·복수 네트워크 환경에서는 선택된 주소에 실기기가 접근 가능한지 확인합니다.

**Metro 없이 Release로 실행할 때**

Xcode의 **Product → Scheme → Edit Scheme… → Run → Info → Build Configuration**을 `Release`로 변경한 뒤 빌드·실행합니다. JS 번들은 빌드 과정에서 생성되므로 Node.js와 npm 의존성은 필요하지만, 별도로 Metro 서버를 켤 필요는 없습니다. JS 코드를 수정했다면 앱을 다시 빌드해야 합니다. RN 개발을 이어갈 때는 `Debug`로 되돌립니다.

### 화면과 데이터 흐름

1. SwiftUI 영화 상세에서 더보기를 누르면 모달을 열고, 이미 조회한 비슷한 작품의 ID·제목·포스터 URL을 `initialProperties`로 전달합니다.
2. `ReactNative/SimilarMoviesPreview.tsx`가 작품 목록을 `FlatList`로 표시합니다. `더보기`는 매번 RN 런타임을 새로 만들고, `더보기 (런타임 재사용)`는 같은 런타임으로 새 목록 뷰를 엽니다.
3. 작품을 선택하면 `SimilarMoviesNavigation` 네이티브 모듈이 작품 ID와 시트 요청 ID를 Swift에 전달합니다. SwiftUI는 현재 시트의 선택인지 확인하고, 시트가 닫힌 뒤 기존 `.movieDetail(id:)` 경로로 이동합니다.

### 실기기 확인

- 두 더보기 버튼에서 비슷한 작품 목록이 열리고 세로로 스크롤됩니다.
- RN에서 작품을 선택하면 해당 영화 상세가 열리고, 뒤로 가면 원래 영화 상세로 돌아옵니다.
- 포스터가 없는 작품에는 이미지 자리 표시자가 나타납니다. 빈 목록을 주입한 경우 비슷한 작품 섹션과 두 더보기 버튼이 숨겨집니다.

### RN 런타임 재사용 측정 (#34)

일반 `더보기`(Fresh)는 진입마다 런타임을 새로 만듭니다. `더보기 (런타임 재사용)`(Shared)는 앱 실행 중 첫 진입에서 만든 런타임으로 이후 목록을 엽니다.

**첫 행 배치 시간**

더보기 요청을 만든 시점부터 RN 첫 행의 `onLayout` 신호를 Swift에서 받을 때까지의 시간입니다. 포스터 다운로드 완료와 실제 화면 그리기 완료는 별도로 측정하지 않았습니다.

| 빌드 | 모드 | 첫 진입 | 재진입 |
| --- | --- | ---: | ---: |
| Debug | Fresh | 3,416.85 ms | 889.16 ms |
| Debug | Shared | 3,101.14 ms | 88.36 ms |
| Release | Fresh | 109.08 ms | 80.11 ms |
| Release | Shared | 84.97 ms | 74.33 ms |

Debug에서는 첫 진입 시 Metro가 JS 번들을 준비해 전달했고, Fresh 재진입에서는 번들을 다시 다운로드했습니다. Release에서는 앱에 포함된 번들을 사용합니다. 두 빌드 모두 Shared 첫 진입은 `reused=false`, 재진입은 `reused=true`로 확인했습니다. 표는 조건별 1회 관찰값입니다.

**Release 메모리 할당량**

실기기 iPhone 14에서 Instruments의 Allocations로 Fresh와 Shared를 별도 녹화했습니다. `All Heap & Anonymous VM`의 `Current Bytes` 타임라인에서 변화를 보고, `Persistent` 열에서 각 녹화 종료 시 남은 할당량을 읽었습니다.

Fresh는 시트를 닫을 때마다 비슷한 할당량으로 돌아왔습니다. Shared는 초반에 올라간 뒤 Fresh보다 높은 수준을 유지했고, 반복 중 변동 폭은 작았습니다.

**구간별 기록**

같은 기기·Release 빌드·영화에서 모드별로 앱을 새로 실행하고, 시트를 10회 열고 닫았습니다. Fresh 그래프에서 시트를 닫은 뒤 할당량이 내려간 구간을 기준으로 1·5·10회차를 확인했습니다.

| 시점             |       Fresh |      Shared | Shared − Fresh |
| -------------- | ----------: | ----------: | -------------: |
| 1회차를 닫은 뒤      | 약 55–60 MiB | 약 70–73 MiB |   약 +10–18 MiB |
| 5회차를 닫은 뒤      | 약 55–60 MiB | 약 73–76 MiB |   약 +13–21 MiB |
| 10회차를 닫은 뒤     | 약 55–60 MiB | 약 74–77 MiB |   약 +14–22 MiB |
| 녹화 종료 시 남은 할당량 |   58.23 MiB |   76.26 MiB |     +18.03 MiB |

차이 열은 같은 시점에서 두 모드의 앱 할당량을 비교한 값이며 RN 런타임 외의 할당도 포함됩니다. 각 모드의 증가량은 `닫고 5초 뒤 할당량 − 첫 진입 직전 할당량`으로 계산합니다. 이번 녹화에서는 첫 진입 직전 기준값을 확보하지 못해 증가량 계산은 보류했습니다. 위 결과는 Allocations 기준입니다.

**측정 결론**

> 현재 Showcase의 `비슷한 작품 더보기` 화면에서는 Fresh를 기본으로 사용하는 편이 합리적이라고 판단했습니다. 실기기 Release 녹화 종료 시 Shared에서 남은 할당량은 Fresh보다 18.03 MiB 많았습니다. 재진입 시 첫 행 배치는 Fresh 80.11 ms, Shared 74.33 ms였으나, 각 방식에서 한 번의 측정으로 약 5.8 ms 차이가 반복해서 나타나는지는 확인하지 못했습니다. 이번 측정에서는 Shared의 추가 할당량을 감수할 만큼 재진입이 빨라진다는 근거를 확보하지 못했습니다.

---

## 💡 테스트 전략
### 개요
- Showcase는 XCTest를 기반으로 각 모듈의 독립 테스트를 수행합니다.
- 단위(Unit) → 통합(Integration) → UI 수준(Stub/Mock)의 **3단계 계층**으로 구성됩니다.
- 각 Feature는 Data / Domain / Presentation 모듈 단위로 별도 테스트 타깃을 가집니다.
  - 예: HomeDataTests, HomeDomainTests, HomePresentationTests

| 계층 | 대상 | 검증 포인트 | 주요 기술 |
|:--:|:--:|:--:|:--:|
| **Data Layer** | RepositoryImpl, DTO → Entity 변환 | API 응답 디코딩</br>모델 매핑 정확성 | XCTest, MockHTTPClient, JSONDecoder |
| **Domain Layer** | UseCase | 입력/출력 시나리오 검증</br>Repository 호출 흐름 | XCTest, Dependency Injection |
| **Presentaion Layer** | ViewModel | 상태 전이(.idle → .loading → .success(.loaded)/.failure)</br>이벤트 트리거</br>Combine 스트림 유지| XCTest, Combine, XCTestExpectation |

---
