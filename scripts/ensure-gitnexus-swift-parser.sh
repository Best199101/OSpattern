#!/usr/bin/env bash
# 若全局 gitnexus 无法 require('tree-sitter-swift')，则自动执行完整修复脚本。
# 已就绪时几乎瞬时返回。设置 GITNEXUS_SKIP_SWIFT_ENSURE=1 可跳过。
set -uo pipefail

[[ "${GITNEXUS_SKIP_SWIFT_ENSURE:-}" == "1" ]] && exit 0

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
G="$(npm root -g)/gitnexus"

[[ -d "$G" ]] || exit 0

if (cd "$G" && node -e "require('tree-sitter-swift')" 2>/dev/null); then
  exit 0
fi

echo "GitNexus: Swift 解析器缺失，正在自动修复（与 npm install -g 后需补装一致）…" >&2
bash "$SCRIPT_DIR/install-gitnexus-tree-sitter-swift.sh"
