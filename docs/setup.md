# Workshop Setup

Everything you need to do **before** the workshop, plus what to expect when you open your environment.

## Pre-workshop checklist

- [ ] Send your GitHub handle to the workshop coordinator so you can be added to the [`2026-viss-ai-workshop-participants`](https://github.com/orgs/schmidt-sciences/teams/2026-viss-ai-workshop-participants) team. Without this, GitHub Codespaces won't have an organization-paid allocation for you.
- [ ] Sign in to [github.com](https://github.com) and confirm you can see this repository.
- [ ] Open this repo and click **Code → Create codespace on main** to verify the Codespace builds successfully (you can stop it immediately afterward, you don't have to use it again until the workshop).
- [ ] (Optional) Install [VSCode](https://code.visualstudio.com/) locally if you'd prefer running Codespaces in the desktop client instead of the browser. Both work.
- [ ] Use a Chromium-based browser (Chrome, Edge, Arc, Brave) for the best Codespaces experience.

## What the Codespace gives you

The Codespace is configured by the scripts in [`.devcontainer/`](../.devcontainer/), which run in stages — when the image is built, when the container is created, when it starts, and when VS Code attaches.

**At image-build time** the container pre-installs:

- Python 3.12 and [`uv`](https://docs.astral.sh/uv/), with the workshop's dependency cache warmed.
- The **GitHub Copilot CLI** (BYOK against the same gateway). No agent plugins are installed — Block 3's research loop (`/research`, `/plan`, `/iterate-plan`, `/experiment`, `/implement`, `/validate`, `/handoff`) ships **in-repo** as Copilot prompt files in [`.github/prompts/`](../.github/prompts/) and runs in **Copilot Chat**.
- The pinned **OAI-compatible Copilot** extension VSIX (downloaded and SHA256-verified against `.devcontainer/oai-compatible-copilot-vsix.env`).

**When the container is created/started**, the lifecycle scripts:

1. Run `uv sync` to install the workshop's Python dependencies (including the `sci_units` and `workshop_agent` packages as path sources). — `on-create.sh`
2. Register a Jupyter kernel called `Workshop (Python 3.12)`. — `on-create.sh`
3. Run a sanity check confirming `litellm`, `sci_units`, and `workshop_agent` import. — `on-create.sh`
4. Report whether the workshop's gateway credentials are visible. — `post-start.sh`
5. Install the **OAI-compatible Copilot** extension into VS Code so Copilot Chat is ready on launch. — `install-vsix.sh` (post-attach)

Each script prints green `==> ... complete` lines as it runs. The last one you'll see reads:

```
==> [post-attach] complete — Copilot extension is installed.
```

If a stage didn't finish, re-run the workspace setup manually with:

```bash
bash .devcontainer/on-create.sh
```

or rebuild the container from the command palette (**Codespaces: Rebuild Container**).

## Where the agent customizations live

Everything the workshop ships is **visible at the repo root** — no generated or
symlinked folders to browse. Open [`.github/`](../.github/) in the Explorer:

- [`.github/prompts/`](../.github/prompts/) — slash-command prompt files, including Block 3's research loop (`/research`, `/plan`, `/iterate-plan`, `/experiment`, `/implement`, `/validate`, `/handoff`).
- [`.github/agents/`](../.github/agents/) — custom agents (Block 4 worked examples).
- [`.github/skills/`](../.github/skills/) — skills that bundle a helper script.
- [`.github/instructions/`](../.github/instructions/) — path-scoped conventions.

See the [customization gallery in the root README](../README.md#copilot-customization-gallery) for the full gallery.

## Gateway credentials

The workshop runs an **LLM gateway** (LiteLLM / LLMoxie) that gives participants access to Claude — currently **Claude Sonnet 4.6** and **Claude Haiku 4.5** — and potentially other models (GPT, Gemini, ...) behind the same endpoint. Copilot Chat, the Copilot CLI, and the **"agent in 50 lines" notebook** all talk to this one gateway.

You provide two values as **Codespace user secrets**:

| Secret | What it is |
|---|---|
| `LITELLM_API_KEY` | API key for the gateway (provided to you for the workshop) |
| `LITELLM_BASE_URL` | Base URL of the gateway, e.g. `https://litellm.example.org` (provided to you for the workshop) |

To add them:

1. Go to your GitHub profile -> **Settings -> Codespaces -> Codespaces secrets -> New secret**.
2. Add `LITELLM_API_KEY` and `LITELLM_BASE_URL` with the values you were given.
3. Scope each secret to this repository (`viss-agentic-ai-workshop-iss-2026`).
4. Rebuild or restart the Codespace so the new secrets are injected.

You only set those two secrets; `devcontainer.json` and the lifecycle scripts fan them out to every tool for you:

- **Copilot Chat** (the OAI-compatible extension) reads `LITELLM_BASE_URL` plus `OAI_API_KEY` (aliased from `LITELLM_API_KEY`).
- **Copilot CLI** reads `COPILOT_PROVIDER_BASE_URL` / `COPILOT_PROVIDER_API_KEY` (also aliased from the same two secrets).
- **The notebooks** wire `litellm` to the gateway in their setup cell.

The instructors will walk you through this live at the start of the workshop if you haven't done it yet.

To verify your credentials work:

```bash
uv run python -c "
import os, litellm
litellm.api_base = os.environ['LITELLM_BASE_URL']
litellm.api_key = os.environ['LITELLM_API_KEY']
print(litellm.completion(model='claude-sonnet-4-6', max_tokens=16,
    messages=[{'role':'user','content':'ping'}]).choices[0].message.content)
"
```

You should see Claude reply (typically `pong` or similar). If the model alias is wrong, you'll get a clear error naming the available aliases.

## Running things outside Codespaces (advanced)

If you'd rather run locally:

1. Install [`uv`](https://docs.astral.sh/uv/) and Python 3.12.
2. Clone this repo.
3. Run `uv sync`, then `bash .devcontainer/on-create.sh` to register the Jupyter kernel and run the sanity check.
4. Export `LITELLM_API_KEY` and `LITELLM_BASE_URL` in your shell.
5. Use any editor you like; if it's VSCode, install the `ms-toolsai.jupyter` extension. The workshop's OAI-compatible Copilot extension and pre-installed CLIs are only wired up automatically inside the Codespace, so you'd configure those yourself locally.

## Troubleshooting

| Symptom | Fix |
|---|---|
| `post-start.sh` warns `LITELLM_BASE_URL is not set` / `LITELLM_API_KEY is not set` | Add `LITELLM_API_KEY` and `LITELLM_BASE_URL` Codespace secrets and rebuild/restart the Codespace. See above. |
| `litellm.completion(...)` raises `AuthenticationError` / 401 | `LITELLM_API_KEY` is wrong or expired. Double-check the value in your Codespace secrets. |
| `litellm.completion(...)` raises `BadRequestError` / "model not found" | The model alias on the gateway doesn't match. Update the `MODEL` constant at the top of the notebook (ask an instructor for the correct alias). |
| `litellm.completion(...)` hangs or `ConnectionError` | `LITELLM_BASE_URL` is wrong or unreachable. `echo $LITELLM_BASE_URL` in the terminal to confirm. |
| Jupyter kernel `Workshop (Python 3.12)` doesn't appear | Run `uv run python -m ipykernel install --user --name workshop --display-name "Workshop (Python 3.12)"` and reload the window. |
| Copilot Chat doesn't respond | Confirm the **OAI-compatible Copilot** extension is installed and the workshop models appear in the model picker. If not, check that `LITELLM_BASE_URL` / `LITELLM_API_KEY` secrets are set and rebuild the Codespace (the extension reads them at startup). |
| `uv sync` fails | Delete `.venv/` and re-run. If still failing, paste the error in the workshop chat. |
| `pytest` complains about missing `sci_units` | Re-run `uv sync` from the repo root, `sci_units` is declared as a path source in `pyproject.toml`. |

## Day-of contacts

- **Anshul Tambay**: [anshul37@uw.edu](mailto:anshul37@uw.edu)
- **Tina Dang**: [tdang@schmidtsciences.org](mailto:tdang@schmidtsciences.org)
