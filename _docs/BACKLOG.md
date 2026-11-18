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

# Milestone 0 — Project Inspection

## B0.1 — Inspect the existing repository

- [ ] Inspect the Flutter project structure.
- [ ] Read `pubspec.yaml`.
- [ ] Identify the Flutter and Dart SDK constraints.
- [ ] Identify existing dependencies.
- [ ] Inspect the current application entry point.
- [ ] Identify existing navigation and state management.
- [ ] Inspect existing theme and design conventions.
- [ ] Identify existing tests and Android configuration.

**Acceptance criteria:**

- The agent understands the existing project.
- Existing architecture is documented.
- No existing functionality has been unnecessarily modified.
- A proposed minimal implementation approach is presented before major changes.

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

# Milestone 1 — Foundation and Data

## B1.1 — Establish application structure

- [x] Create or organize the necessary application folders.
- [x] Establish reusable UI components.
- [x] Establish a consistent theme.
- [x] Define navigation between screens.

**Acceptance criteria:**

- [x] The application has a clear structure.
- [x] Existing unrelated functionality remains intact.

## B1.2 — Implement category and word models

- [ ] Create the category model.
- [ ] Create the word model.
- [ ] Define stable unique identifiers.
- [ ] Define the bundled data format.
- [ ] Implement local data loading.
- [ ] Implement basic data validation.

**Acceptance criteria:**

- Categories and words load from bundled assets.
- Invalid or missing data is handled safely.
- Adding words does not require modifying gameplay logic.

## B1.3 — Populate the 20 initial categories

- [ ] Movies & TV.
- [ ] Video Games.
- [ ] Animals.
- [ ] Sports.
- [ ] Celebrities.
- [ ] Music.
- [ ] Geography.
- [ ] Science.
- [ ] Technology.
- [ ] Food & Drinks.
- [ ] History.
- [ ] Anime & Manga.
- [ ] African Culture.
- [ ] General Knowledge.
- [ ] Programming.
- [ ] Vehicles.
- [ ] Superheroes.
- [ ] Professions.
- [ ] Everyday Objects.
- [ ] Expressions & Slang.

Initial target: 50–100 words per category.

**Acceptance criteria:**

- All 20 categories are present.
- Words are relevant and recognizable.
- Entries are free of avoidable duplicates.
- No fabricated factual entities are included.
- Category counts can be verified.

---

# Milestone 2 — Application UI

## B2.1 — Implement the home screen

- [ ] Create the application home screen.
- [ ] Add application branding.
- [ ] Add a prominent Play action.
- [ ] Add navigation to the game flow.

**Acceptance criteria:**

- Home screen is visually polished.
- Navigation works correctly.

## B2.2 — Implement category selection

- [ ] Display all 20 categories.
- [ ] Create category cards.
- [ ] Add selected/unselected visual states.
- [ ] Support single-category selection.
- [ ] Support multiple-category selection.
- [ ] Display the number of selected categories.
- [ ] Implement select/deselect behavior.
- [ ] Prevent continuing with no selection.

**Acceptance criteria:**

- Every category can be selected.
- Multiple selections work.
- Selection state is consistent.
- The screen remains usable with all 20 categories displayed.

## B2.3 — Implement round settings

- [ ] Add 30-second duration.
- [ ] Add 60-second duration.
- [ ] Add 90-second duration.
- [ ] Add 120-second duration.
- [ ] Display the selected categories.
- [ ] Add a Start Game action.

**Acceptance criteria:**

- Only supported durations can be selected.
- The selected duration is passed correctly into the game session.

---

# Milestone 3 — Game Logic

## B3.1 — Implement word-pool generation

- [ ] Accept one or more selected category identifiers.
- [ ] Retrieve words from the selected categories.
- [ ] Combine all selected words into one collection.
- [ ] Remove duplicate words.
- [ ] Preserve original display text.
- [ ] Normalize comparison values for deduplication.
- [ ] Shuffle the resulting collection.

**Acceptance criteria:**

- One selected category produces its own word pool.
- Multiple selected categories produce one unified pool.
- No word is duplicated in the resulting pool.
- There is no forced category alternation.
- Words are selected randomly.

## B3.2 — Implement word progression

- [ ] Display the current word.
- [ ] Implement Correct.
- [ ] Implement Skip.
- [ ] Advance to the next word after either action.
- [ ] Prevent double registration.
- [ ] Prevent immediate repetition.
- [ ] Handle pool exhaustion safely.

**Acceptance criteria:**

- Every word is counted at most once.
- Correct and Skip both advance gameplay.
- Words do not immediately repeat.
- An exhausted pool is reshuffled without breaking the session.

## B3.3 — Implement scoring

- [ ] Track correct answers.
- [ ] Track skipped words.
- [ ] Calculate final score.
- [ ] Ensure each word contributes only once.
- [ ] Reset scoring when starting a new round.

**Acceptance criteria:**

- Score always matches recorded answers.
- Skipped words do not increase the score.
- New sessions do not inherit previous scores.

---

# Milestone 4 — Gameplay Interface and Sensors

## B4.1 — Implement gameplay screen

- [ ] Display the current word prominently.
- [ ] Display remaining time.
- [ ] Display current score.
- [ ] Display Correct and Skip feedback.
- [ ] Provide clear tilt instructions.
- [ ] Add on-screen fallback controls.

**Acceptance criteria:**

- The word is readable at a distance.
- Gameplay information is easy to understand.
- The player can complete a round without relying on sensors.

## B4.2 — Implement countdown

- [ ] Implement countdown initialization.
- [ ] Start the timer at the correct moment.
- [ ] Update remaining time.
- [ ] Stop the timer when the round ends.
- [ ] Prevent timer updates after disposal.
- [ ] Handle app lifecycle changes appropriately.

**Acceptance criteria:**

- All four durations work.
- The timer does not continue after a completed round.
- Timer updates do not create unnecessary overlapping timers.
- The session ends exactly once.

## B4.3 — Implement tilt detection

- [ ] Integrate a suitable sensor package if necessary.
- [ ] Read device orientation or accelerometer data.
- [ ] Establish neutral device orientation.
- [ ] Detect the correct-answer tilt.
- [ ] Detect the skip tilt.
- [ ] Add threshold and cooldown handling.
- [ ] Require return to neutral before another input.
- [ ] Prevent input during countdown or transitions.
- [ ] Clean up sensor subscriptions.
- [ ] Handle unsupported sensors or sensor errors.

**Acceptance criteria:**

- Correct tilt registers one correct answer.
- Skip tilt registers one skipped word.
- One tilt cannot register multiple actions.
- Small movements do not trigger unwanted actions.
- Sensor behavior is verified on a physical Android device.

---

# Milestone 5 — Results and Replay

## B5.1 — Implement results screen

- [ ] Display final score.
- [ ] Display correct answers.
- [ ] Display skipped answers.
- [ ] Display round duration.
- [ ] Add replay action.
- [ ] Add return-to-categories action.
- [ ] Add return-to-home action.

**Acceptance criteria:**

- Results accurately reflect the completed session.
- Navigation works correctly.
- No previous session data leaks into a new round.

## B5.2 — Implement replay

- [ ] Preserve the previous category selection.
- [ ] Preserve the selected duration.
- [ ] Create a fresh word pool.
- [ ] Reset timer and score.
- [ ] Start a new session.

**Acceptance criteria:**

- Replay starts a genuinely new round.
- Previous results remain unchanged.
- Word repetition is avoided where possible.

---

# Milestone 6 — Visual Polish

## B6.1 — Refine visual identity

- [ ] Establish consistent typography.
- [ ] Refine color palette.
- [ ] Refine category cards.
- [ ] Improve spacing and alignment.
- [ ] Ensure appropriate contrast.
- [ ] Add suitable icons.
- [ ] Refine button styles.

## B6.2 — Add interaction polish

- [ ] Add smooth screen transitions.
- [ ] Add category selection feedback.
- [ ] Add correct/skip animations.
- [ ] Add timer feedback.
- [ ] Add suitable sound effects if approved.
- [ ] Ensure animations never block gameplay.

**Acceptance criteria:**

- All screens share a consistent design language.
- Animations remain lightweight.
- The game remains responsive.

---

# Milestone 7 — Testing and Reliability

## B7.1 — Test category data

- [ ] Verify all 20 categories load.
- [ ] Verify category identifiers are unique.
- [ ] Verify word entries are valid.
- [ ] Verify category word counts.
- [ ] Check duplicates.

## B7.2 — Test category mixing

- [ ] Test one selected category.
- [ ] Test two selected categories.
- [ ] Test several selected categories.
- [ ] Test all 20 categories together.
- [ ] Test overlapping words.
- [ ] Verify unified random selection.
- [ ] Verify no forced category alternation.

## B7.3 — Test game mechanics

- [ ] Test Correct.
- [ ] Test Skip.
- [ ] Test scoring.
- [ ] Test all round durations.
- [ ] Test timer expiration.
- [ ] Test word-pool exhaustion.
- [ ] Test replay.
- [ ] Test screen navigation.
- [ ] Test app interruption and resumption.

## B7.4 — Test physical device behavior

- [ ] Test tilt detection on Android.
- [ ] Verify physical tilt directions.
- [ ] Verify sensor thresholds.
- [ ] Verify cooldown behavior.
- [ ] Test sensor subscription cleanup.
- [ ] Test fallback controls.

## B7.5 — Test offline operation

- [ ] Launch without internet.
- [ ] Navigate through all screens.
- [ ] Start a game.
- [ ] Complete a game.
- [ ] Replay.

**Acceptance criteria:**

- All critical game flows work without internet.
- No unexpected crashes occur.
- No critical scoring or timer defects remain.

---

# Milestone 8 — Android Release

## B8.1 — Prepare Android configuration

- [ ] Verify application identifier.
- [ ] Verify application name.
- [ ] Configure application icon.
- [ ] Verify Android permissions.
- [ ] Ensure unnecessary permissions are absent.
- [ ] Verify minimum Android compatibility.

## B8.2 — Prepare release build

- [ ] Verify build configuration.
- [ ] Generate an Android APK.
- [ ] Verify installation.
- [ ] Test the installed release build.
- [ ] Verify offline operation in release mode.

## B8.3 — Final delivery

- [ ] Confirm all acceptance criteria.
- [ ] Document known limitations.
- [ ] Document build instructions.
- [ ] Document how to add new categories and words.
- [ ] Provide final project summary.

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
