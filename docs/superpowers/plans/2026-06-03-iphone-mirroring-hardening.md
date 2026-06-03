# iPhone Mirroring Auto-Scripts Hardening Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Fix the 8 investigation findings (Project Hub project 82) across the AppleScript generator, the calibration/screenshot scripts, and the Python tooling — making generated scripts always valid, portable across Intel/Apple-Silicon Macs, resilient to shell failures, and covered by automated tests.

**Architecture:** Extract all AppleScript-snippet generation out of `ApplescriptGen.py`'s OpenCV callback into a new pure, dependency-free module `applescript_builders.py` so the logic is unit-testable without OpenCV. The two compiled `.scpt` files are converted to git-diffable `.applescript` text sources (the new source of truth) and recompiled with `osacompile`; this also enables `osacompile` syntax-check tests. `cliclick` is resolved at runtime via `command -v` so the same artifact works on both Homebrew prefixes, and every `do shell script` is wrapped in `try … on error` with an actionable dialog.

**Tech Stack:** Python 3.x, OpenCV (`opencv-python`), AppleScript (`osascript`/`osacompile`/`osadecompile`), `cliclick`, `pytest`.

---

## Decisions Locked (do NOT re-litigate during execution)

| Question | Decision |
|---|---|
| Testing rigor | `pytest` unit tests for pure Python helpers + `osacompile` syntax-check tests for AppleScript sources. Add `pytest` as a dev dependency. |
| `cliclick` path | Auto-detect once at runtime via `command -v cliclick`; fail with a clear dialog if missing. Generated scripts and `.scpt` files all use the resolved `cliclickPath` variable. |
| Calibration 5× clicks | Make configurable: add `clicksPerCell` config var (default **1**) and loop that many times. |
| ApplescriptGen refactor | Extract pure builder functions into a new `applescript_builders.py` module (no OpenCV import) so they are unit-testable. |
| Newline/tab in typed text | Build an AppleScript expression: literal runs are quoted/escaped, `\n` → `& return &`, `\t` → `& tab &`. |
| `GeneratedActions.scpt` lifecycle | Keep fresh-per-run (truncate-then-append within a session, matching the README workflow). Rename the misleading function to `reset_output_file`. |
| AppleScript edit workflow | Decompile each `.scpt` to a tracked `.applescript` text source, edit the text, recompile to `.scpt`. Both files are committed; `.applescript` is the source of truth. |
| Commit messages | Plain conventional-commit messages. **No** AI/assistant attribution or co-author trailers (per repo owner's global rule). |

---

## File Structure

**Create:**
- `applescript_builders.py` — pure functions: `applescript_string_literal`, `build_header`, `build_click_snippet`, `build_type_snippet`. No OpenCV/third-party imports. Single responsibility: turn coordinates/text into valid AppleScript text.
- `Calibration.applescript` — text source for the grid-calibration script (source of truth; `Calibration.scpt` is regenerated from it).
- `Screenshotter.applescript` — text source for the standardized-screenshot script.
- `tests/test_applescript_builders.py` — unit tests for the pure builders.
- `tests/test_applescript_sources.py` — `osacompile` syntax-check tests for the `.applescript` sources and a full generated-script compile test.
- `requirements-dev.txt` — dev dependencies (`pytest`).

**Modify:**
- `ApplescriptGen.py` — import builders, replace inline snippet strings in `mouse_callback`, rename `write_header_if_needed` → `reset_output_file`, fix the OpenCV window name, drop unused `numpy`/`os` imports.
- `ScreenOffset.py` — drop unused `os` import.
- `Calibration.scpt` — regenerated from `Calibration.applescript`.
- `Screenshotter.scpt` — regenerated from `Screenshotter.applescript`.

**Execution order (avoids edit conflicts):** Bucket D → Bucket A → Bucket B → Bucket C. Buckets B and C both touch `Calibration.applescript`; B creates it, C amends it.

---

## Bucket D — Python Tool UX & Hygiene + Test Setup

*Quick, low-risk wins first, plus the test scaffolding the later buckets rely on.*
Implements Project Hub tasks **#2** (window name) and **#7** (unused imports).

### Task D0: Test scaffolding

**Files:**
- Create: `requirements-dev.txt`
- Create: `tests/test_smoke.py`

- [ ] **Step 1: Create the dev requirements file**

```
# requirements-dev.txt
pytest>=8.0
```

- [ ] **Step 2: Install pytest**

Run: `python3 -m pip install -r requirements-dev.txt`
Expected: pytest installs successfully (or "Requirement already satisfied").

- [ ] **Step 3: Add a smoke test to prove the runner works**

```python
# tests/test_smoke.py
def test_smoke():
    assert True
```

- [ ] **Step 4: Run it**

Run: `python3 -m pytest tests/test_smoke.py -v`
Expected: PASS (1 passed).

- [ ] **Step 5: Commit**

```bash
git add requirements-dev.txt tests/test_smoke.py
git commit -m "test: add pytest dev dependency and smoke test"
```

### Task D1: Fix mismatched OpenCV window name (Project Hub #2)

**Files:**
- Modify: `ApplescriptGen.py:124`

- [ ] **Step 1: Inspect the current line**

Run: `grep -n 'Interactive Action Builder' ApplescriptGen.py`
Expected: one match at line 124 inside `mouse_callback`.

- [ ] **Step 2: Replace the wrong window name**

Change line 124 from:

```python
        cv2.imshow("Interactive Action Builder", img_display)
```

to:

```python
        cv2.imshow("Phone Automation Builder", img_display)
```

- [ ] **Step 3: Verify no stray window name remains**

Run: `grep -n 'Interactive Action Builder' ApplescriptGen.py`
Expected: no output (exit code 1).

- [ ] **Step 4: Commit**

```bash
git add ApplescriptGen.py
git commit -m "fix: use correct OpenCV window name in mouse callback"
```

### Task D2: Remove unused imports (Project Hub #7)

**Files:**
- Modify: `ApplescriptGen.py:1-6`
- Modify: `ScreenOffset.py:6`

- [ ] **Step 1: Confirm the imports are unused**

Run: `grep -nE '(^|[^.[:alnum:]])np\.' ApplescriptGen.py; grep -nE '(^|[^.[:alnum:]])os\.' ApplescriptGen.py ScreenOffset.py`
Expected: no output (neither `np.` nor `os.` is referenced anywhere).

- [ ] **Step 2: Remove `numpy` and `os` from `ApplescriptGen.py`**

Delete these two lines from the top of `ApplescriptGen.py`:

```python
import numpy as np
```
```python
import os
```

The remaining imports must be exactly:

```python
import cv2
import argparse
import re
import sys
```

- [ ] **Step 3: Remove `os` from `ScreenOffset.py`**

Delete this line from the top of `ScreenOffset.py`:

```python
import os
```

The remaining imports must be exactly:

```python
import cv2
import re
import argparse
import sys
```

- [ ] **Step 4: Verify both files still import cleanly**

Run: `python3 -c "import ast,sys; [ast.parse(open(f).read()) for f in ('ApplescriptGen.py','ScreenOffset.py')]; print('OK')"`
Expected: `OK`

- [ ] **Step 5: Commit**

```bash
git add ApplescriptGen.py ScreenOffset.py
git commit -m "refactor: drop unused numpy and os imports"
```

---

## Bucket A — Generated AppleScript Integrity

*Make `GeneratedActions.scpt` always valid and reliable. Extract pure builders, fix escaping, focus, header.*
Implements Project Hub tasks **#1** (escaping), **#8** (keystroke focus), **#6** (header rename), and the generated-snippet portions of **#4** (cliclick path) and **#5** (shell error handling).

### Task A1: `applescript_string_literal` — failing test

**Files:**
- Create: `tests/test_applescript_builders.py`

- [ ] **Step 1: Write the failing test**

```python
# tests/test_applescript_builders.py
from applescript_builders import applescript_string_literal


def test_plain_text_is_quoted():
    assert applescript_string_literal("hello") == '"hello"'


def test_empty_string():
    assert applescript_string_literal("") == '""'


def test_double_quote_is_escaped():
    assert applescript_string_literal('say "hi"') == '"say \\"hi\\""'


def test_backslash_is_escaped():
    assert applescript_string_literal("a\\b") == '"a\\\\b"'


def test_newline_becomes_return_concatenation():
    assert applescript_string_literal("line1\nline2") == '"line1" & return & "line2"'


def test_tab_becomes_tab_concatenation():
    assert applescript_string_literal("a\tb") == '"a" & tab & "b"'


def test_leading_newline_has_no_empty_quote():
    assert applescript_string_literal("\nx") == 'return & "x"'
```

- [ ] **Step 2: Run test to verify it fails**

Run: `python3 -m pytest tests/test_applescript_builders.py -v`
Expected: FAIL — `ModuleNotFoundError: No module named 'applescript_builders'`.

### Task A2: `applescript_string_literal` — implementation

**Files:**
- Create: `applescript_builders.py`

- [ ] **Step 1: Implement the module + function**

```python
# applescript_builders.py
"""Pure helpers that turn coordinates and text into valid AppleScript source.

No OpenCV / third-party imports here on purpose: keeping these functions
dependency-free makes them unit-testable in isolation.
"""


def applescript_string_literal(text):
    """Return an AppleScript expression that evaluates to ``text``.

    Plain runs are emitted as quoted string literals with ``\\`` and ``"``
    escaped. Newlines and tabs cannot appear inside an AppleScript string
    literal, so they are emitted as ``return`` / ``tab`` keyword tokens joined
    with ``&``. Example: ``a\\tb`` -> ``"a" & tab & "b"``.
    """
    if text == "":
        return '""'

    parts = []
    buf = ""

    def flush():
        nonlocal buf
        if buf:
            parts.append('"' + buf + '"')
            buf = ""

    for ch in text:
        if ch == "\n":
            flush()
            parts.append("return")
        elif ch == "\t":
            flush()
            parts.append("tab")
        elif ch == '"':
            buf += '\\"'
        elif ch == "\\":
            buf += "\\\\"
        else:
            buf += ch
    flush()

    return " & ".join(parts)
```

- [ ] **Step 2: Run tests to verify they pass**

Run: `python3 -m pytest tests/test_applescript_builders.py -v`
Expected: PASS (7 passed).

- [ ] **Step 3: Commit**

```bash
git add applescript_builders.py tests/test_applescript_builders.py
git commit -m "feat: add applescript_string_literal escaping helper"
```

### Task A3: `build_header` — test + implementation

**Files:**
- Modify: `tests/test_applescript_builders.py`
- Modify: `applescript_builders.py`

- [ ] **Step 1: Add the failing test**

Append to `tests/test_applescript_builders.py`:

```python
from applescript_builders import build_header


def test_header_resolves_cliclick_at_runtime():
    header = build_header()
    assert 'command -v cliclick' in header
    assert 'set cliclickPath to' in header


def test_header_fronts_the_mirroring_process_and_reads_position():
    header = build_header()
    assert 'tell process "iPhone Mirroring"' in header
    assert 'set frontmost to true' in header
    assert 'set {winX, winY} to position of UI element 1' in header
```

- [ ] **Step 2: Run to verify it fails**

Run: `python3 -m pytest tests/test_applescript_builders.py -k header -v`
Expected: FAIL — `ImportError: cannot import name 'build_header'`.

- [ ] **Step 3: Implement `build_header`**

Append to `applescript_builders.py`:

```python
def build_header():
    """AppleScript prelude written once at the top of GeneratedActions.scpt.

    Resolves the cliclick binary at runtime (works on Apple Silicon and Intel)
    and captures the iPhone Mirroring window origin into winX/winY.
    """
    return (
        'set cliclickPath to ""\n'
        'try\n'
        '    set cliclickPath to (do shell script "command -v cliclick")\n'
        'on error\n'
        '    display dialog "cliclick not found. Install it with: brew install cliclick" '
        'buttons {"OK"} default button "OK"\n'
        '    return\n'
        'end try\n'
        '\n'
        'tell application "System Events"\n'
        '    tell process "iPhone Mirroring"\n'
        '        set frontmost to true\n'
        '        set {winX, winY} to position of UI element 1\n'
        '    end tell\n'
        'end tell\n\n'
    )
```

- [ ] **Step 4: Run to verify it passes**

Run: `python3 -m pytest tests/test_applescript_builders.py -k header -v`
Expected: PASS (2 passed).

- [ ] **Step 5: Commit**

```bash
git add applescript_builders.py tests/test_applescript_builders.py
git commit -m "feat: add build_header with runtime cliclick resolution"
```

### Task A4: `build_click_snippet` — test + implementation

**Files:**
- Modify: `tests/test_applescript_builders.py`
- Modify: `applescript_builders.py`

- [ ] **Step 1: Add the failing test**

Append to `tests/test_applescript_builders.py`:

```python
from applescript_builders import build_click_snippet


def test_click_snippet_uses_offsets_and_resolved_path():
    s = build_click_snippet(120, 340)
    assert "set actionOffsetX to 120" in s
    assert "set actionOffsetY to 340" in s
    assert "cliclickPath & \" c:\"" in s
    # cliclick failures must not abort the run silently
    assert "on error errMsg" in s
    assert "display dialog" in s
```

- [ ] **Step 2: Run to verify it fails**

Run: `python3 -m pytest tests/test_applescript_builders.py -k click -v`
Expected: FAIL — `ImportError: cannot import name 'build_click_snippet'`.

- [ ] **Step 3: Implement `build_click_snippet`**

Append to `applescript_builders.py`:

```python
def build_click_snippet(rel_x, rel_y):
    """AppleScript that clicks at (winX+rel_x, winY+rel_y) via cliclick."""
    return (
f'''set actionOffsetX to {rel_x}
set actionOffsetY to {rel_y}

set clickX to winX + actionOffsetX
set clickY to winY + actionOffsetY

try
    do shell script cliclickPath & " c:" & (clickX as integer) & "," & (clickY as integer)
on error errMsg
    display dialog "cliclick failed: " & errMsg buttons {{"OK"}} default button "OK"
    return
end try
delay 0.5
''')
```

- [ ] **Step 4: Run to verify it passes**

Run: `python3 -m pytest tests/test_applescript_builders.py -k click -v`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add applescript_builders.py tests/test_applescript_builders.py
git commit -m "feat: add build_click_snippet with cliclick error handling"
```

### Task A5: `build_type_snippet` — test + implementation

**Files:**
- Modify: `tests/test_applescript_builders.py`
- Modify: `applescript_builders.py`

- [ ] **Step 1: Add the failing test**

Append to `tests/test_applescript_builders.py`:

```python
from applescript_builders import build_type_snippet


def test_type_snippet_clicks_then_types_escaped_text():
    s = build_type_snippet(10, 20, 'he said "hi"')
    assert "set actionOffsetX to 10" in s
    # text is escaped via applescript_string_literal
    assert 'keystroke "he said \\"hi\\""' in s


def test_type_snippet_reasserts_focus_before_typing():
    s = build_type_snippet(10, 20, "x")
    # frontmost must be re-asserted right before keystroke (Project Hub #8)
    focus_idx = s.index('set frontmost of process "iPhone Mirroring" to true')
    type_idx = s.index("keystroke")
    assert focus_idx < type_idx


def test_type_snippet_handles_newlines_in_text():
    s = build_type_snippet(0, 0, "a\nb")
    assert 'keystroke "a" & return & "b"' in s
```

- [ ] **Step 2: Run to verify it fails**

Run: `python3 -m pytest tests/test_applescript_builders.py -k type -v`
Expected: FAIL — `ImportError: cannot import name 'build_type_snippet'`.

- [ ] **Step 3: Implement `build_type_snippet`**

Append to `applescript_builders.py`:

```python
def build_type_snippet(rel_x, rel_y, text):
    """AppleScript that clicks the target, re-asserts focus, then types text.

    Focus is re-asserted immediately before the keystroke so an earlier delay
    or focus change cannot misroute keys to another app (Project Hub #8).
    """
    literal = applescript_string_literal(text)
    return (
f'''set actionOffsetX to {rel_x}
set actionOffsetY to {rel_y}

set clickX to winX + actionOffsetX
set clickY to winY + actionOffsetY

try
    do shell script cliclickPath & " c:" & (clickX as integer) & "," & (clickY as integer)
on error errMsg
    display dialog "cliclick failed: " & errMsg buttons {{"OK"}} default button "OK"
    return
end try
delay 0.5
tell application "System Events"
    set frontmost of process "iPhone Mirroring" to true
    delay 0.2
    keystroke {literal}
    delay 0.5
end tell
''')
```

- [ ] **Step 4: Run to verify it passes**

Run: `python3 -m pytest tests/test_applescript_builders.py -k type -v`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add applescript_builders.py tests/test_applescript_builders.py
git commit -m "feat: add build_type_snippet with escaped text and focus re-assert"
```

### Task A6: Generated-script compiles end-to-end (osacompile test)

**Files:**
- Create: `tests/test_applescript_sources.py`

- [ ] **Step 1: Write the failing/guarded test**

```python
# tests/test_applescript_sources.py
import shutil
import subprocess

import pytest

from applescript_builders import build_header, build_click_snippet, build_type_snippet

osacompile = shutil.which("osacompile")
requires_osacompile = pytest.mark.skipif(
    osacompile is None, reason="osacompile not available (non-macOS environment)"
)


@requires_osacompile
def test_generated_script_compiles(tmp_path):
    script = (
        build_header()
        + build_click_snippet(10, 20)
        + "\n"
        + build_type_snippet(30, 40, 'he said "hi"\n\tindented \\ path')
    )
    src = tmp_path / "gen.applescript"
    src.write_text(script)
    out = tmp_path / "gen.scpt"
    result = subprocess.run(
        [osacompile, "-o", str(out), str(src)],
        capture_output=True,
        text=True,
    )
    assert result.returncode == 0, result.stderr
    assert out.exists()
```

- [ ] **Step 2: Run the test**

Run: `python3 -m pytest tests/test_applescript_sources.py -v`
Expected: PASS on macOS (the script — including quotes, newline, tab, and backslash in typed text — compiles). On non-macOS: SKIPPED.

- [ ] **Step 3: Commit**

```bash
git add tests/test_applescript_sources.py
git commit -m "test: verify generated AppleScript compiles with osacompile"
```

### Task A7: Wire builders into `ApplescriptGen.py` and rename header writer (Project Hub #1, #6, #8)

**Files:**
- Modify: `ApplescriptGen.py` (imports, `write_header_if_needed` → `reset_output_file`, `mouse_callback`, `main`)

- [ ] **Step 1: Import the builders**

Add to the import block at the top of `ApplescriptGen.py` (below `import sys`):

```python
from applescript_builders import build_header, build_click_snippet, build_type_snippet
```

- [ ] **Step 2: Replace `write_header_if_needed` with `reset_output_file`**

Replace the whole function (currently `ApplescriptGen.py:53-68`) with:

```python
def reset_output_file():
    """Start a fresh GeneratedActions.scpt for this session.

    Truncates any existing file and writes the AppleScript header once. Actions
    are appended during the session as the user clicks.
    """
    with open(output_file, "w") as f:
        f.write(build_header())
    print("Header written to GeneratedActions.scpt")
```

- [ ] **Step 3: Replace the inline snippet construction in `mouse_callback`**

In `mouse_callback`, replace the `if action_type == 'c': ... elif ... 't': ... else:` block (currently the body building `snippet` at `ApplescriptGen.py:80-113`) with:

```python
        if action_type == 'c':
            snippet = build_click_snippet(rel_offset_x, rel_offset_y)
            marker_color = (0, 255, 0)  # Green for click
            label = "CLICK"
        elif action_type == 't':
            text_to_type = input("Enter the text to type: ")
            snippet = build_type_snippet(rel_offset_x, rel_offset_y, text_to_type)
            marker_color = (0, 0, 255)  # Red for type
            label = "TYPE"
        else:
            print("Invalid action type. Click ignored.")
            return
```

Note: the typed text is intentionally **not** `.strip()`ped anymore — escaping is handled by the builder, and stripping would silently drop intended leading/trailing whitespace.

- [ ] **Step 4: Update the call site in `main`**

In `main`, replace the call `write_header_if_needed()` (currently `ApplescriptGen.py:136`) with:

```python
    reset_output_file()
```

- [ ] **Step 5: Verify no references to the old name or inline cliclick path remain**

Run: `grep -nE 'write_header_if_needed|/opt/homebrew/bin/cliclick' ApplescriptGen.py`
Expected: no output (exit code 1).

- [ ] **Step 6: Verify the module still parses and the builder import resolves**

Run: `python3 -c "import ast; ast.parse(open('ApplescriptGen.py').read()); print('parse OK')"`
Expected: `parse OK`

Run: `python3 -c "import applescript_builders; print('import OK')"`
Expected: `import OK`

- [ ] **Step 7: Run the full Python test suite**

Run: `python3 -m pytest tests -v`
Expected: all pass / osacompile test passes on macOS.

- [ ] **Step 8: Commit**

```bash
git add ApplescriptGen.py
git commit -m "refactor: generate snippets via builders; reset_output_file; safe typed text"
```

---

## Bucket B — Shell/Binary Portability & Error Handling (AppleScript files)

*Convert the compiled scripts to text sources, auto-detect cliclick, wrap shell calls.*
Implements Project Hub tasks **#4** (cliclick path) and **#5** (shell error handling) for `Calibration.scpt` and `Screenshotter.scpt`.

### Task B1: Decompile both scripts to tracked text sources

**Files:**
- Create: `Calibration.applescript`
- Create: `Screenshotter.applescript`

- [ ] **Step 1: Decompile to text**

Run:
```bash
osadecompile Calibration.scpt > Calibration.applescript
osadecompile Screenshotter.scpt > Screenshotter.applescript
```
Expected: two text files created, each readable AppleScript.

- [ ] **Step 2: Sanity-check they round-trip compile**

Run:
```bash
osacompile -o /tmp/cal_check.scpt Calibration.applescript && osacompile -o /tmp/shot_check.scpt Screenshotter.applescript && echo COMPILE_OK
```
Expected: `COMPILE_OK`

- [ ] **Step 3: Commit the sources**

```bash
git add Calibration.applescript Screenshotter.applescript
git commit -m "chore: add editable AppleScript text sources for calibration and screenshotter"
```

### Task B2: Harden `Screenshotter.applescript` (smaller; do first)

**Files:**
- Modify: `Screenshotter.applescript`
- Modify (regenerate): `Screenshotter.scpt`

- [ ] **Step 1: Replace the file with the hardened version**

Write `Screenshotter.applescript` with exactly this content:

```applescript
-- Get the "iPhone Mirroring" window's position and size
tell application "System Events"
	tell process "iPhone Mirroring"
		set frontmost to true
		-- Assume the main UI element (the window) is the first element
		set theWindow to UI element 1
		set {winX, winY} to position of theWindow
		set {winW, winH} to size of theWindow
	end tell
end tell

set screenshotFile to (POSIX path of (path to desktop)) & "new_screenshot.png"

-- Capture the window region using the 'screencapture' command.
set captureCmd to "screencapture -R" & winX & "," & winY & "," & winW & "," & winH & " " & quoted form of screenshotFile
try
	do shell script captureCmd
on error errMsg
	display dialog "screencapture failed (check Screen Recording permission): " & errMsg buttons {"OK"} default button "OK"
end try
```

- [ ] **Step 2: Recompile to `.scpt`**

Run: `osacompile -o Screenshotter.scpt Screenshotter.applescript && echo OK`
Expected: `OK`

- [ ] **Step 3: Confirm the source compiles cleanly (no warnings/errors)**

Run: `osacompile -o /tmp/shot_check.scpt Screenshotter.applescript; echo $?`
Expected: `0`

- [ ] **Step 4: Commit**

```bash
git add Screenshotter.applescript Screenshotter.scpt
git commit -m "fix: wrap screencapture in error handling in screenshotter"
```

### Task B3: Harden `Calibration.applescript` (cliclick auto-detect + error handling)

**Files:**
- Modify: `Calibration.applescript`
- Modify (regenerate): `Calibration.scpt`

Note: This task also introduces the `clicksPerCell` config var and the single-click default that Bucket C (Task C1) depends on — they are delivered together here because they edit the same click loop. Task C1 then only verifies/configures.

- [ ] **Step 1: Replace the file with the hardened version**

Write `Calibration.applescript` with exactly this content:

```applescript
-- CONFIGURATION: Adjust these values as needed
set numRows to 3 -- number of rows in the grid
set numCols to 3 -- number of columns in the grid
set clickDelay to 0.3 -- delay between clicks in seconds
set clicksPerCell to 1 -- number of clicks issued at each grid point

-- Define the vertical range of the grid within the window:
set gridStartFraction to 0.15 -- grid starts at 15% of the window height
set gridEndFraction to 0.85 -- grid ends at 85% of the window height

-- Resolve the cliclick binary (works on both Apple Silicon and Intel)
set cliclickPath to ""
try
	set cliclickPath to (do shell script "command -v cliclick")
on error
	display dialog "cliclick not found. Install it with: brew install cliclick" buttons {"OK"} default button "OK"
	return
end try

-- Get the "iPhone Mirroring" window's position and size
tell application "System Events"
	tell process "iPhone Mirroring"
		set frontmost to true
		-- Assume the main UI element (the window) is the first element
		set theWindow to UI element 1
		set {winX, winY} to position of theWindow
		set {winW, winH} to size of theWindow
	end tell
end tell

-- Initialize the log string
set offsetLog to "Grid Click Offsets:" & linefeed
set offsetLog to offsetLog & "Window Position: (" & winX & ", " & winY & ")" & linefeed
set offsetLog to offsetLog & "Window Size: (" & winW & " x " & winH & ")" & linefeed & linefeed

-- Loop over the grid cells
repeat with rowIndex from 0 to (numRows - 1)
	repeat with colIndex from 0 to (numCols - 1)
		-- Calculate the relative X coordinate (full window width)
		set relX to ((colIndex + 0.5) / numCols) * winW

		-- For Y, restrict to the vertical range from gridStartFraction to gridEndFraction.
		set gridEffectiveHeight to winH * (gridEndFraction - gridStartFraction)
		set relY to (gridStartFraction * winH) + ((rowIndex + 0.5) / numRows) * gridEffectiveHeight

		-- Calculate the absolute screen coordinates
		set absX to winX + relX
		set absY to winY + relY

		-- Click at the absolute coordinates using cliclick (clicksPerCell times)
		try
			repeat clicksPerCell times
				do shell script cliclickPath & " c:" & (absX as integer) & "," & (absY as integer)
			end repeat
		on error errMsg
			display dialog "cliclick failed: " & errMsg buttons {"OK"} default button "OK"
			return
		end try
		delay clickDelay

		-- Append this cell's offsets to the log.
		set offsetLog to offsetLog & "Cell " & (colIndex + 1) & "," & (rowIndex + 1) & ": " & ¬
			"Relative (" & (relX as integer) & ", " & (relY as integer) & ") / " & ¬
			"Absolute (" & (absX as integer) & ", " & (absY as integer) & ")" & linefeed
	end repeat
end repeat

-- Write the log to a text file on the Desktop
set desktopPath to (path to desktop as text)
set logFile to desktopPath & "grid_offsets.txt"

try
	set fileReference to open for access file logFile with write permission
	set eof fileReference to 0 -- clear the file if it exists
	write offsetLog to fileReference
	close access fileReference
on error errMsg
	try
		close access file logFile
	end try
	display dialog "Error writing log: " & errMsg
end try

-- Automatically screenshot the window
set screenshotFile to (POSIX path of (path to desktop)) & "grid_screenshot.png"

-- Capture the window region using the 'screencapture' command.
set captureCmd to "screencapture -R" & winX & "," & winY & "," & winW & "," & winH & " " & quoted form of screenshotFile
try
	do shell script captureCmd
on error errMsg
	display dialog "screencapture failed (check Screen Recording permission): " & errMsg buttons {"OK"} default button "OK"
end try

display dialog "Grid clicks complete. Log written to grid_offsets.txt. Log and Screenshot are on your Desktop."
```

- [ ] **Step 2: Recompile to `.scpt`**

Run: `osacompile -o Calibration.scpt Calibration.applescript && echo OK`
Expected: `OK`

- [ ] **Step 3: Confirm the source compiles cleanly**

Run: `osacompile -o /tmp/cal_check.scpt Calibration.applescript; echo $?`
Expected: `0`

- [ ] **Step 4: Confirm the hardcoded Homebrew path is gone and the loop is configurable**

Run: `grep -nE '/opt/homebrew/bin/cliclick|repeat with x from 0 to 4' Calibration.applescript`
Expected: no output (exit code 1).

Run: `grep -n 'repeat clicksPerCell times' Calibration.applescript`
Expected: one match.

- [ ] **Step 5: Commit**

```bash
git add Calibration.applescript Calibration.scpt
git commit -m "fix: auto-detect cliclick, add shell error handling, configurable click count in calibration"
```

### Task B4: Add `.applescript` sources to the osacompile test sweep

**Files:**
- Modify: `tests/test_applescript_sources.py`

- [ ] **Step 1: Add a parametrized compile test for the source files**

Append to `tests/test_applescript_sources.py`:

```python
import pathlib

REPO_ROOT = pathlib.Path(__file__).resolve().parent.parent
APPLESCRIPT_SOURCES = ["Calibration.applescript", "Screenshotter.applescript"]


@requires_osacompile
@pytest.mark.parametrize("src_name", APPLESCRIPT_SOURCES)
def test_applescript_source_compiles(tmp_path, src_name):
    src = REPO_ROOT / src_name
    assert src.exists(), f"missing source: {src_name}"
    out = tmp_path / (src_name + ".scpt")
    result = subprocess.run(
        [osacompile, "-o", str(out), str(src)],
        capture_output=True,
        text=True,
    )
    assert result.returncode == 0, result.stderr
```

- [ ] **Step 2: Run the test**

Run: `python3 -m pytest tests/test_applescript_sources.py -v`
Expected: PASS on macOS (both sources compile); SKIPPED off-macOS.

- [ ] **Step 3: Commit**

```bash
git add tests/test_applescript_sources.py
git commit -m "test: compile-check Calibration and Screenshotter AppleScript sources"
```

---

## Bucket C — Calibration Click-Count Configuration

*Confirm and document the configurable click count delivered in B3.*
Implements Project Hub task **#3** (5× clicks).

> The behavior change (default 1 click, configurable via `clicksPerCell`) ships in Task B3 because it edits the same click loop as the cliclick/error-handling work — splitting it would mean two edits to the same lines. This task verifies the behavior and locks it with a test, so #3 is independently demonstrable.

### Task C1: Verify configurable click count + regression test

**Files:**
- Modify: `tests/test_applescript_sources.py`

- [ ] **Step 1: Add a content-assertion test for the calibration source**

Append to `tests/test_applescript_sources.py`:

```python
def test_calibration_click_count_is_configurable_and_defaults_to_one():
    text = (REPO_ROOT / "Calibration.applescript").read_text()
    assert "set clicksPerCell to 1" in text          # default is a single click
    assert "repeat clicksPerCell times" in text       # loop is driven by the config
    assert "repeat with x from 0 to 4" not in text    # the old hardcoded 5x loop is gone
```

- [ ] **Step 2: Run the test**

Run: `python3 -m pytest tests/test_applescript_sources.py -k click_count -v`
Expected: PASS.

- [ ] **Step 3: Manual verification against a live session (checklist)**

With iPhone Mirroring connected and the Notes highlighter target open (README §0):
- [ ] Run `osascript Calibration.scpt`.
- [ ] Confirm each of the 9 grid cells produces exactly **one** mark/tap (not five).
- [ ] Confirm `~/Desktop/grid_offsets.txt` and `~/Desktop/grid_screenshot.png` are written.
- [ ] Temporarily set `clicksPerCell to 3` in `Calibration.applescript`, recompile (`osacompile -o Calibration.scpt Calibration.applescript`), re-run, confirm 3 taps per cell, then revert to `1` and recompile.

- [ ] **Step 4: Commit**

```bash
git add tests/test_applescript_sources.py
git commit -m "test: lock calibration click count to configurable default of 1"
```

---

## Final Verification

- [ ] **Run the full test suite**

Run: `python3 -m pytest tests -v`
Expected: all tests pass on macOS (osacompile tests run); on non-macOS the osacompile tests are SKIPPED and the pure-Python tests pass.

- [ ] **Confirm no hardcoded Homebrew cliclick paths remain anywhere**

Run: `grep -rn '/opt/homebrew/bin/cliclick' . --include='*.py' --include='*.applescript'`
Expected: no output.

- [ ] **Confirm both `.scpt` files are in sync with their sources**

Run:
```bash
diff <(osadecompile Calibration.scpt) Calibration.applescript && diff <(osadecompile Screenshotter.scpt) Screenshotter.applescript && echo IN_SYNC
```
Expected: `IN_SYNC` (note: osadecompile output may differ in trivial whitespace; if so, re-run `osacompile` from the sources and re-commit the `.scpt`).

- [ ] **Update Project Hub:** mark tasks #1–#8 resolved (see matrix below) via the hub MCP tools or the Project Hub UI.

---

## Project Hub Coverage Matrix

| # | Project Hub task | Priority | Implemented by |
|---|---|---|---|
| 1 | Escape AppleScript special chars in keystroke/type snippets | high | A1, A2, A5, A7 |
| 2 | Fix mismatched OpenCV window name | medium | D1 |
| 3 | Calibration clicks each grid point 5× | medium | B3 (behavior) + C1 (verify/lock) |
| 4 | Hardcoded `/opt/homebrew/bin/cliclick` path | medium | A3 (generated), B3 (calibration); screenshotter has no cliclick |
| 5 | No error handling on cliclick/screencapture | medium | A4, A5 (generated), B2 (screenshotter), B3 (calibration) |
| 6 | `write_header_if_needed` truncates despite its name | low | A7 (`reset_output_file`) |
| 7 | Remove unused imports (numpy, os) | low | D2 |
| 8 | Generated type snippet may keystroke wrong app | medium | A5 (focus re-assert), A7 (wiring) |

## Self-Review Notes

- **Spec coverage:** all 8 Project Hub tasks + all 4 locked decisions map to tasks (matrix above). ✔
- **Type/name consistency:** `applescript_string_literal`, `build_header`, `build_click_snippet`, `build_type_snippet`, `reset_output_file`, `cliclickPath`, `clicksPerCell` are used identically across tasks and tests. ✔
- **No placeholders:** every code step contains complete content; AppleScript files are given in full rather than as diffs (they derive from a compiled binary, so full text is unambiguous). ✔
