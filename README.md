# Kaizen Tasks product skills

Two Claude Code skills for product managers, the readiness rubric engineering scores requests with, the Part 3 planning templates, and synthetic data so everything runs without customer material. Built for the Kaizen Tasks workshop and packaged as a Claude Code plugin, so it can go to the company marketplace later without restructuring.

## Install in three steps

1. Clone: `git clone https://github.com/kpnemo/kaizen-tasks-product-skills.git` and `cd kaizen-tasks-product-skills`.
2. Open the folder in Claude Code (`claude` from inside it), or add the folder as a project in Cowork or Claude Desktop. If the skills do not appear there, copy the two folders under `skills/` into `~/.claude/skills/` for Claude Code, or the Skills folder under Settings → Capabilities in Claude Desktop. If you both install the plugin and open this folder as a project, Claude Code may list each skill twice; either path alone is enough.
3. Run `/refine-request data/prd-sample.md`.

The skills need no install step. `npm install` is only for rebuilding the PDFs and running the checks. You need git and Claude Code. `gh` (`brew install gh`, then `gh auth login`) is only needed if you want the skill to read or update a GitHub issue; everything else works without it.

## The two skills

### `/refine-request <issue number | file path | pasted text>`

Scores a feature request with the rubric, asks one question at a time until it would score as ready, and returns the request rewritten in the five sections of the engineering issue form with a before-and-after score. Example: `/refine-request data/prd-sample.md`. With an issue number from `kaizen-tasks-assembly-line` (or an issue URL) and a logged-in `gh`, it offers to update your own issue; it never applies labels or comments. Otherwise, file it yourself at <https://github.com/kpnemo/kaizen-tasks-assembly-line/issues/new?template=feature-request.yml>.

### `/synthesize-interviews <transcript paths...>`

Turns interview transcripts into jobs to be done, pains with verbatim quotes, an opportunity table, and two or three candidate feature requests already in the form's sections and pre-scored. Example: `/synthesize-interviews data/interviews/01-supervisor.md data/interviews/02-agent.md data/interviews/03-workforce-planner.md`, or with no arguments to be offered the bundled three. Output lands in `out/`, which is git-ignored.

## The rubric

`rubric/readiness.md` is a copy of the rubric engineering owns in [kaizen-tasks-assembly-line](https://github.com/kpnemo/kaizen-tasks-assembly-line/blob/develop/rubric/readiness.md). Both skills read it and print its version, so your local score and the engineering triage score agree for the same text. Engineering's triage applies the score labels (`clarity:1..5`, `complexity:1..5`, `risk:1..5`, `arch-change`, `triaged`) to issues; the skills here never do.

- Pull the latest: `npm run sync-rubric` (or `scripts/sync-rubric.sh [ref]`).
- Check for drift without changing anything: `scripts/sync-rubric.sh --check`. CI prints a warning on drift and does not fail.

## Part 3 templates

`templates/part3/` holds the agentic layer canvas (A4 landscape), the 30/60/90 plan (A4 portrait), and the facilitator sheet, as markdown, with the two printable ones also as PDF. Rebuild the PDFs with `npm install`, `npx playwright install chromium`, then `npm run pdf`.

## Propose a new skill

Open a pull request against `develop` that adds `skills/<name>/SKILL.md` with `name` (equal to the folder name) and `description` in its front matter, and one example under "The two skills" above. `npm test` checks the front matter; CI runs it.

## After the session

Distribution goes through the company Claude marketplace and Enterprise connectors; this repository is already in plugin shape for that.
