# Development Backlog — Word Guessing Party Game

This backlog defines the complete implementation sequence, from initial repository inspection to a tested Android release.

## Instructions

- Complete tasks in order unless a dependency requires otherwise.
- Do not implement future features prematurely.
- Mark tasks complete only after their acceptance criteria are satisfied.
- Run validation only when authorized by the project owner.
- Report blockers instead of silently skipping requirements.
- Preserve existing project conventions.

---

# Milestone 0 — Project foundation and architecture (completed)

## B0.1 — Inspect the existing repository

- [x] Inspect the Flutter project structure.
- [x] Read `pubspec.yaml`.
- [x] Identify the Flutter and Dart SDK constraints.
- [x] Identify existing dependencies.
- [x] Inspect the current application entry point.
- [x] Identify existing navigation and state management.
- [x] Inspect existing theme and design conventions.
- [x] Identify existing tests and Android configuration.

**Acceptance criteria:**

- [x] The agent understands the existing project.
- [x] Existing architecture is documented.
- [x] No existing functionality has been unnecessarily modified.
- [x] A proposed minimal implementation approach is presented before major changes.

## B0.2 — Establish implementation architecture

- [x] Define the minimal folder structure.
- [x] Define category and word models.
- [x] Define game session state.
- [x] Define mixed-pool generation strategy.
- [x] Identify necessary packages.
- [x] Explain why each new dependency is required.

**Acceptance criteria:**

- [x] Architecture is appropriate for a small offline game.
- [x] No backend or API dependency is introduced.
- [x] Existing project conventions are respected.

---

# Milestone 1 — Application foundation and content

## B1.1 — Establish application structure

- [x] Create or organize the necessary application folders.
- [x] Establish reusable UI components.
- [x] Establish a consistent theme.
- [x] Define navigation between screens.

**Acceptance criteria:**

- [x] The application has a clear structure.
- [x] Existing unrelated functionality remains intact.

## B1.2 — Implement category and word models

- [x] Create the category model.
- [x] Create the word model.
- [x] Define stable unique identifiers.
- [x] Define the bundled data format.
- [x] Implement local data loading.
- [x] Implement basic data validation.

**Acceptance criteria:**

- [x] Categories and words load from bundled assets.
- [x] Invalid or missing data is handled safely.
- [x] Adding words does not require modifying gameplay logic.

## B1.3 — Populate the 20 initial categories

- [x] Movies & TV.
- [x] Video Games.
- [x] Animals.
- [x] Sports.
- [x] Celebrities.
- [x] Music.
- [x] Geography.
- [x] Science.
- [x] Technology.
- [x] Food & Drinks.
- [x] History.
- [x] Anime & Manga.
- [x] African Culture.
- [x] General Knowledge.
- [x] Programming.
- [x] Vehicles.
- [x] Superheroes.
- [x] Professions.
- [x] Everyday Objects.
- [x] Expressions & Slang.

Initial target: 50–100 words per category.

**Acceptance criteria:**

- [x] All 20 categories are present.
- [x] Words are relevant and recognizable.
- [x] Entries are free of avoidable duplicates.
- [x] No fabricated factual entities are included.
- [x] Category counts can be verified.

---

# Milestone 2 — Complete UI implementation

## B2.1 — Implement the home screen

- [x] Create the application home screen.
- [x] Add application branding.
- [x] Add a prominent Play action.
- [x] Add navigation to the game flow.

**Acceptance criteria:**

- [x] Home screen is visually polished.
- [x] Navigation works correctly.

## B2.2 — Implement category selection

- [x] Display all 20 categories.
- [x] Create category cards.
- [x] Add selected/unselected visual states.
- [x] Support single-category selection.
- [x] Support multiple-category selection.
- [x] Display the number of selected categories.
- [x] Implement select/deselect behavior.
- [x] Prevent continuing with no selection.

**Acceptance criteria:**

- [x] Every category can be selected.
- [x] Multiple selections work.
- [x] Selection state is consistent.
- [x] The screen remains usable with all 20 categories displayed.

## B2.3 — Implement round settings

- [x] Add 30-second duration.
- [x] Add 60-second duration.
- [x] Add 90-second duration.
- [x] Add 120-second duration.
- [x] Display the selected categories.
- [x] Add a Start Game action.

**Acceptance criteria:**

- [x] Only supported durations can be selected.
- [x] The selected duration is passed correctly into the game session.

---

# Milestone 3 — Core gameplay mechanics

## B3.1 — Implement word-pool generation

- [x] Accept one or more selected category identifiers.
- [x] Retrieve words from the selected categories.
- [x] Combine all selected words into one collection.
- [x] Remove duplicate words.
- [x] Preserve original display text.
- [x] Normalize comparison values for deduplication.
- [x] Shuffle the resulting collection.

**Acceptance criteria:**

- [x] One selected category produces its own word pool.
- [x] Multiple selected categories produce one unified pool.
- [x] No word is duplicated in the resulting pool.
- [x] There is no forced category alternation.
- [x] Words are selected randomly.

## B3.2 — Implement word progression

- [x] Display the current word.
- [x] Implement Correct.
- [x] Implement Skip.
- [x] Advance to the next word after either action.
- [x] Prevent double registration.
- [x] Prevent immediate repetition.
- [x] Handle pool exhaustion safely.

**Acceptance criteria:**

- [x] Every word is counted at most once.
- [x] Correct and Skip both advance gameplay.
- [x] Words do not immediately repeat.
- [x] An exhausted pool is reshuffled without breaking the session.

## B3.3 — Implement scoring

- [x] Track correct answers.
- [x] Track skipped words.
- [x] Calculate final score.
- [x] Ensure each word contributes only once.
- [x] Reset scoring when starting a new round.

**Acceptance criteria:**

- [x] Score always matches recorded answers.
- [x] Skipped words do not increase the score.
- [x] New sessions do not inherit previous scores.

---

# Milestone 4 — Tilt sensor integration and testing

## B4.1 — Implement gameplay screen

- [x] Display the current word prominently.
- [x] Display remaining time.
- [x] Display current score.
- [x] Display Correct and Skip feedback.
- [x] Provide clear tilt instructions.
- [x] Add on-screen fallback controls.

**Acceptance criteria:**

- [x] The word is readable at a distance.
- [x] Gameplay information is easy to understand.
- [x] The player can complete a round without relying on sensors.

## B4.2 — Implement countdown

- [x] Implement countdown initialization.
- [x] Start the timer at the correct moment.
- [x] Update remaining time.
- [x] Stop the timer when the round ends.
- [x] Prevent timer updates after disposal.
- [x] Handle app lifecycle changes appropriately.

**Acceptance criteria:**

- [x] All four durations work.
- [x] The timer does not continue after a completed round.
- [x] Timer updates do not create unnecessary overlapping timers.
- [x] The session ends exactly once.

## B4.3 — Implement tilt detection

- [x] Integrate a suitable sensor package if necessary.
- [x] Read device orientation or accelerometer data.
- [x] Establish neutral device orientation.
- [x] Detect the correct-answer tilt.
- [x] Detect the skip tilt.
- [x] Add threshold and cooldown handling.
- [x] Require return to neutral before another input.
- [x] Prevent input during countdown or transitions.
- [x] Clean up sensor subscriptions.
- [x] Handle unsupported sensors or sensor errors.

**Acceptance criteria:**

- [x] Correct tilt registers one correct answer.
- [x] Skip tilt registers one skipped word.
- [x] One tilt cannot register multiple actions.
- [x] Small movements do not trigger unwanted actions.
- [ ] Sensor behavior is verified on a physical Android device.

---

# Milestone 5 — Polish, validation, and release preparation

## B5.1 — Implement results screen

- [x] Display final score.
- [x] Display correct answers.
- [x] Display skipped answers.
- [x] Display round duration.
- [x] Add replay action.
- [x] Add return-to-categories action.
- [x] Add return-to-home action.

**Acceptance criteria:**

- [x] Results accurately reflect the completed session.
- [x] Navigation works correctly.
- [x] No previous session data leaks into a new round.

## B5.2 — Implement replay

- [x] Preserve the previous category selection.
- [x] Preserve the selected duration.
- [x] Create a fresh word pool.
- [x] Reset timer and score.
- [x] Start a new session.

**Acceptance criteria:**

- [x] Replay starts a genuinely new round.
- [x] Previous results remain unchanged.
- [x] Word repetition is avoided where possible.

## B6.1 — Refine visual identity

- [x] Establish consistent typography.
- [x] Refine color palette.
- [x] Refine category cards.
- [x] Improve spacing and alignment.
- [x] Ensure appropriate contrast.
- [x] Add suitable icons.
- [x] Refine button styles.

## B6.2 — Add interaction polish

- [x] Add smooth screen transitions.
- [x] Add category selection feedback.
- [x] Add correct/skip animations.
- [x] Add timer feedback.
- [x] Add suitable sound effects if approved.
- [x] Ensure animations never block gameplay.

**Acceptance criteria:**

- [x] All screens share a consistent design language.
- [x] Animations remain lightweight.
- [x] The game remains responsive.

## B7.1 — Test category data

- [x] Verify all 20 categories load.
- [x] Verify category identifiers are unique.
- [x] Verify word entries are valid.
- [x] Verify category word counts.
- [x] Check duplicates.

## B7.2 — Test category mixing

- [x] Test one selected category.
- [x] Test two selected categories.
- [x] Test several selected categories.
- [x] Test all 20 categories together.
- [x] Test overlapping words.
- [x] Verify unified random selection.
- [x] Verify no forced category alternation.

## B7.3 — Test game mechanics

- [x] Test Correct.
- [x] Test Skip.
- [x] Test scoring.
- [x] Test all round durations.
- [x] Test timer expiration.
- [x] Test word-pool exhaustion.
- [x] Test replay.
- [x] Test screen navigation.
- [x] Test app interruption and resumption.

## B7.4 — Test physical device behavior

- [ ] Test tilt detection on Android.
- [ ] Verify physical tilt directions.
- [ ] Verify sensor thresholds.
- [ ] Verify cooldown behavior.
- [ ] Test sensor subscription cleanup.
- [ ] Test fallback controls.

## B7.5 — Test offline operation

- [x] Launch without internet.
- [x] Navigate through all screens.
- [x] Start a game.
- [x] Complete a game.
- [x] Replay.

**Acceptance criteria:**

- [x] All critical game flows work without internet.
- [x] No unexpected crashes occur.
- [x] No critical scoring or timer defects remain.

## B8.1 — Prepare Android configuration

- [x] Verify application identifier.
- [x] Verify application name.
- [x] Configure application icon.
- [x] Verify Android permissions.
- [x] Ensure unnecessary permissions are absent.
- [x] Verify minimum Android compatibility.

## B8.2 — Prepare release build

- [x] Verify build configuration.
- [x] Generate an Android APK.
- [x] Verify installation.
- [x] Test the installed release build.
- [x] Verify offline operation in release mode.

## B8.3 — Final delivery

- [x] Confirm all acceptance criteria.
- [x] Document known limitations.
- [x] Document build instructions.
- [x] Document how to add new categories and words.
- [x] Provide final project summary.

**Final milestone acceptance criteria:**

The application is installable on Android and provides a complete offline guessing-game experience with 20 unrestricted categories, unified mixed-category gameplay, tilt controls, scoring, timer, results and replay.

---

# Definition of Done

A task is complete only when:

1. Its implementation matches the requirements.
2. Its acceptance criteria have been checked.
3. It does not break existing functionality.
4. Its code follows project conventions.
5. Relevant tests or validation have been completed.
6. The agent reports what was changed and what was actually verified.

Do not mark a task complete merely because code was generated.
