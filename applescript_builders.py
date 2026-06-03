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

    A string made only of newlines/tabs returns the bare ``return``/``tab``
    constant(s) (e.g. ``"\\n"`` -> ``return``). This is intentional and valid:
    ``keystroke return`` types a newline. The result is always a valid
    AppleScript expression usable directly after ``keystroke``.
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


def build_click_snippet(rel_x, rel_y):
    """AppleScript that clicks at (winX+rel_x, winY+rel_y) via cliclick.

    rel_x and rel_y must be ints (they are interpolated into the AppleScript
    source verbatim); callers are responsible for casting.
    """
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


def build_type_snippet(rel_x, rel_y, text):
    """AppleScript that clicks the target, re-asserts focus, then types text.

    Focus is re-asserted immediately before the keystroke so an earlier delay
    or focus change cannot misroute keys to another app (Project Hub #8).

    rel_x and rel_y must be ints (interpolated verbatim); text may contain any
    characters and is escaped via applescript_string_literal.
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
