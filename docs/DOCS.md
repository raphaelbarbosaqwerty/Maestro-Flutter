# Maestro E2E Testing Framework

## Overview

[Maestro](https://maestro.dev/) is an open-source framework for mobile UI testing that provides a simple, declarative approach to end-to-end testing for iOS and Android applications.

### Why Maestro?

| Feature                 | Benefit                                                |
| ----------------------- | ------------------------------------------------------ |
| **Flakiness Tolerance** | Automatically handles UI instability and timing issues |
| **No Sleep Calls**      | Intelligently waits for content to load                |
| **YAML Syntax**         | Simple, readable test definitions                      |
| **Fast Iteration**      | Tests are interpreted, no compilation needed           |
| **Single Binary**       | Easy installation and setup                            |

#### Flakiness Tolerance

**The Problem**: In traditional testing frameworks (Appium, Espresso, Selenium), UI elements don't always appear where expected. Animations can temporarily displace buttons, a tap might not register on the first attempt, and layouts can vary between devices. This causes tests to fail randomly — known as "flaky tests."

**How Maestro Solves It**: Maestro automatically retries failed interactions, waits for elements to stabilize, and adjusts tap coordinates if needed. You don't need to add `retry()` logic or manual recovery — Maestro handles it internally.

```yaml
# Maestro automatically:
# 1. Retries taps if they fail
# 2. Waits for element to stabilize
# 3. Adjusts coordinates if needed
- tapOn: "Submit"
```

#### No Sleep Calls

**The Problem**: In other frameworks, you often need arbitrary waits:

```javascript
// Appium/Selenium - manual waits everywhere
await driver.wait(5000); // Arbitrary 5 seconds
await driver.findElement("Button").click();
```

This leads to either:

- **Too short waits** → Tests fail because content didn't load
- **Too long waits** → Tests are unnecessarily slow

**How Maestro Solves It**: Maestro intelligently waits for exactly the time needed — no more, no less. It automatically detects when:

- Network content finishes loading
- UI elements are rendered
- Animations complete

```yaml
# No sleep() needed - Maestro waits automatically
- assertVisible: "Dashboard" # Waits until text appears
- tapOn: "Profile" # Waits until element is tappable
```

## Project Structure

```
maestro_dev/
├── e2e/
│   └── maestro_dev/
│       ├── login_flow.yaml        # Login flow test
│       ├── register_flow.yaml     # Registration flow test
│       └── dashboard_flow.yaml    # Dashboard interactions test
├── lib/
│   ├── main.dart                  # App entry with routes
│   └── pages/
│       ├── login_page.dart        # Login page with Semantics
│       ├── register_page.dart     # Register page with Semantics
│       └── dashboard_page.dart    # Dashboard with Semantics
├── .agent/
│   └── workflows/
│       ├── maestro-test.md        # Workflow to create new tests
│       └── maestro-run.md         # Workflow to run existing tests
└── docs/
    └── E2E_TESTING.md             # Technical documentation
```

## How It Works

### 1. Flutter Integration

Maestro interacts with Flutter through the **accessibility tree**. To make widgets testable, we use `Semantics`:

```dart
// Method 1: Semantics identifier (recommended)
Semantics(
  identifier: 'login_submit_button',
  child: ElevatedButton(...),
)

// Method 2: Semantic label for icons
Icon(
  Icons.add,
  semanticLabel: 'add_icon',
)

// Method 3: Text labels (automatic)
TextField(
  decoration: InputDecoration(
    labelText: 'Email',  // Maestro can use this directly
  ),
)
```

### 2. Writing Tests

Tests are written in YAML format:

```yaml
appId: com.example.maestroDev
---
- launchApp:
    clearState: true

- assertVisible: "Login"
- tapOn:
    id: "login_email_field"
- inputText: "test@example.com"
- tapOn:
    id: "login_submit_button"
- assertVisible: "Dashboard"
```

### 3. Running Tests

```bash
# Run all tests
maestro test e2e/maestro_dev/

# Run specific test
maestro test e2e/maestro_dev/login_flow.yaml

# Debug with Studio
maestro studio
```

## AI-Powered Workflows

This project uses **agent workflows** (`.agent/workflows/`) that allow an AI assistant to automatically create and run tests.

### Available Workflows

| Command         | Description                       |
| --------------- | --------------------------------- |
| `/maestro-test` | Create new E2E tests for a module |
| `/maestro-run`  | Run existing E2E tests            |

### How AI Workflows Work

1. **User Request**: "Create E2E tests for the checkout module"

2. **AI Agent**:
   - Reads the workflow instructions from `.agent/workflows/maestro-test.md`
   - Analyzes the Flutter code for the module
   - Identifies widgets that need `Semantics.identifier`
   - Adds missing Semantics to the code
   - Creates YAML test files
   - Runs the tests using `maestro test`

3. **Result**: Complete E2E test coverage with minimal manual effort

### Workflow: `/maestro-test`

**Purpose**: Guide AI to create new tests for a Flutter module

**Steps**:

1. Identify module and user flows
2. Analyze Flutter code for interactive widgets
3. Add `Semantics.identifier` to widgets (if needed)
4. Create YAML test file in `e2e/maestro_dev/`
5. Run the test
6. Verify results and debug if needed

### Workflow: `/maestro-run`

**Purpose**: Execute existing tests

**Steps**:

1. Run all tests or specific test file
2. Open Maestro Studio for debugging (optional)

## Semantics Reference

### Current Identifiers

**Login Page:**

- `login_email_field`
- `login_password_field`
- `login_submit_button`
- `login_register_link`

**Register Page:**

- `register_name_field`
- `register_email_field`
- `register_password_field`
- `register_confirm_password_field`
- `register_submit_button`
- `register_login_link`

**Dashboard Page:**

- `dashboard_logout_button`
- `dashboard_add_button`
- `dashboard_profile_card`
- `dashboard_settings_card`
- `dashboard_analytics_card`
- `dashboard_notifications_card`

## Maestro Commands Reference

| Command              | Example                                     | Description                        |
| -------------------- | ------------------------------------------- | ---------------------------------- |
| `launchApp`          | `- launchApp: { clearState: true }`         | Launch app (optionally clear data) |
| `tapOn`              | `- tapOn: "Button"`                         | Tap on visible text                |
| `tapOn`              | `- tapOn: { id: "btn_id" }`                 | Tap on semantic identifier         |
| `inputText`          | `- inputText: "email@test.com"`             | Enter text in focused field        |
| `assertVisible`      | `- assertVisible: "Welcome"`                | Assert text is visible             |
| `assertNotVisible`   | `- assertNotVisible: "Error"`               | Assert text is not visible         |
| `scroll`             | `- scroll`                                  | Scroll down                        |
| `scrollUntilVisible` | `- scrollUntilVisible: { element: "Item" }` | Scroll until element appears       |
| `takeScreenshot`     | `- takeScreenshot: "result"`                | Capture screenshot                 |
| `back`               | `- back`                                    | Press back button                  |

## Installation

```bash
# Prerequisites: Java 17+
java -version

# Install Maestro (macOS)
brew tap mobile-dev-inc/tap
brew install mobile-dev-inc/tap/maestro

# Verify
maestro --version
```

## Bundle IDs

| Platform | Bundle ID                 |
| -------- | ------------------------- |
| iOS      | `com.example.maestroDev`  |
| Android  | `com.example.maestro_dev` |

## Resources

- [Maestro Documentation](https://docs.maestro.dev/)
- [Flutter Integration](https://docs.maestro.dev/platform-support/flutter)
- [Commands Reference](https://docs.maestro.dev/api-reference/commands)
- [Maestro Cloud](https://maestro.dev/cloud) - CI/CD integration

---

## Framework Comparison

### Maestro vs Patrol vs Flutter integration_test

| Aspect             | **Maestro** | **Patrol** | **Flutter integration_test** |
| ------------------ | ----------- | ---------- | ---------------------------- |
| **Test Language**  | YAML        | Dart       | Dart                         |
| **Developer**      | mobile.dev  | LeanCode   | Google (Flutter)             |
| **Setup Time**     | 2 min       | 15-30 min  | 5 min                        |
| **Learning Curve** | Low         | Medium     | Medium-High                  |

### Feature Comparison

| Feature                   |         Maestro          |     Patrol      | integration_test |
| ------------------------- | :----------------------: | :-------------: | :--------------: |
| Permission config         |    ✅ At launch only     |       ✅        |        ❌        |
| Native dialog interaction | ✅ Android / ⚠️ iOS Auto |       ✅        |        ❌        |
| Notifications             |      ✅ Config only      |       ✅        |        ❌        |
| WebView support           |        ⚠️ Limited        |       ✅        |        ❌        |
| API Mocking               |        ✅ Via env        |       ✅        |        ✅        |
| State access              |            ❌            |       ✅        |        ✅        |
| Hot Restart               |            ❌            |       ✅        |    ⚠️ Limited    |
| Device Farms              |         ✅ Cloud         |       ✅        |    ⚠️ Manual     |
| Physical iOS              |            ❌            |       ✅        |        ✅        |
| Cross-platform            |            ✅            | ❌ Flutter only | ❌ Flutter only  |
| Auto flakiness handling   |            ✅            |    ⚠️ Manual    |    ❌ Manual     |

> **Note on Native Dialog Interaction:**
>
> - **Android**: Maestro can interact with system dialogs using `tapOn: "Allow"` or by inspecting elements with `maestro hierarchy`
> - **iOS**: Maestro auto-dismisses permission dialogs (in English only). Cannot click on specific dialog buttons manually

### Maestro Strengths

- **Extremely simple setup** — one command installs everything
- **YAML syntax** — anyone can read and write tests
- **No compilation** — tests are interpreted instantly
- **Automatic tolerance** to flakiness and delays
- **Cross-platform** — same syntax for iOS, Android, Web, React Native
- **Maestro Studio** — visual tool to explore UI

### Maestro Limitations

- **iOS native dialogs**: Can only auto-dismiss (in English), cannot click specific buttons
- No access to Dart logic or internal state
- Depends on Semantics/accessibility tree
- Physical iOS devices not supported
- No Hot Restart between tests

### When to Use Each

| Use Case                     | Recommended                               |
| ---------------------------- | ----------------------------------------- |
| Quick smoke tests            | **Maestro**                               |
| Non-technical QA team        | **Maestro**                               |
| Multi-platform apps          | **Maestro**                               |
| Permission dialogs (Android) | **Maestro** or **Patrol**                 |
| Permission dialogs (iOS)     | **Patrol**                                |
| Camera/GPS testing           | **Patrol**                                |
| WebView interactions         | **Patrol**                                |
| Device Farms (Firebase, AWS) | **Maestro Cloud** or **Patrol**           |
| API mocking needed           | **Maestro** (env) or **integration_test** |
| Internal state verification  | **integration_test**                      |
| No external dependencies     | **integration_test**                      |

### Related Links

- [Patrol Documentation](https://patrol.leancode.co/)
- [Flutter integration_test](https://docs.flutter.dev/testing/integration-tests)
