---
name: synthesize-interviews
description: Turn customer interview transcripts into jobs, pains with quotes, opportunities, and ready-to-file feature requests
---

# Synthesize customer interviews

Usage: `/synthesize-interviews <transcript paths...>`

Read one or more interview transcripts and produce what a product manager needs to act on them: jobs to be done, pains backed by verbatim quotes, opportunities ranked by how many people have the pain and how badly it hurts, and two or three feature requests written in the form engineering triages, each pre-scored with the shared readiness rubric.

Transcript paths given with the command: `$ARGUMENTS` (if that reads literally as `$ARGUMENTS`, nothing was passed; treat it as no argument)

## Step 1. Load the rubric

Read the rubric before the transcripts. Look in this order and use the first file that exists:

1. `readiness.md` in the same folder as this SKILL.md (the copy that travels with the skill when it is uploaded as a ZIP).
2. `${CLAUDE_PLUGIN_ROOT}/rubric/readiness.md` when the `CLAUDE_PLUGIN_ROOT` environment variable is set.
3. `rubric/readiness.md` under the project root, the folder that contains `skills/synthesize-interviews/`.

If none exists, stop and print exactly: `The readiness rubric is missing. From the repo root run scripts/sync-rubric.sh, then run /synthesize-interviews again.`

Take the value of the `version:` line in the rubric's front matter. Print `Rubric version: <value>` as the first line of the reply and write it into the output file. When scoring a candidate request in Step 5, follow the rubric's Procedure section (`## 4. Procedure`) as written and produce its output shape `{ clarity, complexity, risk, archChange, readiness, reasons: { clarity, complexity, risk }, questions: [] }` internally; the rubric's Scales section (`## 1. Scales`, tables `### Clarity`, `### Complexity`, `### Risk`), its Architecture change test (`## 2.`), and its Readiness section (`## 3.`, `readiness = clarity * 2 + (6 - complexity) + (6 - risk)`, range 4 to 20) are the only definitions used.

When the request is about a product other than Kaizen Tasks — the sample PRD and anything drawn from the interview transcripts are — map it to the closest analogous area in the rubric's repo layouts, and say in the complexity and risk reasons that the mapping is by analogy. Never name a file that does not exist.

## Step 2. Collect the transcripts

- If paths were given, read every one. For a path that does not exist, say which one and continue with the rest; if none remain, stop.
- If no paths were given, offer the bundled transcripts. Resolve the folder the same way as the rubric: `${CLAUDE_PLUGIN_ROOT}/data/interviews/` or `data/interviews/`. When the AskUserQuestion tool is available, ask `Which transcripts should I synthesize?` with multi-select on and one option per file, labelled with the file name and the persona from its header; in plain text otherwise, list them with numbers and say that the default is all of them. Proceed with the chosen files; with no choice, all of them.
- For each transcript, record its file name and the value of the `Role` row in its header table. Quotes are attributed by that role and file name. If a transcript has no header table, use the speaker's name as it appears in the transcript, or `unknown role`.

Print `Transcripts: <file names, comma separated>`.

## Step 3. Extract per transcript

For each transcript, in its own pass and before looking at the others, write down:

- **Jobs to be done**, in the form `When I <situation>, I want to <motivation>, so I can <outcome>`. One line each; three to six per transcript.
- **Pains.** Each pain gets a short name, one sentence on what happens, and one to three verbatim quotes. A quote is copied character for character from the transcript. Write each quote on its own line as `> "<quote>" — <role>, <file name>`. Never put paraphrase inside quotation marks; when the point needs shortening, quote a shorter span that is still character for character. Prefer quotes that carry a number, a frequency, or a consequence.
- **Workarounds** the person described (a text file, a spreadsheet, an email thread, walking the floor). A workaround is evidence of severity.

## Step 4. Merge across transcripts

- Merge pains that describe the same thing under one name; keep every transcript's quotes under it.
- **Frequency** of a pain: the number of transcripts in which it appears, out of the number read, written `2 of 3`.
- **Severity** of a pain: 1 to 5 in the style of the rubric's `### Risk` table under `## 1. Scales`, applied to the customer's job instead of the codebase:
  1. cosmetic: an annoyance the person mentions and moves on from;
  2. slows one task; no workaround needed;
  3. forces a workaround (a spreadsheet, a text file, an email thread) every day or every week;
  4. causes errors that reach the customer, or work that is lost or redone;
  5. makes part of the job impossible or breaks a commitment to a customer or the business.
- **Contradictions.** When two transcripts disagree about the same thing (one trusts a process that another calls arbitrary), do not resolve it and do not average it. Record both sides with their quotes under `## Contradictions`, count frequency only for the transcripts that report the pain, and write one sentence on what evidence would settle it.
- **Opportunities.** An opportunity is a change that would remove or reduce one or more pains. Name it as an outcome, not a feature (`Supervisors see which contact reasons each agent struggles with`, not `Add a contact reasons dashboard`). Tie it to the pains it addresses by pain name. Score it: frequency is the highest frequency among its pains; severity is the highest severity among its pains; score is frequency times severity. Sort by score descending, then by severity descending.

## Step 5. Candidate feature requests

For the top two or three opportunities, write one feature request each in the request form's five sections, with these exact headings:

```markdown
### Problem
### Proposed behavior
### Acceptance criteria
### Out of scope
### Your role
```

- Problem: two to four sentences with at least one verbatim quote and the frequency.
- Proposed behavior: what the user sees, as the interviewee described the job. Do not design the system.
- Acceptance criteria: three to five bullets a tester could check; use the numbers the interviewees gave.
- Out of scope: at least one bullet naming a nearby thing this request does not include.
- Role: the persona whose job the request serves.

Score each candidate with the rubric procedure and show the result under it as one line: `Score: clarity 4, complexity 3, risk 2, architecture change no, readiness 15`. Aim each candidate at the bar `refine-request` stops at: clarity 4 or higher, scope stated (the Out of scope section filled), and at least three acceptance criteria a tester could check. Write to that bar where the transcripts give enough detail; do not invent detail to reach it. When a candidate falls short, add one line `Still missing: <what the transcripts could not supply>` under the score line. When a candidate triggers the rubric's architecture change test, say so in the score line; it still goes in the list.

## Step 6. Write the file and print the table

Write everything to `out/<YYYY-MM-DD>-synthesis.md` under the folder Claude Code is open in (it is git-ignored in this repository), using today's date, creating `out/` if needed. If the file already exists, use `-2`, `-3`, and so on before `.md`. File layout:

```markdown
# Interview synthesis, <date>

Rubric version: <value>
Transcripts: <file names>

## Jobs to be done
## Pains
## Contradictions
## Opportunities
## Candidate feature requests
```

Under `## Candidate feature requests`, each candidate starts with `### Candidate N: <title>` followed by its five sections and its score line.

Then print to the chat: the rubric version, the file path, and the opportunity table:

| # | Opportunity | Pains | Frequency | Severity | Score |
|---|---|---|---|---|---|
| 1 | Supervisors see which contact reasons each agent struggles with | Coaching prep by listening; No per-reason view | 2 of 3 | 4 | 8 |

## Step 7. Offer the next step

Ask, through the question tool when available and as a numbered list in plain text otherwise: `Refine one of the candidates now?` with one option per candidate title plus `Not now`. On a choice, run the `refine-request` skill with that candidate's five sections as the pasted text (`/refine-request` followed by the text). Do not run it unasked.

## Rules

- Quotes are verbatim or they are not quotes.
- Every pain, opportunity, and candidate points back to at least one transcript by file name.
- Plain language and no engineering words in the candidates; the reader is a PM who will paste them into a form.
- Print the rubric version used, in the file and in the chat.
- This skill never touches GitHub: it opens no issues, applies no labels, and posts no comments. Filing is the PM's step, and labels belong to engineering triage.
