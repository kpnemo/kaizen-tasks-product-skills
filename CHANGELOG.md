# Changelog

All notable changes to this repository are recorded here. The format follows Keep a Changelog; versions follow semantic versioning and match `.claude-plugin/plugin.json`.

## [Unreleased]

### Added

- `scripts/package-skills.sh` (`npm run package`): zips each `skills/<name>/` folder to `dist/<name>.zip`, unpacking to `<name>/SKILL.md` and `<name>/readiness.md`, ready to upload to claude.ai.
- Repository scaffold: Node 24 pin, npm scripts `pdf`, `sync-rubric`, `lint`, `typecheck`, `test`, markdown lint, Prettier, ESLint flat config, `checkJs` strict, and the skill front matter check.
- Plugin manifest `.claude-plugin/plugin.json` so the repository loads as a Claude Code plugin.
- `refine-request` skill: scores a request with the rubric, interviews one question at a time to readiness, rewrites it in the issue form's five sections, and offers `gh issue edit` for the author's own issue.
- `synthesize-interviews` skill: transcripts to jobs to be done, pains with verbatim quotes, an opportunity table scored by frequency and severity, and pre-scored candidate requests written to `out/`.
- Synthetic interview transcript `data/interviews/01-supervisor.md` (team supervisor: coaching prep, per-intent visibility, after-call work backlog).
- Synthetic interview transcript `data/interviews/02-agent.md` (frontline agent: five tools per interaction, stale knowledge base, arbitrary wrap-up codes).
- Synthetic interview transcript `data/interviews/03-workforce-planner.md` (workforce planner: promotion-day forecast misses, shift swaps by email, manual intraday reallocation).
- `data/prd-sample.md`: a two-page sample PRD for "Coaching insights" written at clarity 3, the default input for `/refine-request`.
- Part 3 templates in `templates/part3/`: agentic layer canvas, 30/60/90 plan, and the 45-minute facilitator sheet.
- `scripts/build-pdf.mjs` renders the canvas (A4 landscape) and the 30/60/90 plan (A4 portrait) to PDF with Playwright's Chromium; the PDFs are committed under `templates/part3/`.
- README: install in three steps, the two skills with examples, rubric ownership and sync, Part 3 templates, how to propose a skill.
- `rubric/readiness.md` vendored from `kaizen-tasks-assembly-line` at version 1, and `scripts/sync-rubric.sh` with `[ref]`, `--local <path>`, and `--check` (warns on drift, never fails).
- CI workflow `ci` on pull requests and pushes to `main` and `develop`: skill front matter, rubric drift warning, PDF build, markdown and script lint.
- `.claude/skills` symlinks to the plugin's skill folders so the repository works when opened directly as a project.

### Fixed

- Skills upload to claude.ai, Claude Desktop and Cowork: `argument-hint` removed from the front matter (the upload rejects any field outside the Agent Skills spec) and each skill folder carries its own `readiness.md`, kept in sync by `scripts/sync-rubric.sh`; `npm run package` builds the two ZIPs.
- Final review fixes: rubric sync tracks `develop`; 30/60/90 template asks for three commitments; filing URL and analogy rule in the skills; README prerequisites and install locations; the README rubric link tracks `develop`.
