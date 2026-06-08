# Block 4: Instructor Notes

These are the notes you actually deliver from. The slide deck has the
public-facing version; this is the inside view.

This is the most facilitation-heavy block in the workshop. The slides
are short on purpose; your job is mostly **circulating**.

> **Naming reminder:** what used to be a "custom chat mode" (`.chatmode.md`)
> is now a **custom agent** (`.agent.md` in `.github/agents/`). Same fields,
> current name. If an attendee found an older tutorial that says "chat mode",
> reassure them it's the same thing.

## Pre-block checklist

- [ ] Confirm both worked-example agents appear in the Copilot agent picker. (Open the chat panel, click the agent dropdown, look for `scientific-python-reviewer` and `docstring-writer`.) If not: **Developer: Reload Window**.
- [ ] Have the **live-build agent** memorized or in a scratch buffer (see "Live-build script" below).
- [ ] Have the climate model open in a side editor: `blocks/03-research-loop/demo/starter/climate_model.py`.
- [ ] Have `blocks/04-build-a-skill/exercise/ideas.md` open in another tab, you'll point participants at it constantly.
- [ ] Identify any participants who have brought their own code, they'll need slightly different guidance during circulation.

## Timing checkpoints

| at minute | should be on slide / phase | what to do |
|---|---|---|
| 3 | slide 2 (recap) | Done with framing |
| 8 | slide 4 (worked examples) | Done with anatomy + tour |
| 12 | slide 5 (your turn) | Live build done; release the room |
| 17 | hands-on (5 min in) | Walking the room; helping the stuck |
| 22 | hands-on (10 min in) | Announce 5 min remaining; scout show-and-tell volunteers |
| 25 | show-and-tell | 1-2 volunteers demo |
| 28 | slide 6 (wrap-up) | Office hours pointer + thank-yous |
| 30 | done | Thank-yous, fade to applause |

If you're behind: cut show-and-tell first (it's optional). Then collapse the live-build to a quick walkthrough of `.github/agents/scientific-python-reviewer.agent.md` rather than typing one fresh.

## Per-slide notes

### 1. Title

- 30 seconds. Hand-off from Block 3 with energy.
- *"This is the part you've been waiting for. Light on talk, heavy on doing."*

### 2. The whole workshop, in one slide

- Read across the rows. Pause briefly on each.
- *"The pieces are simple. The practice is what makes it useful. The next 25 minutes are practice."*, say this slowly. It's the workshop's closing thesis.

### 3. Anatomy of a Copilot custom agent

- Walk through the example file left-to-right, top-to-bottom.
- Call out the Block 1 mappings:
  - `tools` -> the agent loop's hands.
  - System prompt -> persona + project memory + workflow.
  - "What you do NOT do" -> safety constraints (analogous to RLHF refusals, but in the prompt, not the weights).
- *"A handful of fields. That's it. You can read the file in 30 seconds."*
- Tee up the live build.

### 4. Two worked examples

- Open `scientific-python-reviewer.agent.md` in a side editor. Point at structure.
- Open `docstring-writer.agent.md`. Same shape, different tool list.
- *"The exercise tells you to copy patterns. Do that, the worked examples ARE the curriculum."*
- If anyone asks "is there more?": yes, `.github/` has a fuller gallery (more agents, prompt-file commands, a skill, instructions) mapped to the research lifecycle. Point them at the customization gallery in the root `README.md`, but don't detour the whole room.

### 5. Your turn (HOLD this slide for the whole hands-on)

- Project for the duration. Participants need it as a reference.
- Repeat *"narrow over broad"* whenever you spot someone aiming too big.
- ~3 min in: walk the room. Help anyone whose agent hasn't appeared in the picker.
- ~10 min in: announce 5 min remaining and start scouting show-and-tell volunteers.

### 6. Wrap-up

- Confirm office hours time + location explicitly.
- Thank: co-instructors, Schmidt Sciences, the VISS centers, and the attendees.
- Keep the close short; don't gild it.

## Live-build script

Build a tiny `error-explainer` agent in ~3-4 minutes. The point is to
demystify, not to impress. Keep it small and visible.

**Type, don't paste.** The visible typing is part of the lesson.

```bash
# In a terminal, in the workshop root:
cp blocks/04-build-a-skill/exercise/my-agent.agent.md.template \
   .github/agents/error-explainer.agent.md
code .github/agents/error-explainer.agent.md
```

Then in the editor, replace the TODOs with:

```markdown
---
name: error-explainer
description: 'Explain a Python traceback in plain English and suggest a fix.'
tools: ['read', 'search/codebase']
---

# Error Explainer

You are a friendly Python tutor. The user pastes you a traceback.

## What you do

1. Read the traceback. Identify the error type and the relevant line.
2. If the line references project files, read them with `read` to confirm context.
3. Explain in plain English: what the error is, why it happened, and one or two ways to fix it.
4. Be concrete: cite the actual line of code. No vague suggestions.

## What you do NOT do

- You do not edit files. You only explain.
- You do not lecture about Python in general. Stay focused on this specific error.

## Output format

```
**Error:** <one-line summary>
**Cause:** <one or two sentences>
**Fix:** <one or two concrete suggestions, with code snippet if helpful>
```
```

Save. Open Copilot Chat. Click the agent picker. **Point out** that
`error-explainer` now appears. Switch to it. Paste a small fake traceback:

```
Traceback (most recent call last):
  File "co2_emissions.py", line 39, in _read_ssp_csv
    df = pd.read_csv('SSP_CO2emissions.csv', skiprows=1)
NameError: name 'pd' is not defined
```

Watch it explain. Move on to the hands-on slide. Whole thing should be
~4 minutes including narration.

## What to circulate for

The biggest categories of stuck participants and how to unstick them:

| Stuck on | Ask | Then |
|---|---|---|
| Picking what to build | "What's a tiny annoying thing in your day-to-day?" | Point at `ideas.md` |
| Agent not appearing in picker | "What's your filename?" | Confirm `*.agent.md` in `.github/agents/`. Tell them to **Reload Window** |
| Agent loaded but YAML error | (check the chat panel for an error toast) | Read the frontmatter together. Common: missing quotes around description, malformed `tools` list |
| Agent runs but does the wrong thing | "Read your steps out loud" | Usually the steps are too vague. Tighten step 1, add a "do NOT" |
| Agent stuck in a loop / doing too much | (check for missing terminal condition) | Add to system prompt: *"After at most 5 tool calls, summarize and stop."* |
| Wants to use `edit/editFiles` but worried | "What scope?" | Suggest narrowing: *"only edit files in `tests/`"* in system prompt + the file path filter |
| Wants something more advanced | "Have you got the basic one working?" | If yes, point at the prompt-file, skill, or MCP sections of `resources.md`. If no, finish the basic one first. |

## Show-and-tell

- ~5 min before the slot, identify 1-2 volunteers whose agents work AND aren't too domain-specific (so the rest of the room can follow).
- Each volunteer gets 60-90 seconds: show the agent file, run a query, show the result.
- If no volunteers: walk through what you saw circulating ("a bunch of you built docstring writers, here's a clever twist someone added"). Don't force.

## What to skip if you're behind time

In order:

1. Show-and-tell (skip entirely; thank participants and move to wrap-up).
2. Live build (point at the worked examples and say *"go read these for 1 minute, then build your own"*).
3. Slide 3 (anatomy), collapse to "open the file, you'll see the structure."

**Never skip:** slide 5 (the hands-on instructions), the office hours pointer, the thank-yous.

## Common audience questions

| Question | Short answer |
|---|---|
| "Didn't these used to be called chat modes?" | "Yes. VS Code renamed custom chat modes to custom agents (`.chatmode.md` -> `.agent.md`, `.github/chatmodes/` -> `.github/agents/`). Same fields, same idea." |
| "What's the difference between a custom agent and a prompt file?" | "Custom agent = persistent persona for the whole conversation, picked from the agent dropdown. Prompt file = one-shot `/slash` command. Use prompt files for repeated quick actions, agents for sustained tasks." |
| "What's a skill then?" | "A skill is a folder (`.github/skills/<name>/SKILL.md`) that can bundle scripts and resources, loaded on demand. Use it for a multi-step capability, not a single prompt. See `.github/skills/experiment-log/`." |
| "Can I have multiple agents active?" | "One at a time per chat. But you can switch mid-conversation, and agents can hand off to each other." |
| "Does the agent use the LiteLLM proxy?" | "Yes, Copilot uses the same env vars regardless of agent. The model you see in the picker comes from your Copilot settings." |
| "Can I use this with another tool (Cursor, Claude Code)?" | "Yes. They have their own equivalents (Cursor rules/modes, Claude Code skills). The pattern transfers; the file format differs slightly. We keep the whole workshop in Copilot Chat for consistency. See `resources.md`." |
| "Where do I save the agent if I want to use it on my own repo?" | "Same place: `.github/agents/<name>.agent.md` in that repo. The file is portable; commit it and your collaborators get it too." |
| "How do I test an agent without running a real query?" | "You can't, really. The iteration loop is: edit prompt -> reload -> run -> observe -> edit. Same as prompt engineering anywhere." |
