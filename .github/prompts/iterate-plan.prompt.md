---
agent: agent
description: 'Refine an existing plan in docs/rse/specs/ with surgical edits based on feedback.'
tools: ['read', 'search/codebase', 'search', 'search/usages', 'edit/editFiles']
---

Use the `iterating-plans` skill to handle this request.

Plan + changes: ${input:request:plan path and what to change, e.g. "docs/rse/specs/plan-vscm-package.md split the CLI phase into two"}

If nothing was provided, enter the skill's Collaborative mode and ask what is needed before proceeding.
