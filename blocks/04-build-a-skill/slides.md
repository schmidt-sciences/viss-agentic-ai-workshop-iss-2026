---
marp: true
theme: workshop
paginate: true
title: "Block 4 - Build Your Own Skill"
description: "Coding with AI Agents - 2026 Interdisciplinary Science Summit"
---

<!-- _class: lead -->

# Build Your Own Skill

## Block 4: Capstone

*Five fields in a markdown file. No magic. Let's go.*

---

## The whole workshop, in one slide

| Block | Takeaway |
|---|---|
| 1. Landscape | All coding agents have the same anatomy: LLM + tools + memory + loop. |
| 2. How it works | Triage failures: **prompt problem** vs **training problem** — the prompt is your lever. |
| 3. Workflows | **Workflows ARE the prompt**, structured, reusable, auditable. |
| 4. **Now** | Write one. |

> The pieces are simple. The **practice** is what makes it useful.
> The next 25 minutes are practice.

---

## Anatomy of a Copilot custom agent

```markdown
---
name: scientific-python-reviewer
description: 'Review code against Scientific Python guidelines (read-only).'
tools: ['read', 'search/codebase', 'search']
---

# Scientific Python Reviewer

You are a senior research software engineer reviewing scientific Python code...

## What you do

1. Read the code thoroughly.
2. Identify gaps against the recommendations.
3. Output a markdown review with file:line references.

## What you do NOT do

- You do not edit files.
- You do not invent issues.
```

> Top: **frontmatter**, the name + what shows in the picker + which tools it can use.
> Below: **system prompt**, persona, steps, constraints.
> That's it. A handful of fields.

---

## Two worked examples in `.github/agents/`

| Agent | What it does | Tools | Why it's a good template |
|---|---|---|---|
| `scientific-python-reviewer` | Reviews against Scientific Python guidelines | read-only | Persona + standard reference + tight scope |
| `docstring-writer` | Adds NumPy-style docstrings | read + write | Scoped editing + output style example |

Open them. Read them. **They are the reference for what you'll write.**

> The exercise's `ideas.md` has 30+ more agent ideas if you don't have one
> in mind, by category (review, generation, refactoring, climate-specific,
> general research, onboarding). The rest of `.github/` is a fuller gallery.

---

## Your turn (~15 min)

1. **Copy** the template:
    ```bash
    cp blocks/04-build-a-skill/exercise/my-agent.agent.md.template \
       .github/agents/my-agent.agent.md
    ```
2. **Pick** a target, the climate model, `sci_units`, or your own code.
3. **Pick** a job, see `exercise/ideas.md`, or invent your own.
4. **Edit** the file: name, description, tools, system prompt, constraints.
5. **Reload** Copilot Chat (or wait, agents auto-detect).
6. **Run** your agent and **iterate**.

Full instructions: [`blocks/04-build-a-skill/exercise/README.md`](../../blocks/04-build-a-skill/exercise/README.md)

> Instructors circulating. **Get something narrow working** before
> trying to make it broader. Ship a boring agent that runs over an
> ambitious agent that doesn't.

---

## Wrap-up

You now have:

- A mental model that survives the next product release (Blocks 1, 2)
- A concrete workflow you've seen run on real code (Block 3)
- A custom agent you wrote yourself that **lives in your Codespace** (Block 4)

This Codespace stays. The repo stays. 

> Thank you for spending the afternoon with us.
