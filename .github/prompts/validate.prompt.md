---
agent: agent
description: 'Systematically verify an implementation against its plan and report pass/fail with evidence.'
tools: ['read', 'search/codebase', 'search', 'execute/runInTerminal', 'edit/editFiles']
---

# Validate (phase 4 of the research loop)

Verify that an implementation actually matches its plan. This is the quality
gate: without it, you are trusting the agent's "Done!" message.

Plan to validate against: `${input:plan:path to the plan, e.g. .agents/plan-vscm-package.md}`.
If blank, search `.agents/` for `plan-*.md` / `implement-*.md` and ask which to use.

## Process

1. **Read the plan completely.** Note every phase and every success criterion.
2. **Gather evidence** of what was actually done: inspect the changed files; if
   useful, run `git log --oneline -n 10` and `git diff --stat`.
3. **Run every Automated Verification command** from the plan and record the real
   result (don't assume):
    - ✅ PASS — command succeeded, output as expected
    - ❌ FAIL — command failed; capture the error and find the root cause
4. **Read the code against the spec.** Don't trust checkmarks — confirm the
   claimed changes are actually present and match the plan.
5. **List the Manual Verification items** the human still needs to test.
6. **Write the artifact** to `.agents/validate-<slug>.md` (derive `<slug>` from
   the plan filename, e.g. `plan-vscm-package.md` → `validate-vscm-package.md`).
   Use the structure below.
7. **Present** a short summary in chat (overall status + any failures) and link
   to the written artifact.

## Artifact structure (`.agents/validate-<slug>.md`)

```
# Validation: <goal>

Plan: [plan-<slug>.md](plan-<slug>.md)

## Overall: ✅ Ready | ⚠️ Issues found | ❌ Incomplete

## Per-phase status
- Phase 1 <name>: ✅ / ⚠️ / ❌  — <note>

## Automated verification
- ✅ `uv run pytest -q` — N passed
- ❌ `<cmd>` — <error + root cause + file:line>

## Deviations from plan
<what differs from the spec, with assessment — or "matches plan">

## Manual testing still required
- [ ] <item>

## Recommendations
- Critical (before ship): ...
- Nice to have: ...
```

## Constraints

- **Actually run the checks.** Validation is systematic, not a vibe check.
- Be objective: report what is, not what you hoped. Document failures even when
  inconvenient.
- **Read-only on source.** The _only_ file you create is the validation artifact
  in `.agents/`. Do not fix issues here — report them. If the user wants fixes,
  that's a new `/implement` (or a plan update). Re-run `/validate` after fixes.
