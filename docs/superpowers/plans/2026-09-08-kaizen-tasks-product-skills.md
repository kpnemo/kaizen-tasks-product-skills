# Kaizen Tasks Product Skills Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build the `kaizen-tasks-product-skills` repository: a plugin-shaped repo with the `refine-request` and `synthesize-interviews` skills, a vendored copy of the engineering readiness rubric with a drift check, the Part 3 canvas, plan, and facilitator templates with committed PDFs, three synthetic interview transcripts and a sample PRD, a one-page README, and CI.

**Architecture:** Everything is files that Claude Code, Claude Desktop, and Cowork read directly: two `SKILL.md` folders under `skills/`, a `.claude-plugin/plugin.json` manifest so the same folder is a plugin, markdown data and templates, and three small scripts (a bash rubric sync with `--check`, a bash front-matter check, and a Node PDF builder on Playwright's Chromium). There is no application code. The rubric is owned by the assembly-line lane and copied here at the same relative path; both skills read it and print its version so a PM's local score matches the engineering triage score.

**Tech Stack:** Markdown skills for Claude Code, bash, Node 24 with ESM, Playwright 1.63 (Chromium `page.pdf`), marked 18, markdownlint-cli2 0.23, Prettier 3.9, ESLint 10 flat config, TypeScript 5.9 in `checkJs` strict mode, GitHub Actions.

**Spec:** `/Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/product-skills/docs/superpowers/specs/2026-09-08-kaizen-tasks-product-skills-design.md`. Upstream: `/Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/webapp/docs/PRD.md` sections 9, 10, 12; the rubric and issue form are defined in `/Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/webapp/docs/superpowers/specs/2026-09-08-kaizen-tasks-assembly-line-design.md` sections 5 and 4.1; cross-lane rules in `/Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/webapp/docs/superpowers/plans/2026-09-08-master-plan.md`.

## Global Constraints

Every lane plan inherits these. They are copied from the specs and from Mike's standing rules.

- Node 24 LTS everywhere, pinned by `.nvmrc` containing `24`; `engines.node` is `>=24 <25`. Run `nvm use` before any npm command.
- Branching: work on `develop`. Feature branches come off `develop` and merge by pull request. `main` receives only `develop` by pull request after staging verification. Nothing is ever pushed to `main` directly. `develop` is the default branch on GitHub.
- Secrets never enter a repository. `ANTHROPIC_API_KEY`, `JWT_SECRET`, `ADMIN_TOKEN`, `SEED_DEMO_PASSWORD`, and any GitHub token live only in Railway variables and in git-ignored local `.env` files. Mike pastes them.
- Railway: only the new project `kaizen-tasks`. Never link to, modify, or redeploy any other project in the account. Railway operations follow the official `use-railway` skill.
- GitHub: repos `kpnemo/kaizen-tasks-api`, `kpnemo/kaizen-tasks-web`, `kpnemo/kaizen-tasks-assembly-line`, `kpnemo/kaizen-tasks-product-skills`, all public.
- TypeScript strict in every repo. ESM. Prettier formatting. ESLint flat config.
- Test first: every task shows a failing test before implementation. Tests that hit external services are opt-in and excluded from CI.
- Docs are part of every change: `CHANGELOG.md` `[Unreleased]` bullet, regenerated OpenAPI or types where applicable, ADR when an architectural file changes. The docs-check script enforces it locally and in CI.
- Migrations are additive only (ADR 0004 in the API repo).
- The API service pins `PORT=3000`; the web service proxies `/api/*` to `http://api.railway.internal:3000`.
- The workshop root folder is not a repository. `webapp/` is `kaizen-tasks-assembly-line`; `webapp/backend/` and `webapp/frontend/` are nested, git-ignored repositories; `product-skills/` is at the root.

How these apply to this repository, which has no application code, no Railway service, and no secrets:

- "TypeScript strict" is met by `tsconfig.json` with `allowJs`, `checkJs`, and `strict` over the one `.mjs` script, run by `npm run typecheck`. ESM is `"type": "module"`. Prettier and ESLint flat config cover the script and the config file.
- "Test first" at script level: every task first runs the check that will verify its deliverable and shows it failing, then writes the deliverable, then shows the check passing. The checks are `npm test` (front matter), `scripts/sync-rubric.sh --check`, `npm run pdf`, `npm run lint`, and `grep` counts on the data files.
- "Docs are part of every change" means every task adds one bullet under `## [Unreleased]` in `CHANGELOG.md`. There is no OpenAPI and no ADR here.
- Nothing in this plan pushes to `main`. All commits land on `develop` in `/Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/product-skills`.

---

## Working rules for every task

- Repo root: `/Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/product-skills`. Every command below starts with `cd` to that path. The shell must have nvm loaded (`source ~/.nvm/nvm.sh` if `nvm` is not found).
- Node 24 is not installed on this machine yet (`nvm ls` shows only the system Node 26). Task 1 installs it. After that, run `nvm use` in every new shell before `npm`.
- Commit with `git commit -F -` and a heredoc so the trailer line is always the last paragraph of the message (shown in each task's commit step).
- Branch: commit directly on `develop` and push it at the end of every task with `git push origin develop`. The remote `origin` (`https://github.com/kpnemo/kaizen-tasks-product-skills.git`, default branch `develop`) already exists from L3-M0. Nothing is ever pushed to `main`.

## File map

| Path | Responsibility | Task |
|---|---|---|
| `.nvmrc`, `package.json`, `package-lock.json`, `.gitignore`, `CHANGELOG.md`, `.markdownlint-cli2.jsonc`, `.prettierrc`, `.prettierignore`, `eslint.config.js`, `tsconfig.json` | Repo scaffold, scripts `pdf`, `sync-rubric`, `lint`, `test`, `typecheck` | 1 |
| `scripts/check-skills.sh` | Front matter check for every `skills/*/SKILL.md`; `npm test` | 1 |
| `.claude-plugin/plugin.json` | Plugin manifest | 2 |
| `skills/refine-request/SKILL.md` | The hands-on skill: interview one request to readiness | 3 |
| `skills/synthesize-interviews/SKILL.md` | The take-home skill: transcripts to jobs, pains, opportunities, candidate requests | 4 |
| `data/interviews/01-supervisor.md` | Synthetic transcript, team supervisor | 5 |
| `data/interviews/02-agent.md` | Synthetic transcript, frontline agent | 6 |
| `data/interviews/03-workforce-planner.md` | Synthetic transcript, workforce planner | 7 |
| `data/prd-sample.md` | Sample PRD "Coaching insights" at clarity 3 | 8 |
| `templates/part3/agentic-layer-canvas.md`, `plan-30-60-90.md`, `facilitator-sheet.md` | Part 3 templates | 9 |
| `scripts/build-pdf.mjs`, `templates/part3/agentic-layer-canvas.pdf`, `templates/part3/plan-30-60-90.pdf` | PDF build and the committed PDFs | 10 |
| `README.md` | One page for PMs | 11 |
| `rubric/readiness.md`, `scripts/sync-rubric.sh` | Vendored rubric and the sync and drift script | 12 |
| `.github/workflows/ci.yml` | CI with the four checks | 13 |
| `docs/superpowers/specs/...-product-skills-design.md` section 9 | P1 verification result recorded | 14 |

## Task order and the one cross-lane gate

Tasks 1 to 11 depend on nothing outside this repository. Task 12 (rubric vendoring) is the only task gated on another lane: it starts when the master plan's L4-M1 condition is true (`webapp/rubric/readiness.md` with a `version:` line is committed on the assembly-line repo's `develop`). Task 13 (CI) runs `sync-rubric.sh --check`, so it follows Task 12; Task 14 exercises the skills, which need the rubric, so it is last. If L4-M1 has not landed when Task 11 is done, stop the lane and report "L5 waiting on L4-M1" to the orchestrator rather than writing a rubric here; the rubric text is owned by the assembly-line lane.

Interfaces this lane assumes about other lanes (all from the master plan section 4):

- Rubric: `rubric/readiness.md` in `kpnemo/kaizen-tasks-assembly-line`, written by the assembly-line plan's Task 2. Front matter `version: 1` (an integer, not semver; it changes whenever an anchor, the formula, or the output shape changes). Headings, exactly: `## 1. Scales` with the tables `### Clarity`, `### Complexity`, `### Risk`; `## 2. Architecture change test`; `## 3. Readiness`; `## 4. Procedure` with `### Repo layouts used for scoring`; `## 5. Clarifying questions`. Formula in section 3: `readiness = clarity * 2 + (6 - complexity) + (6 - risk)`, range 4 to 20. Output shape from section 4, step 7: `{ clarity, complexity, risk, archChange, readiness, reasons: { clarity, complexity, risk }, questions: [] }`, where `questions` holds two or three clarifying questions only when clarity is below 3 and is empty otherwise. Raw URL `https://raw.githubusercontent.com/kpnemo/kaizen-tasks-assembly-line/<ref>/rubric/readiness.md`; local nested path `/Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/webapp/rubric/readiness.md`.
- Issue form fields, in order, from the assembly-line plan's Task 3 (`.github/ISSUE_TEMPLATE/feature-request.yml`): ids `problem`, `behavior`, `acceptance`, `out_of_scope`, `role` with labels `Problem`, `Proposed behavior`, `Acceptance criteria`, `Out of scope`, `Your role`; the first three required, the last two optional. GitHub renders a submitted form as `### <label>` sections, so the skills write exactly the headings `### Problem`, `### Proposed behavior`, `### Acceptance criteria`, `### Out of scope`, `### Your role`, which are also the headings of the assembly-line seeds and what its `triage-requests` skill reads. Feature requests are filed in `kpnemo/kaizen-tasks-assembly-line`, so a bare issue number means an issue there.
- Labels applied by engineering triage only, never by these skills: `feature-request`, `clarity:1..5`, `complexity:1..5`, `risk:1..5`, `arch-change`, `triaged`, `implementing`, `shipped`, `triage-board`.

---

### Task 1: Repository scaffold and the front matter check

**Files:**
- Create: `.nvmrc`
- Create: `package.json`
- Create: `package-lock.json` (generated by `npm install`)
- Modify: `.gitignore` (currently `node_modules/`, `out/`, `.DS_Store`)
- Create: `CHANGELOG.md`
- Create: `.markdownlint-cli2.jsonc`
- Create: `.prettierrc`
- Create: `.prettierignore`
- Create: `eslint.config.js`
- Create: `tsconfig.json`
- Create: `scripts/check-skills.sh`
- Test: `npm test`, `npm run lint`, `npm run typecheck`

**Interfaces:**
- Consumes: nothing.
- Produces: npm scripts `pdf` (`node scripts/build-pdf.mjs`, script written in Task 10), `sync-rubric` (`bash scripts/sync-rubric.sh`, script written in Task 12), `lint` (markdownlint on `README.md` and `templates/**/*.md`, then Prettier and ESLint on `scripts/**/*.mjs` and `eslint.config.js`), `typecheck` (`tsc` in `checkJs` strict over the same files), `test` (`bash scripts/check-skills.sh`). `scripts/check-skills.sh` exits 1 with `FAIL: ...` lines or 0 with one `ok: <path> (<name>)` line per skill; it also requires the front matter `name` to equal the skill folder name.

- [ ] **Step 1: Install Node 24 and confirm the shell is on it**

Run:

```bash
cd /Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/product-skills && printf '24\n' > .nvmrc && nvm install 24 && nvm use && node --version
```

Expected: the last line is `v24.` followed by a minor and patch number (for example `v24.11.1`). `nvm use` prints `Found '/Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/product-skills/.nvmrc' with version <24>` and `Now using node v24.x.y`.

- [ ] **Step 2: Run the checks that do not exist yet, to see them fail**

Run:

```bash
cd /Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/product-skills && nvm use >/dev/null && npm test; echo "exit=$?"
```

Expected: `npm error Missing script: "test"` (or `npm error enoent Could not read package.json`), then `exit=1`.

- [ ] **Step 3: Write `package.json`**

Create `package.json`:

```json
{
  "name": "kaizen-tasks-product-skills",
  "version": "0.1.0",
  "private": true,
  "description": "Product skills for the Kaizen Tasks workshop: refine-request, synthesize-interviews, the readiness rubric, and the Part 3 templates",
  "type": "module",
  "license": "MIT",
  "engines": {
    "node": ">=24 <25"
  },
  "scripts": {
    "pdf": "node scripts/build-pdf.mjs",
    "sync-rubric": "bash scripts/sync-rubric.sh",
    "lint": "npm run lint:md && npm run lint:js",
    "lint:md": "markdownlint-cli2 \"README.md\" \"templates/**/*.md\"",
    "lint:js": "prettier --check --no-error-on-unmatched-pattern \"scripts/**/*.mjs\" eslint.config.js && eslint .",
    "typecheck": "tsc -p tsconfig.json",
    "test": "bash scripts/check-skills.sh"
  },
  "devDependencies": {
    "@eslint/js": "10.0.1",
    "@types/node": "24.13.3",
    "eslint": "10.10.0",
    "globals": "17.12.0",
    "markdownlint-cli2": "0.23.2",
    "marked": "18.0.12",
    "playwright": "1.63.0",
    "prettier": "3.9.6",
    "typescript": "5.9.3"
  }
}
```

- [ ] **Step 4: Write the lint, format, and type configuration**

Create `.markdownlint-cli2.jsonc`:

```jsonc
{
  // MD013 (line length) is off because table rows are long.
  // MD033 (inline HTML) is off in case a template cell needs a <br>.
  // MD060 (table column style, new in markdownlint 0.41) is off because the
  // print templates use compact pipes and empty cells on purpose.
  "config": {
    "default": true,
    "MD013": false,
    "MD033": false,
    "MD060": false
  },
  "ignores": ["node_modules/**", "out/**"]
}
```

Create `.prettierrc`:

```json
{
  "singleQuote": true,
  "semi": true,
  "printWidth": 100,
  "trailingComma": "all"
}
```

Create `.prettierignore`:

```
node_modules/
out/
package-lock.json
templates/part3/*.pdf
```

Create `eslint.config.js`:

```js
import js from '@eslint/js';
import globals from 'globals';

export default [
  js.configs.recommended,
  {
    files: ['scripts/**/*.mjs', 'eslint.config.js'],
    languageOptions: {
      ecmaVersion: 'latest',
      sourceType: 'module',
      globals: { ...globals.node },
    },
  },
  { ignores: ['node_modules/**', 'out/**'] },
];
```

Create `tsconfig.json` (type-checks the JavaScript script under `strict`; there are no `.ts` files in this repo):

```json
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "NodeNext",
    "moduleResolution": "NodeNext",
    "allowJs": true,
    "checkJs": true,
    "strict": true,
    "noEmit": true,
    "skipLibCheck": true,
    "types": ["node"]
  },
  "include": ["scripts/**/*.mjs", "eslint.config.js"]
}
```

`eslint.config.js` is included so `tsc` has an input before Task 10 adds the script; `tsc` exits 2 with `TS18003: No inputs were found` when `include` matches nothing.

- [ ] **Step 5: Extend `.gitignore` and write `CHANGELOG.md`**

Replace `.gitignore` with:

```
node_modules/
out/
.DS_Store
.env
.env.*
```

Create `CHANGELOG.md`:

```markdown
# Changelog

All notable changes to this repository are recorded here. The format follows Keep a Changelog; versions follow semantic versioning and match `.claude-plugin/plugin.json`.

## [Unreleased]

### Added

- Repository scaffold: Node 24 pin, npm scripts `pdf`, `sync-rubric`, `lint`, `typecheck`, `test`, markdown lint, Prettier, ESLint flat config, `checkJs` strict, and the skill front matter check.
```

- [ ] **Step 6: Write `scripts/check-skills.sh`**

Create `scripts/check-skills.sh`:

```bash
#!/usr/bin/env bash
# Verify every skills/*/SKILL.md starts with YAML front matter that has
# name and description, and that name equals the folder name.
# Exit 1 with FAIL lines on any problem; exit 0 with one ok line per skill.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

shopt -s nullglob
files=(skills/*/SKILL.md)
if [ "${#files[@]}" -eq 0 ]; then
  echo "FAIL: no skills found under skills/"
  exit 1
fi

status=0
for f in "${files[@]}"; do
  bad=0
  dir="$(basename "$(dirname "$f")")"
  if [ "$(head -n1 "$f")" != "---" ]; then
    echo "FAIL: $f does not start with front matter"
    status=1
    continue
  fi
  # Lines between the first '---' and the next '---'.
  fm="$(awk 'NR==1 {next} /^---$/ {exit} {print}' "$f")"
  name="$(printf '%s\n' "$fm" | sed -n 's/^name:[[:space:]]*//p' | head -n1)"
  desc="$(printf '%s\n' "$fm" | sed -n 's/^description:[[:space:]]*//p' | head -n1)"
  if [ -z "$name" ]; then
    echo "FAIL: $f has no name in its front matter"
    bad=1
  elif [ "$name" != "$dir" ]; then
    echo "FAIL: $f name '$name' does not match folder '$dir'"
    bad=1
  fi
  if [ -z "$desc" ]; then
    echo "FAIL: $f has no description in its front matter"
    bad=1
  fi
  if [ "$bad" -eq 0 ]; then
    echo "ok: $f ($name)"
  else
    status=1
  fi
done
exit "$status"
```

Then:

```bash
cd /Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/product-skills && chmod +x scripts/check-skills.sh
```

- [ ] **Step 7: Install dependencies and run every check**

Run:

```bash
cd /Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/product-skills && nvm use >/dev/null && npm install && npm run lint && npm run typecheck && npm test; echo "exit=$?"
```

Expected, in order:

- `npm install` ends with `added N packages` and creates `package-lock.json` and `node_modules/`.
- `lint:md` prints `markdownlint-cli2 v0.23.2 (markdownlint v0.41.1)`, `Finding: README.md templates/**/*.md !node_modules/** !out/**`, `Linting: 0 files`, `Summary: 0 issues in 0 files` (no markdown exists yet).
- `lint:js` prints `Checking formatting...` and `All matched files use Prettier code style!` (the `scripts/**/*.mjs` glob matches nothing yet, which `--no-error-on-unmatched-pattern` allows); `eslint .` prints nothing.
- `typecheck` prints nothing.
- `npm test` prints `FAIL: no skills found under skills/` and `exit=1`. This is the failing test that Task 3 turns green.

- [ ] **Step 8: Commit**

```bash
cd /Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/product-skills && git add .nvmrc package.json package-lock.json .gitignore CHANGELOG.md .markdownlint-cli2.jsonc .prettierrc .prettierignore eslint.config.js tsconfig.json scripts/check-skills.sh && git commit -F - <<'MSG'
chore: scaffold repository with npm scripts and skill front matter check

Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>
MSG
/Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/product-skills && git push origin develop
```

Expected: `git status --short` prints nothing afterwards; `git log --oneline -1` shows the subject above.

---

### Task 2: Plugin manifest

**Files:**
- Create: `.claude-plugin/plugin.json`
- Modify: `CHANGELOG.md` (one bullet under `## [Unreleased]` / `### Added`)
- Test: `node -p` reads the manifest fields

**Interfaces:**
- Consumes: nothing.
- Produces: plugin name `kaizen-tasks-product-skills`, version `0.1.0` (kept equal to `package.json` `version`). Skills are auto-discovered from `skills/*/SKILL.md`; the manifest declares no custom paths.

- [ ] **Step 1: Run the manifest check and watch it fail**

Run:

```bash
cd /Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/product-skills && nvm use >/dev/null && node -p 'const m=require("./.claude-plugin/plugin.json"); [m.name, m.version, m.description.length > 20, m.author.name].join(" | ")'; echo "exit=$?"
```

Expected: `Error: Cannot find module './.claude-plugin/plugin.json'` and `exit=1`.

- [ ] **Step 2: Write the manifest**

Create `.claude-plugin/plugin.json`:

```json
{
  "name": "kaizen-tasks-product-skills",
  "version": "0.1.0",
  "description": "Product skills for the Kaizen Tasks workshop: refine a feature request against the engineering readiness rubric, and synthesize customer interviews into ready-to-file requests",
  "author": {
    "name": "Mike Bogdanovsky",
    "url": "https://github.com/kpnemo"
  },
  "homepage": "https://github.com/kpnemo/kaizen-tasks-product-skills",
  "repository": "https://github.com/kpnemo/kaizen-tasks-product-skills",
  "license": "MIT",
  "keywords": ["product-management", "feature-requests", "readiness", "customer-interviews", "workshop"]
}
```

The manifest must stay in `.claude-plugin/`; the `skills/` folder stays at the repo root, never inside `.claude-plugin/`.

- [ ] **Step 3: Run the manifest check again**

Run the Step 1 command again.

Expected: `kaizen-tasks-product-skills | 0.1.0 | true | Mike Bogdanovsky` and `exit=0`.

Also confirm the two versions agree:

```bash
cd /Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/product-skills && test "$(node -p 'require("./package.json").version')" = "$(node -p 'require("./.claude-plugin/plugin.json").version')" && echo "versions match"
```

Expected: `versions match`.

- [ ] **Step 4: Changelog bullet**

Add under `### Added` in `CHANGELOG.md`:

```markdown
- Plugin manifest `.claude-plugin/plugin.json` so the repository loads as a Claude Code plugin.
```

- [ ] **Step 5: Commit**

```bash
cd /Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/product-skills && git add .claude-plugin/plugin.json CHANGELOG.md && git commit -F - <<'MSG'
feat: add plugin manifest

Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>
MSG
/Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/product-skills && git push origin develop
```

---
### Task 3: The `refine-request` skill

**Files:**
- Create: `skills/refine-request/SKILL.md`
- Modify: `CHANGELOG.md`
- Test: `npm test` (front matter check turns green here)

**Interfaces:**
- Consumes: `rubric/readiness.md` (Task 12) at `${CLAUDE_PLUGIN_ROOT}/rubric/readiness.md` or `rubric/readiness.md` under the project root; its front matter `version:` line; its sections `## 1. Scales` (tables `### Clarity`, `### Complexity`, `### Risk`), `## 2. Architecture change test`, `## 3. Readiness` (`readiness = clarity * 2 + (6 - complexity) + (6 - risk)`), `## 4. Procedure`, `## 5. Clarifying questions`; its output shape `{ clarity, complexity, risk, archChange, readiness, reasons: { clarity, complexity, risk }, questions: [] }`. `scripts/sync-rubric.sh` (Task 12) named in the missing-rubric message. `gh` CLI when present; feature-request issues live in `kpnemo/kaizen-tasks-assembly-line`.
- Produces: slash command `/refine-request`, invoked with `$ARGUMENTS`. The report's five headings `### Problem`, `### Proposed behavior`, `### Acceptance criteria`, `### Out of scope`, `### Your role`; the `synthesize-interviews` skill (Task 4) hands candidates to this skill as pasted text and uses the same headings. First output line `Rubric version: <value>`.

- [ ] **Step 1: Confirm the check fails for the missing skill**

Run:

```bash
cd /Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/product-skills && nvm use >/dev/null && npm test; echo "exit=$?"
```

Expected: `FAIL: no skills found under skills/`, `exit=1`.

- [ ] **Step 2: Write the skill**

Create `skills/refine-request/SKILL.md` with exactly this content. The description string is fixed by the spec; do not rewrite it into "Use when" form.

````markdown
---
name: refine-request
description: Interview me about a feature request until it is ready for engineering, then rewrite it in the request form
argument-hint: "<issue number | file path | pasted text>"
---

# Refine a feature request

Take one feature request from a product manager, score it with the shared readiness rubric, ask one question at a time until it would score as ready, and hand back the request rewritten in the form engineering triages. The PM's local score and the engineering triage score come from the same rubric text, so they agree for the same request.

Request source given with the command: `$ARGUMENTS`

## Step 1. Load the rubric

Read the rubric before reading the request. Look in this order and use the first file that exists:

1. `${CLAUDE_PLUGIN_ROOT}/rubric/readiness.md` when the `CLAUDE_PLUGIN_ROOT` environment variable is set (the plugin is installed).
2. `rubric/readiness.md` under the project root, the folder that contains `skills/refine-request/` (the repository is opened directly).

If neither exists, stop and print exactly: `The readiness rubric is missing. From the repo root run scripts/sync-rubric.sh, then run /refine-request again.` Do not score without the rubric.

Take the value of the `version:` line in the rubric's front matter. Print `Rubric version: <value>` as the first line of the reply, and repeat it in the final report.

Follow the rubric's Procedure section (`## 4. Procedure`) as written every time a score is produced. Do not shorten, reorder, or paraphrase it. The rubric's Scales section (`## 1. Scales`, tables `### Clarity`, `### Complexity`, `### Risk`), its Architecture change test (`## 2.`), and its Readiness section (`## 3.`, `readiness = clarity * 2 + (6 - complexity) + (6 - risk)`, range 4 to 20) are the only definitions of clarity, complexity, risk, architecture change, and readiness used here. Produce the rubric's output shape `{ clarity, complexity, risk, archChange, readiness, reasons: { clarity, complexity, risk }, questions: [] }` internally for every score; show it only in the tables below. The rubric's `questions` array (two or three, only while clarity is below 3, from `## 5. Clarifying questions`) is material for the interview in Step 4, not a limit on it: the interview keeps asking one question at a time past clarity 3 until the stop condition in Step 4, up to eight questions.

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
- Otherwise say where to paste it: `Paste the five sections into the Feature request form of the kaizen-tasks-assembly-line repository, or into your own tracker.`

Never apply labels, never comment on the issue, never change its title or state. Labels (`clarity:1..5`, `complexity:1..5`, `risk:1..5`, `arch-change`, `triaged`) and clarifying comments belong to the engineering triage skill.

## Tone

- Plain language. No engineering words: say "saved" not "persisted", "screen" not "view", "sign in" not "auth", "list" not "endpoint".
- One idea per question. A question with "and" in it is two questions.
- No praise. Never "great", "perfect", "good answer". Acknowledge by asking the next question.
- Do not explain the rubric or the scoring unless asked.
- Keep every message short enough to read in ten seconds.
````

- [ ] **Step 3: Run the front matter check**

Run:

```bash
cd /Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/product-skills && nvm use >/dev/null && npm test; echo "exit=$?"
```

Expected: `ok: skills/refine-request/SKILL.md (refine-request)` and `exit=0`.

Also confirm the fixed strings the spec requires are present:

```bash
cd /Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/product-skills && grep -c 'gh issue edit' skills/refine-request/SKILL.md && grep -c 'The cap is eight' skills/refine-request/SKILL.md && grep -c '^ *### Problem$' skills/refine-request/SKILL.md && grep -cF 'readiness = clarity * 2 + (6 - complexity) + (6 - risk)' skills/refine-request/SKILL.md && grep -c -- '--repo kpnemo/kaizen-tasks-assembly-line' skills/refine-request/SKILL.md
```

Expected: `1`, `1`, `1`, `1`, `1` (the heading sits in an indented code block, hence the leading-space allowance; the last two confirm the rubric formula is cited and the issue lookup targets the assembly-line repository).

- [ ] **Step 4: Changelog bullet**

Add under `### Added` in `CHANGELOG.md`:

```markdown
- `refine-request` skill: scores a request with the rubric, interviews one question at a time to readiness, rewrites it in the issue form's five sections, and offers `gh issue edit` for the author's own issue.
```

- [ ] **Step 5: Commit**

```bash
cd /Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/product-skills && git add skills/refine-request/SKILL.md CHANGELOG.md && git commit -F - <<'MSG'
feat: add refine-request skill

Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>
MSG
/Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/product-skills && git push origin develop
```

---
### Task 4: The `synthesize-interviews` skill

**Files:**
- Create: `skills/synthesize-interviews/SKILL.md`
- Modify: `CHANGELOG.md`
- Test: `npm test`

**Interfaces:**
- Consumes: the rubric as in Task 3; `data/interviews/01-supervisor.md`, `02-agent.md`, `03-workforce-planner.md` (Tasks 5 to 7), each with a header table whose `Role` row gives the persona used for quote attribution; the `refine-request` skill (Task 3) and its five headings.
- Produces: slash command `/synthesize-interviews`; output file `out/<YYYY-MM-DD>-synthesis.md` with the headings `## Jobs to be done`, `## Pains`, `## Contradictions`, `## Opportunities`, `## Candidate feature requests`, and each candidate under `### Candidate N: <title>`; severity anchors 1 to 5 defined in the skill; opportunity score = frequency times severity.

- [ ] **Step 1: Run the check and see only one skill**

Run:

```bash
cd /Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/product-skills && bash scripts/check-skills.sh | wc -l
```

Expected: `1` (only `refine-request` is listed).

- [ ] **Step 2: Write the skill**

Create `skills/synthesize-interviews/SKILL.md` with exactly this content:

````markdown
---
name: synthesize-interviews
description: Turn customer interview transcripts into jobs, pains with quotes, opportunities, and ready-to-file feature requests
argument-hint: "<transcript paths...>"
---

# Synthesize customer interviews

Read one or more interview transcripts and produce what a product manager needs to act on them: jobs to be done, pains backed by verbatim quotes, opportunities ranked by how many people have the pain and how badly it hurts, and two or three feature requests written in the form engineering triages, each pre-scored with the shared readiness rubric.

Transcript paths given with the command: `$ARGUMENTS`

## Step 1. Load the rubric

Read the rubric before the transcripts. Look in this order and use the first file that exists:

1. `${CLAUDE_PLUGIN_ROOT}/rubric/readiness.md` when the `CLAUDE_PLUGIN_ROOT` environment variable is set.
2. `rubric/readiness.md` under the project root, the folder that contains `skills/synthesize-interviews/`.

If neither exists, stop and print exactly: `The readiness rubric is missing. From the repo root run scripts/sync-rubric.sh, then run /synthesize-interviews again.`

Take the value of the `version:` line in the rubric's front matter. Print `Rubric version: <value>` as the first line of the reply and write it into the output file. When scoring a candidate request in Step 5, follow the rubric's Procedure section (`## 4. Procedure`) as written and produce its output shape `{ clarity, complexity, risk, archChange, readiness, reasons: { clarity, complexity, risk }, questions: [] }` internally; the rubric's Scales section (`## 1. Scales`, tables `### Clarity`, `### Complexity`, `### Risk`), its Architecture change test (`## 2.`), and its Readiness section (`## 3.`, `readiness = clarity * 2 + (6 - complexity) + (6 - risk)`, range 4 to 20) are the only definitions used.

## Step 2. Collect the transcripts

- If paths were given, read every one. For a path that does not exist, say which one and continue with the rest; if none remain, stop.
- If no paths were given, offer the bundled transcripts. Resolve the folder the same way as the rubric: `${CLAUDE_PLUGIN_ROOT}/data/interviews/` or `data/interviews/`. When the AskUserQuestion tool is available, ask `Which transcripts should I synthesize?` with multi-select on and one option per file, labelled with the file name and the persona from its header; in plain text otherwise, list them with numbers and say that the default is all of them. Proceed with the chosen files; with no choice, all of them.
- For each transcript, record its file name and the value of the `Role` row in its header table. Quotes are attributed by that role and file name.

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

Write everything to `out/<YYYY-MM-DD>-synthesis.md` under the project root, using today's date, creating `out/` if needed. If the file already exists, use `-2`, `-3`, and so on before `.md`. File layout:

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
````

- [ ] **Step 3: Run the check**

Run:

```bash
cd /Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/product-skills && nvm use >/dev/null && npm test; echo "exit=$?"
```

Expected:

```
ok: skills/refine-request/SKILL.md (refine-request)
ok: skills/synthesize-interviews/SKILL.md (synthesize-interviews)
exit=0
```

Also confirm the two skills use the same five headings:

```bash
cd /Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/product-skills && for h in 'Problem' 'Proposed behavior' 'Acceptance criteria' 'Out of scope' 'Your role'; do printf '%s: ' "$h"; grep -l "^ *### $h\$" skills/*/SKILL.md | wc -l; done
```

Expected: each heading followed by `2`.

- [ ] **Step 4: Changelog bullet**

Add under `### Added` in `CHANGELOG.md`:

```markdown
- `synthesize-interviews` skill: transcripts to jobs to be done, pains with verbatim quotes, an opportunity table scored by frequency and severity, and pre-scored candidate requests written to `out/`.
```

- [ ] **Step 5: Commit**

```bash
cd /Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/product-skills && git add skills/synthesize-interviews/SKILL.md CHANGELOG.md && git commit -F - <<'MSG'
feat: add synthesize-interviews skill

Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>
MSG
/Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/product-skills && git push origin develop
```

---
### Task 5: Synthetic transcript 01, team supervisor

**Files:**
- Create: `data/interviews/01-supervisor.md`
- Modify: `CHANGELOG.md`
- Test: `grep -c '^Interviewer:'` between 60 and 90; planted phrases present

**Interfaces:**
- Consumes: nothing.
- Produces: transcript format shared by Tasks 6 and 7: a header table with rows `Interviewee`, `Role`, `Company`, `Interviewer`, `Date`, `Length`; then exchanges as paragraphs starting `Interviewer:` and `<first name>:`. The `Role` row is what `synthesize-interviews` uses for attribution. Fictional setting shared by all three transcripts: Larkspur Home Warranty, about 380 agents on two sites (Columbus and Tulsa), a CXone-style platform; internal systems named Atlas (claims), DispatchHub (contractor dispatch), Compass (knowledge base), Ledger (customer records).

Planted content to verify after writing (spec section 6):

| Theme | Quotable pains (verbatim spans that must appear) |
|---|---|
| Coaching prep takes hours | `two hours of prep for a fifteen-minute conversation`; `I spend Sunday evenings building coaching packs` |
| Cannot see which agents struggle with which intents | `it does not tell me why`; `never the two shall meet`; `until I sat next to him for a shift` |
| After-call work backlog | `the wrap-up queue is longer than the call queue`; `agents being slow or the system being slow` |
| Contradiction seed (resolved against 02 and 03) | `the one thing in the system I actually trust` (Dana trusts disposition codes; the agent in 02 calls them arbitrary; the planner in 03 doubts them) |

- [ ] **Step 1: Run the count check and see it fail**

Run:

```bash
cd /Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/product-skills && n=$(grep -c '^Interviewer:' data/interviews/01-supervisor.md 2>/dev/null || echo 0); echo "exchanges=$n"; test "$n" -ge 60 -a "$n" -le 90; echo "exit=$?"
```

Expected: `exchanges=0`, `exit=1`.

- [ ] **Step 2: Write the transcript**

Create `data/interviews/01-supervisor.md` with exactly this content:

````markdown
# Interview 01: Team supervisor

| Field | Value |
|---|---|
| Interviewee | Dana Okafor (invented name) |
| Role | Team supervisor, 12 agents, chat and voice |
| Company | Larkspur Home Warranty (invented), contact center of about 380 agents across two sites, on a CXone-style platform |
| Interviewer | Product research, Kaizen Tasks workshop |
| Date | 2026-08-19 |
| Length | 52 minutes |

All names, companies, systems, and numbers are fictional and were written for the workshop.

---

Interviewer: Thanks for making the time, Dana. Can you start with what your job is and how long you have done it?

Dana: I supervise a team of twelve agents at Larkspur, Columbus site. Home warranty claims and service requests. I have been a supervisor for four years, and I was an agent for six before that, so ten years on the floor one way or another.

Interviewer: What does the team handle?

Dana: Mixed. Seven of mine are chat-first, five are voice-first, and everybody gets blended when the queues cross a threshold. Claims intake, claim status, contractor scheduling, cancellations, billing questions. Cancellations and billing are the ones that eat time.

Interviewer: How long have your agents been with you?

Dana: Two are under six months, most are one to three years, and I have one who has been here longer than me. Turnover on my team is lower than the site, which I put down to the one-on-ones, so I protect them.

Interviewer: Walk me through a normal day.

Dana: I am in at 7:30. First thing is the queue board and who called in sick. Then I check yesterday's after-call work backlog, because whatever did not get closed yesterday is sitting on today. Around nine I start my one-on-ones, two a day, twenty minutes each. Afternoons are escalations, the daily huddle, and whatever the site lead needs. Coaching prep happens whenever it happens, which usually means evenings.

Interviewer: What is the huddle?

Dana: Ten minutes at two o'clock. Numbers from the morning, anything that changed in the products, one thing to focus on. It is the only time all twelve are off the queue together, so I do not waste it on coaching individuals.

Interviewer: Let's stay on the one-on-ones. How do you prepare for one?

Dana: I pull the agent's scorecard from the quality tool. That gives me the quality score, handle time, adherence, and the last few evaluations. Then I go looking for interactions worth talking about. That is the slow part.

Interviewer: What does "go looking" involve?

Dana: I open the interaction search, filter by agent and date, and start listening or reading. For a voice agent I will listen to six or seven calls to find one worth coaching on. For chat I skim maybe fifteen transcripts.

Interviewer: How long does that take per agent?

Dana: Honestly, two hours of prep for a fifteen-minute conversation. That is the number I say to my manager and she does not believe me, but it is true. Twelve agents, one-on-ones weekly for the ones on a plan, fortnightly for the rest.

Interviewer: So per week?

Dana: If I do it properly, eight to ten hours of prep a week. I do not do it properly every week. I spend Sunday evenings building coaching packs, and I know that is not sustainable, and I know I am not the only supervisor doing it.

Interviewer: What is in a coaching pack?

Dana: One interaction that went well, one that did not, the scorecard, and what I want them to try for the next two weeks. It is a one-page thing. Finding the two interactions is ninety percent of the time.

Interviewer: Why is finding them hard?

Dana: Because the search does not know what I am looking for. I can filter by agent, date, queue, length. I cannot filter by "this is the kind of call where Jamal loses the customer." So I listen until I hit one.

Interviewer: Do the quality evaluations help point you at the right calls?

Dana: They tell me the score on the calls the evaluator happened to pick. Three or four a month per agent. The evaluator picks at random, so it is a random sample of a person's month, not the calls I need.

Interviewer: What is your relationship with the quality team like?

Dana: Good, and they are stretched thinner than I am. Two evaluators for the site. If I ask them to target a specific agent on a specific kind of call, they can do it once a quarter as a favor.

Interviewer: What would the calls you need look like?

Dana: The ones where the same thing goes wrong again. If an agent is fine on claim status and struggles every time somebody calls to cancel, I want the cancellation calls. Right now the only way I find that pattern is by sitting with them for a shift.

Interviewer: Do you know that pattern for each of your twelve today?

Dana: For maybe half of them. The other half I have a feeling about and no evidence. I know Jamal is slow. I did not know he was slow specifically on cancellations until I sat next to him for a shift in June, and that was one shift out of my year.

Interviewer: What did you find when you sat with him?

Dana: That he reads the whole cancellation policy article to the customer because he is scared of getting it wrong. Six minutes of reading. Nobody would ever see that in a handle-time number.

Interviewer: What does the system give you about intents, the reason for the contact?

Dana: The routing side knows the intent. The customer picked "cancel my plan" in the phone menu or the chat bot classified it, and it routed to a skill. That is in the routing reports. The quality side has scores. Intents are in the routing engine and the scores are in the quality tool, and never the two shall meet.

Interviewer: Have you tried to join them yourself?

Dana: I export both to spreadsheets once a month. It takes an afternoon and by the time it is done it is a month old. And the join is on the contact ID, which the quality export does not always include for chat.

Interviewer: What do you do with the joined sheet when it works?

Dana: I get a table of agent by intent with average score and handle time. That table is the most useful thing I have, and I make it four times a year at most.

Interviewer: What would you do with it if you had it every morning?

Dana: Pick who to coach and on what before I have listened to anything. Then listen to three calls instead of seven, because I would know which three.

Interviewer: Why a morning view rather than a monthly report?

Dana: Because I decide who to coach on Monday. A monthly report tells me what I should have done last month.

Interviewer: Let's talk about the dashboards you do have.

Dana: The supervisor dashboard tells me handle time, it does not tell me why. It shows me a red number for Jamal and a green number for Priya and leaves me to work out the rest.

Interviewer: What is "why" in your world?

Dana: Which contact reason. Which step in that contact reason. Whether the agent got stuck on the system or on the conversation. Half the time a long call is the claims system being slow, not the agent being slow, and the dashboard cannot tell those apart.

Interviewer: How do you tell them apart?

Dana: I ask the agent. Or I watch the screen recording, if quality captured that call, and I see them waiting on a spinner for forty seconds.

Interviewer: How often do you get to watch a screen recording?

Dana: Screen capture is on for a sample, maybe one call in ten. So if the call I care about was captured, I am lucky. Usually I am not.

Interviewer: Does coaching look different for chat?

Dana: Chat is easier to read and harder to coach. I can skim a transcript in a minute, but the failure is usually tone or three chats at once and dropping one, and a transcript does not show the three-at-once part. I coach chat from the transcript and from what the agent tells me.

Interviewer: Let's move to after-call work. Tell me what that is on your team.

Dana: After a voice call the agent has wrap-up time to finish notes, set the disposition code, and update the claim. Chat is similar but overlapping; they can be in two chats and finishing notes on a third. If they do not finish in the allowed wrap-up window, it goes into a backlog they have to clear later.

Interviewer: How big is the backlog?

Dana: By three in the afternoon the wrap-up queue is longer than the call queue. Most days. Yesterday I had forty-one open wrap-ups across the team at 3 pm.

Interviewer: What happens to them?

Dana: Agents finish them at end of shift, off the phones. Some park their notes in a text file during the day and paste them in at five. Which means the claim is not updated until five, and if the customer calls back at two, the next agent sees nothing.

Interviewer: Has that caused a problem with a customer?

Dana: Last month. A cancellation was in somebody's text file, the customer called back to check, the second agent saw an active plan and told them it was still active, and the customer thought we were refusing to cancel. That was an escalation to the site lead and a credit.

Interviewer: What is the allowed wrap-up window?

Dana: Ninety seconds on voice. It is not enough for a claim update that touches three systems, and it is too much for a status check. One number for every kind of call.

Interviewer: Is the backlog an agent problem or a system problem?

Dana: I cannot tell if after-call work is agents being slow or the system being slow. That is the honest answer. The claims system, Atlas, takes fifteen to twenty seconds to save. Three saves per call and your ninety seconds is gone before you have typed a word.

Interviewer: Have you raised that?

Dana: Every quarter. The answer is that wrap-up is a coaching issue. So I coach people to type faster into a system that takes twenty seconds to save.

Interviewer: What do you look at to manage the backlog?

Dana: A report I run at 3 pm and again at 5 pm. Count of open wrap-ups by agent. I message the top three and ask them to clear it. That is the whole process.

Interviewer: Do you know which calls are sitting in the backlog?

Dana: Only by count. Not by what they were about, and not which ones matter. A wrap-up on a cancellation that is not saved is a customer who might get billed again. A wrap-up on a status check is nothing. They look the same in the count.

Interviewer: Tell me about disposition codes. How do they fit into coaching?

Dana: They are the one thing in the system I actually trust. Agents pick them carefully because I coach on them. Every one-on-one I look at the code mix, and if somebody is coding "other" more than ten percent I ask why.

Interviewer: How many codes are there?

Dana: Around forty. Most calls fit one of ten. The codes are how I know what kind of work my team is doing, and what workforce planning uses to forecast the mix. If those are wrong everything is wrong, so I keep them honest.

Interviewer: How do you keep them honest?

Dana: I spot-check. Pull ten calls a week, listen, compare to the code. My team is at ninety-plus percent match. I am proud of that number.

Interviewer: When a call covers two things, which code should the agent pick?

Dana: The reason the customer called. If they called to cancel and also asked about a claim, it is a cancellation. I have told the team that. Whether every team has been told that, I do not know.

Interviewer: What tools are open on your screen during the day?

Dana: The supervisor dashboard, the quality tool, the interaction search, the workforce app for adherence, Atlas so I can see what the agent sees, email, and the chat tool where the agents message me. Seven, and I have two monitors.

Interviewer: What is the workaround you are least proud of?

Dana: The Sunday spreadsheet. Agent by intent. It should not need me.

Interviewer: What have you tried before to fix the prep time?

Dana: I asked for the quality evaluators to sample by intent. Once a quarter, as I said. I tried having agents flag their own hard calls; that lasted two weeks because nobody flags a call while they are on the next one. And I tried the AI call summaries that came with the last platform upgrade.

Interviewer: What happened with the summaries?

Dana: They are good at saying what the call was about and useless at saying what went wrong. "Customer called to cancel; agent explained policy; customer agreed to keep plan" is a summary of a great call and of a terrible one.

Interviewer: If you had one extra hour every day, where would it go?

Dana: Sitting with agents. Side-by-side is where I actually learn what is going wrong, and I get to do it twice a month.

Interviewer: What does the site lead measure you on?

Dana: Team handle time, quality score, adherence, attrition. Coaching hours are not a number anywhere, which is why they are the thing that gets squeezed.

Interviewer: Let's do the wish list. If you could change one thing about coaching prep, what would it be?

Dana: Show me, per agent, the contact reasons where they are below the team, and give me three interactions for each. That is the whole coaching pack. I would still write the plan myself.

Interviewer: What would "below the team" mean?

Dana: Quality score or handle time worse than the team average for that reason, over the last two weeks. Two weeks because one bad day should not show up, and a month is too slow to act on.

Interviewer: How would you know the suggestions were right?

Dana: I would listen to them. For the first month I would listen to everything it picked and compare it to what I would have picked. If it agreed with me eight times out of ten I would trust it.

Interviewer: And if it picked calls you disagreed with?

Dana: Then I want to be able to say so, and I want that to change what it picks next time. Otherwise I stop using it in a week.

Interviewer: Would you want the agent to see the same view?

Dana: Eventually. Not first. First I need to trust it, then I show it to them. If Jamal sees "you are bad at cancellations" before I have talked to him, that is a bad day for both of us.

Interviewer: What about the after-call backlog, one change?

Dana: Sort the backlog by what matters. Cancellations and billing first, status checks last. And tell me which ones have been open more than an hour. I would clear the top of that list myself if I had to.

Interviewer: Would a different wrap-up window per contact reason help?

Dana: Yes, and I have asked for that. Sixty seconds for status, three minutes for a cancellation. Workforce planning says it makes the forecast harder. I say the forecast is already wrong.

Interviewer: What about the intent-and-score join?

Dana: Do it for me. Every morning. Agent by contact reason, score and handle time, last two weeks, with the trend. If it were in the dashboard I would open the dashboard.

Interviewer: What are you worried about with anything automated here?

Dana: That it scores people on things that are not their fault. A slow claims system on a Tuesday afternoon is not Jamal's fault. If the tool cannot tell the difference, I will spend my one-on-ones defending the tool instead of coaching.

Interviewer: How would you know it could tell the difference?

Dana: Show me the hold time and the system time separately. If the call was long because the agent was waiting on a save, say that.

Interviewer: Is there anything the agents ask you for that you cannot give them?

Dana: A straight answer on why their handle time is red. I give them a guess. They know it is a guess.

Interviewer: How do the agents feel about the disposition codes?

Dana: Fine, I think. Nobody complains. They are part of the job.

Interviewer: What do you use email for?

Dana: Escalations from the site lead, shift swap approvals, which is a whole other thing, and the weekly numbers.

Interviewer: Shift swaps go through you?

Dana: The agent emails me and the planner. I reply approved, the planner updates the schedule. Sometimes the planner does not see the email and the agent turns up on the wrong day.

Interviewer: How often?

Dana: Once or twice a month on my team. Across the site, I hear it is weekly.

Interviewer: When chat spikes and planning asks for people, what happens on your side?

Dana: Ingrid, the planner, walks over or messages me and asks for two bodies on chat. I look at who is mid-call, pick two, tell them, and they switch. Ten minutes, and I have lost two voice agents for the afternoon. I say no more often than she would like.

Interviewer: If we built the coaching view first and nothing else, would that be the right choice?

Dana: Yes. The backlog thing is painful but I have a process for it. Coaching prep has no process; it is just my evenings.

Interviewer: How would you measure whether it worked?

Dana: My prep time per one-on-one, before and after. I would write it down for a month. If two hours became forty-five minutes I would tell every supervisor on the site.

Interviewer: What would you need to see before you rolled it out to the other supervisors?

Dana: A month of me using it. My own before-and-after prep time. And it has to work on chat, not just voice; half my team is chat.

Interviewer: What happens to a new agent in their first month?

Dana: Three weeks of training, then the floor with a buddy. I coach new agents weekly, and for them the pattern finding is worse, because they are bad at everything at once and I have to pick where to start.

Interviewer: Anything I did not ask that I should have?

Dana: Ask the agents what they think of the codes. I said they are fine. Ask them anyway.

Interviewer: I will. Thank you, Dana.

Dana: Thank you. Send me the summary; I want to see if I sound as tired as I feel.
````

- [ ] **Step 3: Run the count and phrase checks**

Run:

```bash
cd /Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/product-skills && f=data/interviews/01-supervisor.md && n=$(grep -c '^Interviewer:' "$f") && echo "exchanges=$n" && test "$n" -ge 60 -a "$n" -le 90 && test "$(grep -c '^Interviewer:' "$f")" -eq "$(grep -c '^Dana:' "$f")" && for p in 'two hours of prep for a fifteen-minute conversation' 'I spend Sunday evenings building coaching packs' 'it does not tell me why' 'never the two shall meet' 'until I sat next to him for a shift' 'the wrap-up queue is longer than the call queue' 'agents being slow or the system being slow' 'the one thing in the system I actually trust'; do grep -q "$p" "$f" && echo "found: $p"; done; echo "exit=$?"
```

Expected: `exchanges=67`, then eight `found:` lines, then `exit=0`. The exact count is 67 as written above; any value from 60 to 90 passes.

- [ ] **Step 4: Changelog bullet**

Add under `### Added` in `CHANGELOG.md`:

```markdown
- Synthetic interview transcript `data/interviews/01-supervisor.md` (team supervisor: coaching prep, per-intent visibility, after-call work backlog).
```

- [ ] **Step 5: Commit**

```bash
cd /Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/product-skills && git add data/interviews/01-supervisor.md CHANGELOG.md && git commit -F - <<'MSG'
feat: add synthetic supervisor interview transcript

Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>
MSG
/Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/product-skills && git push origin develop
```

---
### Task 6: Synthetic transcript 02, frontline agent

**Files:**
- Create: `data/interviews/02-agent.md`
- Modify: `CHANGELOG.md`
- Test: `grep -c '^Interviewer:'` between 60 and 90; planted phrases present

**Interfaces:**
- Consumes: the transcript format and fictional setting from Task 5 (Larkspur Home Warranty; systems Atlas, DispatchHub, Compass, Ledger; supervisor Dana).
- Produces: the agent-side view of the same contact center, including the deliberate contradiction with Task 5 about disposition codes.

Planted content to verify after writing (spec section 6):

| Theme | Quotable pains (verbatim spans that must appear) |
|---|---|
| Switching between five tools per interaction | `Five windows, two monitors, one customer`; `I copy the claim number four times on a normal call`; `Alt-tab is the most used key on my keyboard` |
| Knowledge base out of date | `Compass says thirty days, the policy document says forty-five, and the customer's contract says sixty`; `I keep my own notes in a text file` |
| Wrap-up codes feel arbitrary | `There are forty-one codes and I use six`; `Whichever I click first wins`; `Nobody has ever told me what the codes are for` |
| Contradiction with 01 | Marcus codes to match how the call started because the supervisor spot-checks: `I pick the code that matches how the call started` |

- [ ] **Step 1: Run the count check and see it fail**

Run:

```bash
cd /Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/product-skills && n=$(grep -c '^Interviewer:' data/interviews/02-agent.md 2>/dev/null || echo 0); echo "exchanges=$n"; test "$n" -ge 60 -a "$n" -le 90; echo "exit=$?"
```

Expected: `exchanges=0`, `exit=1`.

- [ ] **Step 2: Write the transcript**

Create `data/interviews/02-agent.md` with exactly this content:

````markdown
# Interview 02: Frontline agent

| Field | Value |
|---|---|
| Interviewee | Marcus Reyes (invented name) |
| Role | Frontline agent, 18 months, blended chat and voice |
| Company | Larkspur Home Warranty (invented), contact center of about 380 agents across two sites, on a CXone-style platform |
| Interviewer | Product research, Kaizen Tasks workshop |
| Date | 2026-08-20 |
| Length | 47 minutes |

All names, companies, systems, and numbers are fictional and were written for the workshop.

---

Interviewer: Thanks for doing this, Marcus. Tell me about your role and how long you have been in it.

Marcus: Agent on Dana's team, Columbus. Eighteen months in October. I started on voice only, and about eight months in they moved me to blended, so now I take chats most of the day and calls when the voice queue backs up.

Interviewer: What kinds of contacts do you get?

Marcus: Claims, mostly. Somebody's water heater died, they want to file a claim or know when the contractor is coming. Then billing, then cancellations. Cancellations are the ones I dread, not because of the customer, because of the process.

Interviewer: We will get to that. What does a shift look like?

Marcus: Log in at eight, take chats until lunch, usually two at a time, sometimes three. Afternoons I am on voice more because that is when the queue builds. Between contacts there is wrap-up, which I never finish in the time they give us, and at the end of the shift I clean up whatever I did not finish.

Interviewer: Walk me through one claim status call, from the moment it lands.

Marcus: The desktop pops with the customer's name and phone number. That is all it tells me. I open Ledger to find the account by phone number, because the pop does not link to it. In Ledger I find the plan and the claim number. I copy the claim number into Atlas to see the claim. If there is a contractor assigned, I copy the claim number again into DispatchHub to see the appointment. If the customer asks a coverage question, I open Compass and search. Then I put the notes in Ledger and the disposition in the desktop.

Interviewer: How many systems is that?

Marcus: Five. The desktop, Ledger, Atlas, DispatchHub, Compass. Five windows, two monitors, one customer.

Interviewer: How many times do you re-enter the same thing?

Marcus: I copy the claim number four times on a normal call. Ledger to Atlas, Atlas to DispatchHub, DispatchHub back into my notes, notes into the desktop wrap-up. Phone number twice. Name, I just type.

Interviewer: What happens when you type it wrong?

Marcus: I get somebody else's claim, or nothing. Once I read a different customer's appointment to somebody because two claim numbers were one digit apart. I caught it before the end of the call, but I still think about it.

Interviewer: How long does the switching add?

Marcus: On a call, maybe a minute, and the customer hears me typing. On chat it is worse because I have two customers, so I have ten windows, and I lose track of which Atlas tab is which customer. Alt-tab is the most used key on my keyboard.

Interviewer: Do any of the systems talk to each other?

Marcus: Ledger and Atlas are supposed to. There is a button in Ledger that opens the claim in Atlas, and it works if the claim was created in the last year. Anything older, it opens a blank search. DispatchHub talks to nothing. Compass talks to nothing.

Interviewer: What happens in DispatchHub when a contractor reschedules?

Marcus: The contractor updates DispatchHub, Atlas still shows the old date, and the customer gets a text with the new one. So the customer knows before I do. I find out when they call to ask why my screen says Tuesday.

Interviewer: How often does that happen?

Marcus: Daily. Maybe one in fifteen of my appointment calls is a customer who knows more than my screen does.

Interviewer: What would you want them to do?

Marcus: Open with the customer. If the pop knew who was calling and opened the account and the open claim and the appointment, I would be reading instead of typing when I say hello.

Interviewer: What is on your second monitor?

Marcus: Compass and my notes file on the right. Everything else on the left. The notes file is a text file where I keep the things Compass gets wrong.

Interviewer: How much of a call is spent looking at screens rather than talking?

Marcus: Half. On a six-minute call, three minutes are me finding things. The customer hears the keyboard and "bear with me."

Interviewer: Tell me about Compass.

Marcus: The knowledge base. Every policy, every process. It is where new agents are told to look, and it is where I stopped looking after about four months.

Interviewer: Why?

Marcus: Because it is out of date often enough that I stopped trusting it. The cancellation notice period is the famous one. Compass says thirty days, the policy document says forty-five, and the customer's contract says sixty. Three answers, and the one that counts is the contract, which is in Atlas, not in Compass.

Interviewer: How did you find out the article was wrong?

Marcus: A customer told me. I read him the thirty days, he read me his contract, and I had to put him on hold and ask Dana. That was month three. After that, I keep my own notes in a text file for anything I have been burned on.

Interviewer: What did the customer do?

Marcus: He was polite about it. He said, "You might want to fix your website," and Compass is not even the website. I have thought about that line a lot.

Interviewer: What is in the file?

Marcus: About sixty lines. Which contractors do not do weekends. The real notice periods by plan type. Which coverage exclusions the article leaves out. Where the refund form actually is. Things Dana told me, things the person who trained me told me.

Interviewer: Does anyone else have one?

Marcus: Everybody who has been here more than six months has one. We do not share them, because they are personal and half of it is probably wrong too. The difference is I know which half.

Interviewer: What happens when a new agent asks you a question?

Marcus: I answer from my file. Then they write it in theirs. That is how policy travels here: text file to text file.

Interviewer: Who owns the Compass articles?

Marcus: There is a name on each article. The cancellation one says it was last updated fourteen months ago, and the name on it left the company. There is a "was this helpful" button. I have pressed no with a comment maybe ten times, and nothing has ever changed.

Interviewer: What did training tell you about Compass?

Marcus: To trust it. The trainer used the cancellation article in class. It was wrong then too; I just did not know yet.

Interviewer: What about chat macros or canned answers?

Marcus: We have canned responses in the desktop for chat. They are better than Compass because a supervisor wrote them last year, but they are not linked to it, so when a policy changes somebody has to remember to change both, and they do not.

Interviewer: Do you ever get a policy update pushed to you?

Marcus: An email from the site lead, one paragraph. It says the notice period changed. It does not say which article, and the article does not change. I add the email to my file.

Interviewer: How do you handle a coverage question you are not sure about?

Marcus: I check my file. If it is not in my file, I check Compass and then read the contract in Atlas to see if Compass is lying. If it is a cancellation, I put them on hold and ask a senior. That is where the six-minute calls come from.

Interviewer: Let's talk about wrap-up. What do you have to do after a contact?

Marcus: Finish the notes in Ledger, update the claim in Atlas if anything changed, and pick a disposition code in the desktop. Ninety seconds on voice. Chat, the wrap-up runs while the next chat is already coming in.

Interviewer: Is ninety seconds enough?

Marcus: For a status check, yes. For anything with Atlas, no. Atlas takes fifteen or twenty seconds to save. I click save and count. If the next call lands before the save finishes, I lose the notes or I lose the call.

Interviewer: What does the timer do when it runs out?

Marcus: The desktop puts me back to available and the next contact lands. There is a button to extend wrap-up, but it shows up on Dana's adherence report, so I use it once a day at most.

Interviewer: What do you do then?

Marcus: I keep a Notepad window open. I write the notes there during the call, and if wrap-up runs out I leave them in Notepad and paste them into Ledger at the end of the shift. There are usually eight or ten waiting by five o'clock.

Interviewer: What is the risk of that?

Marcus: If the customer calls back at two, the next agent sees nothing, because it is in my Notepad. And if my machine crashes, the notes are gone. It has happened once.

Interviewer: Does anyone know how many notes are sitting in Notepad files across the floor?

Marcus: No. Dana sees the count of unfinished wrap-ups. She does not see the ones I closed with a one-line note because the real notes are still in Notepad.

Interviewer: Let's talk about disposition codes.

Marcus: There are forty-one codes and I use six. Claim status, new claim, appointment, billing, cancellation, other. Maybe a seventh for a transfer.

Interviewer: Why six?

Marcus: Because those are the ones I was shown. Nobody has ever told me what the codes are for. The person who trained me on the floor said "you will mostly use these," and I have used those ever since.

Interviewer: What are the other thirty-five?

Marcus: I scrolled through them once. "Coverage inquiry, pre-sale." "Contractor complaint, no-show." "Claim status, parts delay." Some of them are more specific versions of the ones I use, and I do not know when I am supposed to use the specific one.

Interviewer: Have you ever used "other"?

Marcus: Every day. If nothing fits in five seconds, it is "other." Dana asks about it if it goes over ten percent, so I keep it under ten percent.

Interviewer: What happens when a call is about two things?

Marcus: Which is most calls. Somebody calls about a claim and asks about their bill. One code. Whichever I click first wins. There is no rule I have been given, so I go with whatever the call felt like.

Interviewer: Does anyone check your codes?

Marcus: Dana does. She pulls calls and compares. So I pick the code that matches how the call started, because that is what she will hear in the first minute. That is not the same as what the call was about.

Interviewer: Does she know that?

Marcus: I do not think so, and I have not brought it up, because the codes are her thing and she is proud of the team's numbers on them. She has never said what the codes are used for. I assume it is reporting.

Interviewer: If you knew what they were used for, would you pick differently?

Marcus: If somebody told me the code decides how many people get scheduled next week, I would take it seriously. Right now it feels like a box to close the call.

Interviewer: Has anyone from workforce planning ever talked to the agents about the codes?

Marcus: Never. I have not seen anyone from planning on the floor. If they use the codes for something, that is news to me.

Interviewer: Let's move to coaching. What is your one-on-one like?

Marcus: Twenty minutes, every two weeks. Dana shows me my numbers, and if the handle time is red she guesses why. Sometimes she has a call she listened to. Sometimes the call is from three weeks ago and I do not remember it.

Interviewer: Do you feel the feedback is fair?

Marcus: Mostly. What is not fair is being told my handle time is up when I know it is Atlas being slow that week. I say that, and she believes me, but neither of us can prove it.

Interviewer: How do you prepare for a one-on-one yourself?

Marcus: I do not. I cannot see my own numbers between sessions, so I find out what the two weeks looked like when Dana shows me.

Interviewer: What would make it fair?

Marcus: Show the time I was waiting on a save separately from the time I was talking. Or show handle time by what the call was about, so a week of cancellations does not look like I got worse.

Interviewer: Do you know what you are good at?

Marcus: Claims. I like the puzzle of it. I am slower on cancellations because I read the whole policy so I do not get it wrong, and I have been told that is too slow, but nobody has shown me what the right amount to read is.

Interviewer: What would help there?

Marcus: A call from somebody who does it well. Dana said she would find one. That was in June.

Interviewer: What is different about chat coaching?

Marcus: Chat, the problem is juggling. Two or three at once, and if one goes quiet I forget it. The transcript looks fine, the customer waited four minutes for nothing. Nobody sees that unless the customer complains.

Interviewer: How many chats at once is too many?

Marcus: Three, if one of them is a cancellation. Two is fine. The system sets it at three for everyone and does not care what the chats are about.

Interviewer: Have you used any of the AI features in the desktop?

Marcus: The summary after a call. It writes a paragraph. It is fine for what the call was about, and I still have to fix the notes because it says "customer" instead of the plan and claim details Ledger needs. I paste it in and edit it, which is about as fast as typing.

Interviewer: What about the suggested answers on chat?

Marcus: They come from Compass. So they are wrong when Compass is wrong, and they are confident about it. I turned them off.

Interviewer: What would make you turn them back on?

Marcus: If they came from the contract in front of me instead of Compass. If the suggestion quoted the customer's own plan, I would use it.

Interviewer: What is the worst part of the job?

Marcus: End of shift. Ten Notepad entries, ten Ledger updates, four Atlas saves, and the queue still counting. I am off the phones and still working, and that is the part that is not measured.

Interviewer: What is the best part?

Marcus: When a contractor shows up on the day I promised. That is the whole job, and it only happens when every system agreed.

Interviewer: If you could change one thing about the tools, what would it be?

Marcus: Open the customer for me. Account, claim, appointment, in one place, when the contact lands. Half of my wrap-up would disappear because I would not be retyping the claim number into four places.

Interviewer: And one thing about Compass?

Marcus: A date on every article and a way to fix it. If I could correct the thirty days to whatever is in the contract and somebody would approve it in a day, I would stop keeping the file.

Interviewer: And the codes?

Marcus: Tell me what they are for. Then give me two codes when the call is about two things, or ask me a question instead of showing me forty-one options.

Interviewer: If something suggested the code for you, would you trust it?

Marcus: If it listened to the call, maybe. If it read Compass, no.

Interviewer: What would you need to see to trust a tool that fills in notes or codes?

Marcus: That it gets the claim number right every time. One wrong claim number and I am back to checking everything, which is slower than typing it.

Interviewer: What do you think supervisors do not see?

Marcus: The typing. They see the numbers and they hear the calls. They do not see me with ten windows open holding a claim number in my head.

Interviewer: If you could show Dana one thing, what would it be?

Marcus: A screen recording of a cancellation with the timer on. Six minutes, and four of them are windows.

Interviewer: Have you told Dana this?

Marcus: Some of it. She is on our side; she just cannot fix Atlas.

Interviewer: Do you plan to stay?

Marcus: Yes. I like the team. I would like the job to be less typing.

Interviewer: What do the agents who leave say?

Marcus: That the customers are fine and the tools are not. Two people from my training class left in the first year, both to jobs with one screen.

Interviewer: Is there anything I did not ask that I should have?

Marcus: Ask what happens when a system is down. Atlas was down for two hours last month and we took notes on paper. That is the whole answer to what we depend on.

Interviewer: I will add it. Thank you, Marcus.

Marcus: Thanks. If you build the open-the-customer thing, I will test it.
````

- [ ] **Step 3: Run the count and phrase checks**

Run:

```bash
cd /Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/product-skills && f=data/interviews/02-agent.md && n=$(grep -c '^Interviewer:' "$f") && echo "exchanges=$n" && test "$n" -ge 60 -a "$n" -le 90 && test "$n" -eq "$(grep -c '^Marcus:' "$f")" && for p in 'Five windows, two monitors, one customer' 'I copy the claim number four times on a normal call' 'Alt-tab is the most used key on my keyboard' "Compass says thirty days, the policy document says forty-five, and the customer's contract says sixty" 'I keep my own notes in a text file' 'There are forty-one codes and I use six' 'Whichever I click first wins' 'Nobody has ever told me what the codes are for' 'I pick the code that matches how the call started'; do grep -qF "$p" "$f" && echo "found: $p"; done; echo "exit=$?"
```

Expected: `exchanges=66`, then nine `found:` lines, then `exit=0`. The exact count is 66 as written above; any value from 60 to 90 passes.

- [ ] **Step 4: Changelog bullet**

Add under `### Added` in `CHANGELOG.md`:

```markdown
- Synthetic interview transcript `data/interviews/02-agent.md` (frontline agent: five tools per interaction, stale knowledge base, arbitrary wrap-up codes).
```

- [ ] **Step 5: Commit**

```bash
cd /Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/product-skills && git add data/interviews/02-agent.md CHANGELOG.md && git commit -F - <<'MSG'
feat: add synthetic agent interview transcript

Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>
MSG
/Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/product-skills && git push origin develop
```

---
### Task 7: Synthetic transcript 03, workforce planner

**Files:**
- Create: `data/interviews/03-workforce-planner.md`
- Modify: `CHANGELOG.md`
- Test: `grep -c '^Interviewer:'` between 60 and 90; planted phrases present

**Interfaces:**
- Consumes: the transcript format and fictional setting from Task 5 (Larkspur Home Warranty, two sites Columbus and Tulsa, CXone-style platform, supervisor Dana).
- Produces: the planning-side view, including the third voice on disposition codes so the synthesis has to weigh Dana's trust against Marcus's and Ingrid's doubts.

Planted content to verify after writing (spec section 6):

| Theme | Quotable pains (verbatim spans that must appear) |
|---|---|
| Forecast misses on promotional days | `Marketing sends a promotion on Tuesday and I find out on Wednesday from the queue`; `is a thirty percent miss on chat`; `The forecast model does not know what a promotion is` |
| Shift-swap requests by email | `Sixty swap emails a week`; `an agent on the wrong day`; `I spend Friday afternoons on swaps` |
| Intraday reallocation is manual | `I walk the floor asking supervisors for bodies`; `one agent at a time in the admin screen`; `the spike is over` |
| Contradiction, third voice | `I forecast the contact mix from the disposition codes`; `every time a team gets a new supervisor` |

- [ ] **Step 1: Run the count check and see it fail**

Run:

```bash
cd /Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/product-skills && n=$(grep -c '^Interviewer:' data/interviews/03-workforce-planner.md 2>/dev/null || echo 0); echo "exchanges=$n"; test "$n" -ge 60 -a "$n" -le 90; echo "exit=$?"
```

Expected: `exchanges=0`, `exit=1`.

- [ ] **Step 2: Write the transcript**

Create `data/interviews/03-workforce-planner.md` with exactly this content:

````markdown
# Interview 03: Workforce planner

| Field | Value |
|---|---|
| Interviewee | Ingrid Halvorsen (invented name) |
| Role | Workforce planner, weekly schedules for about 380 agents on two sites |
| Company | Larkspur Home Warranty (invented), contact center of about 380 agents across two sites, on a CXone-style platform |
| Interviewer | Product research, Kaizen Tasks workshop |
| Date | 2026-08-21 |
| Length | 55 minutes |

All names, companies, systems, and numbers are fictional and were written for the workshop.

---

Interviewer: Thank you for the time, Ingrid. What is your role, and how long have you been doing it?

Ingrid: Workforce planner. Seven years at Larkspur, five in this job. I build the weekly schedules for both sites, Columbus and Tulsa, about three hundred and eighty agents, and I run the forecast they are built on.

Interviewer: Is it just you?

Ingrid: Two planners, me and Tomas, and one real-time analyst in Tulsa who covers half the day. Columbus has no real-time analyst, so intraday in Columbus is me, on top of planning.

Interviewer: What does the real-time analyst do that you do not?

Ingrid: Watches the queue all day and moves people. In Tulsa that is one person's job for half a day. In Columbus it is squeezed between everything else I do, which is why Columbus reacts slower.

Interviewer: What tools do you work in?

Ingrid: The workforce module of the platform for forecasting and scheduling, the routing admin screens for skills, a spreadsheet for shift swaps, email, and the queue dashboard on a screen I never close.

Interviewer: Walk me through the weekly cycle.

Ingrid: Monday I refresh the forecast. Tuesday and Wednesday I build schedules for the week after next. Thursday the schedules publish. Friday is swaps and the mess from the week. Every day, all day, is intraday.

Interviewer: Let's start with the forecast. How is it built?

Ingrid: The model in the workforce module takes twelve weeks of history by fifteen-minute interval, by skill, and projects it forward with seasonality. I adjust it by hand for holidays and for anything I know about. Then it converts to staffing by interval, and the schedules are built to that.

Interviewer: What is "by skill"?

Ingrid: Voice claims, voice billing, chat claims, chat billing, cancellations, and so on. About fourteen skills across the two sites. The mix of contacts by skill is what decides whether I need chat people or voice people at two in the afternoon.

Interviewer: Where does the mix come from?

Ingrid: Two places. Routing tells me which skill a contact landed in. Disposition codes tell me what the contact turned out to be about. I forecast the contact mix from the disposition codes, because routing only knows what the customer pressed, and the customer presses billing to get to a person faster.

Interviewer: How much do you trust the codes?

Ingrid: Less than the supervisors do. If those are wrong, the forecast is wrong from the first step. And I have a reason to think they are inconsistent.

Interviewer: What is the reason?

Ingrid: The mix shifts every time a team gets a new supervisor. Same customers, same queues, and suddenly a team's cancellation share goes from eight percent to fourteen. I do not think it is the customers changing. I think it is what the new supervisor tells the team to click.

Interviewer: Have you raised it?

Ingrid: With the site lead, twice. The supervisors say their codes are clean, and each of them is probably right about their own team. The problem is that clean means something different on each team.

Interviewer: How accurate is the forecast on a normal week?

Ingrid: Within five percent on volume, most weeks. Interval accuracy is worse, but that is normal. The weeks that hurt are not the normal weeks.

Interviewer: What does a five percent miss cost?

Ingrid: On a normal day, nothing you would notice; a few intervals under target. Over a year it is the difference between hitting the service level bonus and not.

Interviewer: Tell me about the weeks that hurt.

Ingrid: Promotions. Marketing sends a promotion on Tuesday and I find out on Wednesday from the queue. The email goes out to two hundred thousand customers, "first month free on an upgrade," and chat volume goes up forty percent for three days.

Interviewer: How big is the miss?

Ingrid: Every "first month free" campaign is a thirty percent miss on chat. Voice is less, maybe fifteen. Cancellations spike too, oddly, because people log in to look at the offer and remember they wanted to cancel.

Interviewer: What happens on the floor when that lands?

Ingrid: Service level on chat drops from eighty percent to fifty for the afternoon. I pull people from voice, which pushes voice wait times up, and then I approve overtime for the evening. Last April that was eleven thousand dollars of overtime for one campaign.

Interviewer: Who notices first?

Ingrid: The customers, then the supervisors, then me. Marketing never. Marketing sees the campaign numbers; they do not see the queue.

Interviewer: Why does the forecast not see it coming?

Ingrid: The forecast model does not know what a promotion is. It knows what last Tuesday looked like. Unless somebody tells it, a promotion day is an outlier it smooths away, and then the next promotion is a surprise all over again.

Interviewer: Could you tell it?

Ingrid: There is a special-events feature. I can mark a day and give it a multiplier. I have to know the day and the multiplier. I know neither until it has happened.

Interviewer: Does marketing have a calendar?

Ingrid: They have a slide deck. I asked for it in January and got a version from December. The dates in it moved twice before the campaigns went out. There is no place where "an email goes to two hundred thousand customers on Tuesday at ten" is written down that I can read.

Interviewer: What have you tried?

Ingrid: I asked to be copied on the campaign approval emails. That worked for two months and then the person who copied me changed roles. I asked for a shared calendar; marketing said they would think about it. I built my own list of past promotions and their lift so at least I know the multiplier, if somebody ever tells me the day.

Interviewer: What is in that list?

Ingrid: Fourteen campaigns over two years. Campaign type, send day, send time, lift on chat and voice by day for three days after. It is the most useful spreadsheet I own and nobody else has seen it.

Interviewer: Does anyone in marketing know the queue effect of a campaign?

Ingrid: I sent them the April number once. They were surprised, then apologetic, then the next campaign went out the same way. It is not malice. There is no step in their process where I exist.

Interviewer: What would you want, ideally?

Ingrid: The day and the size of the audience, a week ahead. I can do the rest. Give me "Tuesday, ten in the morning, two hundred thousand, upgrade offer," and I will staff it.

Interviewer: What if the system could see marketing's sends directly?

Ingrid: Then I would want it to propose the multiplier from my fourteen campaigns and let me say yes. I would not want it to change the forecast without me looking, not for the first year.

Interviewer: Let's talk about shift swaps. What is the process?

Ingrid: An agent wants to swap a shift with another agent, or give one away, or pick one up. They email me and their supervisor. The supervisor replies approved or not. I check the rules, record it in the swap spreadsheet, and retype it into the schedule.

Interviewer: How many a week?

Ingrid: Sixty swap emails a week, give or take. More around holidays. I spend Friday afternoons on swaps, and whatever does not fit on Friday spills into Monday, which is forecast day.

Interviewer: What are the rules you check?

Ingrid: Both agents must have the skills for the shift. Neither goes over forty hours. Neither breaks the eleven-hour rest rule between shifts. The shift keeps the same interval coverage, or close. And the supervisor said yes.

Interviewer: How long does one take?

Ingrid: Three to five minutes if the email has everything. Fifteen if I have to reply asking which shift they mean, which is a third of them.

Interviewer: What is missing from the emails?

Ingrid: The date, half the time. "Can I swap my Thursday with Priya," when they both have two Thursdays in the published window. So I reply, they reply, and now it is Monday.

Interviewer: What goes wrong?

Ingrid: A swap that is approved by email and never retyped is an agent on the wrong day. The supervisor said yes, I missed the email or it landed on Monday, the schedule still shows the old shift, and on the day two agents are in and one is not.

Interviewer: How often?

Ingrid: I know of four or five a month across both sites. There are probably more that get sorted out on the floor and never reach me.

Interviewer: What does the agent see?

Ingrid: Their schedule in the app. If I have not retyped the swap, they see the old shift, and half of them trust the email more than the app. The other half trust the app, and that is how you get two agents in for one shift.

Interviewer: Is there a self-service swap feature in the platform?

Ingrid: There is. It was on before the migration two years ago. It was turned off during the migration because the rules were not configured, and nobody has turned it back on. I have asked. It is on a list.

Interviewer: What would it take to turn it on?

Ingrid: Somebody to configure the five rules I just told you, and the supervisors to approve in the app instead of email. The supervisors are fine with that. The configuration needs a vendor ticket, and the ticket needs a sponsor.

Interviewer: What is the swap spreadsheet for, if the schedule is the truth?

Ingrid: History. Who swapped with whom, how often, and who never gets their swap approved. When an agent complains that their supervisor never says yes, the spreadsheet is the only record.

Interviewer: How do agents feel about the process?

Ingrid: They think I am slow. From where they sit, they sent an email on Tuesday and nothing happened until Friday. They are not wrong.

Interviewer: Let's go to intraday. What does a normal afternoon look like?

Ingrid: I watch the queue dashboard. When chat goes red, which is most days around one and again around four, I have to find people. I walk the floor asking supervisors for bodies. In Tulsa the real-time analyst does it by message. Either way it is a person asking a person.

Interviewer: What happens when you ask?

Ingrid: The supervisor looks at their team and decides who they can spare. Dana is good about it; some of them are not. Everybody is protecting their own handle time and their own after-call backlog. I get two people when I need five.

Interviewer: And then?

Ingrid: I move them. Skill by skill, one agent at a time in the admin screen. Open the agent, change the skill assignment, save, next agent. Twelve agents is twelve screens, and the screen takes ten seconds to save.

Interviewer: How long does a reallocation take, start to finish?

Ingrid: Twenty minutes from red queue to the last agent moved. By the time the reallocation is done, the spike is over, and now I have too many people on chat and voice is red. So I move them back. That is my afternoon.

Interviewer: How many times a day?

Ingrid: Three or four moves on a normal day. Ten on a promotion day. Each one is me walking or messaging, then twelve screens.

Interviewer: What happens when you are in a meeting?

Ingrid: Nobody moves anyone. Chat stays red until I am back. Tomas can do it, but he is building schedules and does not watch the dashboard. There is no second person in Columbus.

Interviewer: Is there a rules-based reallocation in the platform?

Ingrid: There is a way to give agents secondary skills so the router can spill over. Supervisors do not like it, because an agent with a chat secondary skill gets pulled into chat by the router without anyone asking, and the supervisor's numbers move. So most agents have one skill, and I move them by hand.

Interviewer: Is the supervisors' objection reasonable?

Ingrid: Partly. Their numbers do move, and they get measured on them. But the alternative is me walking the floor. If the router could take two people from each team instead of five from one, they would mind less. It cannot; it takes whoever is free.

Interviewer: What do you look at when you decide who to move?

Ingrid: Who has both skills, who is not mid-call, whose team is least behind on after-call work, and who I moved last time, so it is not always the same two people. That is four screens before I have moved anyone.

Interviewer: Do you ever move the wrong person?

Ingrid: Every week. Somebody who was mid-cancellation and got a chat dropped on them, or somebody I moved twice in one day. I find out when the supervisor messages me.

Interviewer: What would you want instead?

Ingrid: Tell me "chat will be red in fifteen minutes," and give me a list of six people who could move with the least damage, and one button. I would still press the button myself.

Interviewer: Why fifteen minutes?

Ingrid: Because I can see the queue now. What I cannot see is the queue in fifteen minutes, and by the time I can see it, it is too late to do anything but overtime.

Interviewer: Could you trust a prediction like that?

Ingrid: I would compare it to what happened for a month. If it called the spike right three times out of four, I would move people on it. I already move people on my own guess, and my guess is not three out of four.

Interviewer: Supervisors have asked for different wrap-up windows by contact reason. What is your view?

Ingrid: I would take it if the codes were reliable enough to tell me the reason. Right now a per-reason wrap-up window means a per-reason forecast, and I do not trust the reason. Fix the codes first, then I will forecast wrap-up by reason gladly.

Interviewer: Does the after-call backlog show up in your numbers?

Ingrid: As agents in wrap-up state who are not available. If a team has forty open wrap-ups at three, that is forty intervals of somebody not answering. I see the state; I do not see what is in the backlog or whether it matters.

Interviewer: Do you and the supervisors look at the same numbers?

Ingrid: No. They see their team's dashboard; I see the site's. When I say chat is red and Dana says her team is fine, we are both right, and that is the argument every afternoon.

Interviewer: What do supervisors not understand about planning?

Ingrid: That the schedule they got was the best one for the whole building, not for their team. And that every swap they approve by email is a change I have to make by hand.

Interviewer: What do you not understand about the floor?

Ingrid: Why a call about a claim takes six minutes on one team and nine on another. I see the numbers. I do not see the windows.

Interviewer: If you could fix one thing first, which one?

Ingrid: The promotion misses. One bad campaign costs more than a year of swap emails. The swap fix is a configuration ticket; the promotion fix needs somebody in marketing to tell me a date.

Interviewer: And the second?

Ingrid: Intraday. Not because it is the biggest cost, because it is my whole afternoon, every day.

Interviewer: What would make you worry about automation here?

Ingrid: A system that moves people without telling the supervisor. The first time an agent disappears from a team's numbers without warning, every supervisor turns the feature off. Anything that moves people has to tell the supervisor first and let them say no once.

Interviewer: How would you measure success?

Ingrid: Service level on promotion days within ten points of a normal day. Swaps retyped by hand at zero. Reallocation from red queue to agents moved under five minutes. I have the baseline for all three.

Interviewer: Do you share those numbers with anyone?

Ingrid: A weekly deck to the site leads. Volume, service level, adherence, overtime. Nobody asks about the swap count or the reallocation time because nobody knows they exist.

Interviewer: What would you add to that deck if someone asked?

Ingrid: Promotion-day misses as a line item with the overtime cost next to it. Once somebody sees eleven thousand dollars next to "nobody told planning," the calendar conversation gets easier.

Interviewer: What is the most manual thing you do that should not be?

Ingrid: Retyping. Swaps into the schedule, skill changes into the admin screen, promotion dates into the special-events screen. Three different screens, all of them me typing something that already exists somewhere else.

Interviewer: If planning and supervisors had one shared view, what would be on it?

Ingrid: The queue now and in fifteen minutes, who could move, who is in wrap-up and on what, and whether there is a promotion today. One screen, both of us looking at the same thing. Right now we argue from different dashboards.

Interviewer: Have the agents ever been asked about any of this?

Ingrid: Not by me. I should. If Marcus on Dana's team is clicking a code because it was the first thing the customer said, I would rather know that than keep pretending the mix is real.

Interviewer: Anything I should have asked?

Ingrid: Ask marketing when their next send is. If they can tell you, tell me.

Interviewer: I will. Thank you, Ingrid.

Ingrid: Thank you. My afternoon starts in ten minutes; chat goes red at one.
````

- [ ] **Step 3: Run the count and phrase checks**

Run:

```bash
cd /Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/product-skills && f=data/interviews/03-workforce-planner.md && n=$(grep -c '^Interviewer:' "$f") && echo "exchanges=$n" && test "$n" -ge 60 -a "$n" -le 90 && test "$n" -eq "$(grep -c '^Ingrid:' "$f")" && for p in 'Marketing sends a promotion on Tuesday and I find out on Wednesday from the queue' 'is a thirty percent miss on chat' 'The forecast model does not know what a promotion is' 'Sixty swap emails a week' 'an agent on the wrong day' 'I spend Friday afternoons on swaps' 'I walk the floor asking supervisors for bodies' 'one agent at a time in the admin screen' 'the spike is over' 'I forecast the contact mix from the disposition codes' 'every time a team gets a new supervisor'; do grep -qF "$p" "$f" && echo "found: $p"; done; echo "exit=$?"
```

Expected: `exchanges=66`, then eleven `found:` lines, then `exit=0`. The exact count is 66 as written above; any value from 60 to 90 passes.

Then confirm the three transcripts share the setting and the contradiction has three voices:

```bash
cd /Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/product-skills && grep -l 'Larkspur Home Warranty' data/interviews/*.md | wc -l && grep -c 'disposition code' data/interviews/01-supervisor.md data/interviews/02-agent.md data/interviews/03-workforce-planner.md
```

Expected: `3`, then one line per file each with a count of at least `1`.

- [ ] **Step 4: Changelog bullet**

Add under `### Added` in `CHANGELOG.md`:

```markdown
- Synthetic interview transcript `data/interviews/03-workforce-planner.md` (workforce planner: promotion-day forecast misses, shift swaps by email, manual intraday reallocation).
```

- [ ] **Step 5: Commit**

```bash
cd /Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/product-skills && git add data/interviews/03-workforce-planner.md CHANGELOG.md && git commit -F - <<'MSG'
feat: add synthetic workforce planner interview transcript

Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>
MSG
/Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/product-skills && git push origin develop
```

---
### Task 8: Sample PRD at clarity 3

**Files:**
- Create: `data/prd-sample.md`
- Modify: `CHANGELOG.md`
- Test: headings present; success section contains no testable criterion

**Interfaces:**
- Consumes: the fictional setting from Task 5 and Dana's wish list (per-agent contact reasons below the team, three example interactions each, two-week window, system time shown separately, agents see it later).
- Produces: the default input for `/refine-request` in the README (Task 11) and the P1 check (Task 14). Scores clarity 3 on the rubric by design: behavior is described, acceptance criteria are missing or untestable, so the interview has to ask for done criteria.

- [ ] **Step 1: Run the check and see it fail**

Run:

```bash
cd /Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/product-skills && test -f data/prd-sample.md; echo "exit=$?"
```

Expected: `exit=1`.

- [ ] **Step 2: Write the sample PRD**

Create `data/prd-sample.md` with exactly this content. It must stay at clarity 3: the Success section deliberately has no criterion a tester could check, and the Open questions leave the period, the count, and the metric undecided.

````markdown
# PRD: Coaching insights

| Field | Value |
|---|---|
| Owner | Product, Supervisor Experience (invented) |
| Status | Draft for review |
| Written | 2026-08-28 |
| Note | Sample written for the Kaizen Tasks workshop. It is meant to score clarity 3 on the readiness rubric: the behavior is described, the acceptance criteria are not testable. |

## 1. Background

Team supervisors in the contact center run one-on-one coaching sessions with each agent every one or two weeks. Supervisors tell us that preparing for a session takes far longer than the session itself, because the tools show scores per agent but not the reasons behind them. A supervisor who wants to coach an agent on a specific kind of contact has to listen to recordings until one turns up.

In interviews at Larkspur Home Warranty, a supervisor with twelve agents described two hours of preparation for a fifteen-minute conversation, and Sunday evenings spent building coaching packs. She could name the contact reasons where about half of her agents struggle; for the other half she had "a feeling and no evidence."

## 2. Problem

Supervisors cannot see which contact reasons each agent struggles with. Quality scores live in the quality tool, contact reasons live in routing, and no screen joins them. As a result:

- Coaching preparation is done by listening to a sample of interactions, which takes about two hours per session.
- Coaching topics are chosen by impression rather than evidence.
- Agents receive feedback on handle time without knowing what drove it, and cannot tell a slow week from a slow back-office system.

## 3. Goals

- Reduce the time supervisors spend preparing coaching sessions.
- Make coaching topics evidence-based.
- Give supervisors confidence in the interactions they bring to a session.

## 4. Users

- Team supervisors (primary). Twelve agents each on average, mixed chat and voice.
- Quality analysts (secondary), who may use the same view to target evaluations.
- Agents (later), who may see their own view once supervisors trust it.

## 5. Proposed behavior

A new **Coaching insights** page in the supervisor workspace.

When a supervisor opens the page, they see their team as a list. For each agent the page shows the contact reasons where that agent's results are worse than the team over a recent period, and for each of those reasons a few example interactions the supervisor can open directly.

The supervisor can pick an agent to see the detail: the contact reasons ranked by how far the agent is from the team, the trend over the period, and the example interactions with a short note on why each was chosen. The supervisor can mark an example as not useful, and the page should take that into account.

The page should work for chat and voice, and it should separate time the agent spent waiting on systems from time spent with the customer, so that a slow back-office system does not look like a slow agent.

## 6. Out of scope for the first version

- Showing the page to agents.
- Changing how quality scores are calculated.
- Automatic coaching plans or automatic messages to agents.

## 7. Success

- Supervisors report that preparation takes less time.
- Supervisors find the suggested interactions relevant.
- The page is used regularly by the supervisors who have it.

## 8. Open questions

- What is "a recent period": one week, two weeks, a month?
- How many example interactions per contact reason?
- Should "worse than the team" use quality score, handle time, or both?
- What happens for agents with too few interactions in a reason to compare?
- Does this need contact-reason data that the quality tool does not store today?
````

- [ ] **Step 3: Run the checks**

Run:

```bash
cd /Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/product-skills && f=data/prd-sample.md && grep -c '^## ' "$f" && grep -c 'Coaching insights' "$f" && sed -n '/^## 7. Success/,/^## 8/p' "$f" | grep -c '^- ' && wc -w < "$f"
```

Expected: `8` (eight sections), a count of at least `2`, `3` (three untestable success bullets), and a word count between 550 and 800 (about two printed pages).

- [ ] **Step 4: Changelog bullet**

Add under `### Added` in `CHANGELOG.md`:

```markdown
- `data/prd-sample.md`: a two-page sample PRD for "Coaching insights" written at clarity 3, the default input for `/refine-request`.
```

- [ ] **Step 5: Commit**

```bash
cd /Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/product-skills && git add data/prd-sample.md CHANGELOG.md && git commit -F - <<'MSG'
feat: add sample PRD at clarity 3

Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>
MSG
/Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/product-skills && git push origin develop
```

---

### Task 9: Part 3 templates in markdown

**Files:**
- Create: `templates/part3/agentic-layer-canvas.md`
- Create: `templates/part3/plan-30-60-90.md`
- Create: `templates/part3/facilitator-sheet.md`
- Modify: `CHANGELOG.md`
- Test: `npm run lint:md`

**Interfaces:**
- Consumes: nothing.
- Produces: the two files `scripts/build-pdf.mjs` (Task 10) renders: `agentic-layer-canvas.md` (A4 landscape) and `plan-30-60-90.md` (A4 portrait). Both start with an `# ` heading, then a two-column `Team | Date` table, then the grid table; the PDF stylesheet targets the second table of each page for row height. No front matter, no inline HTML.

- [ ] **Step 1: Run markdown lint and see nothing is linted**

Run:

```bash
cd /Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/product-skills && nvm use >/dev/null && npm run lint:md 2>&1 | tail -2
```

Expected: `Linting: 0 files` and `Summary: 0 issues in 0 files`.

- [ ] **Step 2: Write the canvas**

Create `templates/part3/agentic-layer-canvas.md`:

```markdown
# Agentic layer canvas

| Team | Date |
|---|---|
| | |

| | Discover | Define | Deliver | Learn |
|---|---|---|---|---|
| **What I do today in this phase** | | | | |
| **What is slow, repetitive, or error-prone** | | | | |
| **A candidate agent or skill** ("an agent that ... so that ...") | | | | |
| **Evidence needed to trust it** | | | | |

## Our top three candidates

1. An agent that
2. An agent that
3. An agent that
```

- [ ] **Step 3: Write the 30/60/90 plan**

Create `templates/part3/plan-30-60-90.md`:

```markdown
# 30/60/90 plan for the product agentic layer

| Team | Date |
|---|---|
| | |

| | 30 days | 60 days | 90 days |
|---|---|---|---|
| **Commitment 1** | | | |
| Owner | | | |
| Measurable signal | | | |
| First step | | | |
| **Commitment 2** | | | |
| Owner | | | |
| Measurable signal | | | |
| First step | | | |
| **Commitment 3** | | | |
| Owner | | | |
| Measurable signal | | | |
| First step | | | |

Up to three commitments per column. Each has one named owner in the room, one signal you can measure, and a first step small enough to do next week.
```

- [ ] **Step 4: Write the facilitator sheet**

Create `templates/part3/facilitator-sheet.md`. It contains the 45-minute timing, the prompts per column and row, the prioritization rule, and the closing line. It promises nothing from the facilitator after the session.

```markdown
# Facilitator sheet: the agentic layer exercise

45 minutes. Paper, no laptops. Groups of three or four fill one canvas each; the team fills one plan.

## Timing

| Minutes | Segment | What happens |
|---|---|---|
| 0 to 5 | Framing | Say why: engineering has an agentic delivery cycle and product does not yet. The canvas maps where one would help. Show the canvas and read the four column prompts once. |
| 5 to 20 | Canvas | Groups of three or four fill the four rows for each column. Circulate; read a column prompt aloud when a group stalls. Row three must be a sentence of the form "an agent that ... so that ...". |
| 20 to 30 | Prioritize | Each group draws a two-by-two on a blank sheet, value up and effort right, and places every candidate from row three on it. The top three by value over effort go to the plan. |
| 30 to 40 | Plan | The team fills the 30/60/90 plan with its top three, one commitment per column, each with an owner, a measurable signal, and a first step. |
| 40 to 45 | Share | Each team reads its 30-day commitment aloud with the owner and the signal. No discussion; questions go to the owner afterwards. |

## Column prompts

Read one per column and leave it on the table.

- **Discover.** "In the last month, how did you learn what customers need? Interviews, tickets, dashboards, sales calls? Which part of that did you dread?"
- **Define.** "Take the last request you wrote for engineering. What did you do between the idea and the written request? What came back with questions?"
- **Deliver.** "While engineering builds, what do you do? Status, questions, acceptance, release notes? Which of those is copying from one place to another?"
- **Learn.** "After a release, how do you know it worked? Where do the numbers come from, and how long until you look at them?"

## Row prompts

- **What I do today in this phase.** Verbs, not nouns. "Read forty tickets", not "ticket analysis".
- **What is slow, repetitive, or error-prone.** The thing you would hand to a new hire on day one with a checklist.
- **A candidate agent or skill.** The sentence must read "an agent that ... so that ...". The "so that" is the value.
- **Evidence needed to trust it.** What you would check for a month before letting it run without you.

## Prioritization rule

Value is the size of the "so that". Effort is how much the agent needs that does not exist today: data, access, a rubric. Place each candidate on the two-by-two. The top three by value over effort go to the plan. When a group cannot agree, the person who does the task today decides.

## Plan rules

- One commitment per column; up to three if the team insists. Fewer is better.
- Every commitment has a named owner in the room, a measurable signal, and a first step small enough to do next week.
- 30 days is a first step done and measured. 60 days is a second candidate started, or the first one used by someone other than its owner. 90 days is something running without its owner watching.

## Closing

Say this, in these words or your own: "This plan belongs to the team. The repository you cloned today is the starting point, and after today you know how to add a skill to it."

Collect nothing. Photograph the canvases if a group wants a copy. The plan stays with its owners.
```

- [ ] **Step 5: Run markdown lint**

Run:

```bash
cd /Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/product-skills && nvm use >/dev/null && npm run lint:md 2>&1 | tail -3; echo "exit=$?"
```

Expected: `Linting: 3 files`, `Summary: 0 issues in 0 files`, `exit=0`. (`README.md` does not exist until Task 11; the glob for it matches nothing and that is not an error.)

Also confirm the timing adds to 45 and the sheet makes no promise:

```bash
cd /Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/product-skills && grep -c '^| [0-9]* to [0-9]* |' templates/part3/facilitator-sheet.md && grep -ci 'follow-up\|I will send\|we will build' templates/part3/facilitator-sheet.md
```

Expected: `5`, then `0`.

- [ ] **Step 6: Changelog bullet**

Add under `### Added` in `CHANGELOG.md`:

```markdown
- Part 3 templates in `templates/part3/`: agentic layer canvas, 30/60/90 plan, and the 45-minute facilitator sheet.
```

- [ ] **Step 7: Commit**

```bash
cd /Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/product-skills && git add templates/part3/agentic-layer-canvas.md templates/part3/plan-30-60-90.md templates/part3/facilitator-sheet.md CHANGELOG.md && git commit -F - <<'MSG'
feat: add Part 3 canvas, plan, and facilitator templates

Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>
MSG
/Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/product-skills && git push origin develop
```

---
### Task 10: PDF build script and the committed PDFs

**Files:**
- Create: `scripts/build-pdf.mjs`
- Create: `templates/part3/agentic-layer-canvas.pdf` (generated, committed)
- Create: `templates/part3/plan-30-60-90.pdf` (generated, committed)
- Modify: `CHANGELOG.md`
- Test: `npm run pdf`, `npm run lint:js`, `npm run typecheck`

**Interfaces:**
- Consumes: `templates/part3/agentic-layer-canvas.md` and `templates/part3/plan-30-60-90.md` (Task 9), each with a first `Team | Date` table and a second grid table; npm script `pdf` (Task 1); `marked` and `playwright` devDependencies (Task 1).
- Produces: `node scripts/build-pdf.mjs` writes the two PDFs next to their markdown, prints one `wrote templates/part3/<name>.pdf (<bytes> bytes, A4 <orientation>)` line each, exits non-zero if a PDF is empty. CI (Task 13) runs it and checks the files are non-empty.

- [ ] **Step 1: Run the build and see it fail**

Run:

```bash
cd /Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/product-skills && nvm use >/dev/null && npm run pdf; echo "exit=$?"
```

Expected: `Error: Cannot find module '/Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/product-skills/scripts/build-pdf.mjs'` and `exit=1`.

- [ ] **Step 2: Install Chromium for Playwright**

Run:

```bash
cd /Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/product-skills && npx playwright install chromium
```

Expected: either download progress ending without error, or no output when Chromium for Playwright 1.63 is already present. Browsers install under `~/Library/Caches/ms-playwright/`, not in the repo.

- [ ] **Step 3: Write the build script**

Create `scripts/build-pdf.mjs`:

```js
#!/usr/bin/env node
// Render the two printable Part 3 templates to PDF with Playwright's Chromium.
// Usage: npm run pdf   (needs: npx playwright install chromium)
// Canvas is A4 landscape; plan is A4 portrait. Large type for print.

import { readFile, stat } from 'node:fs/promises';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { marked } from 'marked';
import { chromium } from 'playwright';

const repoRoot = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const templatesDir = path.join(repoRoot, 'templates', 'part3');

/** @type {{ md: string; pdf: string; landscape: boolean; rowHeightMm: number }[]} */
const jobs = [
  {
    md: 'agentic-layer-canvas.md',
    pdf: 'agentic-layer-canvas.pdf',
    landscape: true,
    rowHeightMm: 22,
  },
  { md: 'plan-30-60-90.md', pdf: 'plan-30-60-90.pdf', landscape: false, rowHeightMm: 14 },
];

/**
 * Minimal print stylesheet. The first table on each page is the Team/Date
 * header; the second is the grid people write in, so its rows get the height.
 * @param {number} rowHeightMm
 */
function stylesheet(rowHeightMm) {
  return `
    @page { margin: 12mm; }
    * { box-sizing: border-box; }
    body { font-family: Helvetica, Arial, "Liberation Sans", sans-serif; color: #111; margin: 0; }
    h1 { font-size: 22pt; margin: 0 0 4mm 0; }
    h2 { font-size: 15pt; margin: 5mm 0 2mm 0; }
    p, li { font-size: 12pt; line-height: 1.35; margin: 0 0 2mm 0; }
    ol { margin: 0; padding-left: 7mm; }
    li { min-height: 9mm; }
    table { width: 100%; border-collapse: collapse; table-layout: fixed; margin: 0 0 4mm 0; }
    th, td { border: 0.4mm solid #111; padding: 2mm; vertical-align: top; font-size: 12pt; text-align: left; }
    th { background: #eee; font-size: 13pt; }
    table:nth-of-type(1) td { height: 10mm; }
    table:nth-of-type(2) td { height: ${rowHeightMm}mm; }
    table:nth-of-type(2) th:first-child, table:nth-of-type(2) td:first-child { width: 22%; font-size: 11pt; }
  `;
}

const browser = await chromium.launch();
try {
  for (const job of jobs) {
    const markdown = await readFile(path.join(templatesDir, job.md), 'utf8');
    const body = await marked.parse(markdown);
    const html = `<!doctype html><html><head><meta charset="utf-8"><title>${job.md}</title><style>${stylesheet(job.rowHeightMm)}</style></head><body>${body}</body></html>`;
    const page = await browser.newPage();
    await page.setContent(html, { waitUntil: 'load' });
    const outPath = path.join(templatesDir, job.pdf);
    await page.pdf({
      path: outPath,
      format: 'A4',
      landscape: job.landscape,
      printBackground: true,
      margin: { top: '12mm', right: '12mm', bottom: '12mm', left: '12mm' },
    });
    await page.close();
    const { size } = await stat(outPath);
    if (size === 0) {
      throw new Error(`${job.pdf} is empty`);
    }
    const orientation = job.landscape ? 'landscape' : 'portrait';
    console.log(`wrote templates/part3/${job.pdf} (${size} bytes, A4 ${orientation})`);
  }
} finally {
  await browser.close();
}
```

Then format it so the Prettier check passes regardless of hand wrapping:

```bash
cd /Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/product-skills && npx prettier --write scripts/build-pdf.mjs
```

Expected: `scripts/build-pdf.mjs` printed once (Prettier lists the file it formatted).

- [ ] **Step 4: Build the PDFs**

Run:

```bash
cd /Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/product-skills && nvm use >/dev/null && npm run pdf; echo "exit=$?"
```

Expected:

```
wrote templates/part3/agentic-layer-canvas.pdf (NNNNN bytes, A4 landscape)
wrote templates/part3/plan-30-60-90.pdf (NNNNN bytes, A4 portrait)
exit=0
```

where each `NNNNN` is a positive number (Chromium PDFs of these pages are typically 20 to 60 kB).

- [ ] **Step 5: Check each PDF is one page and the right orientation**

Chromium writes page objects uncompressed, so the page count and the media box can be read from the file:

```bash
cd /Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/product-skills && for p in agentic-layer-canvas plan-30-60-90; do printf '%s pages=%s mediabox=%s\n' "$p" "$(strings templates/part3/$p.pdf | grep -Ec '/Type ?/Page([^s]|$)')" "$(strings templates/part3/$p.pdf | grep -Eo '/MediaBox ?\[[0-9. ]+\]' | head -n1)"; done
```

Expected:

```
agentic-layer-canvas pages=1 mediabox=/MediaBox [0 0 842.88 595.91998]
plan-30-60-90 pages=1 mediabox=/MediaBox [0 0 595.91998 842.88]
```

(About 843 by 596 points is A4 landscape; the reverse is A4 portrait. The exact decimals may differ by a point between Chromium builds; what matters is `pages=1` and the larger number first for the canvas.) With Chrome 153 the canvas fits one page up to 23mm rows; 22mm leaves margin for the bundled Chromium's font metrics on Ubuntu. If `pages=2` for the canvas, lower `rowHeightMm` for the canvas job from 22 to 20 and rebuild. Then open both files and check the type is readable from arm's length and the cells are empty boxes:

```bash
open templates/part3/agentic-layer-canvas.pdf templates/part3/plan-30-60-90.pdf
```

- [ ] **Step 6: Run the script checks**

Run:

```bash
cd /Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/product-skills && nvm use >/dev/null && npm run lint:js && npm run typecheck; echo "exit=$?"
```

Expected: `Checking formatting...`, `All matched files use Prettier code style!`, nothing from ESLint, nothing from `tsc`, `exit=0`.

- [ ] **Step 7: Changelog bullet**

Add under `### Added` in `CHANGELOG.md`:

```markdown
- `scripts/build-pdf.mjs` renders the canvas (A4 landscape) and the 30/60/90 plan (A4 portrait) to PDF with Playwright's Chromium; the PDFs are committed under `templates/part3/`.
```

- [ ] **Step 8: Commit**

```bash
cd /Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/product-skills && git add scripts/build-pdf.mjs templates/part3/agentic-layer-canvas.pdf templates/part3/plan-30-60-90.pdf CHANGELOG.md && git commit -F - <<'MSG'
feat: build Part 3 PDFs with Playwright Chromium

Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>
MSG
/Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/product-skills && git push origin develop
```

---

### Task 11: README

**Files:**
- Create: `README.md`
- Modify: `CHANGELOG.md`
- Test: `npm run lint:md`

**Interfaces:**
- Consumes: the skill names and argument hints (Tasks 3, 4), `data/prd-sample.md` (Task 8), the transcript paths (Tasks 5 to 7), `scripts/sync-rubric.sh` flags `[ref]` and `--check` (Task 12; the README describes the interface the script implements), npm scripts (Task 1), labels from the master plan interfaces table.
- Produces: the one page PMs read; its "Install in three steps" is what the P1 check (Task 14) follows.

- [ ] **Step 1: Confirm lint does not yet see a README**

Run:

```bash
cd /Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/product-skills && nvm use >/dev/null && npm run lint:md 2>&1 | grep Linting
```

Expected: `Linting: 3 files` (the three templates only).

- [ ] **Step 2: Write the README**

Create `README.md` with exactly this content:

```markdown
# Kaizen Tasks product skills

Two Claude Code skills for product managers, the readiness rubric engineering scores requests with, the Part 3 planning templates, and synthetic data so everything runs without customer material. Built for the Kaizen Tasks workshop and packaged as a Claude Code plugin, so it can go to the company marketplace later without restructuring.

## Install in three steps

1. Clone: `git clone https://github.com/kpnemo/kaizen-tasks-product-skills.git` and `cd kaizen-tasks-product-skills`.
2. Open the folder in Claude Code (`claude` from inside it), or add the folder as a project in Cowork or Claude Desktop. If the skills do not appear there, copy the two folders under `skills/` into the app's skills location.
3. Run `/refine-request data/prd-sample.md`.

The skills need no install step. `npm install` is only for rebuilding the PDFs and running the checks.

## The two skills

### `/refine-request <issue number | file path | pasted text>`

Scores a feature request with the rubric, asks one question at a time until it would score as ready, and returns the request rewritten in the five sections of the engineering issue form with a before-and-after score. Example: `/refine-request data/prd-sample.md`. With an issue number from `kaizen-tasks-assembly-line` (or an issue URL) and a logged-in `gh`, it offers to update your own issue; it never applies labels or comments.

### `/synthesize-interviews <transcript paths...>`

Turns interview transcripts into jobs to be done, pains with verbatim quotes, an opportunity table, and two or three candidate feature requests already in the form's sections and pre-scored. Example: `/synthesize-interviews data/interviews/01-supervisor.md data/interviews/02-agent.md data/interviews/03-workforce-planner.md`, or with no arguments to be offered the bundled three. Output lands in `out/`, which is git-ignored.

## The rubric

`rubric/readiness.md` is a copy of the rubric engineering owns in [kaizen-tasks-assembly-line](https://github.com/kpnemo/kaizen-tasks-assembly-line/blob/main/rubric/readiness.md). Both skills read it and print its version, so your local score and the engineering triage score agree for the same text. Engineering's triage applies the score labels (`clarity:1..5`, `complexity:1..5`, `risk:1..5`, `arch-change`, `triaged`) to issues; the skills here never do.

- Pull the latest: `npm run sync-rubric` (or `scripts/sync-rubric.sh [ref]`).
- Check for drift without changing anything: `scripts/sync-rubric.sh --check`. CI prints a warning on drift and does not fail.

## Part 3 templates

`templates/part3/` holds the agentic layer canvas (A4 landscape), the 30/60/90 plan (A4 portrait), and the facilitator sheet, as markdown, with the two printable ones also as PDF. Rebuild the PDFs with `npm install`, `npx playwright install chromium`, then `npm run pdf`.

## Propose a new skill

Open a pull request against `develop` that adds `skills/<name>/SKILL.md` with `name` (equal to the folder name) and `description` in its front matter, and one example under "The two skills" above. `npm test` checks the front matter; CI runs it.

## After the session

Distribution goes through the company Claude marketplace and Enterprise connectors; this repository is already in plugin shape for that.
```

- [ ] **Step 3: Run markdown lint and the one-page check**

Run:

```bash
cd /Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/product-skills && nvm use >/dev/null && npm run lint:md 2>&1 | tail -2 && wc -w < README.md
```

Expected: `Linting: 4 files`, `Summary: 0 issues in 0 files`, and a word count under 520 (one printed page).

- [ ] **Step 4: Changelog bullet**

Add under `### Added` in `CHANGELOG.md`:

```markdown
- README: install in three steps, the two skills with examples, rubric ownership and sync, Part 3 templates, how to propose a skill.
```

- [ ] **Step 5: Commit**

```bash
cd /Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/product-skills && git add README.md CHANGELOG.md && git commit -F - <<'MSG'
docs: add README for product managers

Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>
MSG
/Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/product-skills && git push origin develop
```

---
### Task 12: Vendor the rubric and the sync script (gated on L4-M1)

**Files:**
- Create: `scripts/sync-rubric.sh`
- Create: `rubric/readiness.md` (copied, never edited here)
- Modify: `skills/refine-request/SKILL.md` and `skills/synthesize-interviews/SKILL.md` only if the rubric's real heading text differs from the section names the skills use
- Modify: `CHANGELOG.md`
- Test: `scripts/sync-rubric.sh --check --local <path>` in the matching, drifted, and missing-local cases

**Interfaces:**
- Consumes: the assembly-line lane's `rubric/readiness.md` at `/Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/webapp/rubric/readiness.md` (L4-M1) and, once pushed, at `https://raw.githubusercontent.com/kpnemo/kaizen-tasks-assembly-line/<ref>/rubric/readiness.md`. Front matter `version:` line.
- Produces: `scripts/sync-rubric.sh [ref]` (download at ref, default `main`, over the local copy; exit 1 on download failure), `scripts/sync-rubric.sh --local <path>` (copy from a local file), `scripts/sync-rubric.sh --check [ref | --local <path>]` (compare `version:` lines; print `rubric up to date: version <v>` or a `warning: rubric drift: ...` line; always exit 0; in GitHub Actions also emit a `::warning::` annotation). `rubric/readiness.md` at the same relative path as upstream, read by both skills.

- [ ] **Step 1: Check the gate**

Run:

```bash
test -f /Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/webapp/rubric/readiness.md && grep -m1 '^version:' /Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/webapp/rubric/readiness.md && git -C /Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/webapp log --oneline -1 -- rubric/readiness.md
```

Expected: a `version: <v>` line (for example `version: 1`) and one commit line. If the file is missing or has no `version:` line, L4-M1 has not landed: stop this lane here and report "L5 waiting on L4-M1". Do not write a rubric in this repository.

- [ ] **Step 2: Run the check and see the script is missing**

Run:

```bash
cd /Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/product-skills && bash scripts/sync-rubric.sh --check; echo "exit=$?"
```

Expected: `bash: scripts/sync-rubric.sh: No such file or directory` and `exit=127`.

- [ ] **Step 3: Write the script**

Create `scripts/sync-rubric.sh`:

```bash
#!/usr/bin/env bash
# Vendor the readiness rubric from kaizen-tasks-assembly-line, or check for drift.
#
#   scripts/sync-rubric.sh [ref]             download rubric/readiness.md at <ref> (default main)
#                                            from GitHub over the local copy
#   scripts/sync-rubric.sh --local <path>    copy from a local checkout instead of downloading
#   scripts/sync-rubric.sh --check [ref]     compare the version: lines only; warn on drift; exit 0
#   scripts/sync-rubric.sh --check --local <path>
#
# Engineering owns the rubric. This script only copies it; never edit rubric/readiness.md here.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOCAL_RUBRIC="$REPO_ROOT/rubric/readiness.md"
UPSTREAM_REPO="kpnemo/kaizen-tasks-assembly-line"
UPSTREAM_PATH="rubric/readiness.md"

check=0
source_path=""
ref="main"

while [ $# -gt 0 ]; do
  case "$1" in
    --check)
      check=1
      shift
      ;;
    --local)
      source_path="${2:-}"
      if [ -z "$source_path" ]; then
        echo "error: --local needs a path" >&2
        exit 2
      fi
      shift 2
      ;;
    -h | --help)
      sed -n '2,10p' "$0"
      exit 0
      ;;
    -*)
      echo "error: unknown option $1" >&2
      exit 2
      ;;
    *)
      ref="$1"
      shift
      ;;
  esac
done

warn() {
  echo "warning: $1" >&2
  if [ "${GITHUB_ACTIONS:-}" = "true" ]; then
    echo "::warning::$1"
  fi
}

version_of() {
  grep -m1 '^version:' "$1" | sed 's/^version:[[:space:]]*//'
}

tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT

if [ -n "$source_path" ]; then
  if [ ! -f "$source_path" ]; then
    echo "error: $source_path does not exist" >&2
    exit 1
  fi
  cp "$source_path" "$tmp"
  origin="$source_path"
else
  origin="https://raw.githubusercontent.com/$UPSTREAM_REPO/$ref/$UPSTREAM_PATH"
  if ! curl -fsSL "$origin" -o "$tmp"; then
    if [ "$check" -eq 1 ]; then
      warn "rubric drift check skipped: could not download $origin"
      exit 0
    fi
    echo "error: could not download $origin" >&2
    exit 1
  fi
fi

upstream_version="$(version_of "$tmp" || true)"
if [ -z "$upstream_version" ]; then
  echo "error: no version: line in $origin" >&2
  exit 1
fi

if [ "$check" -eq 1 ]; then
  if [ ! -f "$LOCAL_RUBRIC" ]; then
    warn "rubric/readiness.md is missing locally; upstream is version $upstream_version. Run scripts/sync-rubric.sh"
    exit 0
  fi
  local_version="$(version_of "$LOCAL_RUBRIC" || true)"
  if [ "$local_version" = "$upstream_version" ]; then
    echo "rubric up to date: version $local_version"
  else
    warn "rubric drift: local version ${local_version:-none}, upstream version $upstream_version. Run scripts/sync-rubric.sh"
  fi
  exit 0
fi

mkdir -p "$(dirname "$LOCAL_RUBRIC")"
cp "$tmp" "$LOCAL_RUBRIC"
echo "rubric/readiness.md updated to version $upstream_version from $origin"
```

Then:

```bash
cd /Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/product-skills && chmod +x scripts/sync-rubric.sh && scripts/sync-rubric.sh --help | head -n 2
```

Expected: the first two comment lines of the usage block.

- [ ] **Step 4: Vendor the rubric from the nested workspace copy**

Run:

```bash
cd /Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/product-skills && scripts/sync-rubric.sh --local /Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/webapp/rubric/readiness.md && diff -q rubric/readiness.md /Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/webapp/rubric/readiness.md && echo identical
```

Expected: `rubric/readiness.md updated to version <v> from /Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/webapp/rubric/readiness.md`, then `identical`.

- [ ] **Step 5: Drift check, matching case**

Run:

```bash
cd /Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/product-skills && scripts/sync-rubric.sh --check --local /Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/webapp/rubric/readiness.md; echo "exit=$?"
```

Expected: `rubric up to date: version <v>` (the same `<v>` as Step 1, for example `1`) and `exit=0`.

- [ ] **Step 6: Drift check, drifted case**

Run:

```bash
cd /Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/product-skills && d="$(mktemp -d)" && printf -- '---\nversion: 0.0.0-drift\n---\n\n# Readiness rubric (drift test)\n' > "$d/drift.md" && scripts/sync-rubric.sh --check --local "$d/drift.md"; echo "exit=$?"
```

Expected: `warning: rubric drift: local version <v>, upstream version 0.0.0-drift. Run scripts/sync-rubric.sh` and `exit=0`. The warning is on stderr; the exit code is 0 in both cases, which is what lets CI surface drift without failing.

- [ ] **Step 7: Drift check, missing local copy**

Run:

```bash
cd /Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/product-skills && d="$(mktemp -d)" && mv rubric/readiness.md "$d/keep.md" && scripts/sync-rubric.sh --check --local "$d/keep.md"; echo "exit=$?"; mv "$d/keep.md" rubric/readiness.md && test -f rubric/readiness.md && echo restored
```

Expected: `warning: rubric/readiness.md is missing locally; upstream is version <v>. Run scripts/sync-rubric.sh`, `exit=0`, `restored`.

- [ ] **Step 8: Network case (opt-in, needs internet; not part of `npm test`)**

Run:

```bash
cd /Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/product-skills && scripts/sync-rubric.sh --check no-such-ref; echo "exit=$?"; gh repo view kpnemo/kaizen-tasks-assembly-line --json name -q .name 2>/dev/null && scripts/sync-rubric.sh --check develop; echo "exit=$?"
```

Expected: first, `warning: rubric drift check skipped: could not download https://raw.githubusercontent.com/kpnemo/kaizen-tasks-assembly-line/no-such-ref/rubric/readiness.md` and `exit=0`. Then, if the assembly-line repo exists on GitHub (L3-M0 done), `kaizen-tasks-assembly-line` followed by `rubric up to date: version <v>` and `exit=0`; if it does not exist yet, nothing more and `exit=1` from `gh`, which is fine.

- [ ] **Step 9: Confirm the skills name the rubric's sections, formula, and output shape correctly**

Run:

```bash
cd /Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/product-skills && grep -n '^## \|^### ' rubric/readiness.md && grep -cF 'readiness = clarity * 2 + (6 - complexity) + (6 - risk)' rubric/readiness.md && for k in clarity complexity risk archChange readiness reasons questions; do grep -q "\"$k\":" rubric/readiness.md && printf '%s ' "$k"; done; echo
```

Expected, as the assembly-line plan's Task 2 writes the file: the headings `## 1. Scales`, `### Clarity`, `### Complexity`, `### Risk`, `## 2. Architecture change test`, `## 3. Readiness`, `## 4. Procedure`, `### Repo layouts used for scoring`, `## 5. Clarifying questions` in that order; then `1` (the formula line is present once); then `clarity complexity risk archChange readiness reasons questions` (the seven keys of the output shape in the JSON example under Procedure).

Both skills cite these by name: `skills/refine-request/SKILL.md` Step 1 paragraph three and `skills/synthesize-interviews/SKILL.md` Step 1 last paragraph name the five sections, the three scale tables, the formula, and the output shape; `synthesize-interviews` Step 4 names the `### Risk` table. If the vendored file's headings, formula, or JSON keys differ from what the skills cite (a later rubric version may renumber a section or change the formula), edit those citations in the two skills to match the file, run `npm test` again, and mention the change in the Task 12 changelog bullet. Do not edit the rubric.

- [ ] **Step 10: Changelog bullet**

Add under `### Added` in `CHANGELOG.md`:

```markdown
- `rubric/readiness.md` vendored from `kaizen-tasks-assembly-line` at version <v>, and `scripts/sync-rubric.sh` with `[ref]`, `--local <path>`, and `--check` (warns on drift, never fails).
```

Replace `<v>` with the version from Step 1.

- [ ] **Step 11: Commit**

```bash
cd /Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/product-skills && git add scripts/sync-rubric.sh rubric/readiness.md CHANGELOG.md skills/refine-request/SKILL.md skills/synthesize-interviews/SKILL.md && git commit -F - <<'MSG'
feat: vendor readiness rubric with sync and drift check script

Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>
MSG
/Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/product-skills && git push origin develop
```

(`git add` on the two SKILL.md files is a no-op when Step 9 changed nothing.)

---

### Task 13: CI workflow

**Files:**
- Create: `.github/workflows/ci.yml`
- Modify: `CHANGELOG.md`
- Modify: `docs/superpowers/specs/2026-09-08-kaizen-tasks-product-skills-design.md` (section 9, row P3 status, after the first CI run)
- Test: the four checks run locally in CI order; then the workflow on GitHub

**Interfaces:**
- Consumes: npm scripts `test`, `lint`, `typecheck`, `pdf` (Task 1), `scripts/sync-rubric.sh --check` (Task 12), the two PDF paths (Task 10), `.nvmrc` (Task 1).
- Produces: workflow and job id `ci`, run on pull requests and on pushes to `main` and `develop`. The spec names pushes to `main`; `develop` is added because this lane commits straight to `develop` and the L5-M1 condition is "CI green" there.

- [ ] **Step 1: Run the four checks locally, in CI order, before the workflow exists**

Run:

```bash
cd /Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/product-skills && nvm use >/dev/null && npm ci && npm test && bash scripts/sync-rubric.sh --check --local /Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/webapp/rubric/readiness.md && npx playwright install chromium && npm run pdf && for p in templates/part3/agentic-layer-canvas.pdf templates/part3/plan-30-60-90.pdf; do test -s "$p" || { echo "missing or empty: $p"; exit 1; }; done && npm run lint && npm run typecheck; echo "exit=$?"; test -f .github/workflows/ci.yml; echo "workflow exists: $?"
```

Expected: the two `ok:` lines, `rubric up to date: version <v>`, the two `wrote ...` lines, the lint output ending with `All matched files use Prettier code style!`, `exit=0`, then `workflow exists: 1` (the file is not there yet).

- [ ] **Step 2: Write the workflow**

Create `.github/workflows/ci.yml`:

```yaml
name: ci

on:
  pull_request:
  push:
    branches: [main, develop]

jobs:
  ci:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v7

      - uses: actions/setup-node@v7
        with:
          node-version-file: .nvmrc
          cache: npm

      - run: npm ci

      - name: Skill front matter
        run: npm test

      - name: Rubric drift (warns, never fails)
        run: bash scripts/sync-rubric.sh --check

      - name: Build PDFs
        run: |
          npx playwright install --with-deps chromium
          npm run pdf
          for f in templates/part3/agentic-layer-canvas.pdf templates/part3/plan-30-60-90.pdf; do
            test -s "$f" || { echo "missing or empty: $f"; exit 1; }
          done

      - name: Markdown lint, script lint, typecheck
        run: |
          npm run lint
          npm run typecheck
```

- [ ] **Step 3: Validate the YAML parses and names the four checks**

Run:

```bash
cd /Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/product-skills && node -e 'const y=require("fs").readFileSync(".github/workflows/ci.yml","utf8"); const names=[...y.matchAll(/^\s+- name: (.+)$/gm)].map(m=>m[1]); console.log(names.join(" | ")); console.log(/^jobs:\n  ci:/m.test(y) ? "job id ci" : "job id wrong")'
```

Expected:

```
Skill front matter | Rubric drift (warns, never fails) | Build PDFs | Markdown lint, script lint, typecheck
job id ci
```

- [ ] **Step 4: Changelog bullet**

Add under `### Added` in `CHANGELOG.md`:

```markdown
- CI workflow `ci` on pull requests and pushes to `main` and `develop`: skill front matter, rubric drift warning, PDF build, markdown and script lint.
```

- [ ] **Step 5: Commit**

```bash
cd /Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/product-skills && git add .github/workflows/ci.yml CHANGELOG.md && git commit -F - <<'MSG'
ci: add workflow with front matter, rubric drift, PDF, and lint checks

Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>
MSG
/Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/product-skills && git push origin develop
```

- [ ] **Step 6: Push to `develop` and watch the first run (when the GitHub repo exists)**

Run:

```bash
cd /Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/product-skills && git remote get-url origin && git push origin develop && sleep 20 && gh run list --workflow ci --branch develop --limit 1 && gh run watch "$(gh run list --workflow ci --branch develop --limit 1 --json databaseId -q '.[0].databaseId')" --exit-status; echo "exit=$?"
```

Expected: `https://github.com/kpnemo/kaizen-tasks-product-skills.git` (or the `git@` form), the push output, a run row that ends as `completed  success`, `gh run watch` printing each step with a check mark, and `exit=0`.

If `git remote get-url origin` fails with `error: No such remote 'origin'`, the CI/CD lane (L3-M0) has not created the repository yet. Leave the workflow committed; the orchestrator re-runs this step after L3-M0, and L5-M1 is not complete until the run is green.

If the `Build PDFs` step fails on the Ubuntu runner, open the log. A failure inside `npx playwright install --with-deps chromium` is a runner or apt problem: re-run the job once. A failure in `npm run pdf` with a font error is the P3 fallback case: add `fonts-liberation` explicitly with `sudo apt-get install -y fonts-liberation` as a line before `npm run pdf` in the workflow, commit, push, and watch again. When the step passes, the P3 verification item is done.

- [ ] **Step 7: Record P3 in the spec's verification table**

In `docs/superpowers/specs/2026-09-08-kaizen-tasks-product-skills-design.md` section 9, change the P3 row's Status cell from `Open, verified by the first CI run` to `Verified <date>, run <url>` with the date and the `gh run view --web`-style URL of the green run (for example `https://github.com/kpnemo/kaizen-tasks-product-skills/actions/runs/<id>`). Then:

```bash
cd /Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/product-skills && git add docs/superpowers/specs/2026-09-08-kaizen-tasks-product-skills-design.md && git commit -F - <<'MSG'
docs: record P3 verification from the first CI run

Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>
MSG
/Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/product-skills && git push origin develop
```

---

### Task 14: Verify P1 by running both skills from a fresh clone

**Files:**
- Modify: `docs/superpowers/specs/2026-09-08-kaizen-tasks-product-skills-design.md` (section 9, row P1 status)
- Create, only if the fallback is needed: `.claude/skills/refine-request` and `.claude/skills/synthesize-interviews` as relative symlinks to `../../skills/<name>`
- Modify: `CHANGELOG.md` (only if the fallback is added)
- Test: the manual check below, plus `grep` checks on the synthesis file

**Interfaces:**
- Consumes: everything: the README install steps (Task 11), both skills (Tasks 3, 4), the rubric (Task 12), `data/prd-sample.md` (Task 8), the three transcripts (Tasks 5 to 7).
- Produces: the L5-M1 evidence: `/refine-request` and `/synthesize-interviews` run from a fresh clone; the spec's P1 row updated.

This task is interactive. Whoever runs it (Mike, or the implementer with Mike watching) plays the product manager. Time the whole thing from the clone command to the refined request; the PRD's S4 target is under ten minutes.

- [ ] **Step 1: Fresh clone**

If L3-M0 has published the repository, clone as a PM would; otherwise clone the local repository:

```bash
P1="${TMPDIR:-/tmp}/p1-check" && rm -rf "$P1" && mkdir -p "$P1" && cd "$P1" && (gh repo view kpnemo/kaizen-tasks-product-skills --json name -q .name >/dev/null 2>&1 && git clone -b develop https://github.com/kpnemo/kaizen-tasks-product-skills.git || git clone -b develop /Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/product-skills kaizen-tasks-product-skills) && cd kaizen-tasks-product-skills && ls skills rubric data/interviews && test ! -d node_modules && echo "no install needed"
```

Expected: `refine-request  synthesize-interviews`, `readiness.md`, the three transcript names, and `no install needed`.

- [ ] **Step 2: Open Claude Code in the clone and run `/refine-request`**

In a terminal:

```bash
cd "${TMPDIR:-/tmp}/p1-check/kaizen-tasks-product-skills" && claude
```

Type `/` and confirm `refine-request` and `synthesize-interviews` appear in the command list. Then run:

```
/refine-request data/prd-sample.md
```

Expected transcript, in order (wording may vary; the checks in Step 4 are what matter):

1. `Rubric version: <v>` on the first line, then `Request source: data/prd-sample.md`.
2. A "Before" table whose Clarity cell is `3` with a reason that says the behavior is described but the acceptance criteria are not testable. Complexity, risk, architecture change, and readiness may vary with the rubric text; note them.
3. The first question is about **done criteria**, not about the user or the behavior, because sections 4 and 5 of the PRD already answer those and section 6 states out of scope. It arrives through the AskUserQuestion tool with three or four options drawn from the PRD, for example `Opening the page for a team of 12 shows every agent with at least one contact reason below the team`, `Each flagged reason shows three example interactions that open in one click`, `System wait time is shown separately from talk time on each example`, `Marking an example as not useful removes it from the list`. Pick one.
4. Two more done-criteria questions, each with new options, until three criteria exist. Then possibly one complexity probe such as `Does this need information we do not store today?` (the PRD's last open question implies new data). Answer `No, what we have already`.
5. The skill stops: it prints `Rubric version: <v>`, the five sections `### Problem`, `### Proposed behavior`, `### Acceptance criteria` (three or more bullets, each one you chose), `### Out of scope` (the three items from PRD section 6), `### Your role` (`Team supervisor` or the product owner, taken from the text), then the Before/After table with After clarity `4` and a higher readiness, then one sentence such as `Naming the three tester checks moved clarity from 3 to 4.`, then `Paste the five sections into the Feature request form of the kaizen-tasks-assembly-line repository, or into your own tracker.`
6. No `gh issue edit` offer, because the source was a file. No labels mentioned as applied.

Total questions asked: between three and five. If the first question asks who the user is, the skill's "never ask what is already answered" rule is not being followed; that is a defect to fix in `skills/refine-request/SKILL.md` Step 4 before recording P1.

- [ ] **Step 3: If `/refine-request` is not listed, apply the P1 fallback**

If the command list does not show the two skills when the repo is opened directly as a project, add the `.claude/skills` layer as relative symlinks, in the real repository, not the clone:

```bash
cd /Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/product-skills && mkdir -p .claude/skills && ln -s ../../skills/refine-request .claude/skills/refine-request && ln -s ../../skills/synthesize-interviews .claude/skills/synthesize-interviews && ls -l .claude/skills && test -f .claude/skills/refine-request/SKILL.md && echo "symlinks resolve"
```

Expected: two `->` lines and `symlinks resolve`. Add under `### Added` in `CHANGELOG.md`:

```markdown
- `.claude/skills` symlinks to the plugin's skill folders so the repository works when opened directly as a project.
```

Commit:

```bash
cd /Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/product-skills && git add .claude/skills CHANGELOG.md && git commit -F - <<'MSG'
fix: add .claude/skills symlink layer so skills load when the repo is opened directly

Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>
MSG
/Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/product-skills && git push origin develop
```

Then repeat Step 1 and Step 2. Also confirm the plugin shape itself loads, which is the marketplace path: `claude --plugin-dir "${TMPDIR:-/tmp}/p1-check/kaizen-tasks-product-skills"` from any other folder, then `/` should list the skills, possibly namespaced as `/kaizen-tasks-product-skills:refine-request`.

- [ ] **Step 4: Run `/synthesize-interviews` with no arguments**

Still in the clone's Claude Code session:

```
/synthesize-interviews
```

Expected: `Rubric version: <v>`, then a multi-select question `Which transcripts should I synthesize?` listing `01-supervisor.md`, `02-agent.md`, `03-workforce-planner.md` with their personas. Select all three. The skill reads them, prints `Transcripts: 01-supervisor.md, 02-agent.md, 03-workforce-planner.md`, works, then prints the rubric version, the path `out/<today>-synthesis.md`, and an opportunity table of at least four rows whose top rows are about coaching prep and per-reason visibility (2 of 3 transcripts), one-screen customer context and re-typing (2 of 3), promotion-day forecasting, shift swaps, and intraday reallocation (1 of 3 each). It then asks `Refine one of the candidates now?`; answer `Not now`.

Then check the file from a second terminal:

```bash
cd "${TMPDIR:-/tmp}/p1-check/kaizen-tasks-product-skills" && f="$(ls out/*-synthesis.md | head -n1)" && echo "$f" && grep -c '^## ' "$f" && grep -c '^### Candidate' "$f" && grep -c '^Rubric version:' "$f" && grep -ci 'disposition' "$f" && grep -h '^> "' "$f" | sed 's/^> "//; s/" — .*$//' | while IFS= read -r q; do grep -qF "$q" data/interviews/*.md && echo "verbatim: ok" || echo "NOT VERBATIM: $q"; done | sort | uniq -c
```

Expected: the file path; `5` (the five `##` sections); `2` or `3` candidates; `1`; a count of at least `1` (the disposition-code contradiction is recorded); and one line `N verbatim: ok` with no `NOT VERBATIM` lines. A `NOT VERBATIM` line means a quote was paraphrased inside quotation marks, which is the rule the skill must not break; fix the wording of Step 3 in `skills/synthesize-interviews/SKILL.md` and re-run before recording P1.

Also confirm each candidate carries the five headings and a score line:

```bash
cd "${TMPDIR:-/tmp}/p1-check/kaizen-tasks-product-skills" && f="$(ls out/*-synthesis.md | head -n1)" && for h in 'Problem' 'Proposed behavior' 'Acceptance criteria' 'Out of scope' 'Your role'; do printf '%s: %s\n' "$h" "$(grep -c "^### $h\$" "$f")"; done && grep -c '^Score: clarity [1-5], complexity [1-5], risk [1-5], architecture change \(yes\|no\), readiness [0-9]*' "$f"
```

Expected: each heading with the same count as the number of candidates, and the score-line count equal to that number.

- [ ] **Step 5: Record P1 and the timing in the spec**

In `docs/superpowers/specs/2026-09-08-kaizen-tasks-product-skills-design.md` section 9, change the P1 row's Status cell to one of:

- `Verified <date>: both skills run from a fresh clone opened directly in Claude Code; clone to refined request in <m> minutes`, or
- `Verified <date> with the fallback: .claude/skills symlinks added; clone to refined request in <m> minutes`.

Then:

```bash
cd /Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/product-skills && git add docs/superpowers/specs/2026-09-08-kaizen-tasks-product-skills-design.md && git commit -F - <<'MSG'
docs: record P1 verification from a fresh clone

Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>
MSG
/Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/product-skills && git push origin develop
```

- [ ] **Step 6: Check the L5-M1 condition and report**

The master plan's L5-M1 is done when `/refine-request` and `/synthesize-interviews` run from a fresh clone (Steps 2 and 4), the PDFs are built (Task 10, and CI's `Build PDFs` step), and CI is green (Task 13 Step 6). Run:

```bash
cd /Users/Mike.Bogdanovsky/Projects/nice-product-workshop-Sep.2026/product-skills && git status --short && git log --oneline develop | head -n 20 && test -s templates/part3/agentic-layer-canvas.pdf && test -s templates/part3/plan-30-60-90.pdf && echo "pdfs present" && (gh run list --workflow ci --branch develop --limit 1 2>/dev/null || echo "no GitHub remote yet")
```

Expected: an empty status, one commit per task in this plan plus the P1 and P3 records (fifteen to seventeen from this plan, after the four earlier commits: init, spec, plan, review fixes), `pdfs present`, and either a `completed  success` run row or `no GitHub remote yet`. Report L5-M1 as done only with the green run; otherwise report "L5-M1 pending CI run after L3-M0" and the clone-to-refined-request timing. P2 (Claude Desktop and Cowork) stays with Mike per the spec; remind him in the report.

---

## Self-review against the spec

**1. Spec coverage.**

| Spec section | Requirement | Task |
|---|---|---|
| 1 Purpose, A1 to A4 | Skills as `SKILL.md` folders, plugin shape, vendored rubric, one question at a time through the question tool, synthetic data | 2, 3, 4, 5 to 8, 12 |
| 2 Repo shape | Every path listed | 1 (`package.json`, `.nvmrc`, `.gitignore`, `CHANGELOG.md`), 2 (`.claude-plugin/plugin.json`), 3 and 4 (`skills/`), 5 to 8 (`data/`), 9 and 10 (`templates/part3/` md and pdf), 10 and 12 (`scripts/`), 11 (`README.md`), 12 (`rubric/`), 13 (`.github/workflows/ci.yml`); `out/` git-ignored in 1; `docs/superpowers/` exists |
| 3.1 refine-request | Front matter strings, source rules including `gh issue view`, before score, one question per turn, question tool with three or four options, question order, never re-ask, silent re-score, stop condition, cap of eight with "still missing", five-section output, before-and-after table, one sentence, `gh issue edit --body-file` offer, never labels or comments, tone rules | 3 |
| 3.2 synthesize-interviews | Front matter strings, read or offer the three, jobs in the when-I form, pains with one to three verbatim quotes by role and transcript, opportunities with frequency and severity, two or three candidates in the five sections pre-scored, `out/<date>-synthesis.md`, print the table, offer `refine-request` | 4 |
| 3.3 Shared rubric behavior | Both skills follow the Procedure section verbatim and print the version | 3, 4, 12 Step 9 |
| 4 Rubric sync | `sync-rubric.sh [ref]` from the raw URL, default `main`; `--check` compares `version:` lines, warns, exits 0; README says engineering owns it | 12, 11 |
| 5 Part 3 templates | Canvas four columns by four rows plus top-three footer; plan three columns by up to three commitments with owner, signal, first step, team and date header; facilitator sheet with the 45-minute timing, column prompts, prioritization rule, closing line, no facilitator commitment; `build-pdf.mjs` A4 landscape and portrait via Playwright Chromium with large-type print stylesheet; PDFs committed and rebuilt by `npm run pdf` | 9, 10 |
| 6 Synthetic data | Three transcripts of 60 to 90 exchanges (67, 66, 66), personas and themes as tabled, invented names, at least two quotable pains per theme, one contradiction across personas (disposition codes); `prd-sample.md` two pages at clarity 3 | 5, 6, 7, 8 |
| 7 README | The seven sections, one page | 11 |
| 8 CI | Front matter check, `sync-rubric.sh --check` warning surfaced, `npm run pdf` with missing-or-empty failure, markdown lint | 13 |
| 9 Verification items | P1 by a fresh-clone run of `/refine-request` (last task, with the symlink fallback); P3 by the first CI run (Task 13 Step 6 and 7, with the font fallback); P2 stays with Mike and the README carries the copy-the-folders line | 14, 13, 11 |
| 10 Out of scope | No marketplace publishing, no connectors, no real data, no harness, no slides anywhere in the plan | all |
| PRD Q1 to Q4, T1 to T4 | Covered by the rows above; T4 (no ongoing commitment) is checked by grep in Task 9 Step 5 | 9, 11 |
| Master plan L5 row and section 3 | Tasks 1 to 11 start now; the rubric is vendored from the nested `webapp/rubric/readiness.md` with `--local` and the script points at GitHub | 12 |

Deliberate deviations, each small and stated where it happens: CI also runs on pushes to `develop` (Task 13); Prettier, ESLint flat config, and `checkJs` strict are added to satisfy the global constraints even though the spec's CI list does not name them (Tasks 1, 10, 13); `sync-rubric.sh --check` treats an unreachable upstream as a warning rather than a failure so CI stays green before the assembly-line repo publishes `main` (Task 12); the spec's P1 row says "verified in the first task" but the check needs the rubric and the data, so it is the last task, as the lane brief asks (Task 14).

**2. Placeholder scan.** Searched the plan for `TBD`, `TODO`, `implement later`, `fill in`, `similar to Task`, and `appropriate`; none remain. The only angle-bracket tokens are values that come from outside this repository at run time and are named as such: `<v>` (the upstream rubric version, first read in Task 12 Step 1), `<date>` and `<m>` (recorded during the P1 run), `<url>` and `<id>` (the CI run), and the `<n>` issue number inside the skill text where it is the skill's own notation.

**3. Consistency.** Script names and flags match everywhere: `scripts/check-skills.sh` (Tasks 1, 3, 4, 13), `scripts/sync-rubric.sh` with `[ref]`, `--local <path>`, `--check` (Tasks 11, 12, 13, and the skills' missing-rubric message in 3 and 4), `scripts/build-pdf.mjs` via `npm run pdf` (Tasks 1, 10, 11, 13). The five headings `### Problem`, `### Proposed behavior`, `### Acceptance criteria`, `### Out of scope`, `### Your role` are identical in Tasks 3, 4, and the checks in 4 and 14. The quote line format `> "<quote>" — <role>, <file name>` defined in Task 4 is what Task 14's verbatim check parses. The transcript header row `Role` named in Task 5 is what Task 4 Step 2 reads. Persona names, company, sites, and system names are the same across Tasks 5 to 8. Versions are pinned identically in `package.json` (Task 1) and named in the header.
