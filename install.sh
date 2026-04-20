#!/bin/sh

set -eu

cat <<'EOF'
[DEPRECATED] install.sh is no longer supported.

Use one of the documented workflows in README.md instead:
- Local Ruby execution via Bundler
- Docker execution with a persistent /app/store volume
EOF

exit 1
