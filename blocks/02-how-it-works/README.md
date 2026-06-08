# Block 2: How It Actually Works (Post-Training and Tool Calling)

**Duration:** ~30 minutes
**Tool focus:** Same `litellm` proxy setup as Block 1, but used to compare *multiple* models on the same agent loop.
**Spine:** *Each post-training stage answers one phenomenon from Block 1's demo.*

## Learning goals

By the end of this block, an attendee can:

1. Explain why a **base** language model, without post-training, can't follow instructions, can't choose helpful actions, and can't call tools, even though it has read most of the internet.
2. Name and distinguish the four post-training stages, **pre-training, SFT, RLHF / preference learning, tool-use fine-tuning**, and say what each one teaches the model.
3. Describe **agentic RL** in one sentence and explain why every major lab is investing in it for coding agents in 2025-2026.
4. Apply the **"trained in" vs "in the prompt"** mental model to triage agent failures (is this a training problem or a prompt problem?).
5. Predict that swapping the model on the workshop's LiteLLM proxy will *mostly* work for the same loop, and explain *why* that's true (convergent post-training).
6. Explain what a **context window** is, what consumes it during an agent run, and why "the model silently forgot my instructions" is an architectural limit, not a bug (the setup for Block 3's context-exhaustion failure mode).

## What's in this folder

```
02-how-it-works/
  README.md            # this file
  slides.md            # Marp slides (~12 slides, ~22 min talking)
                       # (theme: shared blocks/_shared/slides.css)
  instructor-notes.md  # speaker notes, demo script, fallbacks, timing
  resources.md         # curated further reading
  demo/
    notebook.ipynb     # "Same loop, different brain", model swap experiment
```

## Timing (30 min)

| min | section |
|---|---|
| 0–2 | Recap + the four questions Block 1 raised |
| 2–6 | Pre-training is not enough |
| 6–11 | SFT, answers Q1 ("why does it follow our prompt?") |
| 11–16 | RLHF, answers Q2 ("why does it stop when done?") |
| 16–21 | Tool-use fine-tuning + agentic RL, answers Q3 ("why does it call `run_bash`?") |
| 21–23 | Convergent post-training, answers Q4 ("why does the same loop drive Claude AND GPT?") |
| 23–25 | "Trained in" vs "in the prompt" + the context-window budget (skippable if behind) |
| 25–28 | **Demo**: "Same loop, different brain", live model swap |
| 28–30 | Bridge to Block 3 |

## How to run the material

### View / present the slides

The Codespace ships with the **Marp for VS Code** extension installed. See [`blocks/01-landscape/README.md`](../01-landscape/README.md#view--present-the-slides) for the full set of preview / present / export options. tl;dr: open `slides.md`, click the preview icon.

### Run the demo

The demo is a single notebook, run live.

1. Reset Block 1's starter file so the demo is deterministic:
   ```bash
   cd blocks/01-landscape/demo/starter
   git checkout -- src/sci_units/converters.py
   ```
2. Open `blocks/02-how-it-works/demo/notebook.ipynb`.
3. Run all cells top to bottom. Cell 4 discovers which models the LiteLLM proxy fronts; subsequent cells run the **same agent loop** (imported from `workshop_agent`) against each one.

The notebook is robust to model unavailability, if the proxy only fronts Claude, the model-swap cells skip gracefully and the tool-description ablation still runs.

## Prerequisites

- Block 1 completed (or at least its setup: Codespace running, `LITELLM_API_KEY` and `LITELLM_BASE_URL` configured).
- `workshop_agent` importable (verified by the `on-create.sh` sanity check).

## Bridge to Block 3

This block ends with the framing: *"Knowing how the model is shaped lets us predict how it can fail."* Block 3 turns common agent failures (context exhaustion, looping, niche-stack hallucination) into a teachable taxonomy with mitigations.
