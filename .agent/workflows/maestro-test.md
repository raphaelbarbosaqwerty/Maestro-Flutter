---
description: Create E2E tests with Maestro for a Flutter module
---

# Maestro E2E Test Workflow

This workflow guides the creation of E2E tests using Maestro for Flutter modules.

## Context

- **Tests folder**: `e2e/maestro_dev/`
- **iOS Bundle ID**: `com.example.maestroDev`
- **Android Bundle ID**: `com.example.maestro_dev`
- **Documentation**: https://docs.maestro.dev/platform-support/flutter

## Steps

### 1. Identify the module to be tested

Ask the user:

- Which module/feature will be tested? (e.g., authentication, dashboard, checkout)
- What are the main user flows?
- Are there widgets that need `Semantics.identifier` for testing?

### 2. Analyze the Flutter module code

Check the module files for:

- Identify main screens/pages
- List interactive widgets (buttons, inputs, lists)
- Verify if they already have `Semantics` or `semanticLabel`

### 3. Add Semantics to widgets (if needed)

For each interactive widget, add identifiers:

```dart
// Buttons
Semantics(
  identifier: 'login_submit_button',
  child: ElevatedButton(...),
)

// TextFields
TextField(
  decoration: InputDecoration(
    labelText: 'Email',  // Maestro can use this
  ),
)

// Icons
Icon(
  Icons.add,
  semanticLabel: 'add_icon',  // For icons without text
)
```

### 4. Create YAML test file

Create file at `e2e/maestro_dev/{module_name}_flow.yaml`:

```yaml
# {module_name}_flow.yaml
# Tests the {description} flow
appId: com.example.maestroDev # iOS
# appId: com.example.maestro_dev  # Android
---
- launchApp:
    clearState: true

# Step 1: Description
- assertVisible: "expected text"
- tapOn:
    id: "semantic_identifier"

# Step 2: Description
- inputText: "input text"
```

### 5. Run the test

// turbo

```bash
maestro test e2e/maestro_dev/{file_name}.yaml
```

### 6. Verify results

If there are failures:

- Check if `Semantics.identifier` values are correct
- Use `maestro studio` to explore the accessibility tree
- Adjust timeouts if needed (`extendedWaitUntil`)

## Useful Maestro Commands

| Command                  | Description                     |
| ------------------------ | ------------------------------- |
| `tapOn: "text"`          | Tap on widget with visible text |
| `tapOn: { id: "id" }`    | Tap on widget by identifier     |
| `inputText: "value"`     | Type text in focused field      |
| `assertVisible: "text"`  | Verify that text is visible     |
| `scroll`                 | Scroll the screen down          |
| `scrollUntilVisible`     | Scroll until element is found   |
| `takeScreenshot: "name"` | Capture screenshot              |
| `extendedWaitUntil`      | Wait with custom timeout        |

## Tips

1. **Descriptive names**: Use IDs like `login_email_field`, `dashboard_menu_button`
2. **Reusable flows**: Create small flows and compose with `runFlow`
3. **Screenshots**: Capture at important points for debugging
4. **Variables**: Use `env` for dynamic data like credentials
