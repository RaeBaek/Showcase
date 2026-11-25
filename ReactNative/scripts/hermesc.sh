#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
HERMES_COMPILER="${PODS_ROOT:?PODS_ROOT must be set}/hermes-engine/destroot/bin/hermesc"

# Keep RN's compiler arguments and use the compiler shipped with the installed Hermes Pod.
exec "$HERMES_COMPILER" "-include-globals=$SCRIPT_DIR/hermes-globals.js" "$@"
