# Workshop Repository: GitHub Copilot Instructions

This repository is the participant- and instructor-facing material for the workshop **"Coding with AI Agents: A Hands-On Workshop for Scientists"** (2026 Interdisciplinary Science Summit, Schmidt Sciences x VISS centers).

You are assisting an instructor or workshop participant. Optimize for **clarity, reproducibility, and teaching value** over cleverness.

## Repo at a glance

- `docs/`, workshop outline, participant setup guide.
- `blocks/0N-*/`, one folder per block. Each contains `slides.md` (Marp), a `demo/` folder, `instructor-notes.md`, and `resources.md`.
- `blocks/01-landscape/demo/starter/`, a tiny `sci_units` Python package used as the running scenario across blocks.
- `.devcontainer/`, Codespace setup (Python 3.12 + uv + Jupyter + Copilot).
- `pyproject.toml`, `uv`-managed dependencies for the workshop environment.

## Conventions

- **Python 3.12.** Use the standard library where reasonable.
- **Package manager: `uv`.** Run things as `uv run <cmd>`. Add deps with `uv add <pkg>`. Do not generate `pip install` instructions in workshop material unless explaining why we *aren't* using it.
- **Code style: `ruff` (configured in `pyproject.toml`).** Format and lint on save.
- **Notebooks:** every code cell should be preceded by a markdown cell that explains *why* the code exists. The notebook should read top-to-bottom as a teaching document, not a script with comments.
- **Slides:** Marp-flavored markdown. View / present with the **Marp for VS Code** extension (preinstalled in the Codespace); export with `Marp: Export Slide Deck...` from the command palette.
- **No emojis** in workshop material unless an instructor explicitly asks for one.

## When asked to write workshop content

- Be opinionated. The workshop's stance is that **all coding agents work the same way under the hood**; reinforce that thread.
- Prefer durable, transferable concepts to product-specific trivia.
- Show, don't tell. Reach for an example or a tiny runnable snippet before reaching for prose.
- Keep examples self-contained inside `blocks/0N-*/demo/`.

## Workshop customizations (`.github/`)

This repo ships a gallery of Copilot customizations under `.github/`, indexed in the [customization gallery in the root README](../README.md#copilot-customization-gallery):

- **Custom agents** in [`.github/agents/`](agents/) (the renamed "chat modes", now `*.agent.md`): `scientific-python-reviewer` and `docstring-writer` are the two Block 4 worked examples; `reproducibility-auditor` and `research-pair` extend the pattern.
- **Commands (prompt files)** in [`.github/prompts/`](prompts/): `scaffold-package`, `eda-summary`, `write-tests`, `citation-and-release`, plus the **Block 3 research-loop workflow** (`research`, `plan`, `iterate-plan`, `experiment`, `implement`, `validate`, `handoff`) — adapted in-repo from UW SSEC's `rse-plugins`.
- **Skills** in [`.github/skills/`](skills/): `experiment-log` (bundles a helper script).
- **Path-scoped instructions** in [`.github/instructions/`](instructions/): `notebooks` and `tests` conventions (auto-applied by `applyTo` glob).

They are referenced in Block 4 as scaffolding for attendees to build their own. When asked "what is this agent/command/skill" or "how does this work", read the relevant file directly. Note: custom agents were formerly "custom chat modes" (`.chatmode.md`); we use the current `.agent.md` form.

## Things to avoid

- Don't add new top-level dependencies without a reason, workshop participants are running on Codespaces with limited time.
- Don't restructure the `blocks/` layout; the four-block structure is load-bearing.
- Don't introduce a JavaScript build step. Slides are rendered by the Marp for VS Code extension; no CLI invocations should be required.
