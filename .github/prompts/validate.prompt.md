---
agent: agent
description: 'Systematically verify an implementation against its plan and report pass/fail with evidence.'
tools: ['read', 'search/codebase', 'search', 'execute/runInTerminal', 'edit/editFiles']
---

Use the `validating-implementations` skill to handle this request.

Plan to validate against: ${input:plan:path to the plan, e.g. .agents/plan-vscm-package.md}

If nothing was provided, enter the skill's Collaborative mode and ask what is needed before proceeding.
