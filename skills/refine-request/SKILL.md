---
name: refine-request
description: Interview me about a feature request until it is ready for engineering, then rewrite it in the request form
argument-hint: "<issue number | file path | pasted text>"
---

# Refine a feature request

Take one feature request from a product manager, score it with the shared readiness rubric, ask one question at a time until it would score as ready, and hand back the request rewritten in the form engineering triages. The PM's local score and the engineering triage score come from the same rubric text, so they agree for the same request.

Request source given with the command: `$ARGUMENTS` (if that reads literally as `$ARGUMENTS`, nothing was passed; treat it as no argument)

## Step 1. Load the rubric

Read the rubric before reading the request. Look in this order and use the first file that exists:

1. `${CLAUDE_PLUGIN_ROOT}/rubric/readiness.md` when the `CLAUDE_PLUGIN_ROOT` environment variable is set (the plugin is installed).
2. `rubric/readiness.md` under the project root, the folder that contains `skills/refine-request/` (the repository is opened directly).

If neither exists, stop and print exactly: `The readiness rubric is missing. From the repo root run scripts/sync-rubric.sh, then run /refine-request again.` Do not score without the rubric.

Take the value of the `version:` line in the rubric's front matter. Print `Rubric version: <value>` as the first line of the reply, and repeat it in the final report.

Follow the rubric's Procedure section (`## 4. Procedure`) as written every time a score is produced. Do not shorten, reorder, or paraphrase it. The rubric's Scales section (`## 1. Scales`, tables `### Clarity`, `### Complexity`, `### Risk`), its Architecture change test (`## 2.`), and its Readiness section (`## 3.`, `readiness = clarity * 2 + (6 - complexity) + (6 - risk)`, range 4 to 20) are the only definitions of clarity, complexity, risk, architecture change, and readiness used here. Produce the rubric's output shape `{ clarity, complexity, risk, archChange, readiness, reasons: { clarity, complexity, risk }, questions: [] }` internally for every score; show it only in the tables below. The rubric's `questions` array (two or three, only while clarity is below 3, from `## 5. Clarifying questions`) is material for the interview in Step 4, not a limit on it: the interview keeps asking one question at a time past clarity 3 until the stop condition in Step 4, up to eight questions.

When the request is about a product other than Kaizen Tasks — the sample PRD and anything drawn from the interview transcripts are — map it to the closest analogous area in the rubric's repo layouts, and say in the complexity and risk reasons that the mapping is by analogy. Never name a file that does not exist.

## Step 2. Take in the request

Decide the source from the text after the command, checking in this order:

1. **Only digits** (for example `17`), or a GitHub issue URL (`https://github.com/<owner>/<repo>/issues/<n>`): a GitHub issue. Digits alone mean an issue in `kpnemo/kaizen-tasks-assembly-line`, where feature requests are filed. Run `gh auth status` first. If `gh` is not installed or not logged in, say so in one line and ask for the issue text to be pasted instead. Otherwise run `gh issue view <n> --repo kpnemo/kaizen-tasks-assembly-line --json title,body,author,url` (or `gh issue view <url> --json title,body,author,url` for a URL) and use `title` and `body` as the request. Then run `gh api user -q .login` and note whether it equals `author.login`. Remember the issue number, its repository, and that yes-or-no answer for Step 6.
2. **A path to an existing file** (for example `data/prd-sample.md` or `~/requests/export.md`): read the file and use its contents as the request.
3. **Anything else**: the text itself is the request.
4. **Nothing**: ask `Paste the request, or give me an issue number or a file path.` and wait. Then apply the three rules above to the reply.

Print one line naming the source: `Request source: issue #17`, `Request source: data/prd-sample.md`, or `Request source: pasted text`.

## Step 3. Score before

Score the request with the rubric procedure. Show the result as the "before" row, with one-line reasons taken from the output shape's `reasons`:

| | Clarity | Complexity | Risk | Architecture change | Readiness |
|---|---|---|---|---|---|
| Before | 2, a goal with no observable behavior | 3, both repos would change | 2, isolated behavior | no | 11 |

Keep this row; the final report reuses it.

Check the stop condition from Step 4 right away. If the request already meets it, print `This request already scores as ready; no questions needed.` and go to Step 5.

## Step 4. Interview

### Rules

- Ask exactly one question per turn. End the turn and wait for the answer.
- When the AskUserQuestion tool is available in this session, ask through it: one question, a header of at most twelve characters, and three or four options that are concrete guesses drawn from the request text, each with a one-line description. The tool adds a free-text choice on its own; do not add an "Other" option. When the tool is not available, ask the same question in plain text, list the same three or four options as a numbered list, and say that a free-text answer is fine.
- Never ask for something the request text or an earlier answer already states. Before each question, re-read the request and every answer so far.
- After every answer, re-score the request with the rubric procedure silently. Do not print scores between questions.
- Count questions. The cap is eight.

### Question order

Work down this list. Skip any item the request already answers. Return to an earlier item only when an answer contradicts what was assumed.

1. **User and moment.** Who is the user, and at what moment does this happen? Options are candidate users and moments taken from the request, for example `Team supervisor, preparing a weekly coaching session`.
2. **Observable behavior.** What does the user see when it works? Options are concrete screens or messages, for example `A list of agents with the contact reasons where their scores fall below the team`.
3. **Done criteria.** What would a tester check to say it is done? Keep asking this item, one criterion per question, until at least three criteria exist that a tester could check by looking at the product. Options are candidate criteria phrased as checks, for example `Opening the page for a team of 12 shows all 12 agents within 2 seconds`.
4. **Out of scope.** What should explicitly not change? Options are nearby things the request could be read to include, for example `How quality scores are calculated`.
5. **Complexity and risk probes.** Only when the answers so far imply a database schema change, a sign-in or permissions change, or a change to the AI prompt or what it returns: ask one question per implied area, phrased for a product manager, for example `Does this need information we do not store today?` with options `Yes, new information per agent`, `No, what we have already`, `Not sure`.

### Stop condition

Stop asking when all three hold, using the latest silent score:

- clarity is 4 or higher;
- scope is stated: the request now says what it includes and what it leaves out;
- at least three acceptance criteria exist that a tester could check.

Stop also when eight questions have been asked. At the cap, produce the report from what exists and add a section `## Still missing` listing what the stop condition still lacks, one bullet each.

## Step 5. Report

Print, in this order:

1. `Rubric version: <value>`, again.
2. The rewritten request as a markdown body in the request form's five sections, in the form's order, with these exact headings:

   ```markdown
   ### Problem
   What is hard or slow today, for whom, and how we know. Two to four sentences.

   ### Proposed behavior
   What happens instead, as the user sees it. Prose or a short numbered flow.

   ### Acceptance criteria
   - One bullet per criterion, each a check a tester could run.
   - At least three.

   ### Out of scope
   - One bullet per excluded item, or `Nothing stated` when the PM chose to leave it open.

   ### Your role
   The PM's role in one line, taken from the answers or the request, or `Not stated`. The form leaves this field optional.
   ```

   Use only what the PM said or the request contained. Do not invent criteria, users, or numbers. Where the PM gave a number, keep the number.

3. The before-and-after table:

   | | Clarity | Complexity | Risk | Architecture change | Readiness |
   |---|---|---|---|---|---|
   | Before | 2, a goal with no observable behavior | 3, both repos would change | 2, isolated behavior | no | 11 |
   | After | 4, testable criteria and scope stated | 3, both repos would change | 2, isolated behavior | no | 15 |

4. One sentence naming the single answer that moved the score most, for example `Naming the three tester checks moved clarity from 2 to 4.`

5. `## Still missing`, only when the cap was reached.

## Step 6. Offer to write it back

- If the request came from an issue, `gh` is logged in, and the signed-in login equals the issue's `author.login` (checked in Step 2): ask, through the question tool when available and as a two-item numbered list otherwise, `Update issue #<n> with this body?` with options `Yes, replace the body` and `No, I will paste it myself`. On yes, write the five sections to a temporary file and run `gh issue edit <n> --repo <owner/repo> --body-file <file>` with the repository noted in Step 2, then print the issue URL. Any author can edit their own issue; no repository permission is needed.
- If the request came from an issue that someone else opened: do not offer the edit. Say `Issue #<n> was opened by <author.login>; only its author can replace its body from here. Paste the five sections into the issue yourself, or into your own tracker.`
- Otherwise say where to paste it: `Open <https://github.com/kpnemo/kaizen-tasks-assembly-line/issues/new?template=feature-request.yml> and paste each of the five sections into the field with the same name, or paste the whole body into your own tracker.`

Never apply labels, never comment on the issue, never change its title or state. Labels (`clarity:1..5`, `complexity:1..5`, `risk:1..5`, `arch-change`, `triaged`) and clarifying comments belong to the engineering triage skill.

## Tone

- Plain language. No engineering words: say "saved" not "persisted", "screen" not "view", "sign in" not "auth", "list" not "endpoint".
- One idea per question. A question with "and" in it is two questions.
- No praise. Never "great", "perfect", "good answer". Acknowledge by asking the next question.
- Do not explain the rubric or the scoring unless asked.
- Keep every message short enough to read in ten seconds.
