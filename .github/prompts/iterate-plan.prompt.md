---
agent: agent
description: 'Refine an existing plan in .agents/ with surgical edits based on feedback.'
tools: ['read', 'search/codebase', 'search', 'search/usages', 'edit/editFiles']
---

Use the `iterating-plans` skill to handle this request.

Plan + changes: ${input:request:plan path and what to change, e.g. ".agents/plan-vscm-package.md split the CLI phase into two"}

If nothing was provided, enter the skill's Collaborative mode and ask what is needed before proceeding.
