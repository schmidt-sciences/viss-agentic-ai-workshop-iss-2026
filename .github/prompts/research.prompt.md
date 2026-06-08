---
agent: agent
description: 'Document how a codebase or topic works today, and write the findings to .agents/.'
tools: ['read', 'search/codebase', 'search', 'search/usages', 'edit/editFiles']
---

Use the `ai-research-workflows:researching` skill to handle this request.

Topic to research (or file references / instructions): ${input:topic:what to research, e.g. "how the climate model is structured and what's missing for it to be a package"}

If nothing was provided, enter the skill's Collaborative mode and ask what is needed before proceeding.
