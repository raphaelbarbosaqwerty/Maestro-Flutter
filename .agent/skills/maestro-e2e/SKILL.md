---
name: Maestro E2E Testing
description: Create and run E2E UI tests with Maestro for iOS, Android, Flutter, React Native, and Web applications
---

# Maestro E2E Testing Skill

## Overview

Maestro is an open-source E2E UI testing framework that uses YAML syntax for test definitions. It supports iOS, Android, Flutter, React Native, and Web platforms with a unified syntax.

## When to Use This Skill

- When the user asks to create E2E, UI, or integration tests
- When testing login, registration, or navigation flows
- When dealing with permission dialogs (camera, location, etc.)
- When debugging test failures or exploring UI hierarchy
- When the user mentions "maestro", "e2e test", or "UI automation"

## Installation

```bash
# macOS
brew tap mobile-dev-inc/tap
brew install mobile-dev-inc/tap/maestro

# Linux/Windows (via curl)
curl -Ls "https://get.maestro.mobile.dev" | bash

# Verify
maestro --version
```

## Bundle ID Conventions

| Platform | Format     | Example               |
| -------- | ---------- | --------------------- |
| iOS      | camelCase  | `com.example.myApp`   |
| Android  | snake_case | `com.example.my_app`  |
| Web      | URL        | `https://example.com` |

## Test Structure

```yaml
# flow_name.yaml
appId: com.example.myApp # or url: for web
env:
  USERNAME: test@example.com
  PASSWORD: secret123
---
- launchApp:
    clearState: true
    permissions:
      camera: allow
      location: deny

- assertVisible: "Welcome"
- tapOn:
    id: "login_button"
- inputText: ${USERNAME}
- takeScreenshot: "result"
```

## Platform-Specific Behavior

### iOS

- **Permission Dialogs**: Auto-dismissed (English simulators only)
- **Cannot manually click** dialog buttons
- **Physical devices**: Not supported
- **Permissions at launch**: Use `permissions:` in `launchApp`

### Android

- **Permission Dialogs**: Full interaction via `tapOn: "Allow"`
- Uses ADB for deep device control
- Can inspect UI with `maestro hierarchy`
- Supports custom permission IDs

### Flutter

- Use `Semantics.identifier` (Flutter 3.19+) for testable widgets
- Or use `semanticsLabel` for older versions
- Keys are NOT accessible by Maestro

```dart
// Preferred (Flutter 3.19+)
Semantics(
  identifier: 'login_button',
  child: ElevatedButton(...),
)

// Alternative (older Flutter)
ElevatedButton(
  child: Text('Login', semanticsLabel: 'login_button'),
)
```

### Web (Desktop Browser)

- Use `url:` instead of `appId:`
- Run with: `maestro test example.yaml`
- Studio: `maestro -p web studio`
- Uses Chromium by default

```yaml
url: https://example.com
---
- launchApp
- tapOn: "Sign In"
- assertVisible: "Dashboard"
```

## Commands Reference

### Navigation

| Command     | Example                             |
| ----------- | ----------------------------------- |
| `launchApp` | `- launchApp: { clearState: true }` |
| `stopApp`   | `- stopApp`                         |
| `killApp`   | `- killApp`                         |
| `openLink`  | `- openLink: "myapp://home"`        |
| `back`      | `- back`                            |

### Interactions

| Command              | Example                                         |
| -------------------- | ----------------------------------------------- |
| `tapOn`              | `- tapOn: "Button"` or `- tapOn: { id: "btn" }` |
| `doubleTapOn`        | `- doubleTapOn: "Element"`                      |
| `longPressOn`        | `- longPressOn: "Element"`                      |
| `inputText`          | `- inputText: "Hello"`                          |
| `eraseText`          | `- eraseText: { charactersToErase: 10 }`        |
| `hideKeyboard`       | `- hideKeyboard`                                |
| `scroll`             | `- scroll`                                      |
| `scrollUntilVisible` | `- scrollUntilVisible: { element: "Footer" }`   |
| `swipe`              | `- swipe: { direction: LEFT }`                  |

### Assertions

| Command            | Example                       |
| ------------------ | ----------------------------- |
| `assertVisible`    | `- assertVisible: "Welcome"`  |
| `assertNotVisible` | `- assertNotVisible: "Error"` |
| `assertTrue`       | `- assertTrue: ${CONDITION}`  |

### Screenshots & Recording

| Command          | Example                      |
| ---------------- | ---------------------------- |
| `takeScreenshot` | `- takeScreenshot: "result"` |
| `startRecording` | `- startRecording: "flow"`   |
| `stopRecording`  | `- stopRecording`            |

### Device Control

| Command           | Example                                                |
| ----------------- | ------------------------------------------------------ |
| `setLocation`     | `- setLocation: { lat: 40.7, long: -74.0 }`            |
| `setAirplaneMode` | `- setAirplaneMode: { enabled: true }`                 |
| `setOrientation`  | `- setOrientation: { orientation: LANDSCAPE }`         |
| `setPermissions`  | `- setPermissions: { permissions: { camera: allow } }` |

### Flow Control

| Command     | Example                                       |
| ----------- | --------------------------------------------- |
| `runFlow`   | `- runFlow: { file: "login.yaml" }`           |
| `runScript` | `- runScript: { file: "script.js" }`          |
| `repeat`    | `- repeat: { times: 3, commands: [...] }`     |
| `retry`     | `- retry: { maxRetries: 3, commands: [...] }` |

## Permissions

### Available Permissions

| Permission      | iOS | Android |
| --------------- | --- | ------- |
| `camera`        | ✅  | ✅      |
| `location`      | ✅  | ✅      |
| `microphone`    | ✅  | ✅      |
| `photos`        | ✅  | ❌      |
| `notifications` | ✅  | ✅      |
| `contacts`      | ✅  | ✅      |
| `calendar`      | ✅  | ✅      |
| `bluetooth`     | ❌  | ✅      |
| `storage`       | ❌  | ✅      |

### Permission Values

| Value   | iOS          | Android      |
| ------- | ------------ | ------------ |
| `allow` | Granted      | Granted      |
| `deny`  | Denied       | Prompt shown |
| `unset` | Prompt shown | Prompt shown |

### iOS Location Special Values

- `always` - Same as allow
- `inuse` - Only while using app
- `never` - Same as deny

### Example: Configure Permissions

```yaml
- launchApp:
    clearState: true
    permissions:
      all: deny # Deny all first
      camera: allow # Then allow specific
      location: inuse # iOS only
```

## Parameters & Environment Variables

### External Parameters

```bash
maestro test -e USERNAME=test@example.com -e PASSWORD=123 flow.yaml
```

### Inline Parameters

```yaml
appId: com.example.app
env:
  USERNAME: test@example.com
  PASSWORD: 123
---
- inputText: ${USERNAME}
```

### Shell Variables

Variables prefixed with `MAESTRO_` are automatically available:

```bash
export MAESTRO_API_URL=https://api.example.com
```

## Conditions

### Run Flow Conditionally

```yaml
- runFlow:
    when:
      visible: "Login"
    file: login_flow.yaml
```

### Inline Conditional Commands

```yaml
- runFlow:
    when:
      visible: "Cookie Banner"
    commands:
      - tapOn: "Accept"
```

### Platform Conditions

```yaml
- runFlow:
    when:
      platform: Android
    commands:
      - tapOn: "Allow" # Android permission dialog
```

## Nested Flows (Subflows)

### Create Reusable Subflows

```yaml
# subflows/login.yaml
appId: com.example.app
env:
  USERNAME: ${USERNAME || 'default@example.com'}
  PASSWORD: ${PASSWORD || 'password123'}
---
- tapOn: { id: "email_field" }
- inputText: ${USERNAME}
- tapOn: { id: "password_field" }
- inputText: ${PASSWORD}
- tapOn: { id: "submit" }
```

### Use Subflows

```yaml
# main_flow.yaml
appId: com.example.app
---
- launchApp
- runFlow:
    file: subflows/login.yaml
    env:
      USERNAME: special@example.com
- assertVisible: "Dashboard"
```

## JavaScript Integration

### Inline Script

```yaml
- evalScript: ${output.value = 'Hello ' + new Date().getTime()}
- inputText: ${output.value}
```

### External Script

```yaml
- runScript: { file: "generate_data.js" }
```

### JavaScript Capabilities

- HTTP requests
- String manipulation
- Date/time operations
- Custom logic
- **No** filesystem access
- **No** require/import

## Debugging

### Maestro Studio

```bash
# Mobile
maestro studio

# Web
maestro -p web studio
```

### View UI Hierarchy

```bash
maestro hierarchy
```

### Common Issues

| Problem                  | Solution                                                          |
| ------------------------ | ----------------------------------------------------------------- |
| Element not found        | Use `maestro hierarchy` to find correct identifier                |
| Keyboard blocking        | Add `- hideKeyboard` before tap                                   |
| Element below fold       | Add `- scroll` or `- scrollUntilVisible`                          |
| Timing issues            | Add `- extendedWaitUntil: { visible: "Element", timeout: 10000 }` |
| iOS dialog not dismissed | Ensure simulator is in English                                    |

## Best Practices

1. **Use semantic identifiers** - Add `Semantics.identifier` to Flutter widgets
2. **Create subflows** - Extract common flows (login, navigation)
3. **Use env variables** - Never hardcode credentials in test files
4. **Take screenshots** - Document key states for debugging
5. **Handle platform differences** - Use conditions for iOS/Android specific flows
6. **Keep tests atomic** - Each test should be independent
7. **Use `clearState: true`** - Start fresh for reproducible tests

## Directory Structure

```
project/
├── e2e/
│   └── app_name/
│       ├── login_flow.yaml
│       ├── register_flow.yaml
│       └── subflows/
│           └── login.yaml
└── .agent/
    └── workflows/
        ├── maestro-test.md
        └── maestro-run.md
```

## CI Integration

### GitHub Actions

```yaml
- name: Install Maestro
  run: curl -Ls "https://get.maestro.mobile.dev" | bash

- name: Run E2E Tests
  run: |
    export PATH="$PATH:$HOME/.maestro/bin"
    maestro test e2e/
```

### Maestro Cloud

```bash
maestro cloud --apiKey $MAESTRO_API_KEY app.apk e2e/
```

## Links

- [Maestro Documentation](https://docs.maestro.dev/)
- [Commands Reference](https://docs.maestro.dev/api-reference/commands)
- [Flutter Support](https://docs.maestro.dev/platform-support/flutter)
- [Maestro Cloud](https://maestro.dev/cloud)
