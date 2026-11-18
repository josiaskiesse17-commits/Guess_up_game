# Project Plan — Offline Word Guessing Party Game

## 1. Project Overview

Build a lightweight, polished, offline-first mobile word-guessing party game using **Flutter and Dart**.

The game is inspired by the core gameplay of Guess Up / Heads Up: one player holds a phone against their forehead while other players provide clues to help them guess the word displayed on the screen.

The application will provide a substantial collection of built-in categories, unrestricted access to all categories, and the ability to combine multiple categories into a single game.

The primary objective is to offer a complete, enjoyable alternative without subscriptions, locked categories, advertisements being required for access, or dependence on online services.

### Product principles

- Simple to understand and quick to play.
- Visually attractive, modern and polished.
- Lightweight and responsive.
- Fully playable offline.
- All built-in categories available from the beginning.
- Easy to expand with additional words and categories.
- No unnecessary technical complexity.

---

## 2. Project Scope

### Platform

- Primary target: Android.
- Framework: Flutter.
- Programming language: Dart.
- Future possibility: iOS.

### Application characteristics

The initial application must:
- Work without an internet connection.
- Require no account or authentication.
- Require no backend.
- Require no external API.
- Require no cloud database.
- Store only the local information necessary for the game.

All initial categories and words will be bundled with the application.

---

## 3. Core Gameplay

### 3.1 Game concept

1. The player opens the application.
2. The player selects one category or multiple categories.
3. The player chooses a round duration.
4. The game begins with a countdown.
5. A word appears on the screen.
6. Other players provide clues without saying the displayed word.
7. The player tilts the phone to indicate the result.
8. The game displays the next word.
9. When the timer expires, the round ends.
10. The results screen displays the player's performance.

### 3.2 Tilt controls

The phone's orientation sensor will control the gameplay.

- **Tilt forward / downward:** Correct answer.
- **Tilt backward / upward:** Skip the current word.

The exact physical direction must be verified on the target Android device. The implementation must use a consistent and understandable orientation convention.

Important requirements:
- Detect deliberate tilts rather than small accidental movements.
- Avoid registering multiple answers from one physical movement.
- Require the phone to return to a neutral position before accepting another tilt.
- Prevent accidental inputs during countdowns and screen transitions.
- Provide visual and audio feedback when an action is registered.

The game must also provide accessible on-screen Correct and Skip controls as a fallback.

### 3.3 Round durations

The initial supported durations are:

- 30 seconds.
- 60 seconds.
- 90 seconds.
- 120 seconds.

The selected duration applies to the entire round.

### 3.4 Scoring

- Correct answers increase the score.
- Skipped words do not increase the score.
- Each displayed word must be counted at most once.
- The results screen must show:
  - Total correct answers.
  - Total skipped words.
  - Final score.
  - Round duration.

### 3.5 Word repetition

- Words should be randomized.
- A word should not immediately reappear.
- A mixed selection must not introduce duplicate copies of the same word.
- The game should avoid repetition for as long as possible within the available word pool.
- If the pool is exhausted, it may be reshuffled and reused.

---

## 4. Category System

The first release will contain exactly 20 initial categories.

All categories must be accessible without payment or unlocking.

| # | Category | Content |
|---|---|---|
| 1 | Movies & TV | Films, television series and characters |
| 2 | Video Games | Games, characters and gaming terminology |
| 3 | Animals | Mammals, birds, reptiles and other animals |
| 4 | Sports | Sports, athletes, teams and terminology |
| 5 | Celebrities | Famous personalities and public figures |
| 6 | Music | Artists, instruments, songs and genres |
| 7 | Geography | Countries, cities, landmarks and places |
| 8 | Science | Physics, chemistry, biology and scientific concepts |
| 9 | Technology | Computers, devices, software and technology |
| 10 | Food & Drinks | Dishes, ingredients, fruits and beverages |
| 11 | History | Historical figures, events and civilizations |
| 12 | Anime & Manga | Anime, manga and their characters |
| 13 | African Culture | African personalities, traditions, places and cultural references |
| 14 | General Knowledge | Common knowledge and everyday facts |
| 15 | Programming | Programming languages, concepts and terminology |
| 16 | Vehicles | Cars, motorcycles, aircraft and other vehicles |
| 17 | Superheroes | Superheroes, villains and fictional universes |
| 18 | Professions | Jobs, occupations and professional roles |
| 19 | Everyday Objects | Common objects and household items |
| 20 | Expressions & Slang | Idioms, expressions and slang |

### Content requirements

Each category should initially target approximately 50–100 words.

The initial content target is approximately 1,000–2,000 words across the 20 categories.

Quality is more important than reaching a numerical target with poor content.

Words must:
- Be recognizable and suitable for a guessing game.
- Be appropriate for a general audience.
- Be relevant to their assigned category.
- Avoid unnecessary duplicates.
- Use consistent spelling.
- Avoid fabricated people, films, games or other factual entities.

For categories containing public figures and cultural references, prioritize accuracy and recognizable names.

---

## 5. Category Selection and Mixing

The application must support two selection modes.

### 5.1 Single-category mode

Players select one category.

Only words belonging to that category are used.

### 5.2 Mixed-category mode

Players can select any combination of the available categories.

Example:

- Movies & TV
- Sports
- Video Games
- Anime & Manga

The selected categories are combined into one **unified random word pool**.

This means:
- Every eligible word from every selected category enters the same pool.
- Words are selected randomly from that combined pool.
- The game does not alternate between categories.
- The game does not enforce equal category distribution.
- Any selected category may appear several times consecutively.
- There is no need to finish one category before another.

### 5.3 Deduplication

When building the combined pool, duplicate entries must be removed.

The same word must not appear multiple times simply because it exists in more than one selected category.

Use a stable, documented normalization strategy for duplicate detection while preserving the original display text.

### 5.4 Selection interface

The category selection screen should:
- Display all 20 categories.
- Provide clear visual identification for each category.
- Allow multiple selections.
- Clearly indicate selected categories.
- Show the number of selected categories.
- Provide a clear way to select or deselect categories.
- Prevent starting a game without at least one selected category.

The interface must make it obvious that multiple selections create a mixed game.

---

## 6. Application Screens

### 6.1 Home screen

The home screen should provide:
- Application identity and branding.
- A prominent Play button.
- A visually attractive introduction to the game.
- Access to basic game settings, if needed.

### 6.2 Category selection screen

Contains:
- All 20 categories.
- Single and multiple category selection.
- Selection indicators.
- A selected-category counter.
- A Continue button.

### 6.3 Game settings screen

Allows players to choose:
- Round duration: 30, 60, 90 or 120 seconds.
- Selected categories, displayed for confirmation.

Avoid unnecessary settings in the initial release.

### 6.4 Gameplay screen

Displays:
- Current word prominently.
- Countdown timer.
- Current score.
- Correct and Skip feedback.
- Tilt-control instructions.

The screen should be optimized for a phone held against the player's forehead.

Text must be large and readable.

### 6.5 Results screen

Displays:
- Final score.
- Correct answers.
- Skipped words.
- Round duration.

Actions:
- Play again with the same selection.
- Return to category selection.
- Return to home.

### 6.6 Optional pause handling

If pausing is supported, it must stop both the timer and gameplay input. Do not introduce pause complexity unless it is reliable and useful.

---

## 7. Technical Direction

### Framework

Flutter and Dart.

### Architecture

Keep the initial architecture lightweight and maintainable.

The code should separate:
- Presentation and UI.
- Game logic.
- Category and word data.
- Sensor input handling.
- Round timing and scoring.

Do not introduce complex architecture for a small offline game.

### State management and navigation

Inspect the existing project before choosing or changing packages.

If the repository already uses Riverpod, GoRouter or another established solution, preserve its conventions unless there is a clear reason to change them.

Do not add dependencies merely because they are popular.

### Sensor handling

Use a maintained Flutter sensor package, such as `sensors_plus`, if the existing project does not already provide a suitable solution.

Handle sensor subscription lifecycle correctly:
- Start listening when gameplay requires it.
- Stop listening when gameplay ends or the screen is disposed.
- Avoid duplicate subscriptions.
- Handle unsupported sensors and runtime failures gracefully.

### Local data

Use bundled local data for the built-in categories and words.

A structured JSON-based data model is sufficient initially.

The data structure should make it straightforward to add categories and words without changing gameplay code.

A word entry should have a stable unique identifier and display text.

A category should have:
- Unique identifier.
- Name.
- Description, if needed.
- Icon identifier or presentation metadata.
- Word collection.

The combined word pool should be generated dynamically from selected categories.

### Offline operation

No internet access should be required for:
- Opening the game.
- Selecting categories.
- Playing rounds.
- Scoring.
- Viewing results.
- Replaying.

---

## 8. UI and Design Requirements

The application should look like a real, polished mobile game rather than a basic utility application.

Design priorities:
- Modern and attractive visual identity.
- Clear visual hierarchy.
- Comfortable spacing.
- Strong typography.
- Readable word presentation.
- Attractive category cards.
- Smooth but restrained animations.
- Consistent colors and components.
- Good contrast and accessibility.

Avoid:
- Generic administrative dashboard layouts.
- Excessively crowded screens.
- Unnecessary decorative elements.
- Small gameplay text.
- Inconsistent styling between screens.
- Excessive animations that interfere with gameplay.

The gameplay screen deserves particular attention because it is the central experience.

---

## 9. Functional Requirements

The initial release is considered functionally complete when:

1. All 20 categories are available.
2. Every category can be selected individually.
3. Multiple categories can be selected together.
4. Mixed selections create one unified random pool.
5. Duplicate words are removed from mixed pools.
6. Words are randomized.
7. Immediate word repetition is prevented.
8. The player can select all four round durations.
9. The timer works correctly.
10. Correct and Skip actions work through tilt detection.
11. On-screen fallback controls work.
12. Scoring is accurate.
13. Results are displayed correctly.
14. Players can replay.
15. The application works offline.

---

## 10. Out of Scope — Initial Release

The following features are explicitly excluded:

- Backend infrastructure.
- User accounts.
- Authentication.
- Cloud synchronization.
- Online multiplayer.
- Online leaderboards.
- AI-generated words.
- External APIs.
- User-created categories.
- User-created words.
- Importing or sharing category packs.
- Subscription systems.
- Paid category unlocking.
- Advertising integration.
- Complex analytics.

These features must not be introduced without explicit approval.

---

## 11. Development Priorities

Implementation should follow this order:

1. Inspect the existing Flutter project.
2. Establish the existing architecture and conventions.
3. Define the category and word data structure.
4. Implement category selection.
5. Implement mixed-category pool generation.
6. Implement core gameplay.
7. Implement tilt detection and fallback controls.
8. Implement timing and scoring.
9. Implement results and replay.
10. Refine UI and animations.
11. Test the application.
12. Prepare the Android release build.

The application should remain small, reliable and easy to maintain.

**Final product objective:** a polished, fully offline word-guessing party game with 20 unrestricted built-in categories and flexible mixed-category gameplay.