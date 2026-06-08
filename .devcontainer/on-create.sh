#!/usr/bin/env bash
set -euo pipefail

# --- Output styling -------------------------------------------------------
# Colors are emitted unconditionally (not gated on a tty) because the
# devcontainer / Codespaces "creating container" log renders ANSI codes.
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
RED="\033[0;31m"
BOLD="\033[1m"
RESET="\033[0m"

STAGE="on-create"
TOTAL_STEPS=6

say()  { printf "%b\n==> [%s] (%s/%s) %s%b\n" "${BOLD}${GREEN}" "${STAGE}" "$1" "${TOTAL_STEPS}" "$2" "${RESET}"; }
info() { printf "      %s\n" "$1"; }
warn() { printf "%b  !   %s%b\n" "${YELLOW}" "$1" "${RESET}"; }
err()  { printf "%b  ERROR: %s%b\n" "${RED}" "$1" "${RESET}" >&2; }

say 1 "Preparing workspace"
# .venv is a Docker volume mount; on first create it may be empty and owned by
# root. Reclaim ownership for the vscode user before uv writes into it.
if [ -e .venv ]; then
  if [ ! -d .venv ] || [ -L .venv ]; then
    err "Refusing to chown .venv: must be a real directory, not a symlink"
    exit 1
  fi

  VENV_REAL="$(realpath .venv)"
  WORKSPACE_REAL="$(realpath .)"

  case "$VENV_REAL" in
    "$WORKSPACE_REAL"/*) ;;
    *)
      err "Refusing to chown .venv: resolved path '$VENV_REAL' is outside workspace '$WORKSPACE_REAL'"
      exit 1
      ;;
  esac

  sudo chown -R --no-dereference vscode:vscode "$VENV_REAL"
  info "Reclaimed ownership of .venv volume mount"
else
  info "No .venv yet — it will be created by uv in the next step"
fi

say 2 "Syncing Python environment with uv"
# `uv sync` resolves from uv.lock and installs the editable path packages
# (sci-units, workshop-agent) declared in pyproject.toml's [tool.uv.sources].
uv sync --locked

say 3 "Registering Jupyter kernel 'workshop'"
uv run python -m ipykernel install --user \
  --name workshop \
  --display-name "Workshop (Python 3.12)"

say 4 "Sanity check: Python + litellm + sci_units + workshop_agent imports"
uv run python - <<'PY'
import importlib.metadata
import sys

print(f"      python:         {sys.version.split()[0]}")
print(f"      litellm:        {importlib.metadata.version('litellm')}")

import sci_units
print(f"      sci_units:      {sci_units.__file__}")

import workshop_agent
print(f"      workshop_agent: {workshop_agent.__file__}")
PY

say 5 "Configuring shell auto-activation of .venv"
# Auto-activate the uv-managed virtualenv in every interactive shell so Python
# is the active interpreter for VS Code terminals and Copilot Chat — not just on
# PATH.
BASHRC="${HOME}/.bashrc"
HOOK_MARKER='# >>> uv venv activation (viss-agentic-ai-workshop-iss-2026) >>>'
if ! grep -qF "${HOOK_MARKER}" "${BASHRC}" 2>/dev/null; then
  {
    echo ""
    echo "${HOOK_MARKER}"
    # Only activate when not already inside this venv, to avoid stacking the
    # prompt prefix on nested shells.
    echo 'if [ -z "${VIRTUAL_ENV:-}" ] && [ -f "'"${PWD}"'/.venv/bin/activate" ]; then'
    echo '  source "'"${PWD}"'/.venv/bin/activate"'
    echo 'fi'
    echo "# <<< uv venv activation (viss-agentic-ai-workshop-iss-2026) <<<"
  } >> "${BASHRC}"
  info "Added .venv activation hook to ~/.bashrc"
else
  info "~/.bashrc already has the .venv activation hook"
fi

say 6 "Linking the research-loop demo to the repo's .github"
# The Block 3 research-loop demo is worked in as its own folder, so it needs a
# .github (prompts, instructions, skills) of its own. Symlink it to the repo-root
# .github instead of duplicating, so the demo always tracks the canonical
# prompts. Created here (not committed) because git symlinks don't survive
# checkout on every platform (e.g. Windows without core.symlinks).
DEMO_GITHUB="blocks/03-research-loop/demo/.github"
if [ -e "${DEMO_GITHUB}" ] && [ ! -L "${DEMO_GITHUB}" ]; then
  warn "Skipping symlink: ${DEMO_GITHUB} exists and is not a symlink"
elif [ ! -d "blocks/03-research-loop/demo" ]; then
  warn "Skipping symlink: blocks/03-research-loop/demo not found"
else
  # Relative target so the link resolves regardless of where the repo is mounted.
  ln -sfn ../../../.github "${DEMO_GITHUB}"
  info "Linked ${DEMO_GITHUB} -> ../../../.github"
fi

printf "%b\n==> [%s] complete — workspace is ready.%b\n" "${BOLD}${GREEN}" "${STAGE}" "${RESET}"
info "Next step: open README.md for the workshop walkthrough"
