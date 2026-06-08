---
marp: true
theme: workshop
paginate: true
title: "Block 2 - How It Actually Works"
description: "Coding with AI Agents - 2026 Interdisciplinary Science Summit"
---

<!-- _class: lead -->

# How It Actually Works

## Block 2: Post-Training and Tool Calling

*A primer on why the loop you just saw is even possible.*

---

## Where we left off: four questions

Block 1 ended with an agent that, given one prompt, did four things we mostly took for granted:

- **Q1.** It **followed our instructions** at all. *Why?*
- **Q2.** It **acted helpfully** and **stopped when done** instead of rambling or looping. *Why?*
- **Q3.** It **called `run_bash`** instead of describing what it would do. *Why?*
- **Q4.** We claimed the same loop would work with **GPT or Gemini**, not just Claude. *Why is that swap even possible?*

---

## Pre-training: a fluent autocomplete

A **base** large language model is trained to predict the next token in
a corpus of text. That's it. After pre-training, the model is great at
*continuing* text in the style of what it just read.

What that does NOT give you:

- Following instructions ("write a function" -> base model writes more *prompts* in the same style)
- Helpful behavior, refusals, knowing when to stop
- Calling tools, the concept doesn't exist in pre-training data
- Stable identity ("you are a helpful assistant", the base model has no idea what that means)

Everything that makes a coding agent *useful* is grafted on **after** pre-training.

---

## Aside: why can a network learn any of this?

Pre-training, SFT, RLHF, every stage in this block assumes one thing: that a neural network *can* represent the function you are training it toward. That assumption has a name.

**Universal Approximation Theorem** (Cybenko 1989, Hornik 1991): a network with a non-linear activation and enough neurons can approximate *any* continuous function to arbitrary precision.

- "Next token given context", "helpful reply given prompt", "tool call given task", all just functions.
- The **non-linearity** (ReLU, etc.) is the key ingredient. Stack only linear layers and the whole thing collapses back into a single straight line.
- **Depth** is what makes it *efficient*: deep nets compose simple features into complex ones, instead of needing astronomically many neurons in one layer.

> Universality only says the function *exists* inside the network. Training is the bet that gradient descent can *find* it, and that it *generalizes* to new inputs. It usually does. That empirical fact is the miracle the rest of this block stands on.

---

## Stage 1: SFT (instruction tuning)

**Supervised fine-tuning** on a curated set of `(prompt, ideal response)` pairs.

- Source: human contractors writing demonstrations, plus distilled from larger models, plus filtered web data.
- Volume: tens of thousands to low millions of pairs.
- Outcome: the model learns the **format** of "user asks, assistant answers." It now follows instructions instead of pattern-matching them.

**This is what answers Q1.** *(Why does it follow our prompt at all?)*

---

## SFT for coding: what the data looks like

A single training example is just a `(prompt, response)` pair. For coding agents, contractors write thousands of these:

```
PROMPT:
Write a Python function `running_mean(xs, k)` that returns the
length-k moving average of a list of floats. Handle k > len(xs)
by returning an empty list.

RESPONSE:
def running_mean(xs: list[float], k: int) -> list[float]:
    if k <= 0 or k > len(xs):
        return []
    out = []
    s = sum(xs[:k])
    out.append(s / k)
    for i in range(k, len(xs)):
        s += xs[i] - xs[i - k]
        out.append(s / k)
    return out
```

The model learns the **shape**: read the spec, write typed code, handle the edge case the prompt mentioned, stop. Multiply by ~hundreds of thousands of examples across languages, frameworks, and difficulty levels.

---

## Stage 2: RLHF (preference learning)

Two steps:

1. **Reward model:** collect pairs of model responses with a human label of "A is better than B". Train a small model to predict that preference.
2. **RL:** use that reward model to push the policy (the LLM) toward higher-scoring outputs. **PPO** (Proximal Policy Optimization) is the classic algorithm; **DPO** (Direct Preference Optimization) is the simpler modern alternative that skips the explicit reward model.

Outcome: the model learns **what humans find helpful**, when to refuse, and, crucially for agents, **when it has done enough and can stop**.

**This is what answers Q2.** *(Why did it stop instead of looping forever?)*

> Trade-off: too much RLHF and the model becomes overly cautious or sycophantic. Lab releases live or die on this dial.

---

## RLHF for coding: what the data looks like

A single training example is a `(prompt, response_A, response_B, label)` tuple. The label is a human's pick of which response is better.

```
PROMPT:
My pytest run hangs forever on test_ingest. What should I do?

RESPONSE A:                          RESPONSE B:
Run `pytest -x test_ingest` to       You should rewrite your test
fail fast, then add `--timeout=10`   suite using async fixtures and
(pytest-timeout). If it still        switch to pytest-asyncio. Also
hangs, the culprit is usually a      consider migrating off pytest
network call or a fixture waiting    entirely. Here is a 200-line
on a lock; isolate with `-k` and     refactor that does that...
add `-s` to see prints.

LABEL: A > B   (focused, answers the question, stops)
```

What the model learns from millions of these:

- **Stay on the asked question** (don't propose a rewrite when asked to debug).
- **Match the user's scope** (one failing test, not the whole suite).
- **Stop when the answer is complete** instead of padding.

**That's the "knowing when to stop" behavior**, learned as a preference, not a rule.

---

## Stage 3: Tool-use fine-tuning

Train on **traces** that include tool calls:

```
system: tools = [read_file, write_file, run_bash]
user:   "fix the failing test"
assistant: <tool_call: run_bash("pytest")>
tool:   <result: 2 failed>
assistant: <tool_call: read_file("test_x.py")>
tool:   <result: ...>
assistant: "I see the bug. Fixing now..."
```

The model learns **two things at once**:

- The **wire format**, emit valid JSON tool calls in the right place.
- The **meta-skill**, when to call a tool versus when to respond directly.

**Bleeding edge: agentic RL.** RL applied over multi-turn tool-use trajectories with task-completion reward. This is what major labs are pouring resources into in 2025-2026. It's why Claude Code, Cursor, and Copilot agent mode have gotten so much better in the last 18 months.

**This is what answers Q3.** *(Why did it call `run_bash` instead of just describing it?)*

---

## Tool-use FT: the meta-skill, side by side

Start with the simplest version of a training example: **one prompt in, one assistant turn out**. Same system prompt, same tools, two different user prompts:

```
─── Example A ──────────────────────────────────────
system: tools = [run_bash, read_file, write_file]
user:   What does the `-x` flag do in pytest?

A: It stops the test run after the first failure
   instead of running the whole suite. Useful when
   you want a fast feedback loop while debugging.
────────────────────────────────────────────────────

─── Example B ──────────────────────────────────────
system: tools = [run_bash, read_file, write_file]
user:   How many tests are in this repo right now?

A: ↳ tool_call: {"name": "run_bash",
                 "params": {"cmd": "pytest --collect-only -q | tail -1"}}
tool:   137 tests collected
A: 137 tests.
────────────────────────────────────────────────────
```

The **only** thing that changes the assistant's first move is the prompt:

- **A** is answerable from training knowledge → answer directly, **don't** call a tool.
- **B** requires reading the actual repo state → **must** call a tool.

This is the **meta-skill**: knowing which prompts cross the line into "I need to actually go look." Trained on thousands of paired examples like these.

---

## Tool-use FT: a full multi-turn trajectory

Now scale up. A real example is a full **trajectory** — the model emits a tool call, reads the result, decides what to do next, and keeps going until the task is done. Lines starting with `A:` (the assistant) are the only ones the model is **trained to emit**; `system`, `user`, and `tool` lines are context the model is trained to **read and condition on**.

```
system: You are a coding agent. Tools available:
        [{"name": "run_bash", "params": {"cmd": "string"}},
         {"name": "read_file", "params": {"path": "string"}},
         {"name": "write_file", "params": {"path": "...", "content": "..."}}]
user:   The test_parse_date test is failing. Please fix it.

A: I'll start by running the test to see the error.
   ↳ tool_call: {"name": "run_bash",
                 "params": {"cmd": "pytest -x test_parse.py::test_parse_date"}}
tool:   FAILED test_parse.py::test_parse_date
        AssertionError: expected datetime(2024,1,2), got datetime(2024,2,1)
A: Day/month swap. Let me read the parser.
   ↳ tool_call: {"name": "read_file", "params": {"path": "parser.py"}}
tool:   def parse_date(s): return datetime.strptime(s, "%m/%d/%Y")
A: Format string has month before day; input is DD/MM/YYYY.
   ↳ tool_call: {"name": "write_file",
                 "params": {"path": "parser.py",
                            "content": "def parse_date(s): return datetime.strptime(s, '%d/%m/%Y')"}}
tool:   ok
A: ↳ tool_call: {"name": "run_bash", "params": {"cmd": "pytest -x test_parse.py"}}
tool:   1 passed
A: Fixed. The format string had month and day swapped. Tests now pass.
```

The trajectory teaches **wire format** (valid JSON, right schema), **multi-step meta-skill** (run → read → reason → write → re-run), and **termination** (stop after the green test, don't keep poking).

---

## Why this is convergent

| Lab | Pre-training | SFT | Preference learning | Tool-use FT |
|---|---|---|---|---|
| Anthropic | yes | yes | RLHF + Constitutional AI | yes + agentic RL |
| OpenAI | yes | yes | RLHF, RLAIF | yes + agentic RL |
| Google | yes | yes | RLHF | yes |
| Meta (Llama) | yes | yes | DPO | partial |
| DeepSeek | yes | yes | RL on reasoning (R1) | partial |

Different data. Different reward signals. Different sequencing.

**Same shape.**

> When you train very different models to do *overlapping skills*, they
> converge on *overlapping behaviors*. That's why `MODEL = "..."` is
> just a string. **Answers Q4.**

---

## Trained in vs in the prompt

The actionable mental model:

| Trained in (the model already knows) | In the prompt (you control) |
|---|---|
| Dialogue format | System message |
| Helpful tone, refusals | Project memory (`AGENTS.md`) |
| Tool-call wire format | Specific tool schemas |
| When to stop | Current task description |
| Knowledge up to training cutoff | Documents you load into context |

When debugging an agent, ask:

> _"Is this a **training problem** (model X just can't do this), or a
> **prompt problem** (it could if I told it better)?"_

**The prompt side is the lever you actually control** — and it's what Blocks 3 and 4 build on.

---

## The catch: the prompt is a finite budget

Everything "in the prompt" shares **one fixed window of tokens** — the
**context window**. The model sees only what fits in it, all at once.

What competes for that budget on every single turn:

- The **system prompt** + your `AGENTS.md` (project memory)
- The **whole conversation so far** (every turn is re-sent)
- Every **tool result**: file contents, `pytest` output, search hits
- The model's own reasoning and the answer it's about to write

A *token* is roughly ¾ of a word (or a few characters of code). Windows are
large (~100K–1M tokens) but **not infinite**, and agent runs fill them fast —
one `read` of a big file or a noisy traceback can cost thousands of tokens.

> When the window fills, the earliest content (your original instructions)
> gets pushed out. The model doesn't error — it just **silently forgets**.
> That's not a bug; it's the architecture. 

---

## Demo: Same loop, different brain

We are going to import the **Block 1 agent loop** as a one-line import (`from workshop_agent import run_agent`) and run it against multiple models on the LiteLLM proxy.

What to watch for:

- The same code drives Claude, GPT, Gemini.
- Different models pick different *first* tools, take different numbers of turns, write the fix slightly differently.
- They all converge on the same **outcome** (passing tests).
- That's convergent post-training, made tactile.

Bonus, if there's time: re-run the agent with deliberately **vague tool descriptions**. Watch behavior degrade. Prompt levers are real.

---

## Bridge to Block 3

You now have the model:

- It learned a **format** (SFT)
- It learned **preferences** (RLHF)
- It learned a **tool protocol** and **when to call** (tool-use FT)
- It came out _similar_ to other models trained the same way (convergence)

That same training history also tells you **how it can fail**:

- Context window full -> forgets what it was doing
- Niche language not in training data -> hallucinates plausible nonsense
- Reward-hacked on "be confident" -> won't admit it doesn't know
- Trained on short trajectories -> loops on long ones

**Enough concepts, all applied now.**
