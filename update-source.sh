#!/usr/bin/env bash
# Refreshes source.json to the latest commit on cemu-project/Cemu's
# main branch. Requires: curl, jq, nix (with nix-command + flakes).
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

owner="cemu-project"
repo="Cemu"
branch="main"
source_file="source.json"

latest_rev=$(curl -sL "https://api.github.com/repos/${owner}/${repo}/commits/${branch}" | jq -r .sha)
current_rev=$(jq -r .rev "$source_file")

if [[ "$latest_rev" == "$current_rev" ]]; then
  echo "cemu-git already up to date (${current_rev})"
  exit 0
fi

echo "Updating cemu-git: ${current_rev} -> ${latest_rev}"

raw_hash=$(nix run nixpkgs#nix-prefetch-git -- \
  --fetch-submodules --quiet \
  --url "https://github.com/${owner}/${repo}" \
  --rev "$latest_rev" | jq -r .sha256)

sri_hash=$(nix hash convert --hash-algo sha256 --to sri "$raw_hash")

jq -n --arg rev "$latest_rev" --arg hash "$sri_hash" '{rev: $rev, hash: $hash}' > "$source_file"

echo "Wrote ${source_file}:"
cat "$source_file"
