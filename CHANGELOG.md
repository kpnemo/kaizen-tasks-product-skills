# Changelog

All notable changes to this repository are recorded here. The format follows Keep a Changelog; versions follow semantic versioning and match `.claude-plugin/plugin.json`.

## [Unreleased]

### Added

- Repository scaffold: Node 24 pin, npm scripts `pdf`, `sync-rubric`, `lint`, `typecheck`, `test`, markdown lint, Prettier, ESLint flat config, `checkJs` strict, and the skill front matter check.
- Plugin manifest `.claude-plugin/plugin.json` so the repository loads as a Claude Code plugin.
- `refine-request` skill: scores a request with the rubric, interviews one question at a time to readiness, rewrites it in the issue form's five sections, and offers `gh issue edit` for the author's own issue.
- `synthesize-interviews` skill: transcripts to jobs to be done, pains with verbatim quotes, an opportunity table scored by frequency and severity, and pre-scored candidate requests written to `out/`.
