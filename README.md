# Coding with AI Agents: A Hands-On Workshop for Scientists

Workshop materials for the **2026 Interdisciplinary Science Summit**, hosted by Schmidt Sciences and the VISS centers.

This repository contains the slides, demos, hands-on notebooks, and instructor notes for a ~2-hour workshop teaching scientists how AI coding agents work and how to use them well in research software engineering.

## Quick start (participants)

1. Make sure your GitHub handle has been added to the team [`2026-viss-ai-workshop-participants`](https://github.com/orgs/schmidt-sciences/teams/2026-viss-ai-workshop-participants).
2. Click **Code → Create codespace on main** at the top of this repo. The first build takes ~3 minutes.
3. When VSCode opens in your browser, wait for the `.devcontainer` setup scripts to finish. They print green `==> ... complete` lines as they run; the last one reads `complete — Copilot extension is installed.`
4. Open `blocks/01-landscape/demo/notebook.ipynb` and follow along.

Detailed setup, troubleshooting, and pre-workshop checks are in [`docs/setup.md`](docs/setup.md).

## Workshop structure

The workshop is organized into four 30-minute-ish blocks. See [`docs/workshop-outline.md`](docs/workshop-outline.md) for the full prose outline.

| # | Block | Folder | Format |
|---|---|---|---|
| 1 | The AI Coding Agent Landscape | [`blocks/01-landscape/`](blocks/01-landscape/) | Slides + demo notebook |
| 2 | How It Actually Works (post-training & tool calling) | [`blocks/02-how-it-works/`](blocks/02-how-it-works/) | Slides + model-swap notebook |
| 3 | Agent-Driven Research Software Engineering | [`blocks/03-research-loop/`](blocks/03-research-loop/) | Slides + live Copilot Chat workflow demo |
| 4 | Build Your Own Skill (capstone) | [`blocks/04-build-a-skill/`](blocks/04-build-a-skill/) | Slides + hands-on custom-agent build |

Each block folder follows the same layout:

```
blocks/0N-name/
  README.md            # what this block teaches, learning goals, timing
  slides.md            # Marp-flavored slides
  instructor-notes.md  # speaker notes, demo script, fallbacks
  resources.md         # curated further reading
  demo/                # runnable code, starter files, notebooks
```

## Tools used

- **Copilot Chat in VSCode / Codespaces**: the deep-dive tool through Blocks 1, 2, and 4. The Codespace ships a custom **OAI-compatible Copilot** extension ([`uw-ssec/oai-compatible-copilot`](https://github.com/uw-ssec/oai-compatible-copilot)) that points Copilot Chat at the workshop's gateway, so you don't need your own Copilot subscription — you pick the workshop's models (Claude Sonnet 4.6, Claude Haiku 4.5) right in the model picker.
  - *Why a custom extension?* Stock Copilot Chat does support bring-your-own-key, but its in-editor flow needs a per-participant GitHub sign-in with a Copilot entitlement, manual per-user key entry, and a fixed list of named providers with no "point at an arbitrary OpenAI-compatible base URL" option. The custom extension reads the gateway URL + key from the Codespace secrets and pre-registers the models, so Chat works on launch for everyone with zero setup and no Copilot license. (The pre-installed **Copilot CLI** instead uses stock BYOK directly via the `COPILOT_PROVIDER_*` env vars, since the CLI *does* accept a custom base URL.)
  - Block 4's capstone uses **custom agents** (`.github/agents/*.agent.md`, the renamed "chat modes"); the workshop ships a whole gallery of customizations in [`.github/`](.github/) — agents, prompt-file commands, a skill, and path-scoped instructions — indexed in the [customization gallery below](#copilot-customization-gallery) for participants to read and remix.
- **Copilot Chat prompt-file commands** for Block 3's research loop: `/research`, `/plan`, `/iterate-plan`, `/experiment`, `/implement`, `/validate`, `/handoff` ship **in-repo** as [`.github/prompts/*.prompt.md`](.github/prompts/) and run in the same Copilot Chat panel (agent mode) — no marketplace plugin to install. The phase design and artifact templates are adapted from UW SSEC's [`rse-plugins`](https://github.com/uw-ssec/rse-plugins) research-plan-implement workflow. The GitHub Copilot CLI also comes pre-installed (BYOK against the same gateway).
- **Claude (via the workshop's LiteLLM/LLMoxie gateway)**: the model backend, fronting Claude Sonnet 4.6 and Claude Haiku 4.5. Copilot Chat, the Copilot CLI, and the notebooks all hit the same gateway. The notebooks use the **`litellm` Python SDK** so the same agent loop also works against any other model the gateway fronts (GPT, Gemini, ...), change one constant.
- **Python 3.12 + `uv`**: environment and package management.
- **Marp**: slides as markdown.

You don't need anything installed locally: everything runs in a GitHub Codespace.

## Copilot customization gallery

The [`.github/`](.github/) folder is a **worked gallery** of the ways you can
customize an AI coding agent for research software engineering, using GitHub
Copilot's current customization surface. It pairs with Block 4 of the workshop
("Build Your Own Skill"): read these as references, then write your own.

Everything there is plain markdown (plus one tiny Python helper). The whole point
of the workshop's spine — _all coding agents work the same way under the hood_ —
is that these files are just **structured prompts + tool lists + project
memory**. The same ideas port to Claude Code skills, Cursor rules, and others.

### The five primitives

| Primitive                    | Folder                                   | Invoked                     | Best for                                     |
| ---------------------------- | ---------------------------------------- | --------------------------- | -------------------------------------------- |
| **Project memory**           | `.github/copilot-instructions.md`        | Always on                   | Conventions every chat should know           |
| **Path-scoped instructions** | `.github/instructions/*.instructions.md` | Auto, by `applyTo` glob     | Rules for a file type (notebooks, tests)     |
| **Custom agents**            | `.github/agents/*.agent.md`              | Agent picker                | A persistent persona with a narrow tool list |
| **Commands (prompt files)**  | `.github/prompts/*.prompt.md`            | `/name` slash command       | A repeatable one-shot task                   |
| **Skills**                   | `.github/skills/<name>/SKILL.md`         | On demand (auto or `/name`) | A multi-step capability that bundles scripts |

> **Note on naming:** custom agents were previously called **custom chat
> modes** (`.chatmode.md` in `.github/chatmodes/`). VS Code renamed them to
> custom agents (`.agent.md` in `.github/agents/`); the functionality is the
> same. This repo uses the current `.agent.md` form.

### Mapped to the research-software lifecycle

These demos are deliberately **narrow** — each does one job on one phase of a
research project. Narrow agents work; "be my coding assistant" disappoints.

| Lifecycle phase           | What it is                                                                                                                                  | Primitive    | File                                                                                                                                                                                                                                                                                                                                                                                                       |
| ------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------- | ------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Research loop (Block 3)   | `/research` → `/plan` → `/iterate-plan` → `/experiment` → `/implement` → `/validate` (+ `/handoff`), each writing an artifact to `.agents/` | commands     | [`research`](.github/prompts/research.prompt.md), [`plan`](.github/prompts/plan.prompt.md), [`iterate-plan`](.github/prompts/iterate-plan.prompt.md), [`experiment`](.github/prompts/experiment.prompt.md), [`implement`](.github/prompts/implement.prompt.md), [`validate`](.github/prompts/validate.prompt.md), [`handoff`](.github/prompts/handoff.prompt.md) |
| Project setup             | Flat script → installable package (plan)                                                                                                    | command      | [`.github/prompts/scaffold-package.prompt.md`](.github/prompts/scaffold-package.prompt.md)                                                                                                                                                                                                                                                                                                                 |
| Data / EDA                | First look at a dataset                                                                                                                     | command      | [`.github/prompts/eda-summary.prompt.md`](.github/prompts/eda-summary.prompt.md)                                                                                                                                                                                                                                                                                                                           |
| Implementation / planning | Read-only thinking partner, then hand off                                                                                                   | agent        | [`.github/agents/research-pair.agent.md`](.github/agents/research-pair.agent.md)                                                                                                                                                                                                                                                                                                                           |
| Testing / validation      | Focused pytest tests for a target                                                                                                           | command      | [`.github/prompts/write-tests.prompt.md`](.github/prompts/write-tests.prompt.md)                                                                                                                                                                                                                                                                                                                           |
| Experiment management     | Summarize a run, append to a lab notebook                                                                                                   | skill        | [`.github/skills/experiment-log/`](.github/skills/experiment-log/)                                                                                                                                                                                                                                                                                                                                         |
| Reproducibility           | Audit for paths, seeds, pinned env                                                                                                          | agent        | [`.github/agents/reproducibility-auditor.agent.md`](.github/agents/reproducibility-auditor.agent.md)                                                                                                                                                                                                                                                                                                       |
| Documentation             | Add NumPy-style docstrings                                                                                                                  | agent        | [`.github/agents/docstring-writer.agent.md`](.github/agents/docstring-writer.agent.md)                                                                                                                                                                                                                                                                                                                     |
| Code review               | Review vs Scientific Python guidelines                                                                                                      | agent        | [`.github/agents/scientific-python-reviewer.agent.md`](.github/agents/scientific-python-reviewer.agent.md)                                                                                                                                                                                                                                                                                                 |
| Packaging / publication   | Draft `CITATION.cff` + release notes                                                                                                        | command      | [`.github/prompts/citation-and-release.prompt.md`](.github/prompts/citation-and-release.prompt.md)                                                                                                                                                                                                                                                                                                         |
| Conventions (notebooks)   | Notebook-as-teaching-document rules                                                                                                         | instructions | [`.github/instructions/notebooks.instructions.md`](.github/instructions/notebooks.instructions.md)                                                                                                                                                                                                                                                                                                         |
| Conventions (tests)       | pytest + `uv` conventions                                                                                                                   | instructions | [`.github/instructions/tests.instructions.md`](.github/instructions/tests.instructions.md)                                                                                                                                                                                                                                                                                                                 |

The two **worked examples** referenced throughout Block 4 are
`scientific-python-reviewer` (read-only) and `docstring-writer` (write-mode).
The rest of the gallery extends the same pattern across the lifecycle.

### How to try them in this Codespace

- **Agents:** open Copilot Chat → the **agent picker** at the top of the panel
  → choose an agent (e.g. `reproducibility-auditor`). If it is missing, run
  **Developer: Reload Window**.
- **Commands:** type `/` in chat and pick a prompt (e.g.
  `/eda-summary`), or pass the input: `/write-tests target=sci_units.converters`.
- **Skills:** ask in plain language ("log this run to my lab notebook from
  `runs/...`") and the `experiment-log` skill loads on demand.
- **Instructions:** open a notebook or a file under `tests/` and they apply
  automatically — no picker, no slash command.

Good targets are already in the repo:
[`blocks/01-landscape/demo/starter/`](blocks/01-landscape/demo/starter/)
(`sci_units`, small) and
[`blocks/03-research-loop/demo/starter/`](blocks/03-research-loop/demo/starter/)
(the climate model, realistically messy). Or point them at your own code.

### Design principles (steal these for your own)

- **Narrow beats broad.** One job, stated in numbered steps.
- **Constrain the tools.** A reviewer with no `edit/editFiles` _cannot_ change your
  code. The tool list is a real safety lever, not decoration.
- **Say what NOT to do.** The "do NOT" section prevents the most common
  failure modes (scope creep, silent edits, runaway loops).
- **Show the output format.** A concrete example beats an abstract description.
- **No emojis** in workshop material unless explicitly requested.

## Repo conventions

- One folder per block, reusable layout.
- All Python work goes through `uv` (`uv run pytest`, `uv add <pkg>`, etc.).
- Notebooks are written to be read top-to-bottom as a teaching document, not just executed.
- Slides are written for the **Marp for VS Code** extension (preinstalled in the Codespace). Open any `slides.md` and click the preview icon, or run **`Marp: Export Slide Deck...`** from the command palette to produce HTML/PDF/PPTX.

## Following day: office hours

VISS members will be available the day after the workshop to help you try the agent on your own data, write your own skills, and explore agentic research workflows. Bring a snippet of code or data you'd like to work on.

## Instructors

Anant Mittal, Carlos García Jurado Suarez, Anshul Tambay, Vani Mandava, Robert Bates, Ryan Hausen, Eric Liu, Tina Dang, Arfon Smith.

## Contact

- **Anshul Tambay**, UW SSEC, [anshul37@uw.edu](mailto:anshul37@uw.edu)
- **Tina Dang**, Schmidt Sciences, [tdang@schmidtsciences.org](mailto:tdang@schmidtsciences.org)

## License

MIT, see `LICENSE` (to be added).
