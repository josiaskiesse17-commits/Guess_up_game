# AGENT.md — Shared Coding Agent Instructions

This document defines the general working rules for any AI coding agent working on this repository.

It applies to Claude Code, Codex and other coding agents.

The project requirements are defined in `plan.md`, and the implementation sequence is defined in `backlog.md`.

---

## 1. Project Context

This repository contains a Flutter/Dart offline word-guessing party game.

The application has:

- 20 built-in categories.
- Single-category gameplay.
- Multiple-category selection.
- Unified random word pools for mixed selections.
- Tilt-based Correct and Skip controls.
- On-screen fallback controls.
- Configurable round durations.
- Scoring and results.
- Replay functionality.

The application requires no backend, authentication, external API or cloud infrastructure.

Read `plan.md` before implementing project features.

Read `backlog.md` to understand implementation order and acceptance criteria.

---

## 2. Mandatory Initial Inspection

Before modifying anything:

1. Inspect the repository structure.
2. Read `pubspec.yaml`.
3. Inspect the existing application entry point.
4. Inspect existing navigation.
5. Inspect existing state management.
6. Inspect existing theme and reusable widgets.
7. Inspect relevant existing tests.
8. Identify the files that actually need modification.

Do not assume the project is empty.

Do not replace an existing architecture simply because another architecture is preferred.

If important project information is missing, ask the owner before making assumptions that could affect the implementation.

---

## 3. Working Method

Work incrementally.

- Follow the backlog in order.
- Complete one logical task at a time.
- Keep changes focused.
- Prefer simple implementations.
- Avoid unnecessary abstractions.
- Avoid introducing unnecessary dependencies.
- Preserve working functionality.
- Avoid unrelated refactoring.

Do not implement multiple unrelated milestones in one large change.

After each logical task:

1. Review the modified files.
2. Check for obvious errors.
3. Validate the implementation when authorized.
4. Report the outcome.
5. Update the relevant backlog checkboxes only when the task is genuinely complete.

If a task is blocked, explain the blocker instead of silently skipping it.

---

## 4. Project Scope Protection

The initial application must remain:

- Offline-first.
- Free to use.
- Independent of a backend.
- Independent of external APIs.
- Independent of user accounts.
- Independent of subscriptions.

Do not introduce:

- Firebase.
- Supabase.
- Cloud databases.
- Authentication.
- Online multiplayer.
- AI services.
- Advertising SDKs.
- Subscription systems.
- Analytics services.

Do not implement user-created categories or custom word entry in the initial release.

These are outside the current scope unless the owner explicitly changes the requirements.

---

## 5. Technical Guidelines

### Flutter and Dart

- Follow existing Flutter and Dart conventions.
- Use sound null safety.
- Keep widgets focused.
- Separate UI from game logic.
- Avoid excessively large files.
- Avoid duplicated logic.
- Use meaningful names.
- Handle errors explicitly.
- Avoid unnecessary global state.

### Dependencies

Before adding a dependency:

1. Check whether the functionality already exists in the project.
2. Check whether Flutter's built-in capabilities are sufficient.
3. Evaluate whether the package is necessary.
4. Explain why it is being introduced.

Do not add packages merely for convenience when a simple native implementation is sufficient.

### State management and navigation

Preserve the project's existing state management and navigation conventions.

Do not introduce Riverpod, Bloc, Provider, GetX, GoRouter or another framework without first inspecting what already exists and establishing a genuine need.

### Data management

Built-in categories and words must be bundled locally.

The content structure must be easy to extend.

Keep data separate from presentation.

Avoid hardcoding category word collections inside UI widgets.

Use stable identifiers.

---

## 6. Game Logic Rules

These rules must be preserved throughout implementation.

### Category selection

- A player can select one category.
- A player can select multiple categories.
- At least one category is required to start a game.

### Mixed categories

Multiple selected categories must form one unified random word pool.

Do not alternate categories.

Do not enforce equal distribution.

Do not implement category-by-category rounds.

### Deduplication

Remove duplicate words from mixed pools.

Comparison must use a documented normalization strategy.

Preserve the original display text.

### Randomization

- Shuffle the pool.
- Avoid immediate repetition.
- Avoid unnecessary repetition until the pool is exhausted.
- Handle exhausted pools safely.

### Scoring

- Correct increases the score.
- Skip does not increase the score.
- A word cannot be registered twice.
- A completed session must not continue accepting gameplay input.

### Sensors

- Prevent accidental multiple registrations.
- Use thresholds and neutral-position handling.
- Manage subscriptions correctly.
- Stop listening when gameplay no longer requires sensors.
- Keep on-screen fallback controls functional.

### Timer

- Support 30, 60, 90 and 120 seconds.
- Stop at the end of the round.
- Prevent duplicate timer instances.
- Avoid updates after disposal.

---

## 7. UI and Design Standards

The application should look and feel like a polished mobile game.

Prioritize:

- Modern visual design.
- Good typography.
- Comfortable spacing.
- Consistent colors.
- Clear interactions.
- Strong contrast.
- Smooth transitions.
- Large, readable gameplay words.

Avoid:

- Generic dashboard design.
- Overcrowded layouts.
- Unnecessary complexity.
- Inconsistent components.
- Excessive animations.
- Small gameplay text.

Do not redesign unrelated screens or existing components without explicit authorization.

---

## 8. Content Quality

Never fabricate factual content to fill category word counts.

Do not invent:

- Celebrities.
- Movies.
- Games.
- Historical events.
- Scientific concepts.
- Geographic locations.

Prefer a smaller accurate collection over a larger collection containing questionable entries.

Check category relevance and duplicate entries.

Use consistent spelling and display formatting.

---

## 9. File Modification Rules

Before modifying a file:

- Read its current contents.
- Understand its responsibilities.
- Identify dependencies and references.

When modifying existing files:

- Preserve unrelated functionality.
- Avoid unnecessary formatting changes.
- Avoid deleting existing working code.
- Avoid renaming files without a clear reason.

When asked to provide corrected files, provide complete corrected file contents rather than isolated fragments.

Do not create duplicate files when an existing file should be updated.

---

## 10. Execution and Validation Permissions

**Do not execute commands or launch the application unless the owner explicitly authorizes it.**

This includes:

- Running Flutter commands.
- Running Dart commands.
- Installing dependencies.
- Running tests.
- Building APKs.
- Launching emulators.
- Launching the application.
- Modifying the environment.

You may inspect repository files and propose commands, but do not execute them without permission.

When validation has not been performed, state that clearly.

Never claim that:

- Tests passed when they were not run.
- An APK was successfully built when it was not.
- A feature works on a physical device when it has not been tested there.

---

## 11. Communication and Reporting

At the end of each task, report:

### Completed

What was implemented.

### Files changed

List the exact files created, modified or deleted.

### Validation

Describe checks actually performed and their results.

### Remaining work

Identify incomplete requirements, blockers or known issues.

### Next task

Identify the next logical backlog item.

Keep reports concise but sufficiently detailed.

Ask the owner when:

- Requirements conflict.
- An important design decision is ambiguous.
- A requested change would alter the project scope.
- Existing functionality could be affected.
- A dependency or architectural change is necessary.

Do not make significant product decisions on behalf of the owner.

---

## 12. Source of Truth

Use the following document hierarchy:

1. `plan.md` — product requirements and scope.
2. `backlog.md` — implementation order and completion criteria.
3. `AGENT.md` — shared working rules.
4. `CLAUDE.md` — Claude Code-specific instructions.

If instructions conflict, do not silently choose an interpretation. Explain the conflict and ask the owner when necessary.

The owner's latest explicit instruction takes precedence over outdated project documentation.

---

## Final Principle

Build the requested game, not a larger product than necessary.

Favor correctness, simplicity, maintainability and a polished player experience over unnecessary technical sophistication.
