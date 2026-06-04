# Base image intentionally uses "base" (not python) because the Python
# interpreter and all dependencies are managed via uv, not system Python.
FROM mcr.microsoft.com/devcontainers/base:dev-ubuntu26.04

# Use bash for RUN so pipefail is supported.
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# curl, git, jq, tar, and ca-certificates are provided by the
# mcr.microsoft.com/devcontainers/base image. Homebrew on Linux additionally
# requires a C toolchain (build-essential), procps, and file, so install those
# here. This runs as root, before the switch to the vscode user below.
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        procps \
        file \
    && rm -rf /var/lib/apt/lists/*

# Install uv from the official, version-pinned uv image. The astral-sh/uv image
# ships statically-linked `uv`/`uvx` binaries, so copying them in is both
# reproducible (pinned tag) and avoids a curl|sh bootstrap.
COPY --from=ghcr.io/astral-sh/uv:0.6.14 /uv /uvx /usr/local/bin/

# /home/linuxbrew/.linuxbrew/{bin,sbin} is the default Homebrew-on-Linux prefix.
# Putting it on PATH at the image level makes `brew` (and brew-installed tools
# such as `node`) available to non-interactive lifecycle scripts and the later
# build-time RUN steps, independent of the interactive `brew shellenv` hook.
ENV VSCODE_HOME=/home/vscode \
    VSCODE_USER=vscode \
    SHELL=/bin/bash \
    PATH=/home/vscode/.local/bin:/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:${PATH}

USER ${VSCODE_USER}
WORKDIR /workspaces/viss-agentic-ai-workshop-iss-2026

RUN echo 'eval "$(uv generate-shell-completion bash)"' >> ${VSCODE_HOME}/.bashrc

# Install Homebrew (Linuxbrew) and use it to provide Node.js. Homebrew refuses to
# run as root, so this runs as the vscode user (which has passwordless sudo).
# NONINTERACTIVE=1 skips the install script's confirmation prompt during the
# image build, and the brew shellenv hook makes brew available in interactive
# shells (the build-time PATH is already set in the ENV block above).
RUN NONINTERACTIVE=1 /bin/bash -c \
      "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" \
    && echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ${VSCODE_HOME}/.bashrc

# Install Node.js via Homebrew. brew is on PATH (see the ENV block), so this
# resolves the prebuilt `node` bottle rather than building from source.
RUN brew install node@24

# Pre-install the GitHub Copilot CLI during the image build so the devcontainer
# is ready on attach. No agent plugins are installed: the research-loop workflow
# ships in-repo as Copilot prompt files under .github/prompts/.
COPY --chown=${VSCODE_USER}:${VSCODE_USER} .devcontainer/install-copilot-cli.sh /tmp/install-copilot-cli.sh
RUN bash /tmp/install-copilot-cli.sh && rm -f /tmp/install-copilot-cli.sh

# Pre-populate uv's package cache (and its managed CPython) so that
# onCreateCommand's `uv sync` resolves from disk instead of hitting the network.
# The editable path dependencies (sci-units, workshop-agent) are copied in as
# well because `uv sync --locked` validates the lock against them; without their
# sources present uv reports the lock as out-of-date and fails. The temporary
# .venv is discarded because the real one is created inside the Docker volume
# mount at container-create time.
COPY --chown=${VSCODE_USER}:${VSCODE_USER} pyproject.toml uv.lock README.md /tmp/uv-warmup/
COPY --chown=${VSCODE_USER}:${VSCODE_USER} blocks/01-landscape/demo/starter /tmp/uv-warmup/blocks/01-landscape/demo/starter
COPY --chown=${VSCODE_USER}:${VSCODE_USER} workshop_agent /tmp/uv-warmup/workshop_agent
RUN cd /tmp/uv-warmup \
    && uv sync --locked \
    && rm -rf /tmp/uv-warmup

# Pre-download and verify the OAI-compatible Copilot VSIX so that
# postCreateCommand can skip the network fetch on first container create.
COPY --chown=${VSCODE_USER}:${VSCODE_USER} .devcontainer/oai-compatible-copilot-vsix.env /tmp/oai-compatible-copilot-vsix.env
COPY --chown=${VSCODE_USER}:${VSCODE_USER} .devcontainer/post-create.sh /tmp/post-create.sh
RUN bash /tmp/post-create.sh \
    && rm -f /tmp/post-create.sh /tmp/oai-compatible-copilot-vsix.env
