# Block 2: Instructor Notes

These are the notes you actually deliver from. The slide deck has the
public-facing version; this is the inside view.

## Pre-block checklist (do this in the 5 min before you start)

- [ ] Reset Block 1's starter file: `cd blocks/01-landscape/demo/starter && git checkout -- src/sci_units/converters.py`
- [ ] Confirm credentials: `echo $LITELLM_BASE_URL` should print the proxy URL.
- [ ] **Confirm at least one model is reachable.** Run the notebook's discovery cell (cell 4) up to that point and check the printed list. Ideally you have at least 2 models so the comparison is interesting.
- [ ] Open VS Code with two windows arranged:
  - **Left:** `blocks/02-how-it-works/slides.md` Marp preview, full-screen on the projector.
  - **Right:** `blocks/02-how-it-works/demo/notebook.ipynb` open in a tab, kernel `Workshop (Python 3.12)` selected, all cells cleared.
- [ ] Restart the notebook kernel so it shows a clean state.

## Timing checkpoints

| at minute | should be on slide | content |
|---|---|---|
| 2 | slide 2 (Where we left off) | Done with the recap |
| 6 | slide 3 (Pre-training) | Done with the base-model framing |
| 11 | slide 4 (SFT) | Q1 answered |
| 16 | slide 5 (RLHF) | Q2 answered |
| 21 | slide 6 (Tool-use FT) | Q3 answered |
| 23 | slide 7 (Convergence) | Q4 answered, demo about to start |
| 25 | slide 9 (Demo intro) | Switching to notebook |
| 28 | (notebook) | Demo done, switching back to slide 10 |
| 30 | slide 10 (Bridge) | Hand off to Block 3 |

If you are behind, cut from slides 4-6 (each one's "trade-off note" is the most expendable line) before cutting from the demo.

## Per-slide notes

### 1. Title

- 30 seconds. Hand-off from Block 1 demo. Acknowledge: "this is the conceptual block. Stay with us, it pays off in everything that follows."

### 2. Where we left off

- Read all four slowly.
- This is the contract for the next 25 minutes.
- Q1-Q3 are things the audience *watched happen* in Block 1. Q4 is different: the notebook only ran Claude (`MODEL` was hardcoded) and *claimed* the swap to GPT/Gemini would work. Don't oversell it as something they saw, frame it as the promise the demo (slide 9) and convergence slide (slide 7) actually cash in.
- "Each one of those was *not* something the model picked up from reading the internet. Each one has a name."

### 3. Pre-training is a fluent autocomplete

- The "Translate to French: Hello" example is the punchiest concrete demo. **Say it out loud:**
  - prompt: `"Translate to French: Hello\n"`
  - base-model continuation: `"Translate to Spanish: Hello\nTranslate to German: Hello\n..."`
- The example makes the point concretely; it usually gets a laugh.
- Pre-training is **necessary, not sufficient.** Everything that makes a coding agent useful is post-training.

### 3a. Aside: why can a network learn any of this? (OPTIONAL)

- This slide is a budget-dependent insert. Use it only if you hit the minute-6 checkpoint with room to spare; otherwise skip straight to SFT. Nothing downstream depends on it.
- Keep it to 60-90 seconds. The one-line pitch: **"a big enough net with a non-linear squiggle can bend itself to fit any curve."**
- The teaching payoff is the parallel to pre-training: universality is **necessary, not sufficient**. Existence (the function is in there) is not findability (gradient descent reaches it) is not generalization (it works on new inputs).
- Resist the math. If someone wants the proof, point them to office hours.
- Likely question, "why not one giant hidden layer?": depth buys **efficiency**, not extra expressive power. A shallow net could match it but might need an impractical number of neurons.

### 4. SFT (instruction tuning)

- Emphasize: SFT is a relatively cheap and small fine-tune compared to pre-training. The base model already "knows" the world; SFT just teaches it the dialogue format.
- This is also why a small open-source SFT dataset (Alpaca, etc.) can turn a base model into a chatty one.
- Don't get drawn into "and how does fine-tuning work?", wave at backprop, move on.

### 4a. SFT for coding: what the data looks like

- Walk through the `running_mean` example. Point out: typed signature, edge case from the spec, O(n) instead of naive O(nk), no extra commentary.
- That's not the model "being smart", that's the model **imitating what a contractor wrote.**
- Key takeaway: the *style* of agent output (concise, typed, edge-case-aware) is literally a learned imitation of how the SFT contractors wrote.
- Open-source analogues, mention only if asked: CodeAlpaca, Magicoder/OSS-Instruct, the SFT split of OpenCodeInterpreter.

### 5. RLHF (preference learning)

- DPO fans in the audience will appreciate the mention. Don't get into the math; just say *"fewer moving parts than PPO + reward model, often equally good."*
- The "when to stop" framing is the workshop-relevant one. Coding agents that don't stop are useless.
- This is also where models get their "personality" / refusal behavior. Constitutional AI is one variant, mention if asked.

### 5a. RLHF for coding: what the data looks like

- Walk through both responses out loud. Audience usually laughs at B, we've all gotten that response.
- Emphasize: nobody told the model *"don't propose 200-line refactors."* It learned that humans rate the focused answer higher.
- Tie back to Q2: the *reason* a coding agent eventually says "done" instead of looping is RLHF preference data like this.
- Public analogues if asked: HH-RLHF (Anthropic), UltraFeedback, the preference splits in the Llama-2/3 papers.

### 6. Tool-use fine-tuning

- The trace block on the slide is concrete. Walk through it. Point at each line.
- **"Wire format vs meta-skill"** is the punchy two-part framing. Repeat it.
- Agentic RL is the answer to *"why are agents getting better so fast in 2025-2026?"*, it's not bigger models, it's better RL signal over multi-turn trajectories.

### 6a. Tool-use FT: the meta-skill, side by side

- Start here so the audience sees the simplest possible case (one prompt in, one turn out) before the multi-turn trajectory on the next slide.
- The point to hammer: tools aren't called *because they exist in the system prompt.* They're called when the prompt requires fresh information the model can't have.
- Common confusion to head off: *"but couldn't the model just guess 137?"* Yes, and a base model would. The whole point of this training stage is teaching it **not** to.
- If asked: yes, this is also why agents sometimes call tools they shouldn't, over-eager tool use is a known failure mode and a major RLHF target.
- Bridge to the next slide: *"OK, that's the easy case, one tool call. Now let's see what a real coding trajectory looks like."*

### 6b. Tool-use FT: a full multi-turn trajectory

- The meatier follow-up to the side-by-side slide. Walk down the trajectory line by line. Note the structure: hypothesis → tool call → observation → updated hypothesis.
- Call out: every assistant turn is either a tool call **or** a final answer. That binary is *learned* here.
- Bridge to the convergence slide: *"Now imagine generating thousands of these trajectories, scoring whether the final test passed, and using that as RL reward. That's agentic RL, the bleeding edge from the previous slide."*
- Public analogues if asked: ToolBench, Gorilla, the agentic SFT data described in the Llama-3.1 and DeepSeek-Coder-V2 papers.

### 7. Why this is convergent

- This is the slide where Block 1's spine ("all coding agents work the same way under the hood") gets its **proof**. Spend time here.
- The table is a teaching tool, not a leaderboard. Read across rows.
- Tee up the demo: "We're about to swap MODEL and watch the same loop drive a different brain."

### 8. Trained in vs in the prompt

- This is the most actionable slide of the whole block. Call it out: **"Bookmark this slide. This is the lens you'll use every time an agent surprises you."**
- Concrete example to drop: *"if Claude won't follow your style guide, it's not because Claude lacks taste, it's because you didn't put the style guide in `AGENTS.md`."*
- When an agent surprises you, the prompt side is the first place to look, because it's the part you control.

### 8a. The context window (the prompt is a finite budget)

- 60-90 seconds. This is the one **inference-time** idea in an otherwise training-focused block, and it's the direct setup for Block 3's "context exhaustion" failure mode. If you're at/under the minute-25 checkpoint, keep it; if you're behind, it's skippable (Block 3 re-states the failure mode).
- The hook: *"Slide 8 said 'in the prompt' is your lever. The catch: the prompt is finite."*
- The one-liner to land: **"When the window fills, the model doesn't error, it silently forgets your earliest instructions."** That's the intuition Block 3 cashes in.
- Concrete cost example to drop: *"One `read` of a 2,000-line file or a noisy stack trace can eat thousands of tokens, that's why long agent sessions drift."*
- Resist a tokenization deep-dive. "Roughly ¾ of a word" is enough. If someone wants BPE details, point to office hours.
- Tie to a lever they already have: *"This is why `/handoff` and smaller per-phase scope (Block 3) exist, they're context-budget management."*

### 9. Demo intro

- Switch to VS Code. Restart kernel. Cells cleared.
- Narrate the discovery cell: *"This is a defensive move. We don't know in advance whether the proxy fronts GPT and Gemini, so we ask. Same notebook keeps working as the proxy admin adds models."*

### 10. Bridge to Block 3

- Keep this hand-off brief.
- Last sentence: *"Block 3 turns these into a taxonomy with mitigations."* Then hand off.

## Demo script

### Setup (target: 30s)

1. Restart kernel + run cells 1-3 (imports, reset). Should be instant.
2. Run cell 4 (model discovery). Read the available list out loud.

### Model swap (target: 3-4 min)

3. Run cell 6 (signature), quick, just shows participants the function exists.
4. Run cell 8 (`compare`), point at the docstring/comments.
5. Run cell 10 (the loop). This is the core of the demo. Narrate as each model runs:
   - First model (Claude usually): "Watch which tool it picks first."
   - Second model: "Same code. Different brain. Watch the path it takes."
   - Third model (if available): "And now a third lab's training pipeline. Same outcome."
6. After the last trace prints, give participants time to read the output before moving on.

### Discussion (target: 30s)

7. Read cell 11 (the "convergence is not perfection" block) verbatim rather than paraphrasing.

### Bonus: tool description ablation (target: 1 min, time permitting)

8. Run cell 13 (verbose vs vague). Narrate: *"Same model. Same task. The only thing that changed is how clearly we described the tools."*
9. If behavior degrades, point at the diff. If it doesn't (modern models are robust to a lot of slop), say *"OK, even sabotaged tool descriptions work for the easy task, but try this on your own messy codebase and you'll see the lever very fast."*

### What to do if something fails live

| Symptom | Recovery |
|---|---|
| Discovery cell finds 0 models | Talk through the slide content; the conceptual case still stands. Promise to debug after the block. |
| Discovery cell finds 1 model only | Skip ahead to the **tool-description ablation** (cell 13). Frame it: *"Convergence we'll have to trust the slides on; let's instead see the prompt-side lever in action."* |
| One model raises mid-run | Point at the `try/except` in `compare`. *"This is data, Block 3 turns this into a taxonomy. For now, watch the model that did finish."* |
| All models stall (proxy slow) | Cancel the cell, switch back to slide 8 ("trained in vs in the prompt"), expand on the framing for 2 extra minutes. Block 2 still lands. |

## Common audience questions and how to handle them

| Question | Short answer |
|---|---|
| "Is RLHF the same as Constitutional AI?" | "Constitutional AI is a *variant* of RLHF where the preferences come from a model graded against a written constitution, not from human raters. Same shape, less human labor." |
| "What's the difference between RLHF and DPO?" | "DPO skips the explicit reward model, it directly optimizes the policy from preference pairs. Often equally effective, much simpler to implement." |
| "Should I fine-tune for my codebase?" | "Almost never to start. Try prompt and tool-schema iteration first, that's Block 4. Fine-tuning is a heavier, later step for behavior the prompt genuinely can't reach." |
| "What's agentic RL exactly?" | "Reinforcement learning where the trajectory is multi-turn tool use, and the reward is task completion (e.g., 'did the tests pass?'). It's how recent agent products got reliably good at long workflows." |
| "Will GPT-5 / Claude / Gemini eventually all be the same?" | "The shape of behavior is converging fast. The remaining differences are speed, cost, and the small number of capabilities each lab over-invests in. Expect the model layer to feel like a commodity within a couple of years." |

## What to skip if you're behind time

In order of expendability:

1. The "why can a network learn any of this?" aside (slide 3a), it's an optional insert in the first place.
1. The context-window slide (slide 8a), Block 3 re-states the context-exhaustion failure mode, so this is a "nice to have" setup rather than load-bearing.
1. The InstructGPT historical aside on slide 4.
2. The DPO mention on slide 5.
3. The agentic RL detail on slide 6, you can collapse it to "and the bleeding edge is multi-turn RL."
4. The bonus tool-description ablation in the demo (cells 13).
5. The convergence table on slide 7, collapse to one sentence.

**Never skip:** the recap (slide 2), the "trained in vs in the prompt" slide (slide 8), or the bridge to Block 3 (slide 10).
