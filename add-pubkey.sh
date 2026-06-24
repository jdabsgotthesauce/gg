#!/bin/bash
# add-pubkey.sh — Register a new SSH public key on this server
# Usage: paste a public key as the single argument, in quotes
#   ./add-pubkey.sh "ssh-ed25519 AAAA... some-label"
# Or run with no args and paste interactively when prompted.

set -e

AUTH_FILE="$HOME/.ssh/authorized_keys"
mkdir -p "$HOME/.ssh" && chmod 700 "$HOME/.ssh"
touch "$AUTH_FILE" && chmod 600 "$AUTH_FILE"

if [ -n "$1" ]; then
  NEW_KEY="$1"
else
  echo "Paste the public key (single line) and press Enter:"
  read -r NEW_KEY
fi

# Basic sanity check: must start with a known key type
if ! echo "$NEW_KEY" | grep -qE "^(ssh-ed25519|ssh-rsa|ecdsa-sha2-)"; then
  echo "ERROR: that doesn't look like a valid public key (expected ssh-ed25519 / ssh-rsa / ecdsa-sha2-...)."
  exit 1
fi

if grep -qF "$NEW_KEY" "$AUTH_FILE"; then
  echo "Key already present, skipping."
else
  echo "$NEW_KEY" >> "$AUTH_FILE"
  echo "Key added successfully."
fi

echo ""
echo "=== Current authorized_keys (labels only) ==="
awk '{if (NF>2) print $NF; else print "(no label)"}' "$AUTH_FILE"
