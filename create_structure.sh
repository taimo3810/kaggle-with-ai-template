#!/usr/bin/env bash

set -euo pipefail

# Resolve repository root based on this script's location.
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Directories to create.
dirs=(
  "configs"
  "data"
  "src/commons"
  "src/Solution1"
  "src/Solution2"
  "ai-src"
  "notebook"
  "logs"
)

for dir in "${dirs[@]}"; do
  mkdir -p "$ROOT/$dir"
done

printf "Project structure ensured under %s\n" "$ROOT"
