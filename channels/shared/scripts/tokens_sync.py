#!/usr/bin/env python3
"""tokens_sync.py — ABNK design tokens 一致性比对脚本（Sprint v0.0.1 Part02 任务 P1.2 / VP1.2.1）。

比对两个事实载体：
  1. 源：channels/website/tailwind.config.js（官网设计 tokens 源点，只读不动）
  2. 单一事实源：channels/shared/design-tokens.json（双端映射的提取产物）

比对口径（逐值）：
  - colors：十族扁平化（<族>.<档位> → hex，大小写不敏感）
  - fonts：sans/serif/mono 三栈逐项（strip 首尾引号后比对）
  - eyebrow（letterSpacing.eyebrow）与 pageMaxWidth（maxWidth.page）字面值

防空洞机制：tailwind 源解析条目数不足（<10 色族、<3 字体栈、缺 eyebrow、缺
pageMaxWidth）时，即使数值一致 `DIFF: 0` 也判无效——脚本以退出码 2 失败。

实现约束：纯标准库；tailwind.config.js 为 ESM `export default` 对象字面量，
按 theme.extend 段做受限括号计数提取，不做整体 JS 求值。

退出码：0 = PASS（零差异且自证通过）；1 = 数值差异；2 = 提取自证失败/解析失败。
"""

import json
import re
import sys
from pathlib import Path

MIN_COLOR_FAMILIES = 10
MIN_FONT_STACKS = 3
SCRIPT_DIR = Path(__file__).resolve().parent
TOKENS_PATH = SCRIPT_DIR.parent / "design-tokens.json"
TAILWIND_PATH = SCRIPT_DIR.parents[1] / "website" / "tailwind.config.js"


def find_braced_block(text: str, start: int) -> tuple[int, int]:
    """从 text[start]（须为 '{'）起括号计数，返回块体 (body_start, closing_index)，不含花括号。

    跳过字符串字面量与 // 行注释，避免花括号/冒号在字符串或注释内误计数。
    """
    if text[start] != "{":
        raise ValueError(f"位置 {start} 非 '{{'")
    depth = 0
    in_str = False
    quote = ""
    i = start
    n = len(text)
    while i < n:
        c = text[i]
        if in_str:
            if c == "\\" and i + 1 < n:
                i += 2
                continue
            if c == quote:
                in_str = False
        else:
            if c in ("'", '"'):
                in_str = True
                quote = c
            elif c == "/" and i + 1 < n and text[i + 1] == "/":
                while i < n and text[i] != "\n":
                    i += 1
                continue
            elif c == "/" and i + 1 < n and text[i + 1] == "*":
                i += 2
                while i + 1 < n and not (text[i] == "*" and text[i + 1] == "/"):
                    i += 1
                i += 2
                continue
            elif c == "{":
                depth += 1
            elif c == "}":
                depth -= 1
                if depth == 0:
                    return start + 1, i
        i += 1
    raise ValueError("花括号不匹配（文件截断或语法异常）")


def extract_section(text: str, key: str) -> str:
    """在 text 内提取 `<key>: { ... }` 块体文本（首个匹配处）。"""
    m = re.search(r"\b" + re.escape(key) + r"\s*:\s*\{", text)
    if not m:
        raise KeyError(f"未找到段: {key}")
    brace_pos = m.end() - 1
    body_start, closing = find_braced_block(text, brace_pos)
    return text[body_start:closing]


def js_object_literal_to_dict(src: str) -> dict:
    """受限 JS→JSON 转换，仅覆盖本文件用到的对象字面量子集。

    处理：剥离 // 与 /* */ 注释（字符串外）；单引号字符串转双引号（内部
    双引号转义）；裸键加引号；去尾逗号。不做任何 JS 求值。
    """
    # 1) 剥离注释（字符串外）
    out = []
    i, n = 0, len(src)
    in_str, quote = False, ""
    while i < n:
        c = src[i]
        if in_str:
            out.append(c)
            if c == "\\" and i + 1 < n:
                out.append(src[i + 1])
                i += 2
                continue
            if c == quote:
                in_str = False
            i += 1
            continue
        if c in ("'", '"'):
            in_str, quote = True, c
            out.append(c)
            i += 1
            continue
        if c == "/" and i + 1 < n and src[i + 1] == "/":
            while i < n and src[i] != "\n":
                i += 1
            continue
        if c == "/" and i + 1 < n and src[i + 1] == "*":
            i += 2
            while i + 1 < n and not (src[i] == "*" and src[i + 1] == "/"):
                i += 1
            i += 2
            continue
        out.append(c)
        i += 1
    text = "".join(out)

    # 2) 单引号字符串 → JSON 双引号字符串
    out, i, n = [], 0, len(text)
    while i < n:
        c = text[i]
        if c == "'":
            j = i + 1
            buf = []
            while j < n and text[j] != "'":
                if text[j] == "\\" and j + 1 < n:
                    buf.append(text[j])
                    buf.append(text[j + 1])
                    j += 2
                    continue
                if text[j] == '"':
                    buf.append('\\"')
                else:
                    buf.append(text[j])
                j += 1
            out.append('"' + "".join(buf) + '"')
            i = j + 1
            continue
        out.append(c)
        i += 1
    text = "".join(out)

    # 3) 裸键加引号 + 尾逗号清理（键模式含数字档位如 50/700；段内值字符串无冒号，无误伤；
    #    块体不含外层花括号，尾逗号可能落在文本末尾——须同时匹配 , } 与 , 文本尾）
    text = re.sub(r"([{,\s])([A-Za-z0-9_]+)(\s*:)", r'\1"\2"\3', text)
    text = re.sub(r",(\s*[}\]]|\s*$)", r"\1", text)
    return json.loads("{" + text + "}")


def flatten_colors(colors: dict) -> dict[str, str]:
    """十族色板扁平化：'ivory.50' → '#FDFBF8'（hex 大小写不敏感）。"""
    flat: dict[str, str] = {}
    for family, val in colors.items():
        if isinstance(val, dict):
            for shade, hexv in val.items():
                flat[f"colors.{family}.{shade}"] = str(hexv).strip().upper()
        else:
            flat[f"colors.{family}.DEFAULT"] = str(val).strip().upper()
    return flat


def normalize_font_stack(stack: list) -> list[str]:
    """字体栈逐项规范化：strip 首尾引号（'"Oxanium Variable"' → 'Oxanium Variable'）。"""
    return [str(item).strip().strip('"').strip("'") for item in stack]


def main() -> int:
    if not TAILWIND_PATH.is_file():
        print(f"FATAL: tailwind 源不存在: {TAILWIND_PATH}", file=sys.stderr)
        return 2
    if not TOKENS_PATH.is_file():
        print(f"FATAL: design-tokens.json 不存在: {TOKENS_PATH}", file=sys.stderr)
        return 2

    # ── 解析 tailwind 源（theme.extend 受限提取）──
    try:
        src = TAILWIND_PATH.read_text(encoding="utf-8")
        theme_body = extract_section(src, "theme")
        extend_body = extract_section(theme_body, "extend")
        colors_src = js_object_literal_to_dict(extract_section(extend_body, "colors"))
        fonts_src = js_object_literal_to_dict(extract_section(extend_body, "fontFamily"))
        letter_src = js_object_literal_to_dict(extract_section(extend_body, "letterSpacing"))
        maxw_src = js_object_literal_to_dict(extract_section(extend_body, "maxWidth"))
    except (ValueError, KeyError, json.JSONDecodeError) as exc:
        print(f"FATAL: tailwind.config.js 解析失败: {exc}", file=sys.stderr)
        return 2

    tokens = json.loads(TOKENS_PATH.read_text(encoding="utf-8"))

    # ── 提取自证（防空洞：条目数为 0 时 DIFF: 0 无效）──
    color_families = len(colors_src)
    color_entries = sum(
        len(v) if isinstance(v, dict) else 1 for v in colors_src.values()
    )
    font_stacks = len(fonts_src)
    eyebrow_src = letter_src.get("eyebrow")
    page_max_src = maxw_src.get("page")

    guards = []
    guard_ok = True
    if color_families < MIN_COLOR_FAMILIES:
        guards.append(f"colorFamilies>={MIN_COLOR_FAMILIES} FAIL (实际 {color_families})")
        guard_ok = False
    else:
        guards.append(f"colorFamilies>={MIN_COLOR_FAMILIES} OK ({color_families})")
    if font_stacks < MIN_FONT_STACKS:
        guards.append(f"fontStacks>={MIN_FONT_STACKS} FAIL (实际 {font_stacks})")
        guard_ok = False
    else:
        guards.append(f"fontStacks>={MIN_FONT_STACKS} OK ({font_stacks})")
    for label, value in (("eyebrow", eyebrow_src), ("pageMaxWidth", page_max_src)):
        if value is None:
            guards.append(f"{label} present FAIL")
            guard_ok = False
        else:
            guards.append(f"{label} present OK ({value})")

    print(f"SOURCE  : {TAILWIND_PATH} (theme.extend 受限提取)")
    print(f"TOKENS  : {TOKENS_PATH}")
    print(
        f"EXTRACTED: colorFamilies={color_families}, colorEntries={color_entries}, "
        f"fontStacks={font_stacks}, eyebrow={eyebrow_src}, pageMaxWidth={page_max_src}"
    )
    print("GUARD   : " + " / ".join(guards))

    if not guard_ok:
        print("DIFF: N/A（提取自证失败，比对结果无效）")
        print("RESULT: FAIL — tailwind 源解析条目不足，DIFF: 0 不成立（防空洞拦截）")
        return 2

    # ── 逐值比对 ──
    diffs: list[str] = []

    src_flat = flatten_colors(colors_src)
    tokens_flat = flatten_colors(tokens.get("colors", {}))
    for key in sorted(set(src_flat) | set(tokens_flat)):
        sv = src_flat.get(key)
        tv = tokens_flat.get(key)
        if sv != tv:
            diffs.append(f"colors.{key}: source={sv} tokens={tv}")

    for stack in sorted(set(fonts_src) | set({k: None for k in ()})):
        pass  # 占位消除迭代歧义（下方按固定三栈口径比对）

    fonts_tokens = tokens.get("fonts", {})
    for name in sorted(set(list(fonts_src) + list(fonts_tokens))):
        sv = fonts_src.get(name)
        tv = fonts_tokens.get(name)
        sv_n = normalize_font_stack(sv) if isinstance(sv, list) else sv
        tv_n = normalize_font_stack(tv) if isinstance(tv, list) else tv
        if sv_n != tv_n:
            diffs.append(f"fonts.{name}: source={sv_n} tokens={tv_n}")

    eyebrow_tokens = tokens.get("eyebrow")
    if eyebrow_src != eyebrow_tokens:
        diffs.append(f"eyebrow: source={eyebrow_src} tokens={eyebrow_tokens}")

    page_max_tokens = tokens.get("pageMaxWidth")
    if page_max_src != page_max_tokens:
        diffs.append(f"pageMaxWidth: source={page_max_src} tokens={page_max_tokens}")

    if diffs:
        print(f"DIFF: {len(diffs)}")
        for d in diffs:
            print(f"  - {d}")
        print("RESULT: FAIL — design-tokens.json 与 tailwind 源存在数值差异，修 tokens.json 后重跑")
        return 1

    print("DIFF: 0")
    print("RESULT: PASS — design-tokens.json 与 tailwind 源逐值零差异")
    return 0


if __name__ == "__main__":
    sys.exit(main())
