# Block 3: Agent-Driven Research Software Engineering

**Duration:** ~30 minutes
**Tool focus:** **GitHub Copilot Chat** (agent mode) driven by workshop **prompt-file commands** that live in [`.github/prompts/`](../../.github/prompts/): `/research`, `/plan`, `/iterate-plan`, `/experiment`, `/implement`, `/validate`, `/handoff` (the live demo uses four of them). Each command is a thin prompt file that delegates to the matching **`ai-research-workflows` skill** from UW SSEC's [`rse-plugins`](https://github.com/uw-ssec/rse-plugins); the skills are installed into Copilot for you by the devcontainer (from the `rse-plugins` submodule), so there's still nothing to install by hand. Same Copilot Chat and same LiteLLM gateway as the rest of the workshop.
**Spine:** *Workflows ARE the prompt.* Structured slash commands (`/research`, `/plan`, `/implement`, `/validate`) are templated, named, reusable prompts that produce auditable artifacts.

## Learning goals

By the end of this block, an attendee can:

1. Articulate the **research-plan-implement-validate** discipline and explain why "research before plan, plan before code, validate before ship" beats unstructured prompting on real research codebases.
2. Recognize the **phases** of the workshop workflow (`/research`, `/plan`, `/iterate-plan`, `/experiment`, `/implement`, `/validate`, `/handoff`), see that each is a small `.github/prompts/*.prompt.md` file that delegates to a reusable skill, and pick the right subset for a given task.
3. Name the common **agent failure modes** (context exhaustion, looping, niche-language hallucination, confidently-wrong answers, tool misuse, scope creep) and trace each one back to a specific post-training shortcut from Block 2.
4. Apply the corresponding **mitigations** (tighter scope per turn, auditable artifacts, fresh chats to compact context, `/validate` as a quality gate, AGENTS.md as durable project memory, manual intervention).
4. Stay in control of an agent that edits files: **review the diff (not the chat), commit per phase, and roll back cleanly with git**, and recognize **prompt injection** (the agent acting on instructions hidden in untrusted code/data/web) and the tool-scoping that mitigates it.
5. Map the workshop's **practical use cases** (feature implementation, debugging, test writing, documentation, code review, exploratory coding, experiment management) to where agents help most and where they hurt.
6. Pick the right **loop length** for the task: the full `/research` -> `/plan` -> `/implement` -> `/validate` cycle for durable code vs. fast chat-against-`AGENTS.md` iteration for research spikes.

## What's in this folder

```
03-research-loop/
  README.md            # this file
  slides.md            # Marp slides (~11 slides, ~22 min talking + demo)
                       # (theme: shared blocks/_shared/slides.css)
  instructor-notes.md  # per-slide notes, demo script with copy-paste prompts, fallback plan
  resources.md         # workflow prompts, Scientific Python guidelines, failure-mode reading
  demo/
    AGENTS.md          # project memory: VSCM goals + Scientific Python conventions
    starter/           # the climate model code (intentionally messy)
      climate_model.py
      co2_emissions.py
      SSP_CO2emissions.csv
    expected-artifacts/  # pre-generated docs/rse/specs/ outputs as live-demo fallback
```

When you open the workspace at `demo/`, the devcontainer also links `demo/.github` to the repo-root [`.github/`](../../.github/) — a gitignored symlink created by `on-create.sh` — so the `/` commands, Copilot instructions, and skills resolve from inside the demo folder.

## Timing (30 min)

| min | section |
|---|---|
| 0–3 | Recap + "workflows are the prompt" |
| 3–6 | The research loop as Copilot prompt files (overview slide) |
| 6–10 | **Demo: `/research`** |
| 10–14 | **Demo: `/plan`** |
| 14–20 | **Demo: `/implement`** + narrate failure modes while it runs |
| 20–22 | **Demo: `/validate`** |
| 22–26 | Failure mode taxonomy + mitigations (+ optional git-hygiene / prompt-injection slides 6a/6b) |
| 26–27 | Practical use cases tour |
| 27–29 | Research vs. engineering mode + cross-field framing |
| 29–30 | Bridge to Block 4 |

The `/implement` step is timed as the longest because that's when we narrate the failure modes in parallel, productive use of the agent's "thinking time."

## How to run the material

### Present the slides

Same Marp-for-VS-Code workflow as Blocks 1 and 2, see [`blocks/01-landscape/README.md`](../01-landscape/README.md#view--present-the-slides). Open `slides.md`, click the preview icon.

### Run the demo

This is a **live, instructor-led demo**. Participants don't need to type anything during the block, but the same Codespace they have open will work, so they can re-run on their own afterward.

1. Open VS Code with the workspace folder set to `blocks/03-research-loop/demo/`.
2. Open **Copilot Chat** and switch the picker to **Agent** mode.
3. Wipe any leftover `docs/rse/specs/` from prior runs: `rm -rf docs/rse/specs/`.
4. Run the four prompt-file commands from [`instructor-notes.md`](instructor-notes.md), `/research`, `/plan`, `/implement`, `/validate`, one at a time. They are defined in [`.github/prompts/`](../../.github/prompts/) and appear when you type `/` in chat.

If anything goes wrong on the day, the [`expected-artifacts/`](demo/expected-artifacts/) folder ships pre-generated outputs to walk through instead.

## Prerequisites

- Codespace running (see top-level [`README.md`](../../README.md) and [`docs/setup.md`](../../docs/setup.md)).
- `LITELLM_API_KEY` and `LITELLM_BASE_URL` Codespace secrets set (Copilot Chat reads them via the OAI-compatible extension).
- The workflow prompt files in [`.github/prompts/`](../../.github/prompts/) (`research`, `plan`, `iterate-plan`, `experiment`, `implement`, `validate`, `handoff`) and the `ai-research-workflows` skills they delegate to — both are set up by the devcontainer (the skills are installed into Copilot; the demo folder gets a `.github` symlink to the repo root). They appear in the `/` picker after a window reload; if they don't show, run **Developer: Reload Window**.
- Copilot Chat in **Agent** mode with one of the workshop models selected (Claude Sonnet 4.6 / Haiku 4.5).

## Bridge to Block 4

This block ends with: *"You just watched four prompt files do all this. Now you'll build a small one of your own. The pieces are the same."* Block 4 is the capstone where attendees write their first custom agent / prompt-file command / skill and run it against their own code.
