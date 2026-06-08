# Dry-Run / Review Plan

A structured way to review the workshop end-to-end before delivery. Use
this as a checklist during a co-instructor review session, or work
through it solo.

## How to use this document

There are **three review passes**, in order:

1. **Cross-cutting** (~30 min) - shared infrastructure + workshop spine. Done once, applies to all blocks.
2. **Per-block deep review** (~30-45 min per block, ~2-3 hours total for all four) - content, accuracy, scope, pacing.
3. **Full delivery rehearsal** (~2 hours, separate session, ideally with co-instructors) - present every slide and run every demo, end-to-end, in real time.

Each section has a checklist. Tick boxes; flag what you change.

If you're tight on time, the minimum viable review is: **cross-cutting + Block 3 deep + full rehearsal**. Block 3 has the most moving parts (the four workflow prompt files in `.github/prompts/`, agent mode, the climate-model demo subject) and is the most likely to break in front of a room.

---

## Pass 1 - Cross-cutting review

Done once, applies to everything downstream.

### 1.1 Shared infrastructure works in a fresh Codespace

- [ ] Open a new Codespace from the `main` branch (no cached state from previous reviews).
- [ ] The lifecycle scripts (`on-create.sh`, `post-create.sh`, `post-start.sh`, `install-vsix.sh`) each run to completion and print their green `==> ... complete` line.
- [ ] The sanity checks print green:
    - [ ] Python + litellm + sci_units + workshop_agent imports (`on-create.sh`)
    - [ ] LITELLM_API_KEY + LITELLM_BASE_URL found (`post-start.sh`)
    - [ ] GitHub Copilot CLI installed at image-build time (no agent plugins expected — the research loop ships as in-repo prompt files)
- [ ] Open Copilot Chat. The **agent picker** shows `scientific-python-reviewer`, `docstring-writer`, `reproducibility-auditor`, and `research-pair` (the `.github/agents/*.agent.md` files). **This is the load-bearing format check:** the workshop now ships custom agents (`.agent.md`), the renamed form of "chat modes". Confirm the installed `GitHub.copilot-chat` build recognizes `.agent.md` on a fresh Codespace. If the agents do NOT appear, the Codespace's Copilot Chat may predate the agent rename, fall back to verifying via the chat customization **Diagnostics** view (right-click in Chat → Diagnostics) and flag for a fix.
- [ ] Type `/` in Copilot Chat. The prompt-file commands appear (`/eda-summary`, `/write-tests`, `/scaffold-package`, `/citation-and-release`, and the Block 3 workflow `/research`, `/plan`, `/iterate-plan`, `/experiment`, `/implement`, `/validate`, `/handoff`).
- [ ] Open a `.md` file with Marp frontmatter (e.g. [`blocks/01-landscape/slides.md`](../blocks/01-landscape/slides.md)). Marp preview renders.

**Files to check if anything fails:**

- [`.devcontainer/devcontainer.json`](../.devcontainer/devcontainer.json)
- [`.devcontainer/on-create.sh`](../.devcontainer/on-create.sh), [`post-create.sh`](../.devcontainer/post-create.sh), [`post-start.sh`](../.devcontainer/post-start.sh), [`install-vsix.sh`](../.devcontainer/install-vsix.sh)
- [`pyproject.toml`](../pyproject.toml)
- [`docs/setup.md`](setup.md)

### 1.2 Workshop spine reads consistently across all four blocks

The workshop's spine is **"all coding agents work the same way under the hood."** Each block restates and pays it off in a specific way.

Read just the slide titles / block READMEs and verify the through-line:

- [ ] Block 1 introduces the spine ("anatomy of an agent" - six pieces).
- [ ] Block 2 justifies it ("convergent post-training is why all the models behave like agents").
- [ ] Block 3 operationalizes it ("workflows ARE the prompt; the same loop wrapped in named slash commands").
- [ ] Block 4 instantiates it ("a few fields in a markdown file - write a custom agent yourself").

If any block feels like it's a side-trip, that's the time to flag and adjust.

### 1.3 Tool consistency

- [ ] All four blocks use **GitHub Copilot Chat** as the tool — no tool switch. Block 3 stays in Copilot Chat (agent mode) and runs the workflow prompt files.
- [ ] All four blocks talk to the **same LiteLLM gateway** (verify the `LITELLM_*` / `OAI_API_KEY` / `COPILOT_PROVIDER_*` wiring in `devcontainer.json` is honored everywhere).
- [ ] No block introduces a new tool that participants didn't see coming.

### 1.4 Repo conventions

- [ ] Every block follows the same folder layout: `README.md`, `slides.md`, `instructor-notes.md`, `resources.md`, `demo/` or `exercise/`. (Slide styling is a single shared Marp theme at `blocks/_shared/slides.css`, registered in `.vscode/settings.json`.)
- [ ] Every block's `README.md` has the same sections in the same order.
- [ ] Every block's `slides.md` has the same Marp frontmatter shape.
- [ ] [`.github/copilot-instructions.md`](../.github/copilot-instructions.md) reflects the current state (agents / prompts / skills / instructions gallery mentioned).
- [ ] The [customization gallery in the root README](../README.md#copilot-customization-gallery) lists every customization and maps it to a research-lifecycle phase.
- [ ] Root [`README.md`](../README.md) block index is up to date.

**Lint sanity:**

```bash
uv run ruff check blocks/ workshop_agent/ .devcontainer/
uv run ruff format --check blocks/ workshop_agent/
uv run pytest blocks/01-landscape/demo/starter/tests/  # 2 fail / 2 pass expected
```

---

## Pass 2 - Per-block deep review

Recommended order: **Block 3 first** (highest risk), then **Block 1** (foundational, sets the spine), then **2 and 4** in either order.

For each block, allocate ~30-45 min. The review pattern is the same across blocks:

1. **Read the block README** - does the goal land?
2. **Read the slides start-to-finish** - out loud, with a clock running.
3. **Run the demo / exercise** - actually do it, end-to-end.
4. **Read the instructor notes** - would they actually help you on the day?
5. **Skim the resources** - links live, accurate, useful.
6. **Risk check** - work through the block-specific risk list below.

---

### Block 1 - The AI Coding Agent Landscape

**Folder:** [`blocks/01-landscape/`](../blocks/01-landscape/)

#### Read

- [x] [`README.md`](../blocks/01-landscape/README.md) - does the block goal land in one read?
- [x] [`slides.md`](../blocks/01-landscape/slides.md) - read aloud. Time it. Should be ~22 min talking + ~8 min demo.
- [x] [`instructor-notes.md`](../blocks/01-landscape/instructor-notes.md) - would the per-slide notes save you on the day?
- [x] [`resources.md`](../blocks/01-landscape/resources.md) - click every link.

#### Run

- [x] Open the demo starter: `cd blocks/01-landscape/demo/starter && uv run pytest -v`
    - Expected: 2 failed (`test_fahrenheit_to_celsius_boiling`, `test_celsius_to_fahrenheit_round_trip`), 2 passed.
- [x] Open Copilot Chat in agent mode. Open the workspace folder to `blocks/01-landscape/demo/starter/`. Paste the demo prompt from `instructor-notes.md`. Watch it fix the bug.
    - [x] Reset afterward: `git checkout -- src/sci_units/converters.py`.
- [x] Open [`demo/notebook.ipynb`](../blocks/01-landscape/demo/notebook.ipynb). Restart kernel. **Run all cells.**
    - [x] All 8 code cells execute without error.
    - [x] Cell 16 (the `run_agent(...)` call) actually drives the model to fix the test live.
    - [x] Final trace shows `=== agent finished ===`.

#### Block 1 risk check

- [ ] **Tool tour table** (slide 3): all 6 tools (Copilot, Claude Code, Cursor, OpenCode, Aider, Cline) still exist and are accurately characterized? Anything new or shifted?
- [ ] **Anatomy diagram** (slide 5 ASCII art): does it actually look readable on the projector? If not, render it as a clean SVG and embed.
- [ ] **Comparison table on slide 6**: all six rows (LLM backbone, tool use, project memory, MCP, skills, agent loop) accurate for each tool's 2026 state?
- [ ] **The notebook's MODEL constant**: `claude-sonnet-4-6` is what the LiteLLM proxy will alias for Schmidt? Or do we need a different alias? (Must match the model IDs in `devcontainer.json` and `docs/setup.md`.)
- [ ] **The 50-line claim**: count the lines. The agent loop in cell 14 should be ~25 lines, plus tools (cell 8, ~15 lines) + schemas (cell 10, ~25 lines). Total Python (excluding markdown) ~ 65 lines. Tighten or rephrase if "50" feels misleading.
- [ ] **The bridge to Block 2**: does the closing question ("why does the model know to call `run_bash`?") still feel earned by what was just demonstrated?

#### Block 1 pacing

- [ ] Hook + landscape (slides 1-3): ≤ 7 min on the clock.
- [ ] Anatomy of an agent (slides 5-6): the longest section, ~10 min. Don't rush it; this is the spine.
- [ ] Demo (slides 9 onward): ≤ 8 min combined for live Copilot + notebook walk.

---

### Block 2 - How It Actually Works

**Folder:** [`blocks/02-how-it-works/`](../blocks/02-how-it-works/)

#### Read

- [x] [`README.md`](../blocks/02-how-it-works/README.md) - 5 learning goals tied to the four "just worked" questions from Block 1?
- [x] [`slides.md`](../blocks/02-how-it-works/slides.md) - read aloud. Time it. ~23 min talking + ~5 min hands-on.
- [x] [`instructor-notes.md`](../blocks/02-how-it-works/instructor-notes.md) - does the per-slide guidance feel sufficient for someone who hasn't taught this content before?
- [x] [`resources.md`](../blocks/02-how-it-works/resources.md) - click every link.

#### Run

- [x] Open [`demo/notebook.ipynb`](../blocks/02-how-it-works/demo/notebook.ipynb). Restart kernel. **Run all cells.**
    - [x] Cell 4 (proxy model discovery): which models actually come back as available against the real proxy? Update the candidate model list in the notebook if it's wildly off.
    - [x] Cell 12 (the `compare(model)` loop): runs against at least 2 models without error.
    - [x] Cell 15 (VAGUE_TOOLS ablation): observable behavior difference between verbose and vague.
- [x] If only one model is available on the proxy: re-read the instructor notes' fallback path (pivot to the ablation). Is the conceptual lesson still landed?

#### Block 2 risk check

- [ ] **The four "just worked" questions** (slide 2): do they accurately recap Block 1's demo? If Block 1's slides changed, sync them.
- [ ] **SFT / RLHF / tool-use FT framing** (slides 4-6): sanity-check with someone who knows the post-training literature. Specifically:
    - [ ] InstructGPT historical reference still accurate (slide 4)?
    - [ ] DPO mention still represents the modern alternative (slide 5)?
    - [ ] "Agentic RL" framing still current as the bleeding edge (slide 6)? Pick a more recent representative paper if there's a better one.
- [ ] **Convergence table** (slide 7): rows for Anthropic / OpenAI / Google / Meta / DeepSeek - accurate for 2026? Add or remove labs as needed.
- [ ] **Trained-in vs in-the-prompt table** (slide 8): is "knowing when to stop" really under "trained in"? (It is, mostly - but flag if you have a more nuanced framing.)
- [ ] **The notebook's "convergence is not perfection"** punchline: does it still land if only 1 model is reachable on the day?
- [ ] **The "try a different MODEL" suggestion** at the end: does it work with what the proxy actually fronts?

#### Block 2 pacing

- [ ] Recap + pre-training (slides 1-3): ≤ 6 min.
- [ ] SFT / RLHF / tool-use FT (slides 4-6): ~15 min combined; equal weight each.
- [ ] Convergence + the takeaway slide (slides 7-8): ~5 min.
- [ ] Demo + bridge (slides 9-10 + notebook): ≤ 5 min.

---

### Block 3 - Agent-Driven Research Software Engineering

**Folder:** [`blocks/03-research-loop/`](../blocks/03-research-loop/)

**Highest risk block.** Most external dependencies.

#### Read

- [x] [`README.md`](../blocks/03-research-loop/README.md) - does the "instructor-led, no participant action required during the block" framing land?
- [x] [`slides.md`](../blocks/03-research-loop/slides.md) - read aloud. Time it. ~22 min talking + ~8 min demo.
- [x] [`instructor-notes.md`](../blocks/03-research-loop/instructor-notes.md) - does the demo script feel like enough to deliver from?
- [x] [`resources.md`](../blocks/03-research-loop/resources.md) - click every link.
- [x] All four [`expected-artifacts/*.md`](../blocks/03-research-loop/demo/expected-artifacts/) files - read as if you were a participant, do they look credible?

#### Run

This is the block where you really need a working environment.

- [ ] Open Copilot Chat in **Agent** mode with a workshop model selected.
- [ ] Type `/` and confirm `research`, `plan`, `implement`, `validate` appear (the prompt files in `.github/prompts/`). If not, **Developer: Reload Window**.
- [ ] Open the workspace at `blocks/03-research-loop/demo/`, then `rm -rf .agents/` in the terminal to clear any leftover artifacts.
- [ ] Run the four prompts from [`instructor-notes.md`](../blocks/03-research-loop/instructor-notes.md), in order:
    - [ ] `/research ...` - produces `.agents/research-*.md` in <4 min, with file:line references.
    - [ ] `/plan ...` - produces `.agents/plan-*.md` in <4 min, with phases + verification steps + no open questions.
    - [ ] `/implement .agents/plan-*.md` - produces `.agents/implement-*.md`, ticking off phases. <8 min.
    - [ ] `/validate .agents/plan-*.md` - produces a pass/fail report.
- [ ] Compare the **real** outputs against [`expected-artifacts/`](../blocks/03-research-loop/demo/expected-artifacts/). If the real ones are wildly better, **replace the hand-crafted samples with the real outputs** so the fallback is authentic.
- [ ] Verify [`demo/starter/climate_model.py`](../blocks/03-research-loop/demo/starter/climate_model.py) still runs after a `git checkout` (in case the demo modified it):
    ```bash
    cd blocks/03-research-loop/demo/starter
    git checkout -- .
    uv pip install pandas matplotlib numpy
    python climate_model.py  # may fail headless; that's OK
    ```

#### Block 3 risk check

- [ ] **The four workflow prompt files** in [`.github/prompts/`](../.github/prompts/) (`research`, `plan`, `implement`, `validate`) - do they appear in the `/` picker on a fresh Codespace, and does each `mode`/`tools` frontmatter validate?
- [ ] **Artifact output path** - do the prompts write to `.agents/` relative to the workspace folder? Confirm the demo opens the workspace at `blocks/03-research-loop/demo/` so `AGENTS.md` is at the root.
- [ ] **`implement`/`validate` tool access** - confirm Copilot agent mode is allowed to run `uv run pytest` (`execute/runInTerminal`) and edit files (`edit/editFiles`) without per-call approval stalling the live demo.
- [ ] **The 4-phase demo timing** - `/implement` is the variable one; if it consistently runs >6 min, prepare to skip `/validate` live.
- [ ] **Failure mode taxonomy** (slide 5): all 6 rows accurate? Any newly common failure modes worth adding (e.g., "model drops Unicode" if that's still a thing)?
- [ ] **The "where it comes from" column** (slide 5): does it tie back cleanly to Block 2's content?
- [ ] **Practical use cases tour** (slide 7): all 6 use cases still feel right for scientific computing audiences?
- [ ] **Live-demo fallback plan**: have you actually tried switching to `expected-artifacts/` mid-demo to make sure it flows?

#### Block 3 pacing

- [ ] Framing (slides 1-3): ≤ 6 min.
- [ ] `/research` + `/plan` + `/implement` + `/validate`: ~16 min total. The implement phase is where you fill dead air with slides 5-6.
- [ ] Failure modes + mitigations (slides 5-6): ~4-6 min, can stretch if implement runs short.
- [ ] Use cases + bridge (slides 7-8): ≤ 5 min.

---

### Block 4 - Build Your Own Skill

**Folder:** [`blocks/04-build-a-skill/`](../blocks/04-build-a-skill/)

**Most facilitation-heavy.** Slides are short on purpose.

#### Read

- [ ] [`README.md`](../blocks/04-build-a-skill/README.md) - does the office hours pointer have concrete time/location?
- [ ] [`slides.md`](../blocks/04-build-a-skill/slides.md) - read aloud. ~10 min talking + 15 min hands-on + 5 min show-and-tell.
- [ ] [`instructor-notes.md`](../blocks/04-build-a-skill/instructor-notes.md) - does the live-build script feel like ~3-4 min you can deliver from memory?
- [ ] [`resources.md`](../blocks/04-build-a-skill/resources.md) - click every link, especially the VS Code Copilot custom-agent / prompt-file / skill docs (these versions drift).
- [ ] [`exercise/README.md`](../blocks/04-build-a-skill/exercise/README.md) - read it as if you were a participant who's never seen Copilot custom agents. Does each step land? Where would you get stuck?
- [ ] [`exercise/ideas.md`](../blocks/04-build-a-skill/exercise/ideas.md) - are the 20+ ideas still relevant? Add any that come to mind.
- [ ] [`exercise/my-agent.agent.md.template`](../blocks/04-build-a-skill/exercise/my-agent.agent.md.template) - TODO placeholders clear?
- [ ] The [customization gallery in the root README](../README.md#copilot-customization-gallery) - skim the gallery index. Every listed agent / command / skill / instruction file exists and the lifecycle mapping reads sensibly.

#### Run

This is the _important_ run because participants will follow it. Be a participant.

- [ ] Copy the template into place:
    ```bash
    cp blocks/04-build-a-skill/exercise/my-agent.agent.md.template \
       .github/agents/dry-run-test.agent.md
    ```
- [ ] Edit it with a small, concrete job - try `error-explainer` from the live-build script.
- [ ] Reload the window. Confirm `dry-run-test` appears in the Copilot agent picker.
- [ ] Switch to it. Run a real query (paste a small Python traceback).
- [ ] Iterate once: tighten a step in the system prompt, reload, re-run.
- [ ] Delete `dry-run-test.agent.md` afterward.

Now also test the worked examples actually do their job:

- [ ] Switch to the `scientific-python-reviewer` agent. Ask it to review `blocks/03-research-loop/demo/starter/climate_model.py`. Does the output match the "Output format" section in the agent file?
- [ ] Switch to the `docstring-writer` agent. Ask it to add docstrings to `blocks/01-landscape/demo/starter/src/sci_units/converters.py`. Does it edit the file? Does the docstring match the "Example output style" section?
- [ ] Spot-check one gallery extra: run `/eda-summary` against `blocks/03-research-loop/demo/starter/SSP_CO2emissions.csv`, or switch to `reproducibility-auditor` against `climate_model.py`. Output sane?

#### Block 4 risk check

- [ ] **`.agent.md` format support** - on a FRESH Codespace, confirm the unpinned `GitHub.copilot-chat` build recognizes `.agent.md` files in `.github/agents/` (the agents appear in the picker). The format parser auto-updates to latest, so this should hold, but verify since the workshop curriculum now depends on it. If they don't appear, check the chat Diagnostics view.
- [ ] **Copilot agent `tools` field IDs** - the namespaced IDs used (`read`, `edit/editFiles`, `execute/runInTerminal`, `search/codebase`, `search`, `search/usages`) match Copilot's current spec? Verify against the VS Code custom-agent docs in resources.md. The whole repo (gallery agents/prompts, the template, the slides, the exercise, and `ideas.md`) now uses this one vocabulary — if the spec differs, update them together so they stay consistent.
- [ ] **Auto-detection vs reload** - confirm whether new agents auto-load or need a window reload. Update [`exercise/README.md`](../blocks/04-build-a-skill/exercise/README.md)'s troubleshooting table accordingly.
- [ ] **Live-build script** ([`instructor-notes.md`](../blocks/04-build-a-skill/instructor-notes.md), "Live-build script" section) - type it from memory once. Does it flow? Time it; should be ≤ 4 min.
- [ ] **The 15-minute hands-on budget** - try to build an agent in 15 min as if you were a participant. Realistic? Tighten the template if not.
- [ ] **Show-and-tell logistics** - is there a microphone? A way for participants to share their screen? If neither, drop the show-and-tell or repurpose as a verbal share.
- [ ] **Office hours info** - concrete time, location, how to join. Update both the slide and the README.

#### Block 4 pacing

- [ ] Recap + anatomy (slides 1-3): ≤ 8 min combined.
- [ ] Live build (slide 4 / live coding): ≤ 4 min.
- [ ] Hands-on (slide 5 projected): 13-15 min for participants.
- [ ] Show-and-tell + wrap-up (slides 6 + closing): 5-7 min.

---

## Pass 3 - Full delivery rehearsal

**Separate session.** ~2 hours, ideally with at least one co-instructor watching.

### Setup

- [ ] Fresh Codespace. Clean state. Any leftover `dry-run-test` / participant agents deleted from `.github/agents/`, leaving the gallery (the two worked examples + `reproducibility-auditor` + `research-pair`).
- [ ] Slides up, full-screen, projected if possible (TV, second monitor - anything that approximates the room).
- [ ] Stopwatch / phone timer running.
- [ ] Notepad for "things to fix" - don't fix mid-rehearsal, write them down.
- [ ] Co-instructor armed with the per-block pacing checklists above.

### Run

Deliver each block in real time. **Do not pause to fix things.** If something blows up, narrate the failure mode and pivot to the documented fallback.

For each block, log:

- [ ] Total time vs budget (target 30 min per block; budget 28 min to leave buffer).
- [ ] Any slide where you found yourself reading speaker notes verbatim - that's a slide that needs internalizing or rewriting.
- [ ] Any audience question you anticipated wasn't in the FAQ - add to the instructor notes.
- [ ] Any demo step that felt too fast / too slow.

### After

- [ ] Compare actual block timings to the budget. Cut content from the slow ones; flesh out the fast ones if there was dead air.
- [ ] Walk through the "things to fix" list. Triage into "must fix before workshop" vs "would be nice."
- [ ] Decide if a second rehearsal is needed (yes if any block ran > 35 min or had a hard failure that the fallback didn't cover).

---

## Pre-workshop final checklist (the day before)

A minimal go/no-go list. Run this from a fresh laptop / fresh Codespace.

- [ ] All four block READMEs read coherently top-to-bottom.
- [ ] All four blocks' slides render in Marp preview.
- [ ] [`docs/setup.md`](setup.md) credentials section reflects what Schmidt Sciences will actually hand out.
- [ ] LITELLM proxy is up; the verification one-liner from [`docs/setup.md`](setup.md) returns a real model response.
- [ ] Block 1 notebook runs end-to-end (`run_agent(...)` finishes).
- [ ] Block 2 notebook runs end-to-end (at least 1 model in `AVAILABLE`).
- [ ] Block 3 demo: `/research` produces a credible artifact in <5 min.
- [ ] Block 4: the worked-example agents (`scientific-python-reviewer`, `docstring-writer`) appear in the agent picker on a fresh Codespace (confirms `.agent.md` is recognized); building a fresh `dry-run-test` agent works.
- [ ] Office hours date, time, and location are in [`README.md`](../README.md), [`blocks/04-build-a-skill/README.md`](../blocks/04-build-a-skill/README.md), and Block 4 slide 6.
- [ ] Workshop participant team membership confirmed: every attendee is in [`2026-viss-ai-workshop-participants`](https://github.com/orgs/schmidt-sciences/teams/2026-viss-ai-workshop-participants).
- [ ] Codespace allocation confirmed for the room size (each Codespace is ~$0.18/hr; 30 attendees x 4hr = ~$22 - peanuts, but get the budget signed off).

---

## Post-workshop debrief template

Optional, for after-the-fact learnings. Capture within 24 hours while it's fresh.

- [ ] What worked? (Anything that landed harder than expected.)
- [ ] What didn't? (Anything that fell flat or confused the room.)
- [ ] What broke? (Anything technical that didn't behave on the day.)
- [ ] What did attendees ask that wasn't in the FAQ?
- [ ] What would you cut next time?
- [ ] What would you add?

Save the answers to a new file - it'll be invaluable when this material gets re-run.
