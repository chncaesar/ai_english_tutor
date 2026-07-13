# ChatGPT Plus/Pro Login Research For v0.0.1

## Purpose

v0.0.1 should let the tester sign in with a ChatGPT Plus/Pro account and use that account for a predefined realtime voice conversation workflow inside the iOS app.

This file records the current research direction and implementation risk.

## What OpenCode Proves

OpenCode supports signing in with a ChatGPT Plus/Pro account for OpenAI models.

The relevant pattern is:

- Authenticate with `https://auth.openai.com`.
- Use OAuth with PKCE.
- Store access and refresh tokens locally.
- Send supported model requests through a ChatGPT-compatible authenticated path instead of using a normal OpenAI API key.

OpenCode does not prove that a ChatGPT Plus/Pro subscription becomes a normal OpenAI API key. It uses a separate authenticated ChatGPT account flow.

## v0.0.1 Assumption

For v0.0.1, the app needs realtime voice after workflow preparation:

- Extract vocabulary and sentence patterns from Markdown.
- Select three practice points for the current session.
- Start a realtime voice conversation based on the predefined workflow.
- Let the user speak and hear ChatGPT's spoken responses.
- Generate the practice record as local Markdown after the session.

Non-realtime voice and text-only chat are out of scope for v0.0.1. They will be discussed only after the tester uses the realtime version and gives feedback.

## Required Spike

Before building the full app flow, implement a small authentication and request spike:

- Open browser-based ChatGPT sign-in from iOS.
- Complete OAuth with PKCE.
- Receive the callback in the app.
- Store token data in Keychain.
- Refresh the token if needed.
- Make one authenticated workflow preparation request.
- Create one authenticated realtime voice session.
- Confirm microphone input and spoken model output work on iOS.
- Confirm the response can be used for a workflow-based voice conversation.
- Confirm a practice record can be generated as local Markdown after the session.

## Risk

This path may depend on non-public ChatGPT web or Codex-compatible endpoints.

Risks include:

- Endpoint changes.
- Account policy changes.
- OAuth client or callback restrictions.
- iOS browser sign-in issues.
- Realtime voice endpoint incompatibility with ChatGPT Plus/Pro OAuth.
- App review unsuitability if released publicly.

v0.0.1 is for local testing by the developer, so these risks are acceptable for a prototype, but they must be explicit.

## Decision Rule

If ChatGPT Plus/Pro login cannot support realtime voice reliably in the iOS prototype, stop and report the blocker.

Do not silently switch to standard OpenAI API key billing, text-only chat, or non-realtime voice unless the user explicitly changes the v0.0.1 scope.

## Deferred

The following are intentionally deferred for v0.0.1:

- Non-realtime voice.
- Text-only chat mode.
- Separate speech-to-text plus text-to-speech pipeline.
- Multi-provider authentication.
