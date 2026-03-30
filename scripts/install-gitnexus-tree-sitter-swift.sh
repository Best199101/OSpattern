#!/usr/bin/env bash
# 修复全局 gitnexus 无法解析 Swift：绕过 tree-sitter-cli 的 GitHub 下载超时，
# 并满足 tree-sitter-swift 对「包内 node_modules/tree-sitter-cli」路径的要求。
# 日常可不必手跑：ensure-gitnexus-swift-parser.sh / scripts/gitnexus / gitnexus-mcp 会自动调用。
set -euo pipefail

GITNEXUS_ROOT="$(npm root -g)/gitnexus"
if [[ ! -d "$GITNEXUS_ROOT" ]]; then
  echo "未找到全局 gitnexus: $GITNEXUS_ROOT"
  echo "请先执行: npm install -g gitnexus@latest"
  exit 1
fi

case "$(uname -s)" in
  Darwin) PLATFORM_NAME="macos" ;;
  Linux) PLATFORM_NAME="linux" ;;
  *) echo "不支持的操作系统: $(uname -s)"; exit 1 ;;
esac

case "$(uname -m)" in
  arm64|aarch64) ARCH_NAME="arm64" ;;
  x86_64|amd64) ARCH_NAME="x64" ;;
  *) echo "不支持的架构: $(uname -m)"; exit 1 ;;
esac

TS_CLI_VERSION="0.23.2"
ASSET="tree-sitter-${PLATFORM_NAME}-${ARCH_NAME}.gz"
GITHUB_URL="https://github.com/tree-sitter/tree-sitter/releases/download/v${TS_CLI_VERSION}/${ASSET}"

URLS=(
  "$GITHUB_URL"
  "https://ghproxy.net/${GITHUB_URL#https://}"
  "https://mirror.ghproxy.com/${GITHUB_URL#https://}"
)

download_tree_sitter_binary() {
  local dest="$1"
  local tmpgz
  tmpgz="$(mktemp -t tree-sitter.XXXXXX.gz)"
  trap 'rm -f "$tmpgz"' RETURN
  for url in "${URLS[@]}"; do
    echo "    尝试: $url"
    if curl -fL --connect-timeout 25 --max-time 300 "$url" -o "$tmpgz" 2>/dev/null; then
      rm -f "$dest"
      gunzip -c "$tmpgz" > "$dest"
      chmod +x "$dest"
      if [[ -x "$dest" ]] && "$dest" --version >/dev/null 2>&1; then
        echo "    成功: $($dest --version 2>/dev/null | head -1)"
        return 0
      fi
    fi
    echo "    失败，换下一地址"
  done
  return 1
}

echo "==> GitNexus: $GITNEXUS_ROOT"
cd "$GITNEXUS_ROOT"

echo "==> 安装 tree-sitter-cli@${TS_CLI_VERSION}（--ignore-scripts，避免 postinstall 直连 GitHub）"
npm install "tree-sitter-cli@${TS_CLI_VERSION}" --no-save --ignore-scripts

CLI_DIR="$GITNEXUS_ROOT/node_modules/tree-sitter-cli"
EXEC="$CLI_DIR/tree-sitter"
[[ -d "$CLI_DIR" ]] || { echo "缺少 $CLI_DIR"; exit 1; }

echo "==> 下载预编译 tree-sitter 到 $EXEC"
download_tree_sitter_binary "$EXEC" || {
  echo "下载失败。可设置代理后重试: export HTTPS_PROXY=http://127.0.0.1:7890"
  exit 1
}

echo "==> 安装 tree-sitter-swift@0.6.0（--ignore-scripts，稍后手动 rebuild）"
rm -rf "$GITNEXUS_ROOT/node_modules/tree-sitter-swift"
npm install tree-sitter-swift@0.6.0 --no-save --ignore-scripts

SWIFT_DIR="$GITNEXUS_ROOT/node_modules/tree-sitter-swift"
mkdir -p "$SWIFT_DIR/node_modules"
# binding.gyp 要求「本包下」存在 node_modules/tree-sitter-cli；npm 扁平化后需补符号链接
ln -sfn "../../tree-sitter-cli" "$SWIFT_DIR/node_modules/tree-sitter-cli"

echo "==> 编译 tree-sitter-swift（需 PATH 能执行 tree-sitter）"
export PATH="$CLI_DIR:$PATH"
npm rebuild tree-sitter-swift --foreground-scripts

echo "==> 校验"
cd "$GITNEXUS_ROOT"
node -e "require('tree-sitter-swift'); console.log('tree-sitter-swift: OK')"

echo "==> 完成。在仓库根目录执行: gitnexus analyze --force"
