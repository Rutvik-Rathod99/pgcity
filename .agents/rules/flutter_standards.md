# Flutter Project Standards & Automated Workflow Rules

## Mandatory Quality Checks on Every Change
For all Flutter project tasks, always execute and adhere to the following workflow automatically without requiring user reminders:

1. **Code Formatting (`dart format .`)**:
   - Always run `dart format .` across the entire codebase before concluding a task or committing changes.
   - Maintain zero syntax or formatting regressions.

2. **Static Code Analysis (`flutter analyze`)**:
   - Always run `flutter analyze` and ensure **0 issues found** (0 errors, 0 warnings, 0 lints).
   - Clean up any unused imports, dead code, or unreferenced elements immediately.

3. **Documentation Integrity (`README.md`)**:
   - Always keep `README.md` synchronized and updated with any new features, screens, UI refinements, themes, font options, or architectural changes made.
   - Ensure README badges, directory structures, and feature matrices accurately reflect the codebase.

4. **Automated Testing (`flutter test`)**:
   - Always run `flutter test` and verify that all unit/state test suites pass (100% pass rate).
