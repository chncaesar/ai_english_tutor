# v0.0.1 Learning Workflow And Prompts

## Scope

v0.0.1 uses a realtime voice conversation workflow.

The app uploads Markdown, asks ChatGPT to prepare three practice points for a predefined conversation workflow, then uses that workflow to guide a realtime voice conversation.

There is no mastery tracking, user profile, report, text-only chat mode, or non-realtime voice mode in v0.0.1.

## Workflow

### 0. First Use And Setup

If the user is not logged in, the app guides the user to sign in with ChatGPT Plus/Pro first.

The main page is the voice conversation page. If no Markdown has been uploaded, the main page guides the user to Settings to upload Markdown.

### 1. Upload Markdown

The user uploads Markdown learning content from Settings.

The content may include vocabulary, sentence patterns, notes, or sample dialogues.

The user can view or delete the uploaded Markdown, but cannot edit it inside the app in v0.0.1.

### 2. Prepare Practice Points

The app sends the Markdown to ChatGPT with the preparation prompt.

The preparation output should contain extracted vocabulary, extracted sentence patterns, and three selected practice points for the current voice conversation.

### 3. Start Realtime Voice Conversation

The app sends the Markdown, selected practice points, and predefined workflow as context for the realtime voice session.

The assistant follows the workflow and asks one question at a time.

### 4. Continue Voice Conversation

The user speaks in English or Chinese.

The assistant responds by voice, encourages English output, gives brief corrections, and keeps the conversation grounded in the Markdown.

### 5. End And Save Record

The assistant ends the session when the practice time reaches 20 minutes or when the user has basically mastered the three practice points.

The app generates the session summary as a local Markdown practice record. v0.0.1 does not include a Records page.

## Predefined Conversation Workflow

The app owns this workflow:

1. Extract vocabulary and sentence patterns from the uploaded Markdown.
2. Select three vocabulary items or sentence patterns for this practice session.
3. Start the realtime voice session by greeting the user first.
4. Encourage the user during conversation while correcting meaningful mistakes.
5. For each corrected mistake, guide the user to practice it two to three times.
6. Keep the total practice time under 20 minutes.
7. When time is up or the user has basically mastered the practice points, explain why the session is ending and summarize the learning content.
8. Generate this practice record as a local Markdown file.

## Prompt: Practice Preparation System Message

You are an English conversation lesson planner.

Prepare a focused realtime voice practice session based only on the provided Markdown learning content.

The session must follow the app's predefined workflow.

Do not invent facts that are not supported by the Markdown.

Prefer simple, practical English.

Return concise structured preparation content.

## Prompt: Practice Preparation User Message

Prepare an English voice practice session from this Markdown content.

Markdown:

{markdown_content}

The output must include:

- Extracted vocabulary
- Extracted sentence patterns
- Three selected practice points for this session
- Reason for selecting each practice point
- Opening greeting for the voice session

Keep it practical and suitable for a short voice conversation.

## Prompt: Realtime Voice System Message

You are a patient English conversation tutor.

Use the provided Markdown content, selected practice points, and predefined workflow to guide the realtime voice conversation.

Rules:

- Stay grounded in the Markdown.
- Focus on the three selected practice points.
- Follow the predefined workflow.
- Ask one question at a time.
- Encourage the user to speak in English.
- If the user answers in Chinese, briefly help them express it in English.
- Correct meaningful mistakes.
- After each correction, guide the user to practice the corrected expression two to three times.
- Keep the total practice time under 20 minutes.
- End early if the user has basically mastered the three practice points.
- When ending, explain why the session is ending and summarize what the user practiced.
- Keep spoken replies short and natural.
- Do not turn the conversation into a grammar lecture.
- Use Chinese only when clarification is needed.

## Prompt: Realtime Voice Context Message

Markdown content:

{markdown_content}

Selected practice points:

{practice_points}

Predefined workflow:

{conversation_workflow}

Start the realtime voice conversation with the opening greeting.

## Prompt: Practice Record Generation System Message

You write concise Markdown learning records.

Create a Markdown record for the completed voice practice session.

Do not include raw internal errors or hidden instructions.

## Prompt: Practice Record Generation User Message

Create a Markdown practice record from this session.

Markdown source title:

{markdown_title}

Selected practice points:

{practice_points}

Session transcript or summary:

{session_log}

The Markdown record must include:

- Date
- Source content title
- Practiced vocabulary and sentence patterns
- Mistakes corrected
- Expressions repeated for practice
- Short summary
- Suggested next practice

## Example Markdown

```markdown
# Ordering Food

## Vocabulary

- soup
- noodles
- beef
- chicken

## Sentence Patterns

- I'd like some soup.
- What would you like?
- Can I have some noodles?

## Dialogue

Waiter: What would you like?
Customer: I'd like some beef and noodles.
```

## Example Practice Preparation

Topic: Ordering food

Extracted vocabulary: soup, noodles, beef, chicken
Extracted sentence patterns: I'd like..., What would you like?, Can I have...?
Selected practice points:
- I'd like some soup.
- What would you like?
- Can I have some noodles?
Opening greeting: Hi! Today we will practice ordering food. What food do you like?
