# E2E Testing with Maestro

This project uses [Maestro](https://maestro.dev/) for end-to-end UI testing.

## Structure

```
e2e/
└── maestro_dev/
    ├── login_flow.yaml               # Login flow test
    ├── register_flow.yaml            # Registration flow test
    ├── dashboard_flow.yaml           # Dashboard interactions test
    ├── camera_permission_flow.yaml   # Generic permission test
    ├── camera_permission_ios.yaml    # iOS-specific (auto-dismiss)
    └── camera_permission_android.yaml # Android-specific (tapOn dialog)
```

## Prerequisites

- Java 17+
- Maestro CLI installed

```bash
# macOS
brew tap mobile-dev-inc/tap
brew install mobile-dev-inc/tap/maestro

# Verify installation
maestro --version
```

## Bundle IDs

| Platform | Bundle ID                 |
| -------- | ------------------------- |
| iOS      | `com.example.maestroDev`  |
| Android  | `com.example.maestro_dev` |

## Commands

```bash
# Run all tests
maestro test e2e/maestro_dev/

# Run specific test
maestro test e2e/maestro_dev/login_flow.yaml

# Run platform-specific permission tests
maestro test e2e/maestro_dev/camera_permission_ios.yaml
maestro test e2e/maestro_dev/camera_permission_android.yaml

# Open Maestro Studio (explore UI)
maestro studio
```

## Native Dialog Handling

Maestro handles permission dialogs differently per platform:

### Android

```yaml
# Can interact with system dialogs directly
- tapOn: "While using the app"
# or
- tapOn: "Allow"
```

### iOS

```yaml
# Auto-dismisses permission dialogs (English only)
# No manual tapOn needed - Maestro handles it automatically
- tapOn:
    id: "camera_request_permission_button"
# Permission is auto-allowed
```

> **Note**: iOS auto-dismiss only works when simulator is set to English.

## Adding Semantics in Flutter

For Maestro to identify widgets without visible text:

```dart
// Buttons/Containers
Semantics(
  identifier: 'my_button',
  child: ElevatedButton(...),
)

// Icons
Icon(
  Icons.add,
  semanticLabel: 'add',
)
```

## Agent Workflows

The project has workflows to automate test creation and execution:

| Command         | Description                       |
| --------------- | --------------------------------- |
| `/maestro-test` | Create new E2E tests for a module |
| `/maestro-run`  | Run existing tests                |

### /maestro-test

Step-by-step guide to create tests:

1. Identify module and user flows
2. Analyze widgets that need `Semantics`
3. Add identifiers in Flutter code
4. Create YAML test file
5. Run and debug

### /maestro-run

Quick execution of existing tests.

## Test Structure

```yaml
# test_name.yaml
appId: com.example.maestroDev
---
- launchApp:
    clearState: true
    permissions:
      camera: allow # Pre-configure permissions

- assertVisible: "Expected text"
- tapOn:
    id: "semantic_identifier"
- inputText: "input text"
- takeScreenshot: "result"
```

## Useful Commands

| Command          | Example                                            |
| ---------------- | -------------------------------------------------- |
| `launchApp`      | `- launchApp: { clearState: true }`                |
| `tapOn`          | `- tapOn: "Button"` or `- tapOn: { id: "btn_id" }` |
| `inputText`      | `- inputText: "email@test.com"`                    |
| `assertVisible`  | `- assertVisible: "Welcome"`                       |
| `scroll`         | `- scroll`                                         |
| `takeScreenshot` | `- takeScreenshot: "home_screen"`                  |
| `permissions`    | `permissions: { camera: allow, location: deny }`   |

## Links

- [Maestro Documentation](https://docs.maestro.dev/)
- [Flutter Support](https://docs.maestro.dev/platform-support/flutter)
- [Commands Reference](https://docs.maestro.dev/api-reference/commands)
- [Permissions Setup](https://docs.maestro.dev/advanced/configuring-permissions)
