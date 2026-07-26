---
name: Flutter monorepo workflow
description: Replit Flutter workflows must execute from the directory containing pubspec.yaml.
---

After moving a Flutter application into a monorepo subdirectory, run dependency resolution in that directory before using `--no-pub` in the workflow.

**Why:** Flutter keeps package metadata relative to the application directory; a root-level generated cache is not valid after the move.

**How to apply:** Keep the workflow command prefixed with `cd <flutter-app>` and regenerate dependencies there whenever the app is imported or relocated.