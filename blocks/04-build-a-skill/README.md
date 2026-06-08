# Block 4: Build Your Own Skill (Capstone)

**Duration:** ~30 minutes (the remaining workshop time)
**Tool focus:** **GitHub Copilot custom agents** (`.github/agents/*.agent.md`).
**Spine:** *Skills are simple, a few fields in a markdown file. Now write one.*

The capstone. Each attendee builds a working custom agent of their own and
runs it against the climate model from Block 3 (or their own code). The
worked examples in [`.github/agents/`](../../.github/agents/) plus the
[`exercise/`](exercise/) folder are the scaffolding.

> **A note on naming:** Copilot's custom agents were until recently called
> **custom chat modes** (`.chatmode.md` files in `.github/chatmodes/`). VS Code
> renamed them to **custom agents** (`.agent.md` in `.github/agents/`) — same
> idea, same fields, current name. If you see "chat mode" in an older blog
> post, it means the same thing.

## Learning goals

By the end of this block, an attendee can:

1. Read a Copilot custom agent file and identify which line corresponds to which **anatomy concept** from Block 1 (LLM backbone, tool use, project memory, system prompt).
2. **Write** a custom agent end-to-end: pick a job, write a focused system prompt, choose a narrow tool list, save it to `.github/agents/`, and invoke it.
3. **Iterate** on an agent that almost works: tighten the prompt, add explicit constraints, narrow or broaden the tool list.
4. Map the same agent pattern to **other primitives** (Copilot prompt-file commands for one-shots, like the Block 3 workflow; skills for multi-step capabilities; MCP servers if they want to add new tools).

## What's in this folder

```
04-build-a-skill/
  README.md            # this file
  slides.md            # Marp slides (~6 slides, ~10 min talking)
                       # (theme: shared blocks/_shared/slides.css)
  instructor-notes.md  # facilitation guide, live-build script, what to circulate for
  resources.md         # Copilot custom-agent docs, prompt files, skills, MCP
  exercise/
    README.md                       # participant-facing step-by-step
    my-agent.agent.md.template      # SKELETON to copy + fill in
    ideas.md                        # 30+ starter agent ideas
```

The **worked examples** live in [`.github/agents/`](../../.github/agents/) so
they're auto-loaded by Copilot in the Codespace from the start of the workshop.
The two used as the Block 4 reference are:

- [`scientific-python-reviewer.agent.md`](../../.github/agents/scientific-python-reviewer.agent.md), read-only opinionated reviewer
- [`docstring-writer.agent.md`](../../.github/agents/docstring-writer.agent.md), focused write-mode for adding NumPy-style docstrings

The rest of [`.github/`](../../.github/) is a fuller gallery (more agents,
prompt-file commands, a skill, path-scoped instructions) mapped to the research
lifecycle — see the [customization gallery in the root README](../../README.md#copilot-customization-gallery). Point curious
attendees at it.

## Timing (~30 min)

| min | section |
|---|---|
| 0–3 | Workshop recap + "the simplest customization is a custom agent" |
| 3–8 | Anatomy of a custom agent + tour the two worked examples |
| 8–12 | **Live build**: instructor builds a tiny agent in front of the room |
| 12–25 | **Hands-on**: attendees build their own; instructors circulate |
| 25–28 | Show-and-tell: 1-2 volunteers demo their agent |
| 28–30 | Wrap-up + office hours |

The hands-on is the load-bearing part. Slides are intentionally light.

## How to run the material

### Present the slides

Marp-for-VS-Code, same as the other blocks, see [`blocks/01-landscape/README.md`](../01-landscape/README.md#view--present-the-slides).

### Run the exercise

Participants follow [`exercise/README.md`](exercise/README.md). Instructors
circulate. The exercise's troubleshooting table covers the common
"my agent doesn't appear" / "agent runs but does the wrong thing" issues.

## Prerequisites

- All of Blocks 1, 2, 3 done (or at least their setup: Codespace, Copilot signed in, LiteLLM proxy credentials).
- Both worked-example agents appear in the Copilot agent picker. (If not: **Developer: Reload Window**.)

## Office hours (next day)

VISS members will be available the day after the workshop to help
attendees:

- Try their agent against their own data or workflows.
- Promote an agent to a Copilot **prompt-file command** (like the Block 3 workflow) or a **skill** (with bundled scripts) if they want a different shape, or wrap a new tool with an **MCP server**.
- Port their agent to another tool (Cursor, Claude Code, ...) — the pattern carries over even though the file format differs.
- Talk through agentic research workflows in general.

Bring whatever code or data you wanted to try during the workshop but
didn't get to.
