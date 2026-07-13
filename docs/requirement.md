# AI English Tutor v0.0.1 Requirements

## Goal

Build a minimal iOS app that lets the tester upload Markdown learning content, sign in with a ChatGPT Plus/Pro account, run a predefined conversation workflow from that Markdown, and have a realtime voice conversation with ChatGPT based on the workflow.

The purpose of v0.0.1 is to validate the smallest useful loop:

- User provides learning material.
- App extracts practice points and runs a fixed conversation workflow.
- User speaks with ChatGPT through that workflow.
- App saves the practice record as Markdown.

## Target User

The first tester is the developer.

Child-focused learning features are postponed. v0.0.1 should be usable by an adult tester first.

## In Scope

- Native iOS app.
- Main voice chat page inspired by the ChatGPT app.
- Settings page for login and Markdown management.
- Upload Markdown content.
- Display uploaded Markdown content in Settings.
- Delete the current Markdown content.
- Extract vocabulary and sentence patterns from the Markdown content.
- Select three practice points for the current session.
- Start a realtime voice conversation based on the predefined workflow.
- Save the practice record as Markdown.
- Use ChatGPT Plus/Pro login as the preferred authentication path.
- Store uploaded Markdown and selected practice points locally on the device.

## Out Of Scope

- PDF import.
- OCR.
- Textbook indexing.
- Multi-user management.
- Age, gender, grade, or learner profile setup.
- Mastery tracking.
- Learning duration tracking.
- Parent review.
- Parent reports.
- Male or female voice selection.
- British or American accent selection.
- Cloud sync.
- Backend service unless required by the ChatGPT login prototype.
- Multiple AI providers.
- App Store release.

## Markdown Input

The app supports one uploaded Markdown document at a time in v0.0.1.

The user manages Markdown in Settings.

The user can provide Markdown by uploading a `.md` file from Files.

The user can view the uploaded Markdown content and delete it.

The user cannot edit Markdown inside the app in v0.0.1.

The Markdown may contain:

- Topic title.
- Vocabulary.
- Sentence patterns.
- Dialogue examples.
- Notes in Chinese or English.

The app does not require a strict schema in v0.0.1, but practice preparation should work better when the Markdown has clear headings and lists.

## ChatGPT Plus/Pro Login

v0.0.1 uses ChatGPT Plus/Pro login as the preferred authentication path.

On first launch, if the user is not logged in, the app should guide the user to log in with ChatGPT before entering the main voice chat experience.

The implementation should follow the OpenCode-style research path:

- Authenticate against `https://auth.openai.com`.
- Use OAuth with PKCE.
- Store access token, refresh token, expiry, and account ID locally and securely.
- Use the authenticated ChatGPT-compatible realtime voice path if validated in the prototype.

This must be implemented as a spike first. If ChatGPT Plus/Pro login cannot support realtime voice reliably in the iOS app, v0.0.1 should stop and report that blocker instead of silently switching to API key billing or non-realtime voice.

## Conversation Workflow

After Markdown upload, the app uses a predefined conversation workflow.

The workflow has eight steps:

- Extract vocabulary and sentence patterns from the uploaded Markdown.
- Select three vocabulary items or sentence patterns for this practice session.
- Start the realtime voice session by greeting the user first.
- Encourage the user during conversation while correcting meaningful mistakes.
- For each corrected mistake, guide the user to practice it two to three times.
- Keep the total practice time under 20 minutes.
- When time is up or the user has basically mastered the practice points, explain why the session is ending and summarize the learning content.
- Save this practice record as a Markdown file.

The selected three practice points are shown to the user before starting the voice conversation.

## Voice Conversation Flow

v0.0.1 uses realtime voice conversation.

The main page is the voice conversation page. Its layout should reference the ChatGPT app: a focused conversation area, clear voice state, and a simple control to start or stop voice practice.

If no Markdown has been uploaded, the main page should guide the user to Settings to upload Markdown before starting practice.

The voice conversation should:

- Stay grounded in the uploaded Markdown.
- Follow the predefined conversation workflow.
- Ask one question at a time.
- Encourage the user to speak in English.
- Correct meaningful mistakes and help the user practice each correction two to three times.
- Use Chinese only when explaining difficult points or when the user asks.
- Show a minimal transcript or status log so the tester can understand what happened during the session.

## Local Data

The app stores locally:

- Uploaded Markdown.
- Selected practice points.
- Current voice session transcript or status log when available.
- Practice record Markdown.
- ChatGPT login token data, stored securely.

The app does not need account registration or cloud sync.

The app does not need a dedicated Records page in v0.0.1. Practice records are generated and stored locally as Markdown for later product decisions.

## Acceptance Criteria

v0.0.1 is accepted when the tester can:

- Open the iOS app.
- Be guided to sign in with ChatGPT Plus/Pro on first use.
- Open Settings and upload Markdown content.
- Extract vocabulary and sentence patterns.
- Review the three selected practice points.
- Return to the main page and start a realtime voice conversation based on the predefined workflow.
- Speak to ChatGPT and hear spoken responses for multiple turns.
- Finish the session within 20 minutes or earlier when practice points are basically mastered.
- Save the practice record as Markdown.
- Quit and reopen the app without losing the uploaded Markdown and latest practice points.

## Future Versions

The previous broader ideas are moved to later versions:

- Non-realtime voice conversation.
- Text-only chat mode.
- PDF and OCR.
- Textbook unit indexing.
- Child profile management.
- Parent review and reports.
- Learning time tracking.
- Mastery model.
- Multi-provider support.
