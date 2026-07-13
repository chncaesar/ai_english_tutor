# AI English Tutor v0.0.1 Design

## Status

Re-scoped to v0.0.1 on 2026-07-12.

This version intentionally cuts the product down to the smallest iOS app that can be tested by the developer.

## Design Goal

v0.0.1 validates one end-to-end loop:

1. Upload Markdown learning content.
2. Extract practice points with a predefined conversation workflow.
3. Run a realtime voice conversation with ChatGPT using that workflow.
4. Generate a local Markdown practice record without a separate Records page.

Everything else is postponed.

## Product Scope

The app has one primary screen and one settings screen:

- Main Voice Chat: the primary screen, inspired by the ChatGPT app, used to start and run realtime voice practice.
- Settings: ChatGPT login state plus Markdown upload, view, and delete.

There is no separate Content screen, Practice screen, or Records screen in v0.0.1.

If the user is not logged in, first launch should guide the user to ChatGPT login.

If the user is logged in but has not uploaded Markdown, the main page should guide the user to Settings to upload Markdown.

## Authentication

The preferred path is ChatGPT Plus/Pro login, based on OpenCode's approach.

The implementation starts with an authentication spike:

- Use OAuth with PKCE against `https://auth.openai.com`.
- Use browser-based sign-in on iOS.
- Capture the callback with a custom URL scheme or universal link suitable for iOS.
- Store refresh token and access token securely in Keychain.
- Confirm a realtime voice session can be created and used through a ChatGPT-compatible authenticated path.

If this cannot be validated, v0.0.1 should report the blocker. It should not quietly fall back to standard OpenAI API key billing, text chat, or non-realtime voice unless the user explicitly chooses to change scope.

## Data Model

v0.0.1 needs only a small local model:

- MarkdownDocument: title, body, updated time.
- PracticeSelection: three selected vocabulary items or sentence patterns, source notes, updated time.
- VoiceSessionLog: role, transcript text or status text, timestamp.
- PracticeRecord: local Markdown summary of the completed session, created time.
- AuthState: stored in Keychain, not in normal app storage.

Only one active Markdown document, one active practice selection, and the latest local practice record are required.

## Markdown Flow

Settings supports one Markdown input path:

- Upload a `.md` file from Files.

After upload, the app stores the Markdown locally and displays it for review.

The user can delete the current Markdown document.

The user cannot edit Markdown inside the app in v0.0.1.

No PDF parsing, OCR, schema validation, or textbook indexing exists in v0.0.1.

## Workflow Preparation Flow

The main voice chat flow sends the Markdown content to ChatGPT and asks it to extract learning material for the predefined workflow before the realtime session starts.

The preparation output must include:

- Extracted vocabulary.
- Extracted sentence patterns.
- Three selected practice points for the current session.
- A short reason for why each practice point was selected.
- A first greeting or opening prompt for the voice session.

The main page can show the three selected practice points briefly before the voice conversation starts.

## Predefined Conversation Workflow

The app owns the workflow. ChatGPT fills the workflow with content from the uploaded Markdown and the live voice conversation.

The workflow steps are:

1. Extract vocabulary and sentence patterns from the uploaded Markdown.
2. Select three vocabulary items or sentence patterns for the current practice session.
3. Start the realtime voice session by greeting the user first.
4. Encourage the user during conversation while correcting meaningful mistakes.
5. For each corrected mistake, guide the user to practice it two to three times.
6. Keep the total practice time under 20 minutes.
7. When time is up or the user has basically mastered the practice points, explain why the session is ending and summarize the learning content.
8. Generate this practice record as a local Markdown file.

## Realtime Voice Flow

The main voice chat screen starts from the selected practice points and predefined workflow.

The visual direction should reference the ChatGPT app:

- Focused single conversation surface.
- Minimal chrome.
- Clear voice connection state.
- Simple start and stop controls.
- Settings entry visible but secondary.

The assistant should:

- Stay grounded in the Markdown content.
- Focus on the three selected practice points.
- Ask one question at a time.
- Encourage English answers.
- Correct meaningful mistakes and repeat each correction two to three times.
- Keep the conversation moving.
- End within 20 minutes or earlier if the user basically masters the practice points.
- Use Chinese only for clarification.

v0.0.1 uses realtime voice. Text-only chat and non-realtime voice are intentionally postponed until after the tester has tried this version and provided feedback.

The app should show minimal session state:

- Not connected.
- Connecting.
- Listening.
- Speaking.
- Error.

If transcript events are available from the realtime session, the app can display them as a lightweight debug transcript for the tester.

There is no Records page in v0.0.1. The generated Markdown practice record is local data, not a separate browsing surface.

## Error Handling

User-facing errors should be clean Chinese text.

Examples:

- `登录失败，请重新登录 ChatGPT。`
- `无法准备本次练习内容，请稍后重试。`
- `当前还没有 Markdown 内容，请先上传。`
- `当前还没有练习内容，请先准备本次练习。`
- `语音连接失败，请重新开始。`

Raw provider errors, tokens, stack traces, and internal endpoint details must not be shown in the UI.

## Acceptance Criteria

The version is accepted when the developer can:

- Install and open the iOS app.
- Be guided to log in with ChatGPT Plus/Pro on first use.
- Open Settings and upload Markdown.
- Extract vocabulary and sentence patterns.
- Review three selected practice points.
- Return to the main page and start a realtime voice conversation based on the workflow.
- Speak to ChatGPT and hear spoken responses for multiple turns.
- Practice corrected mistakes two to three times.
- Finish the session within 20 minutes or earlier when the selected practice points are basically mastered.
- Generate the practice record as local Markdown.
- Close and reopen the app with Markdown and practice points preserved.

## Deferred Features

- Non-realtime voice.
- Text-only chat mode.
- PDF import.
- OCR.
- Multi-user profiles.
- Child-specific profile setup.
- Parent controls.
- Mastery tracking.
- Learning reports.
- Multi-provider support.
