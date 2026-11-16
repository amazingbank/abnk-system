#!/usr/bin/env bash
# check-bilingual.sh —— ABNK 三合一防回潮门（注释双语 + front-matter + 凭据扫描）
# Three-in-one regression gate for ABNK: bilingual comments, front-matter, credentials.
#
# 用法：
#   ./check-bilingual.sh [--help] [<目录|文件>...] \
#       [--frontmatter <workspace路径>] [--credentials <evidence路径>]
#
# 模式（可组合，至少一种；任一模式违规 > 0 → exit 1）：
#   默认（位置参数 = 目录/文件）注释双语门禁：目标源码中含 CJK 的注释必须有英文配对。
#       判据口径（与 Part03 任务 6.1 审计矩阵一致，按注释块判定）：
#       形态 A = 同行 `中文 | English`；形态 B = 中文注释行在上、英文语义重写行紧随；
#       行内 noqa-bilingual 豁免；两形态均合法，缺配对即违规。
#   --frontmatter <workspace路径>  front-matter 门禁：校验创作 md（排除 artifacts/ 与
#       modelB/——与 Phase 5 注入脚本同口径）首行 `---`、YAML 可解析、三 profile 必填
#       字段（sprint-doc: sprint/part/status/date/locale；planning-doc: section/status/
#       locale；release-note: version/date/locale）。
#   --credentials <evidence路径>   凭据门禁（ADR-010 衍生约束 2/5）：口令/token/密钥
#       字面量、GitHub PAT、JWT 字面量、私钥块、密钥形态文件、公网 IP 字面量（IP 为抽检
#       口径：版本号上下文豁免）；`.github-private` 路径引用合法——内容泄漏由字面量模式
#       拦截。
# 输出：markdown 违规表（文件:行号:内容）+ 违规总数
# 退出码：0 = 通过；1 = 存在违规；2 = 用法/目标错误
#
# Usage:
#   ./check-bilingual.sh [--help] [<dir|file>...] \
#       [--frontmatter <workspace-dir>] [--credentials <evidence-path>]
#
# Modes (combinable, at least one; any violation > 0 → exit 1):
#   default (positional targets) — bilingual comment gate: every CJK comment in
#       the targets must have an English pairing, judged per comment block
#       (form A = `Chinese | English` on one line, form B = English line right
#       below the Chinese line; inline noqa-bilingual exemption).
#   --frontmatter — structural gate on authored markdown (artifacts/ and
#       modelB/ excluded): leading `---`, parseable YAML, profile-required
#       fields for sprint-doc / planning-doc / release-note.
#   --credentials — ADR-010 credential gate: password/token/key literals,
#       GitHub PAT and JWT shapes, private key blocks, key-shaped files and
#       public IP literals (spot-check basis, version-context exempt).
# Output: markdown violation table (file:lineno:content) plus violation totals.
# Exit codes: 0 = pass, 1 = violations found, 2 = usage error.
set -euo pipefail

# ---------------------------------------------------------------- 用法 | usage

usage() {
  cat <<'EOF'
用法: ./check-bilingual.sh [--help] [<目录|文件>...]
       [--frontmatter <workspace路径>] [--credentials <evidence路径>]

模式（可组合，至少一种；违规 > 0 → exit 1）:
  默认             注释双语门禁：含 CJK 的注释须有英文配对（同行 `中文 | English`，
                   或中文行在上、英文语义重写行紧随；行内 noqa-bilingual 豁免）
  --frontmatter    front-matter 门禁：创作 md（排除 artifacts/ 与 modelB/）首行 ---、
                   YAML 可解析、三 profile 必填字段
  --credentials    凭据门禁（ADR-010）：口令/token/密钥字面量、PAT/JWT、私钥块、
                   密钥形态文件、公网 IP（版本上下文豁免）；.github-private
                   路径引用合法、内容泄漏违规

退出码: 0 = 通过；1 = 存在违规；2 = 用法/目标错误
EOF
}

# ---------------------------------------------------------------- 参数解析 | args

MODE_DEF=0
MODE_FM=0
MODE_CRED=0
FM_TARGET=""
CRED_TARGET=""
DEFAULT_TARGETS=()

while [ $# -gt 0 ]; do
  case "$1" in
    --help|-h)
      usage
      exit 0
      ;;
    --frontmatter)
      if [ $# -lt 2 ]; then
        echo "错误：--frontmatter 需要一个路径参数 / --frontmatter requires a path" >&2
        exit 2
      fi
      MODE_FM=1
      FM_TARGET="$2"
      shift 2
      ;;
    --credentials)
      if [ $# -lt 2 ]; then
        echo "错误：--credentials 需要一个路径参数 / --credentials requires a path" >&2
        exit 2
      fi
      MODE_CRED=1
      CRED_TARGET="$2"
      shift 2
      ;;
    -*)
      echo "错误：未知选项 / unknown option: $1" >&2
      usage >&2
      exit 2
      ;;
    *)
      MODE_DEF=1
      DEFAULT_TARGETS+=("$1")
      shift
      ;;
  esac
done

if [ "$MODE_DEF" -eq 0 ] && [ "$MODE_FM" -eq 0 ] && [ "$MODE_CRED" -eq 0 ]; then
  echo "错误：至少指定一种检查模式 / at least one mode is required" >&2
  usage >&2
  exit 2
fi

# 目标存在性前置校验（避免扫到一半才失败）
# Validate targets up front (fail fast instead of mid-scan).
for t in "${DEFAULT_TARGETS[@]:-}"; do
  if [ -n "$t" ] && [ ! -e "$t" ]; then
    echo "错误：目标不存在 / target not found: $t" >&2
    exit 2
  fi
done
if [ "$MODE_FM" -eq 1 ] && [ ! -d "$FM_TARGET" ]; then
  echo "错误：--frontmatter 需要 workspace 目录 / --frontmatter requires a directory" >&2
  exit 2
fi
if [ "$MODE_CRED" -eq 1 ] && [ ! -e "$CRED_TARGET" ]; then
  echo "错误：--credentials 目标不存在 / --credentials target not found: $CRED_TARGET" >&2
  exit 2
fi

# ---------------------------------------------------------------- 工作区 | workspace

WORK=$(mktemp -d "${TMPDIR:-/tmp}/check-bilingual.XXXXXX")
trap 'rm -rf "$WORK"' EXIT
RES_DEF="$WORK/def.tsv"    # 默认模式违规输出 / default-mode violations
RES_FM="$WORK/fm.tsv"     # front-matter 模式违规 / front-matter violations
RES_CRED="$WORK/cred.tsv" # 凭据模式违规 / credentials violations
LOG_DEF="$WORK/def-files.log"
LOG_FM="$WORK/fm-files.log"
INFO_SPOT_IPS=""
INFO_GHPRIV_COUNT=0

# 凭据/引用扫描的统一排除（构建产物与运行时物料不入扫描面）
# Shared exclusions for scans (build products and runtime dirs are out of scope).
GREP_EXCLUDES=(--exclude-dir=.git --exclude-dir=node_modules --exclude-dir=dist
  --exclude-dir=build --exclude-dir=out --exclude-dir=target --exclude-dir=.gradle
  --exclude-dir=.dart_tool --exclude-dir=.playwright-cli)

# ---------------------------------------------------------------- 默认模式：注释双语 | mode 1: bilingual comments

# 注释行分类器：C = 含 CJK，E = 无 CJK 但含字母，N = 两者皆无（空注释/块标记等）
# Line classifier: C = has CJK, E = letters without CJK, N = neither (markers).
classify_stream() {
  # 输入：grep -n 的 `行号:内容` 全量注释行；输出：`行号<TAB>类<TAB>内容`
  # Input: grep -n "lineno:content" for comment lines; output: "lineno<TAB>class<TAB>content".
  awk -F':' -v k="$1" '{print $1 "\t" k "\t" substr($0, length($1)+2)}'
}

# 块级配对判定 awk 程序（与任务 6.1 审计脚本 .audit-pairing.py 同口径）
# Block-level pairing program (same semantics as the task 6.1 audit tool).
AWK_PAIR='
BEGIN { size = 0 }
{
  n = $1 + 0
  cls = $2
  content = $0
  sub(/^[^\t]*\t[^\t]*\t/, "", content)
  if (size > 0 && n != prev + 1) { evaluate() }
  size++
  ln[size] = n
  cl[size] = cls
  ct[size] = content
  prev = n
}
END { if (size > 0) { evaluate() } }
function exempt(s) { return (s ~ /noqa-bilingual/ || s ~ /\|[ \t]*[A-Za-z]/) }
function evaluate(   i, nc, lastcjk, all_exempt, hasen, maxen) {
  if (size == 0) { return }
  nc = 0; lastcjk = 0; all_exempt = 1
  for (i = 1; i <= size; i++) {
    if (cl[i] == "C") {
      nc++
      if (ln[i] > lastcjk) { lastcjk = ln[i] }
      if (!exempt(ct[i])) { all_exempt = 0 }
    }
  }
  if (nc > 0 && !all_exempt) {
    hasen = 0; maxen = 0
    for (i = 1; i <= size; i++) {
      if (cl[i] == "E") { hasen = 1; if (ln[i] > maxen) { maxen = ln[i] } }
    }
    if (!hasen || maxen <= lastcjk) {
      for (i = 1; i <= size; i++) {
        if (cl[i] == "C" && !exempt(ct[i])) {
          print file "\t" ln[i] "\t" ct[i]
        }
      }
    }
  }
  size = 0
}
'

# 注释形态识别（与审计口径一致）：`//`、`///`、`/*`、`/**`、`*`、`*/`、`#`
# Comment shapes (audit-compatible): `//`, `///`, `/*`, `/**`, `*`, `*/`, `#`.
COMMENT_RE='^[[:space:]]*(//+|/\*+|\*+|#)'

scan_one_file() {
  local f="$1"
  printf '%s\n' "$f" >> "$LOG_DEF"
  local all
  all=$(grep -nE "$COMMENT_RE" "$f" 2>/dev/null || true)
  if [ -z "$all" ]; then
    return 0
  fi
  {
    printf '%s\n' "$all" | grep -E '[一-龥]' | classify_stream C || true
    printf '%s\n' "$all" | grep -vE '[一-龥]' | grep -E '[A-Za-z]' | classify_stream E || true
    printf '%s\n' "$all" | grep -vE '[一-龥]' | grep -vE '[A-Za-z]' | classify_stream N || true
  } | sort -n | awk -F'\t' -v file="$f" "$AWK_PAIR" >> "$RES_DEF" || true
}

# 目录遍历的源码扩展名白名单（md 不入默认模式——标题 `#` 非注释）
# Extension allowlist for directory traversal (md excluded: `#` headings are not comments).
is_source_file() {
  case "$1" in
    *.ts|*.tsx|*.js|*.jsx|*.mjs|*.cjs|*.java|*.kt|*.kts|*.swift|*.dart|*.py|*.rb|\
    *.go|*.rs|*.c|*.h|*.cpp|*.hpp|*.sh|*.bash|*.zsh|*.yaml|*.yml|*.toml|\
    *.properties|*.gradle|*.sql|*.xml|*.json|*.arb|*.cfg|*.conf|*.ini|*.env|\
    Dockerfile*|Jenkinsfile|Makefile)
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

run_default() {
  local t f
  for t in "$@"; do
    if [ -f "$t" ]; then
      # 显式文件不设扩展名过滤——清单语义，调用方负责范围
      # Explicit files bypass the extension filter: list semantics, caller owns scope.
      scan_one_file "$t"
    else
      find "$t" -type d \( -name .git -o -name node_modules -o -name build \
        -o -name dist -o -name out -o -name target -o -name .gradle \
        -o -name .dart_tool \) -prune -o -type f -print \
      | while IFS= read -r f; do
          if is_source_file "$f"; then
            scan_one_file "$f"
          fi
        done
    fi
  done
}

# ---------------------------------------------------------------- front-matter 模式 | mode 2: front-matter

# 路由规则与 Phase 5 注入脚本 add-frontmatter.py 同口径
# Routing mirrors the Phase 5 injector add-frontmatter.py.
route_profile() {
  case "$1" in
    docs/README.md)                     echo "planning-doc" ;;
    docs/Sprints/v*/part*/*)             echo "sprint-doc" ;;
    sre/ReleaseNotes/*)                  echo "release-note" ;;
    docs/planning/abnk-design/*)         echo "planning-doc" ;;
    *)                                   echo "UNROUTED" ;;
  esac
}

required_of() {
  case "$1" in
    sprint-doc)    echo "sprint part status date locale" ;;
    planning-doc)  echo "section status locale" ;;
    release-note)  echo "version date locale" ;;
  esac
}

check_fm_file() {
  local f="$1" rel="$2" profile="$3"
  printf '%s\n' "$rel" >> "$LOG_FM"
  if [ "$profile" = "UNROUTED" ]; then
    printf '%s\t1\tUNROUTED：路径不在三 profile 路由面内（front-matter 结构无从校验）\n' "$rel" >> "$RES_FM"
    return 0
  fi
  local firstline
  firstline=$(head -n 1 "$f")
  if [ "$firstline" != "---" ]; then
    printf '%s\t1\tNO_FRONTMATTER：首行非 ---（缺结构化元数据头）\n' "$rel" >> "$RES_FM"
    return 0
  fi
  local i=0 closed=0 line key val found=""
  {
    IFS= read -r firstline
    while IFS= read -r line; do
      i=$((i + 1))
      if [ "$i" -gt 50 ]; then
        break
      fi
      if [ "$line" = "---" ]; then
        closed=1
        break
      fi
      case "$line" in
        ""|"#"*)
          # 空行与 YAML 注释行合法
          # Blank lines and YAML comments are fine.
          ;;
        [[:space:]]*)
          # 缩进续行合法
          # Indented continuation lines are fine.
          ;;
        *)
          key=${line%%:*}
          val=${line#*:}
          if [[ "$key" =~ ^[A-Za-z_-]+$ ]] && [ "$key" != "$line" ]; then
            val=${val#"${val%%[![:space:]]*}"}
            if [ -n "$val" ]; then
              found="$found $key"
            fi
          else
            printf '%s\t%d\tYAML_PARSE：无法解析的元数据行：%s\n' "$rel" "$((i + 1))" "$line" >> "$RES_FM"
          fi
          ;;
      esac
    done
  } < "$f"
  if [ "$closed" -ne 1 ]; then
    printf '%s\t1\tNO_CLOSING：50 行内未找到闭合 ---\n' "$rel" >> "$RES_FM"
    return 0
  fi
  local req r
  req=$(required_of "$profile")
  for r in $req; do
    case " $found " in
      *" $r "*)
        ;;
      *)
        printf '%s\t1\tMISSING_FIELD：profile %s 必填字段 %s 缺失或为空\n' "$rel" "$profile" "$r" >> "$RES_FM"
        ;;
    esac
  done
}

run_frontmatter() {
  local target="$1" md rel
  # 创作树口径：排除 artifacts/（证据语言无关）与 modelB/（外部资料）与
  # index/（生成器机器产物——Part04 引入，非创作 md，front-matter 无从注入）
  # Authoring-tree scope: prune artifacts/ (language-agnostic evidence),
  # modelB/ (external material) and index/ (machine-generated outputs,
  # introduced by Part04 — not authored md, no front-matter applies).
  find "$target" -type d \( -name artifacts -o -name modelB -o -name index \) -prune -o \
    -type f -name '*.md' -print \
  | while IFS= read -r md; do
      rel="${md#"$target"/}"
      check_fm_file "$md" "$rel" "$(route_profile "$rel")"
    done
}

# ---------------------------------------------------------------- 凭据模式（ADR-010）| mode 3: credentials

# 追加违规（输入为 grep -rn 的 `文件:行号:内容` 输出）
# Append violations from grep -rn output ("file:lineno:content").
append_hits() {
  local hits="$1" tag="$2" line file rest lineno content
  if [ -z "$hits" ]; then
    return 0
  fi
  while IFS= read -r line; do
    if [ -z "$line" ]; then
      continue
    fi
    file=${line%%:*}
    rest=${line#*:}
    lineno=${rest%%:*}
    content=${rest#*:}
    printf '%s\t%s\t%s\t%s\n' "$file" "$lineno" "$tag" "$content" >> "$RES_CRED"
  done <<EOF
$hits
EOF
}

run_credentials() {
  local target="$1" hits ips
  # C1 私钥块
  # C1 private key blocks
  hits=$(grep -rnI "${GREP_EXCLUDES[@]}" -E \
    'BEGIN (RSA |EC |DSA |OPENSSH )?PRIVATE KEY' "$target" 2>/dev/null || true)
  append_hits "$hits" "PRIVATE_KEY_BLOCK"
  # C2 口令/密钥赋值字面量（占位符 <...>、开发默认值与既有裁决家族豁免）
  # C2 credential assignment literals (placeholders and adjudicated families exempt)
  hits=$(grep -rnI "${GREP_EXCLUDES[@]}" -E \
    "(password|passwd|secret|api[_-]?key)[\"']?[[:space:]]*[:=][[:space:]]*[\"'][^\"'<>]{4,}" \
    "$target" 2>/dev/null \
    | grep -vE 'mifos:password|mifos/password|redacted|design-?tokens|PBKDF2|\$\{' || true)
  append_hits "$hits" "CREDENTIAL_LITERAL"
  # C3 token 赋值字面量
  # C3 token assignment literals
  hits=$(grep -rnI "${GREP_EXCLUDES[@]}" -E \
    "([^A-Za-z0-9_]|^)token[\"']?[[:space:]]*[:=][[:space:]]*[\"'][^\"'<>]{4,}" \
    "$target" 2>/dev/null \
    | grep -vE 'redacted|design-?tokens|\$\{' || true)
  append_hits "$hits" "TOKEN_LITERAL"
  # C4 GitHub PAT 形态
  # C4 GitHub PAT shapes
  hits=$(grep -rnI "${GREP_EXCLUDES[@]}" -E \
    '(ghp|gho|ghs|ghr)_[A-Za-z0-9]{20,}|github_pat_[A-Za-z0-9_]{20,}' \
    "$target" 2>/dev/null || true)
  append_hits "$hits" "GITHUB_TOKEN"
  # C5 JWT 字面量
  # C5 JWT literals
  hits=$(grep -rnI "${GREP_EXCLUDES[@]}" -E \
    'eyJ[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{5,}\.[A-Za-z0-9_-]{5,}' \
    "$target" 2>/dev/null || true)
  append_hits "$hits" "JWT_LITERAL"
  # C6 密钥形态文件
  # C6 key-shaped files
  hits=$(find "$target" -type d \( -name .git -o -name node_modules \) -prune -o \
    -type f \( -name '*.key' -o -name '*.p12' -o -name '*.pfx' \) -print 2>/dev/null || true)
  if [ -n "$hits" ]; then
    printf '%s\n' "$hits" | while IFS= read -r line; do
      if [ -n "$line" ]; then
        printf '%s\t-\tKEY_FILE\t%s\n' "${line%%:*}" "密钥形态文件不得入公开证据" >> "$RES_CRED"
      fi
    done
  fi
  # C7 公网 IP 字面量（抽检口径：排除 RFC1918/回环/链路本地段，版本号上下文豁免）
  # C7 public IP literals (spot-check: RFC1918/loopback/link-local excluded,
  # version-number context exempted via per-hit line re-read)
  ips=$(grep -rnoI "${GREP_EXCLUDES[@]}" -E '([0-9]{1,3}\.){3}[0-9]{1,3}' \
    "$target" 2>/dev/null \
    | grep -vE ':(127\.|10\.|192\.168\.|172\.(1[6-9]|2[0-9]|3[01])\.|0\.0\.0\.0|169\.254\.|224\.)' \
    || true)
  local h f rest ln ip ctx
  while IFS= read -r h; do
    if [ -z "$h" ]; then
      continue
    fi
    f=${h%%:*}
    rest=${h#*:}
    ln=${rest%%:*}
    ip=${rest#*:}
    # 回读命中原行判定版本号上下文（-o 输出无行内容，须回查）
    # Re-read the hit line for version context (-o output has no line content).
    ctx=$(sed -n "${ln}p" "$f" 2>/dev/null || true)
    if printf '%s' "$ctx" | grep -qE '(version|build_id|版本|Emulator)'; then
      if [ -n "$INFO_SPOT_IPS" ]; then
        INFO_SPOT_IPS="${INFO_SPOT_IPS}
$h"
      else
        INFO_SPOT_IPS="$h"
      fi
    else
      printf '%s\t%s\t%s\t%s\n' "$f" "$ln" "PUBLIC_IP_LITERAL" "$ip" >> "$RES_CRED"
    fi
  done <<EOF
$ips
EOF
  # C8 `.github-private` 引用（信息项：路径引用合法；内容泄漏由 C1–C7 拦截）
  # C8 `.github-private` mentions (informational: path refs are legal; content
  # leaks are caught by C1–C7)
  INFO_GHPRIV_COUNT=$(grep -rnI "${GREP_EXCLUDES[@]}" '\.github-private' \
    "$target" 2>/dev/null | wc -l | tr -d ' ')
}

# ---------------------------------------------------------------- 汇总输出 | report

tsv_count() {
  if [ -f "$1" ]; then
    wc -l < "$1" | tr -d ' '
  else
    echo 0
  fi
}

print_table() {
  local title="$1" res="$2" extra="$3"
  local n
  n=$(tsv_count "$res")
  echo "### $title"
  echo
  if [ "$n" -gt 0 ]; then
    echo "| 文件 | 行号 | 内容 |"
    echo "|---|---|---|"
    awk -F'\t' '{
      rest = $0
      sub(/^[^\t]*\t[^\t]*\t/, "", rest)
      gsub(/\|/, "\\|", rest)
      print "| " $1 " | " $2 " | " rest " |"
    }' "$res"
    echo
  fi
  echo "违规数: $n${extra}"
  echo
}

report_all() {
  local total=0 n
  echo "# check-bilingual 检查报告 ($(date +%Y-%m-%d))"
  echo
  if [ "$MODE_DEF" -eq 1 ]; then
    n=$(tsv_count "$LOG_DEF")
    print_table "模式一：注释双语（触碰/增量源码）——扫描文件 $n 个" "$RES_DEF" ""
    total=$((total + $(tsv_count "$RES_DEF")))
  fi
  if [ "$MODE_FM" -eq 1 ]; then
    n=$(tsv_count "$LOG_FM")
    print_table "模式二：front-matter（创作 md，排除 artifacts/ 与 modelB/）——扫描文件 $n 个" "$RES_FM" ""
    total=$((total + $(tsv_count "$RES_FM")))
  fi
  if [ "$MODE_CRED" -eq 1 ]; then
    print_table "模式三：凭据扫描（ADR-010 衍生约束 2/5）" "$RES_CRED" ""
    total=$((total + $(tsv_count "$RES_CRED")))
    echo "抽检信息（不阻塞，供人工复核）:"
    if [ -n "$INFO_SPOT_IPS" ]; then
      printf '%s\n' "$INFO_SPOT_IPS" | sed 's/^/  - 版本号上下文 IP 豁免：/'
    else
      echo "  - 无版本号上下文 IP 命中"
    fi
    echo "  - .github-private 路径引用（合法形态）共 $INFO_GHPRIV_COUNT 处；内容泄漏由字面量模式拦截"
    echo
  fi
  echo "**违规总数: $total**"
  if [ "$total" -gt 0 ]; then
    exit 1
  fi
  echo "✅ 全部通过"
  exit 0
}

# ---------------------------------------------------------------- 主流程 | main

if [ "$MODE_DEF" -eq 1 ]; then
  run_default "${DEFAULT_TARGETS[@]}"
fi
if [ "$MODE_FM" -eq 1 ]; then
  run_frontmatter "$FM_TARGET"
fi
if [ "$MODE_CRED" -eq 1 ]; then
  run_credentials "$CRED_TARGET"
fi
report_all
