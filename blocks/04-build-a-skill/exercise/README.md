# Exercise: Build Your Own Custom Agent

By the end of this exercise (~15 min) you will have **a working Copilot
custom agent you wrote yourself**, runnable from the chat panel in this
Codespace.

The worked examples in [`.github/agents/`](../../../.github/agents/)
(`scientific-python-reviewer` and `docstring-writer`) are your reference.
Read them, copy patterns, then make something different.

> **Naming:** custom agents were until recently called "custom chat modes"
> (`.chatmode.md`). VS Code renamed them to custom agents (`.agent.md` in
> `.github/agents/`). Same fields, current name.

## 1. Setup (1 min)

Copy the template into the workshop's agents directory. Pick a sensible
name, it'll show up in the agent picker.

```bash
cp blocks/04-build-a-skill/exercise/my-agent.agent.md.template \
   .github/agents/my-agent.agent.md
```

(Replace `my-agent` with whatever you want to call your agent. Examples:
`error-explainer`, `style-checker`, `ssp-explainer`.)

## 2. Pick a target (1 min)

What code (or data, or notebook) will your agent run against? Pick
whichever gets you to "running" fastest:

1. **Your own work** — a snippet of code, a notebook, a CSV from your lab, a transcript. This is the most useful target if you brought something. The pattern is identical regardless of domain (physical science, ML, behavioral / social science, bio, stats, qualitative work).
2. **The climate model** in [`blocks/03-research-loop/demo/starter/`](../../03-research-loop/demo/starter/), realistic research Python, has obvious style and structure issues, fits a wide range of agents.
3. **`sci_units`** in [`blocks/01-landscape/demo/starter/`](../../01-landscape/demo/starter/), small and simple, good for narrow agents.

If you didn't bring something, that's fine — use the climate model. If
the climate model feels far from your work, drop a notebook or CSV from
your lab into a scratch folder and target that. The point is the
*pattern*, not the example.

## 3. Pick a job (1 min)

What does your agent do? See [`ideas.md`](ideas.md) for 30+ starting ideas
across categories: code review, code generation, refactoring, climate-
specific, general research, behavioral / social science / stats,
experiment management, onboarding.

Or invent your own. The good first ones are **narrow** ("review against
one specific guideline", "explain one specific kind of error") rather than
ambitious ("become a full agent for my project").

## 4. Edit the agent (8-10 min)

Open `.github/agents/my-agent.agent.md` and fill in the TODOs:

| Field | Guidance |
|---|---|
| `name` | The identifier shown in the agent picker. Match the filename minus `.agent.md`. |
| `description` | One line. Shows next to the name. Make it scannable. |
| `tools` | Start narrow. `['read', 'search/codebase']` is read-only and safe. Add `edit/editFiles` only if your agent needs to modify code. Add `execute/runInTerminal` only if it needs to run shell (e.g., `pytest`). |
| Persona / what you do | A few sentences setting role, then a numbered list of steps. Be specific. Vague prompts produce vague behavior. |
| What you do NOT do | The constraints are as important as the instructions. "Do not edit files outside `tests/`" is a real safety lever. |
| Output format | Show an example of what good output looks like. Concrete examples beat abstract descriptions. |

**Pattern to copy:** look at `.github/agents/scientific-python-reviewer.agent.md` for a read-only agent and `.github/agents/docstring-writer.agent.md` for an agent that edits files.

## 5. Try it (3-5 min)

1. Open Copilot Chat (the icon in the activity bar, or `Ctrl/Cmd+Shift+I`).
2. Click the **agent picker** at the top of the chat panel (it usually shows "Ask" or "Agent" by default).
3. Select your agent name. If you don't see it, see [Troubleshooting](#troubleshooting).
4. Type a query that exercises your agent.

Example queries depending on what you built:
- For a reviewer: *"Review `blocks/03-research-loop/demo/starter/climate_model.py`."*
- For a docstring writer: *"Add docstrings to `blocks/01-landscape/demo/starter/src/sci_units/converters.py`."*
- For an error explainer: *"Explain this traceback: <paste>."*

## 6. Iterate

Did your agent do what you expected? If not, that's the point.

- **Behavior too vague?** Tighten the steps in your system prompt.
- **Wrong tool used?** Adjust the `tools` list.
- **Output format off?** Add a more concrete example to the "Output format" section.
- **Agent being too cautious or too eager?** Add explicit "do NOT" constraints.

This iteration loop, *write, run, observe, adjust the prompt*, is the
same loop behind the Block 3 workflow prompt files in `.github/prompts/`.
You're doing real prompt engineering.

## 7. Stretch: take it further

If your agent is working and you've still got time (or you've built
agents before and want to push past the basics), pick one of these.
Each is ~10-20 min on its own, none are required, all are great
office-hours starting points if you don't finish.

### Stretch A — Promote your agent to a Copilot skill

A **skill** (`.github/skills/<name>/SKILL.md`) is the next primitive up
from an agent: it can bundle scripts and resources and load on demand.
The fields are slightly different (YAML frontmatter with `name` and
`description`; markdown body) but the *shape* is identical to a Copilot
agent: persona + steps + tools + output format. See the worked
`experiment-log` skill in [`.github/skills/`](../../../.github/skills/).

1. Make `.github/skills/<your-skill-name>/` at the repo root.
2. Create `SKILL.md` with `---\nname: <your-skill-name>\ndescription: <one line>\n---` frontmatter, then paste the body from your agent.
3. Reload the window; ask for it in plain language (or `/`-invoke it) in Copilot Chat.

Same handful of fields, different file path. That's the "primitives are
just structured prompts" claim from Block 1, made concrete.

### Stretch B — Chain two agents with a Copilot prompt file

Agents are good for one-job interactions. **Prompt files**
(`.github/prompts/*.prompt.md`) are good for one-shot orchestrations
("review this, then fix what you found"). The `.github/prompts/` folder
already has a few worked commands to copy from.

1. Create `.github/prompts/review-and-fix.prompt.md`.
2. Write a body like: *"First, review `${input:file}` against Scientific Python guidelines. Then add the missing docstrings."*
3. Invoke from chat with `/review-and-fix file=path/to/code.py`.

This is what the Block 3 workflow prompt files are doing under the hood:
slash commands, each a templated prompt, that you run in sequence.

### Stretch C — Sketch an MCP server stub for a new tool

Agents use existing tools (`read`, `edit/editFiles`, etc.). To give
your agent a *new* tool (e.g., "summarize results from this MLflow run",
"query our internal experiment DB"), you write an **MCP server**.

You won't ship a real one in 15 minutes, but you can sketch the
interface. In a scratch file, write:

```
Tool name: summarize_experiment
Inputs: { run_dir: string }
Outputs: { metrics: {...}, best_checkpoint: string, summary_md: string }
What it does (1-2 sentences): ...
```

Bring it to office hours; instructors can help wire it up against the
[MCP SDK](https://modelcontextprotocol.io). Especially useful for
**experiment management** workflows — wrap your run tracker, give the
agent a real tool, stop pasting metrics into chat.

## 8. Show it off

If your agent works and you have a few minutes left, share it:
- Volunteer for the show-and-tell (instructor will ask).
- Paste the agent into the workshop chat / Slack / wherever.
- Save it to your own GitHub fork to keep using after the workshop.

## Troubleshooting

| Symptom | Fix |
|---|---|
| Agent doesn't appear in the picker | Confirm filename ends in `.agent.md` and lives in `.github/agents/`. Click the picker, then "Configure Custom Agents", or run **Developer: Reload Window**. |
| Agent appears but won't load | Check the YAML frontmatter, common issues are missing quotes around the description or a malformed `tools` list. The first two lines should be `---` exactly. |
| Agent runs but ignores your prompt rules | The system prompt is too vague. Make the numbered steps more specific. Add a "do NOT" line for behaviors you've seen go wrong. |
| Agent tries to edit files but isn't allowed | Add `'edit/editFiles'` to the `tools` list in frontmatter. |
| Agent runs forever | Add a max-iterations note in the system prompt: *"After at most 5 tool calls, summarize what you've done and stop."* |

If something else breaks, ask an instructor, that's exactly what they're
circulating for.
