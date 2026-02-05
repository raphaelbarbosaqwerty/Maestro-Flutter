---
description: Run existing E2E tests with Maestro
---

# Run Maestro Tests

## Run all tests

// turbo

```bash
cd ./maestro_dev && maestro test e2e/maestro_dev/
```

## Run specific test

Ask the user which file to run, then execute:

// turbo

```bash
cd ./maestro_dev && maestro test e2e/maestro_dev/{file}.yaml
```

## Open Maestro Studio (debugging)

// turbo

```bash
maestro studio
```
