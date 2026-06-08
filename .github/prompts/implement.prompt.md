---
agent: agent
description: 'Execute an approved plan phase by phase, verifying as you go, then write an implementation report to docs/rse/specs/.'
tools: ['read', 'edit/editFiles', 'search/codebase', 'search', 'execute/runInTerminal']
---

Use the `implementing-plans` skill to handle this request.

Plan to implement: ${input:plan:path to the plan, e.g. docs/rse/specs/plan-vscm-package.md}

If nothing was provided, enter the skill's Collaborative mode and ask what is needed before proceeding.
