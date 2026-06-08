# Block 3: Instructor Notes

These are the notes you actually deliver from. The slide deck has the
public-facing version; this is the inside view.

## Pre-block checklist (do this in the 5 min before you start)

- [ ] Open VS Code in the Codespace with the **workspace folder set to `blocks/03-research-loop/demo/`** (File → Open Folder, or open the Codespace there). The cwd matters: opening `demo/` (not `demo/starter/`) puts `AGENTS.md` at the workspace root, with the starter scripts in the `starter/` subfolder and the fallback `expected-artifacts/` right next to them.
- [ ] Open **Copilot Chat** and switch the picker to **Agent** mode (the dropdown at the top of the chat panel). Confirm a workshop model is selected (Claude Sonnet 4.6 / Haiku 4.5).
- [ ] Confirm the workflow commands appear: type `/` in chat and look for `research`, `plan`, `iterate-plan`, `experiment`, `implement`, `validate`, `handoff` (the demo uses four). They ship in [`.github/prompts/`](../../.github/prompts/). If they're missing, run **Developer: Reload Window**.
- [ ] In the integrated terminal: `cd blocks/03-research-loop/demo && rm -rf docs/rse/specs/`. We want a clean slate so artifacts appear *during* the demo. **Don't run any command yet** — the demo starts with you running `/research` live in front of the room (slide 4).
- [ ] Have **all four prompts copied to a scratch buffer** (text file, sticky note, Slack DM to yourself, wherever you can paste fast). The exact prompts are below.
- [ ] Open `blocks/03-research-loop/demo/expected-artifacts/` in a side tab as the **fallback** in case the live demo fails.

## Timing checkpoints

| at minute | should be on slide / phase | content |
|---|---|---|
| 3 | slide 3 (the research loop) | Done with framing |
| 6 | switching to Copilot Chat (agent mode) | Demo about to start |
| 10 | `/research` complete | Plan kicks off |
| 14 | `/plan` complete | Implement kicks off |
| 20 | `/implement` complete (or near it) | Validate kicks off |
| 22 | `/validate` complete | Switching back to slides |
| 26 | slide 5 (failure modes) -> slide 6 (mitigations) | Demo recap done |
| 26 | slides 6a/6b (git hygiene, prompt injection) | Extra `/implement`-time filler; skip if on schedule |
| 27 | slide 7 (use cases) | Tour done |
| 29 | slide 8 (research vs. engineering) | Cross-field framing done |
| 30 | slide 9 (bridge) | Hand off to Block 4 |

If `/implement` is faster than expected, jump to slide 6 (mitigations) early. If it's slower, **keep narrating** failure modes, that's the design.

## Per-slide notes

### 1. Title

- 30 seconds. Hand-off from Block 2.
- *"Blocks 1 and 2 were about how it works. This block is about how to use it on real research code without it blowing up."*

### 2. Where we left off ("workflows are the prompt")

- This is the through-line. State it explicitly.
- Connect: *"Block 2 said 'in the prompt' matters more than 'trained in.' Workflows are the systematic version of that, every phase of your work has a templated prompt."*
- Spell out the spine chain: *Block 1 introduced project memory; Block 2 said in-the-prompt > trained-in; Block 3 says structured workflows are the systematic way to do that.*

### 3. The research loop (Copilot prompt files)

- Read the table. **Don't memorize**: the *patterns* at the bottom matter more than the individual commands.
- *"You don't use all seven every time. You pick the pattern that matches your work."* (We demo four.)
- Acknowledge: each command is a small `.github/prompts/*.prompt.md` file in this repo that hands off to a reusable **skill** from UW SSEC's `rse-plugins` (`ai-research-workflows`). The prompt files ship in-repo and the devcontainer installs the skills into Copilot — nothing for attendees to install. The point is the *pattern* is portable, and in Block 4 attendees build their own.

### 4. Demo intro

- In Copilot Chat (Agent mode), briefly show that there is no `docs/rse/specs/` directory yet, and that `AGENTS.md` and the `starter/` scripts are right there in the workspace. Type `/` to show the workflow commands in the picker (we'll use four of them).
- *"We're going to package this. Watch the artifacts appear in `docs/rse/specs/` as we go."*

### 5. Failure mode taxonomy

- Read across the rows. Spend most time on the **"Where it comes from"** column, that's the Block 2 payoff.
- Pick **one row to elaborate** based on audience: scientific computing audiences usually relate hardest to "niche language hallucination" and "confident wrong answers."

### 6. Mitigations

- Three groups: process, prompt-side, manual.
- *"Agents are coworkers, not magic. Coworkers get pushback."* Drop this line slowly, it's the most quotable thing in Block 3.
- The mitigations are the actionable thing. Tell them to bookmark this slide.

### 6a. Reviewing the agent's work (git hygiene)

- 45-60 seconds. This is the practical complement to mitigations: the `docs/rse/specs/` artifacts are the *plan* audit trail, git is the *code* audit trail.
- The quotable line: **"Read the diff, not the chat. The 'Done!' is a claim; the diff is the evidence."** Ties straight back to the "confident wrong answer" failure mode on slide 5.
- Concrete demo callback: *"Notice we `git restore`d between runs all morning, that's the same one-command undo you'd use after a bad phase."*
- For scientists new to git: keep it to the four bullets, don't teach git here, just establish "commit before, review the diff, commit per phase." Point them at the Software/Code Carpentry links in `resources.md`.

### 6b. When the input is hostile (prompt injection)

- 45-60 seconds. The one *security* beat in the workshop, and increasingly the question a savvy audience asks. Don't oversell it into paranoia; frame it as a known failure mode with the same levers they already learned.
- The intuition to land: **"the agent can't fully tell your instructions from instructions hidden in the content it reads."** The data file example (a malicious CSV header) is the one that surprises scientists, lead with it.
- The mitigation that matters most for this room: *"reading untrusted data → use a read-only agent. No edit, no shell."* That's a tool-list decision, the same lever from Block 4.
- The closing line, *"a credulous, eager coworker, don't hand it your credentials and point it at the open internet"*, is the memorable one. Deliver it, then move on.
- If asked "has this actually happened?": yes, real incidents exist (poisoned READMEs, injected web content). Keep it short; offer office hours for the rabbit hole.

### 7. Practical use cases

- 30 seconds total. Don't dwell on any row.
- The closing one-liner, *"agents expand what one person can attempt; the editorial judgment stays yours"*, is the takeaway.
- **Experiment management** (new row) is the one to flag for NLP / ML attendees: agent kicks off a sweep, summarizes results, drafts the next hypothesis. Office hours can dig in further.

### 8. Two modes: research vs. engineering

- 60-90 seconds. Reframes everything they just saw: the four-phase demo was the *durable* end of the dial. Research work usually wants the *fast* end.
- This slide exists for two audiences: (a) people from non-RSE backgrounds (NLP, ML, comp ling) who want to know the loop isn't only for "build me a package", and (b) AI engineers who want fast iteration and worry the full loop is overkill.
- Read the table left-to-right. Then drop the punchline slowly: *"Pick the loop length to match the half-life of the code."*
- **The `AGENTS.md` callout is the answer to "how do I configure an agent for my research context?"** Stress it explicitly: *"This is the one file you'll edit most. It's portable across tools (Copilot, Cursor, and others all read some flavor of it). Your domain conventions live there, not in your daily prompts."*
- For the cross-field examples: pick the closest field to your audience and elaborate for ~10 seconds. Examples:
  - **NLP / ML:** *"AGENTS.md = eval harness paths, metric definitions, 'always use seed=42', model registry conventions."*
  - **Behavioral / social science:** *"AGENTS.md = your coding scheme, IRB constraints on what data the agent may read, stats assumptions (parametric vs not), how you label conditions."*
  - **Bio / bioinformatics:** *"AGENTS.md = file-format conventions (BED, VCF), pipeline DAG, where the reference genome lives."*
  - **Physics / climate:** the demo we just ran.
- Don't oversell: we have *one* worked example (climate). The claim is that the workflow shape is portable, not that the workshop covers every field.

### 9. Bridge to Block 4

- Hard hand-off.
- *"A markdown file, no magic."* This framing is what makes Block 4 feel approachable.
- Last sentence: *"Block 4: build your own."* Then hand off.

## Demo script: the four prompts

Copy these to your scratch buffer before starting. **Run them one at a time, in order**, in Copilot Chat (Agent mode). Type the slash command, then paste the rest of the line as the input.

### Prompt 1: `/research` (target: 4 min)

```
/research I have two standalone Python scripts (climate_model.py and co2_emissions.py) implementing a Very Simple Climate Model. Research the current code structure, identify what's missing for it to be an installable scientific Python package, and document existing conventions and quirks (mixed tabs/spaces, missing types, hardcoded CSV paths, etc.). Read AGENTS.md first.
```

**What to narrate while it runs:**
- *"`/research` reads everything completely, not just snippets. It's a documentarian, not an evaluator."*
- *"Notice it's already discovered the `AGENTS.md` file and is reading it for context."*
- When the artifact appears: open `docs/rse/specs/research-*.md` in a split view. Scroll through. Point at the `file:line` references.

### Prompt 2: `/plan` (target: 4 min)

```
/plan Read the research document and create an implementation plan to package these scripts as an installable Python package called vscm, following the Scientific Python guidelines in AGENTS.md. Use uv for the dev workflow and hatchling for the build backend. Phase the work so each phase is independently verifiable.
```

**What to narrate:**
- *"`/plan` reads the research document automatically, that's why we did `/research` first."*
- *"It asks clarifying questions. Watch."* (Sometimes it does, sometimes the AGENTS.md was specific enough that it doesn't.)
- When the artifact appears: open `docs/rse/specs/plan-*.md`. Point at the **automated** vs **manual** verification sections. *"This is what makes `/validate` possible, we know what to check."*

### Prompt 3: `/implement` (target: 6 min: narrate failure modes during)

```
/implement docs/rse/specs/plan-vscm-package.md
```

**What to narrate** (fill the agent's processing time with slides 5 and 6, failure modes + mitigations):

1. (Slide 5) Walk through the failure mode taxonomy. Pause periodically to glance at the agent's progress.
2. (Slide 6) Walk through mitigations.
3. By the time you finish slide 6, the implement should be done or close to it.

**Optional 30-second aside** (drop it once, while `/implement` is grinding, to preempt the "isn't this overkill?" question):

> *"What you're watching now is the slow, durable loop - we're going to ship this code. For day-to-day research iteration you'd just chat against `AGENTS.md`, or run `/research` alone. The point of the full loop is the audit trail in `docs/rse/specs/`, not throughput. We come back to that on slide 8."*

**If `/implement` blows up live:** narrate the failure mode in real time. *"Look, it just hit context exhaustion / it's looping / it's hallucinating an API. This is the taxonomy on slide 5, in action."* Then pivot to the `expected-artifacts/` folder for the rest of the demo.

### Prompt 4: `/validate` (target: 2 min)

```
/validate docs/rse/specs/plan-vscm-package.md
```

**What to narrate:**
- *"This is the quality gate. Without `/validate`, you'd just trust the agent's 'Done!' message."*
- When the report appears: read the pass/fail summary. If anything failed, **don't fix it live**, narrate it as a failure mode example and move on.

## Live-demo fallback plan

| Symptom | Recovery |
|---|---|
| Copilot Chat won't respond / model not selected | Check the model picker shows a workshop model; confirm `LITELLM_*` secrets are set. Meanwhile switch to slides 5-7 and walk through the `expected-artifacts/` folder as if it were live output. Promise to debug after the block. |
| The `/research` etc. commands don't appear in the `/` picker | Run **Developer: Reload Window** (the prompt files in `.github/prompts/` are picked up on reload). ~10 sec. If still missing, fall back to walking through the `expected-artifacts/` folder. |
| `/research` produces obviously wrong output | Open `expected-artifacts/research-vscm-package.md` and walk through it instead. Frame it as: *"the live one was a bit off; here's what a polished one looks like."* |
| `/implement` runs forever | Click **Stop** in the chat panel to cancel the current run. *"This is exactly the failure mode on slide 5, the model gets stuck. Here's what we'd do."* Switch to the pre-built `expected-artifacts/implement-*.md`. |
| The whole thing fails (gateway down, etc.) | Skip the demo entirely. Spend extra time on slides 5-7 (failure modes are the bigger conceptual content anyway). |

The expected-artifacts folder is your safety net. **Don't try to debug live.** A failed demo narrated as a failure mode is *better* than a successful demo, pedagogically.

## Common audience questions

| Question | Short answer |
|---|---|
| "Where do these slash commands come from?" | "Each is a small markdown prompt file in `.github/prompts/` (`research.prompt.md`, `plan.prompt.md`, …) that hands off to a reusable **skill** from UW SSEC's `rse-plugins` (`ai-research-workflows`). The devcontainer installs the skills into Copilot; we keep everything in Copilot Chat so the whole workshop stays in one tool." |
| "Could I run the same workflow in Claude Code or Cursor?" | "Yes — the *pattern* (named slash commands, markdown artifacts in `docs/rse/specs/`) is portable; the file format differs per tool. We keep everything in Copilot Chat here for consistency, but you can port these to any agent." |
| "Should I write workflows for my own projects?" | "Yes, but start small. One slash command for the workflow you do most often (e.g., `/run-tests-and-summarize` or `/explain-this-traceback`) is a good first project. That's Block 4." |
| "How do I carry context across a long session?" | "Run `/handoff` — it writes a self-contained markdown doc to `docs/rse/specs/`, then you start a fresh chat and point it at that file. It ships in `.github/prompts/` like the others." |
| "Can the agent's plan be wrong?" | "Often. Run `/iterate-plan` for surgical edits (or hand-edit the plan — it's plain markdown) instead of regenerating. And `/validate` is non-optional for anything you'd commit." |

## What to skip if you're behind time

In order of expendability:

1. The "iterate" / "experiment" / "handoff" rows on slide 3, collapse to "and three more for refinement, comparison, and context transfer."
2. Slides 6a (git hygiene) and 6b (prompt injection), they're high-value but not load-bearing for the spine. Best used as extra narration filler *while `/implement` grinds*; if the demo runs to time, cut them. If your audience handles sensitive data or is security-minded, keep 6b.
3. One column of the failure modes table on slide 5, drop "Where it comes from" if you have to (sad, it's the Block 2 payoff, but the *mitigations* are more actionable).
3. The practical use cases tour (slide 7), collapse to one sentence: *"Agents help most with feature implementation, debugging, test writing, docs, code review, exploration, and experiment management; they're easiest to misuse on architectural decisions."*
4. The cross-field paragraph at the bottom of slide 8, keep the table, drop the prose. Or vice versa if you have a single-field audience.
5. The bonus discussion of `/validate` failures during the demo.

**Never skip:** the "workflows are the prompt" framing (slide 2), the demo (even if abbreviated to 2 phases), the research-vs-engineering table on slide 8 (it's why the durable loop isn't overkill), or the bridge to Block 4 (slide 9).
