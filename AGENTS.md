# Repository Instructions

## Source Of Truth

- `project.yml` is the Xcode project source of truth. Do not edit or commit `AIEnglishTutor.xcodeproj/`; regenerate it with `xcodegen generate`.
- `docs/` is private local planning material and is intentionally ignored. Do not add or reference `docs/` in public commits.
- This repo is a v0.0.1 blocked prototype: the app shell/local workflow exists, but real ChatGPT Plus/Pro OAuth and validated realtime voice are not implemented.

## Commands

- Generate the Xcode project before opening/building: `xcodegen generate`.
- Run the full test suite: `xcodebuild test -scheme AIEnglishTutor -destination 'platform=iOS Simulator,name=iPhone 16'`.
- If simulator name matching is ambiguous, use a concrete UDID: `xcodebuild test -scheme AIEnglishTutor -destination 'platform=iOS Simulator,id=<SIMULATOR_UDID>'`.
- Run one focused XCTest with: `xcodebuild test -scheme AIEnglishTutor -destination 'platform=iOS Simulator,id=<SIMULATOR_UDID>' -only-testing:AIEnglishTutorTests/<TestClass>/<testMethod>`.

## Architecture Notes

- App entrypoint: `AIEnglishTutor/AIEnglishTutorApp.swift`.
- Top-level state/orchestration: `AIEnglishTutor/AppModel.swift` (`@MainActor`, `ObservableObject`).
- Local data models live in `AIEnglishTutor/Models/`; local stores and provider boundaries live in `AIEnglishTutor/Services/`; SwiftUI screens live in `AIEnglishTutor/Views/`.
- The product shape is one main voice chat page plus Settings. Do not add separate Content, Practice, or Records pages.

## Product Constraints

- Markdown support is upload/view/delete for one `.md` file from Settings. Do not add paste input or in-app Markdown editing.
- Keep practice records as local Markdown data only; do not add a Records browsing surface.
- Do not add API key billing, text-only chat, or non-realtime voice as silent fallbacks.
- Until real provider integration exists, auth and realtime voice must surface clean blocker messages instead of pretending success.

## External Provider Boundaries

- `AuthService` is the ChatGPT Plus/Pro OAuth boundary. `StubAuthService` must not return fake tokens as a real login.
- `RealtimeVoiceService` is the realtime voice boundary. `StubRealtimeVoiceService` must not set the app to listening or simulate a successful realtime session.
- User-facing errors must be clean Chinese text. Do not expose raw provider errors, tokens, stack traces, endpoint details, SQL, or internal field names.

## Git Hygiene

- Keep `AIEnglishTutor.xcodeproj/`, `docs/`, `.superpowers/`, and `.worktrees/` out of commits.
- After changing project structure, update `project.yml`, regenerate locally, and verify tests; commit `project.yml` and source changes, not the generated project.
