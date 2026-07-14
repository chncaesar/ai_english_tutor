# AI English Tutor

AI English Tutor is an iOS 18+ SwiftUI prototype for practicing English through a Markdown-based lesson workflow and a ChatGPT-style realtime voice interface.

## Current Status

This repository currently contains a v0.0.1 blocked prototype.

Implemented:

- iOS 18+ SwiftUI app shell.
- ChatGPT-app-inspired main voice page.
- Settings page for ChatGPT status and Markdown management.
- Upload, view, and delete one Markdown lesson file.
- Local extraction of exactly three practice points from Markdown.
- Local persistence for the uploaded Markdown and latest practice points.
- Local Markdown practice record generation and persistence.
- Service boundaries for ChatGPT Plus/Pro authentication and realtime voice.

Blocked:

- Real ChatGPT Plus/Pro OAuth is not implemented yet.
- A validated ChatGPT-compatible realtime voice path is not implemented yet.
- The app intentionally reports these blockers instead of pretending a stub login or stub voice session succeeded.

## Product Scope For v0.0.1

The intended v0.0.1 loop is:

1. The user signs in with ChatGPT Plus/Pro.
2. The user uploads one Markdown lesson in Settings.
3. The app extracts vocabulary and sentence patterns.
4. The app selects exactly three practice points.
5. The main page starts a realtime voice practice session.
6. The tutor greets first, encourages the user, corrects meaningful mistakes, and repeats each correction two to three times.
7. The session finishes within 20 minutes or earlier when the user has basically mastered the practice points.
8. The app generates a local Markdown practice record.

## Out Of Scope

- Text-only chat mode.
- Non-realtime voice mode.
- API key billing fallback.
- PDF import.
- OCR.
- Multiple Markdown lessons.
- In-app Markdown editing or paste input.
- Records page.
- Cloud sync.
- App Store release.

## Project Structure

```text
AIEnglishTutor/
  Models/                 App data models
  Services/               Local stores and external-service boundaries
  Views/                  SwiftUI screens and components
  Resources/              App Info.plist
AIEnglishTutorTests/      XCTest unit tests
docs/                     Requirements, design docs, UI draft, and implementation plan
project.yml               XcodeGen project definition
```

## Requirements

- macOS with Xcode 26.x.
- iOS 18+ simulator or device.
- XcodeGen installed and available as `xcodegen`.

## Build And Test

Generate the Xcode project:

```bash
xcodegen generate
```

Run tests:

```bash
xcodebuild test -scheme AIEnglishTutor -destination 'platform=iOS Simulator,name=iPhone 16'
```

If multiple simulators match the same name, use a concrete simulator UDID:

```bash
xcodebuild test -scheme AIEnglishTutor -destination 'platform=iOS Simulator,id=<SIMULATOR_UDID>'
```

The latest verified run used an iOS 18.6 iPhone 16 simulator and passed 13 tests with 0 failures.

## Documentation

- Requirements: `docs/requirement.md`
- Design: `docs/superpowers/specs/2026-07-12-ai-english-tutor-design.md`
- Learning workflow and prompts: `docs/learning-workflow-and-prompts.md`
- ChatGPT Plus/Pro login research: `docs/openai-chatgpt-oauth-research.md`
- UI draft: `docs/ui-v0.0.1.html`
- Implementation plan: `docs/superpowers/plans/2026-07-13-ai-english-tutor-v0.0.1-ios.md`

## Security And Privacy Notes

- Token storage is designed to live behind an authentication service boundary.
- Real Keychain-backed ChatGPT Plus/Pro OAuth is still pending.
- The app stores lesson content and practice data locally.
- The prototype does not include cloud sync, child profiles, parent reports, or public release behavior.

## License

MIT License. See `LICENSE`.
