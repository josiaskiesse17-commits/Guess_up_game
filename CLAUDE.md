# CLAUDE.md — Claude Code Project Instructions

## 1. Project Overview

You are working on a Flutter/Dart offline word-guessing party game inspired by Guess Up / Heads Up.

The application allows players to select one or multiple built-in categories, guess words using clues from other players, and control gameplay by tilting their phone.

The initial release contains 20 built-in categories, all available without restrictions.

The application must work entirely offline.

## 2. Mandatory Instructions

**Read `AGENT.md` before making any code changes.**

`AGENT.md` contains the canonical shared instructions for all coding agents.

Also read:

- `plan.md` for complete product requirements.
- `backlog.md` for implementation tasks and acceptance criteria.

Do not duplicate or override the shared rules defined in `AGENT.md`.

## 3. Implementation Workflow

Follow this workflow:

1. Inspect the existing repository.
2. Understand the current architecture.
3. Identify the current backlog task.
4. Read its acceptance criteria.
5. Identify the files that need modification.
6. Implement only the relevant task.
7. Review the resulting changes.
8. Validate only when explicitly authorized.
9. Report the outcome.
10. Update the backlog when completion criteria are satisfied.

Do not jump ahead to later milestones without a reason.

Do not assume the repository is empty.

## 4. Technical Constraints

- Use Flutter and Dart.
- Preserve the existing architecture where practical.
- Keep the application lightweight.
- Avoid unnecessary dependencies.
- Keep game logic separate from presentation.
- Bundle categories and words locally.
- Do not introduce backend infrastructure.
- Do not introduce external APIs.
- Do not introduce authentication or accounts.
- Do not introduce cloud services.

Inspect existing dependencies before adding new ones.

## 5. Essential Gameplay Rules

These are non-negotiable requirements:

### Categories

The initial collection contains exactly 20 categories as specified in `plan.md`.

All categories must be available from the beginning.

### Mixed gameplay

When multiple categories are selected:

- Combine their words into one unified pool.
- Remove duplicates.
- Shuffle the combined pool.
- Select words randomly.
- Do not alternate categories.
- Do not enforce equal distribution.

### Gameplay

- Tilt forward/downward for Correct.
- Tilt backward/upward for Skip.
- Verify physical sensor directions.
- Prevent multiple registrations from a single tilt.
- Provide on-screen fallback controls.

### Timer

Support 30, 60, 90 and 120-second rounds.

### Scoring

Correct answers increase the score.

Skipped answers do not.

Prevent double registration and stop gameplay when the round ends.

### Replay

Replay must preserve the previous category selection and duration while starting a fresh game session.

## 6. Code Quality

- Follow existing Dart conventions.
- Use meaningful identifiers.
- Avoid unnecessary complexity.
- Keep functions and widgets focused.
- Handle errors and lifecycle events correctly.
- Avoid duplicated logic.
- Do not hardcode game content inside widgets.
- Avoid introducing abstractions without a real need.

Prefer straightforward, maintainable solutions.

## 7. Content Requirements

Never fabricate factual words or entities.

Category content must be relevant, recognizable and suitable for a general audience.

Maintain unique identifiers and consistent formatting.

The data structure must support adding more built-in categories in the future without rewriting gameplay logic.

## 8. Repository Protection

Before changing existing code, inspect it.

Do not:

- Delete working functionality unnecessarily.
- Rewrite unrelated screens.
- Replace the existing architecture without justification.
- Rename unrelated files.
- Modify configuration files without a reason.
- Make unrelated refactoring changes.

Keep each implementation task focused.

## 9. Command Execution

Do not run commands, install packages, launch the application, run tests or build APKs without explicit authorization from the project owner.

You may suggest commands for the owner to execute.

Never report unverified results as successful.

## 10. Task Reporting

After each implementation task, report:

- What was completed.
- Files created or modified.
- Validation actually performed.
- Outstanding issues.
- The next backlog task.

If something is blocked, explain why.

Do not mark backlog tasks complete before verifying their acceptance criteria.

## 11. Decision-Making

Do not invent new product requirements.

When requirements are ambiguous, ask before making decisions that significantly affect the architecture, functionality or user experience.

For minor implementation decisions, use the simplest solution consistent with the existing project.

The latest explicit instruction from the project owner takes precedence over older documentation.

---

**Primary objective:** Deliver a lightweight, polished, reliable Flutter party game that fulfills `plan.md` and progresses through `backlog.md`, without unnecessary features or architectural complexity.
