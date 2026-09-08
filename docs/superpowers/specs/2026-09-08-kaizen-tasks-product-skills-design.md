# Kaizen Tasks Product Skills: Design Spec

| Field | Value |
|---|---|
| Repo | `kaizen-tasks-product-skills`, folder `product-skills/` at the workshop root |
| Status | Approved design 2026-09-08 |
| Upstream | `webapp/docs/PRD.md` (sections 9, 10); rubric owned by `kaizen-tasks-assembly-line` at `rubric/readiness.md` |
| Downstream | `superpowers:writing-plans` produces `docs/superpowers/plans/` from this spec |

## 1. Purpose and scope

The take-home for product managers: two skills they run in Claude Code or Cowork, the readiness rubric they are measured against, the Part 3 templates, and synthetic data so everything works without real customer material. Packaged as a Claude Code plugin so it can be published to the company marketplace later without restructuring. Publishing itself is out of scope.

Approach decisions taken in design:

| # | Decision | Choice and reason |
|---|---|---|
| A1 | Surface | Claude Code skills; the same `SKILL.md` folders work in Claude Desktop and Cowork. In the session PMs clone the repo |
| A2 | Rubric | Vendored copy of the assembly-line rubric, `scripts/sync-rubric.sh`, CI warning on drift. Works offline in the room |
| A3 | Question style | One question at a time, through the question tool when the host offers it, plain text otherwise |
| A4 | Data | Three synthetic NICE contact-center interview transcripts and one sample PRD, written for the workshop |

## 2. Repo shape

```
product-skills/
  .claude-plugin/plugin.json      name kaizen-tasks-product-skills, version, description, author
  skills/
    refine-request/SKILL.md
    synthesize-interviews/SKILL.md
  rubric/readiness.md             vendored copy, same version line as upstream
  templates/part3/
    agentic-layer-canvas.md  agentic-layer-canvas.pdf
    plan-30-60-90.md         plan-30-60-90.pdf
    facilitator-sheet.md
  data/
    interviews/01-supervisor.md  02-agent.md  03-workforce-planner.md
    prd-sample.md
  scripts/
    sync-rubric.sh                fetch upstream rubric at a ref; --check compares versions
    build-pdf.mjs                 markdown templates to PDF
  out/                            skill outputs, git-ignored
  docs/superpowers/specs/, plans/
  .github/workflows/ci.yml
  README.md  CHANGELOG.md  package.json  .nvmrc  .gitignore
```

## 3. Skills

### 3.1 refine-request

Frontmatter: name `refine-request`, description "Interview me about a feature request until it is ready for engineering, then rewrite it in the request form", `argument-hint: <issue number | file path | pasted text>`.

Behavior:

1. Load `rubric/readiness.md` from the skill's repo. Take the request from a GitHub issue number (`gh issue view <n> --json title,body`, only if `gh` exists and is logged in), a file path, or the text after the command. If none is given, ask for it.
2. Score it with the rubric's procedure. Show the scores and one-line reasons as the "before" row.
3. Interview. One question per turn. Use the host's question tool when available, with three or four concrete options plus a free-text choice, and plain text otherwise. Question order follows the rubric's clarity anchors: user and moment, observable behavior, done criteria, out of scope, then complexity and risk probes only if the answers imply a schema, auth, or AI change. Never ask what is already answered. After each answer, re-score silently.
4. Stop when clarity is 4 or higher, scope is stated, and at least three testable acceptance criteria exist. Cap at eight questions; at the cap, output what exists and say what is still missing.
5. Output: the rewritten request in the issue form's five sections, then a before-and-after score table, then one sentence on what changed the score most.
6. If the request came from an issue and `gh` is available, offer to update it with `gh issue edit <n> --body-file`, which any author can do for their own issue. Otherwise say where to paste it. Never apply labels or comment on the issue; that is the engineering triage's job.

Tone rules in the skill: plain language, no engineering jargon, one idea per question, no praise.

### 3.2 synthesize-interviews

Frontmatter: name `synthesize-interviews`, description "Turn customer interview transcripts into jobs, pains with quotes, opportunities, and ready-to-file feature requests", `argument-hint: <transcript paths...>`.

Behavior:

1. Read every transcript given; if none, offer the three in `data/interviews/`.
2. Extract per transcript, then merge across transcripts: jobs to be done in the "when I, I want to, so I can" form; pains, each with one to three verbatim quotes attributed by role and transcript, never paraphrased inside quotation marks; opportunities, each tied to the pains it addresses, scored by frequency (how many transcripts) and severity (the rubric's risk-style 1 to 5 anchor for impact on the customer's job).
3. Write two or three candidate feature requests for the top opportunities in the issue form's five sections, each pre-scored with the rubric and shown with its score.
4. Write everything to `out/<YYYY-MM-DD>-synthesis.md` and print the opportunity table.
5. Offer to run `refine-request` on any candidate.

### 3.3 Shared rubric behavior

Both skills read the vendored rubric and follow its procedure section verbatim, so a PM's local score and the engineering triage score agree for the same text. The skills print the rubric version they used.

## 4. Rubric sync

`scripts/sync-rubric.sh [ref]` downloads `rubric/readiness.md` from `https://raw.githubusercontent.com/kpnemo/kaizen-tasks-assembly-line/<ref>/rubric/readiness.md` (default `main`) over the local copy. `--check` downloads to a temp file and compares the `version:` lines, printing a warning and exiting 0 when they differ, so CI surfaces drift without blocking. The README tells PMs that engineering owns the rubric and how to pull the latest.

## 5. Part 3 templates

`agentic-layer-canvas.md`: one page. Four columns, discover, define, deliver, learn. Four rows: what I do today in this phase; what is slow, repetitive, or error-prone; a candidate agent or skill, stated as "an agent that ... so that ..."; evidence needed to trust it. A footer row for the team's top three candidates.

`plan-30-60-90.md`: three columns, 30, 60, 90 days. Each column has up to three commitments with an owner, a measurable signal, and a first step. A header for the team name and date.

`facilitator-sheet.md`: the 45-minute timing (5 framing, 15 canvas in groups of three or four, 10 prioritize by value and effort on a two-by-two, 10 fill the plan, 5 share), the prompt to read for each column, the prioritization rule (top three by value over effort go to the plan), and the closing line that the plan belongs to the team. No ongoing commitment from the facilitator is written anywhere.

`scripts/build-pdf.mjs` renders the two templates to PDF at A4 landscape for the canvas and A4 portrait for the plan, using Playwright's Chromium and a minimal print stylesheet with large type. The PDFs are committed and rebuilt by `npm run pdf`.

## 6. Synthetic data

Three interview transcripts, each 60 to 90 exchanges between an interviewer and one person, in a fictional mid-size contact center running a NICE-style CXone platform. Names and companies are invented.

| File | Persona | Themes planted |
|---|---|---|
| 01-supervisor | Team supervisor, 12 agents, chat and voice | Coaching prep takes hours; cannot see which agents struggle with which intents; after-call work backlog |
| 02-agent | Frontline agent, 18 months | Switching between five tools per interaction; knowledge base out of date; wrap-up codes feel arbitrary |
| 03-workforce-planner | Workforce planner, weekly schedules | Forecast misses on promotional days; shift-swap requests by email; intraday reallocation is manual |

Each transcript contains at least two quotable pains per theme and one contradiction between personas so the synthesis has to weigh evidence.

`prd-sample.md`: a two-page PRD for a fictional "Coaching insights" feature, written at clarity 3, so `refine-request` has a realistic starting point beyond the workshop's own requests.

## 7. README

Sections, one page total: what this is; install in three steps (clone, open the folder in Claude Code or add it to Cowork, run `/refine-request`); the two skills with one example each; the rubric, who owns it, and how to sync; Part 3 templates; how to propose a new skill (open a pull request with a `skills/<name>/SKILL.md`); a one-line note that the company marketplace and Enterprise connectors are the distribution path after the session.

## 8. CI

`.github/workflows/ci.yml` on pull requests and pushes to `main`: check every `skills/*/SKILL.md` has frontmatter with `name` and `description`; run `scripts/sync-rubric.sh --check` and surface the warning; run `npm run pdf` and fail if the PDFs are missing or empty; markdown lint on `README.md` and the templates.

## 9. Verification items

| # | Check | Status | Fallback |
|---|---|---|---|
| P1 | A plugin-shaped repo runs its skills when opened directly as a project in Claude Code | Open, verified in the first task by running `/refine-request` from a fresh clone | Add a `.claude/skills` symlink layer to the same folders |
| P2 | The same `SKILL.md` folders load in Claude Desktop and Cowork | Open, verified by Mike before the session | README documents copying the folders into the Desktop skills location |
| P3 | Playwright PDF rendering runs in CI on Ubuntu without extra fonts | Open, verified by the first CI run | Bundle a single open font in the print stylesheet |

## 10. Out of scope

Marketplace publishing, Enterprise connectors, real customer data, any engineering harness, slides.
