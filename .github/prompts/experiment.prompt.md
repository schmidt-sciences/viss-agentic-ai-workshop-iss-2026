---
agent: agent
description: 'Compare 2-3 approaches with real prototype code and write an evidence-based recommendation to .agents/.'
tools: ['read', 'edit/editFiles', 'search/codebase', 'search', 'execute/runInTerminal']
---

Use the `running-experiments` skill to handle this request.

What to compare: ${input:question:the decision to resolve, e.g. "argparse vs click for the vscm CLI"}

If nothing was provided, enter the skill's Collaborative mode and ask what is needed before proceeding.
