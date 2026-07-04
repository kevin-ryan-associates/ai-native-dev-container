# Secrets Management

The container ships with the 1Password CLI (`op`) and GitHub CLI (`gh`) pre-installed. No credentials are forwarded from the host — secrets are sourced from 1Password inside the container.

## Setup (one-time)

1. In 1Password, create a vault named **DevContainer**.
2. Create the following items in that vault:

   | Item | Fields | Purpose |
   |------|--------|---------|
   | `git` | `username`, `email` | Git commit identity |
   | `github` | `token` (PAT with `repo`, `read:org`, `workflow` scopes) | `gh` CLI + git HTTPS auth |
   | `gitlab` | `token` (PAT with `api`, `write_repository` scopes) | `glab` CLI + git HTTPS auth |
   | `opencode-zen` | `api-key` (from [opencode.ai/auth](https://opencode.ai/auth)) | OpenCode Zen inference |

3. Create a 1Password **service account** scoped to the DevContainer vault (read access). Save the token — you'll paste it into `creds` each session.

## Loading credentials

```bash
creds
```

This prompts for your 1Password service account token (hidden input), then resolves all `op://` references from `~/.config/ainative/credentials.env` into your shell environment:

- `GIT_AUTHOR_NAME` / `GIT_AUTHOR_EMAIL` → `git config --global user.name/email`
- `GH_TOKEN` → `gh` CLI + `gh auth setup-git` (wires git HTTPS auth)
- `GITLAB_TOKEN` → `glab` CLI + git credential helper (wires git HTTPS auth)
- `OPENCODE_API_KEY` → OpenCode Zen inference

The template at `~/.config/ainative/credentials.env` uses `op://DevContainer/...` references. Override the path with the `CREDS_TEMPLATE` environment variable if your vault or item names differ.
