# Demo iOS Application

A modern, highly performant iOS job discovery application built using **Swift 5.9+**, **SwiftUI**, and the state-of-the-art **Observation Framework**. This codebase serves as an architectural blueprint for a lightweight, scalable, and fully testable production mobile app without any third-party dependencies.

---

## 🚀 Setup Instructions

Follow these steps to configure, build, and execute the application and its test suites locally on your machine.

### Prerequisites
- **macOS Sonoma (14.0)** or later.
- **Xcode 15.0** or later.
- **iOS 17.0+** deployment target (required for the native `Observation` framework and `ContentUnavailableView`).

### Step 1: Clone the Repository
Clone this repository to your local directory using your preferred Git client or terminal:
```bash
git clone https://github.com/DharmbirChoudhary/demo_client.git
cd Demo
```

### Step 2: Open the Project in Xcode
Launch Xcode and open the main workspace or project file:
```bash
open Demo.xcodeproj
```

### Step 3: Configure Target Schemes & Signing
1. Select the project root file in the left **Project Navigator** sidebar.
2. Under the **Targets** list, choose `JobDiscovery`.
3. Navigate to the **Signing & Capabilities** tab.
4. Set your development team or change the Bundle Identifier if required to resolve automated provisioning profiles.

### Step 4: Compiling and Running the App
1. Select an iOS 17+ Simulator (e.g., iPhone 15 Pro) from the active run scheme dropdown menu at the top.
2. Press `⌘ + R` (Command + R) or click the **Play** button to build and run the application.

---

## 🧪 Running Unit Tests

The test suite achieves comprehensive coverage over business logic state machines and filtering mechanics.

1. Select the active scheme dropdown menu at the top and verify your application target is active.
2. Press **`⌘ + U` (Command + U)** to execute all unit tests across the workspace.
3. *Alternatively*, open the **Test Navigator** (`⌘ + 6`), hover over the `DemoTests` class name, and click the nested **Play** icon to isolate ViewModel execution.

---

## 🏗️ Architecture Explanation

The application cleanly implements a clean variant of the **MVVM (Model-View-ViewModel)** architectural pattern. It heavily leverages modern Swift language features like **Structured Concurrency (async/await)** and the **Observation Framework** for unidirectional data reactive binding.

```
┌────────────────────────────────────────────────────────┐
│                   Presentation Layer                   │
│  [JobListView] ──(Binds properties via @Bindable)──┐   │
└─────────────────────────┬──────────────────────────┼───┘
                          │                          │
                 (Observes State Change)     (Updates Text)
                          │                          │
┌─────────────────────────▼──────────────────────────▼───┐
│                    Business Logic                      │
│                  [JobListViewModel]                    │
│   • Evaluates state machine based on enum contexts     │
│   • Lazily filters records dynamically on text mutate  │
└─────────────────────────┬──────────────────────────┘
                          │
         (Injected via Protocols / Constructor)
                          │
┌─────────────────────────▼──────────────────────────┐
│                      Data Layer                    │
│    [MockJobService] ──► Conforms to ──► [Protocol]  │
│   • Manages asynchronous JSON modeling abstractions    │
└────────────────────────────────────────────────────┘
```

### 1. Presentation Layer (SwiftUI Views)
- **`JobListView`**: A high-efficiency declaration container displaying structural job rows. Features a custom pinned top search input interface, explicitly suppressing native navigation title rendering pipelines to present a sleek branding layout.
- **`JobDetailView`**: A structural view displaying descriptive corporate specifications, metadata badges, and breakdown fields.

### 2. Business Logic Layer (ViewModel)
- **`JobListViewModel`**: Decorated with the modern `@Observable` macro macro-expression. It isolates mutable properties from global threads by operating strictly on the `@MainActor`. 
- By moving away from `ObservableObject` and `@Published` (Combine dependencies), SwiftUI intercepts property reads at a granular level. The screen re-evaluates *only* when properties used in that specific view render code change, yielding substantial runtime optimization.

### 3. Data & Abstraction Layer
- Built around decoupled protocol structures (`JobServiceProtocol`). This abstracts the network layer away from concrete implementations, ensuring the app code is completely indifferent to whether data originates from an active remote API endpoint, standard JSON disk models, or developer test mocks.

### 4. Dependency Injection (DI)
- Implements explicit **Constructor Injection** backed by a central runtime `DependencyContainer`. This ensures that service lifecycles can be modified seamlessly during boot-up or runtime configurations, laying down the groundwork for reliable software testing metrics.

---

## 💡 Assumptions Made

During the architecture map design phase, the following engineering trade-offs and structural assumptions were applied:

1. **iOS 17+ Target Requirement**: It is assumed that the application is built prioritizing modern software foundations rather than retrofitted legacy layers. Relying on Swift 5.9's macro system (`@Observable`) requires an iOS 17 minimum runtime target.
2. **Main Thread State Execution Safety**: The `JobListViewModel` is marked in its entirety as a `@MainActor`. We assume that all state emissions (including state resets to `.loading` or `.error`) happen strictly on the main thread, removing any possible UI state collision patterns.
3. **In-Memory Text Search Filtration**: It is assumed that the job directory dataset length can fit securely within device memory models. Text query filtration runs lazily over cache lists via localized standard checks (`localizedCaseInsensitiveContains`). If datasets scale past thousands of entries, this mechanism will be decoupled to run through debounced background threads or server-side API query integrations.
4. **Network Lifecycle Abstraction**: For test evaluation execution safety, network endpoints are backed by a structured mock entity capable of simulating variable server-side connection drops and network latency thresholds dynamically.
