# creds -- load secrets from 1Password into the current shell.
# Must be sourced. Usage: creds
#
# Requires op (1Password CLI) and a credentials template with op:// references.
# Default template: ~/.config/kra-ai-native/credentials.env (override with CREDS_TEMPLATE).

creds() {
  emulate -L zsh

  local template="${CREDS_TEMPLATE:-$HOME/.config/kra-ai-native/credentials.env}"

  if [[ ! -f "$template" ]]; then
    print -u2 "creds: template not found: $template"
    print -u2 "creds: set CREDS_TEMPLATE or create the file with op:// references."
    return 1
  fi

  # Authenticate with 1Password
  if [[ -z "${OP_SERVICE_ACCOUNT_TOKEN:-}" ]]; then
    print -n "Enter your 1Password service account token: "
    read -rs token
    print
    if [[ -z "$token" ]]; then
      print -u2 "creds: no token entered, aborting."
      return 1
    fi
    export OP_SERVICE_ACCOUNT_TOKEN="$token"
  fi

  if ! op whoami >/dev/null 2>&1; then
    print -u2 "creds: 1Password authentication failed. Check your service account token."
    return 1
  fi

  # Resolve secret references
  local line key ref value resolved_count=0
  local -a failures
  while IFS= read -r line; do
    [[ -z "$line" || "$line" == \#* ]] && continue
    key="${line%%=*}"
    ref="${line#*=}"
    if [[ "$key" == "$line" || -z "$key" || -z "$ref" ]]; then
      failures+=("malformed: $line")
      continue
    fi
    if [[ "$ref" == op://* ]]; then
      if ! value=$(op read "$ref" 2>/dev/null); then
        failures+=("$ref")
        continue
      fi
    else
      value="$ref"
    fi
    export "$key=$value"
    (( resolved_count++ ))
  done < "$template"

  if (( ${#failures[@]} > 0 )); then
    print -u2 "creds: failed to resolve ${#failures[@]} reference(s):"
    for f in "${failures[@]}"; do
      print -u2 "  - $f"
    done
    return 1
  fi

  # Git HTTPS auth via gh
  if [[ -n "${GH_TOKEN:-}" ]] && command -v gh >/dev/null 2>&1; then
    gh auth setup-git >/dev/null 2>&1
  fi

  # Git HTTPS auth via glab
  if [[ -n "${GITLAB_TOKEN:-}" ]] && command -v glab >/dev/null 2>&1; then
    print -r -- "$GITLAB_TOKEN" | glab auth login --hostname gitlab.com --stdin --git-protocol https >/dev/null 2>&1
  fi

  # Git identity
  if [[ -n "${GIT_AUTHOR_NAME:-}" && -n "${GIT_AUTHOR_EMAIL:-}" ]]; then
    git config --global user.name  "$GIT_AUTHOR_NAME"
    git config --global user.email "$GIT_AUTHOR_EMAIL"
  fi

  print "Credentials loaded ($resolved_count values)."
}
