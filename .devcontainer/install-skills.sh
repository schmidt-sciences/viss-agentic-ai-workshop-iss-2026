#!/usr/bin/env bash
set -euo pipefail

# Install the uw-ssec/rse-plugins "ai-research-workflows" skills into the GitHub
# Copilot CLI (the `-a github-copilot` agent target) at container-create time.
#
# This runs as a runtime lifecycle step — not at image-build time — because the
# rse-plugins submodule that provides the plugin is only present in the mounted
# workspace, not baked into the Docker image (see install-copilot-cli.sh, which
# build-installs the CLI but no plugins). The install is best-effort: a failure
# here must not abort container creation, since the research-loop workflow also
# ships in-repo as Copilot prompt files under .github/prompts/.

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd -- "${SCRIPT_DIR}/.." && pwd)"
PLUGIN_DIR="${REPO_ROOT}/rse-plugins/plugins/ai-research-workflows"

# --- Output styling -------------------------------------------------------
# Colors are emitted unconditionally (not gated on a tty) because the
# devcontainer / Codespaces "creating container" log renders ANSI codes.
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
RED="\033[0;31m"
BOLD="\033[1m"
RESET="\033[0m"

STAGE="install-skills"
TOTAL_STEPS=2

say()   { printf "%b\n==> [%s] (%s/%s) %s%b\n" "${BOLD}${GREEN}" "${STAGE}" "$1" "${TOTAL_STEPS}" "$2" "${RESET}"; }
log()   { printf "      [%s] %s\n" "${STAGE}" "$*"; }
warn()  { printf "%b  !   [%s] %s%b\n" "${YELLOW}" "${STAGE}" "$*" "${RESET}"; }
error() { printf "%b      [%s] ERROR: %s%b\n" "${RED}" "${STAGE}" "$*" "${RESET}" >&2; }

say 1 "Locating rse-plugins ai-research-workflows plugin"
if [ ! -f "${PLUGIN_DIR}/.claude-plugin/plugin.json" ]; then
  warn "Plugin not found at ${PLUGIN_DIR}"
  warn "The rse-plugins submodule may not be checked out; attempting to initialize it..."
  if git -C "${REPO_ROOT}" submodule update --init --depth 1 rse-plugins; then
    log "Submodule initialized."
  else
    warn "Could not initialize the rse-plugins submodule."
  fi
fi

if [ ! -f "${PLUGIN_DIR}/.claude-plugin/plugin.json" ]; then
  warn "Skipping skills install — plugin still unavailable at ${PLUGIN_DIR}."
  warn "Copilot still works via the in-repo prompt files under .github/prompts/."
  exit 0
fi
log "Found plugin: ${PLUGIN_DIR}"

say 2 "Installing ai-research-workflows skills into GitHub Copilot (global)"
# `npx -y` auto-confirms the one-time fetch of the `skills` CLI so this stays
# non-interactive during the container lifecycle. `-g` installs globally for the
# user; `-a github-copilot` targets the GitHub Copilot CLI agent.
if npx -y skills add "${PLUGIN_DIR}" -g -a github-copilot; then
  log "Installed ai-research-workflows skills for github-copilot."
else
  warn "Failed to install ai-research-workflows skills (continuing)."
  warn "Retry manually with: npx skills add ${PLUGIN_DIR} -g -a github-copilot"
  exit 0
fi

printf "%b\n==> [%s] complete — ai-research-workflows skills installed.%b\n" "${BOLD}${GREEN}" "${STAGE}" "${RESET}"
