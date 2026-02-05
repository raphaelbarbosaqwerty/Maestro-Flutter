# Maestro E2E Testing Demo

A Flutter project demonstrating end-to-end testing with [Maestro](https://maestro.dev/).

## 📚 Documentation

| Document                                  | Description                                                |
| ----------------------------------------- | ---------------------------------------------------------- |
| [CONFLUENCE.md](docs/CONFLUENCE.md)       | Complete Maestro guide with framework comparison (English) |
| [CONFLUENCE_PT.md](docs/CONFLUENCE_PT.md) | Guia completo do Maestro (Português)                       |
| [E2E_TESTING.md](docs/E2E_TESTING.md)     | Quick reference for running tests                          |

## 🚀 Quick Start

```bash
# Install Maestro (macOS)
brew tap mobile-dev-inc/tap
brew install mobile-dev-inc/tap/maestro

# Run all E2E tests
maestro test e2e/maestro_dev/

# Open Maestro Studio
maestro studio
```

## 📁 Project Structure

```
maestro_dev/
├── lib/
│   ├── main.dart
│   └── pages/
│       ├── login_page.dart
│       ├── register_page.dart
│       ├── dashboard_page.dart
│       └── camera_page.dart
├── e2e/
│   └── maestro_dev/
│       ├── login_flow.yaml
│       ├── register_flow.yaml
│       ├── dashboard_flow.yaml
│       ├── camera_permission_ios.yaml
│       └── camera_permission_android.yaml
├── .agent/
│   └── workflows/
│       ├── maestro-test.md      # AI workflow: create tests
│       └── maestro-run.md       # AI workflow: run tests
└── docs/
    ├── CONFLUENCE.md
    ├── CONFLUENCE_PT.md
    └── E2E_TESTING.md
```

## 🤖 AI Workflows

This project includes agent workflows for automated test creation:

| Command         | Description                       |
| --------------- | --------------------------------- |
| `/maestro-test` | Create new E2E tests for a module |
| `/maestro-run`  | Run existing E2E tests            |

## 🔗 Resources

- [Maestro Documentation](https://docs.maestro.dev/)
- [Flutter Integration](https://docs.maestro.dev/platform-support/flutter)
- [Maestro Cloud](https://maestro.dev/cloud)
