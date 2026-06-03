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


def test_only_newline_is_bare_return_constant():
    # `return` is the AppleScript carriage-return constant; `keystroke return`
    # is valid and types a newline. Locking this so it is never "fixed" into
    # an empty-quote-prefixed expression.
    assert applescript_string_literal("\n") == "return"


def test_only_tab_is_bare_tab_constant():
    assert applescript_string_literal("\t") == "tab"


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


from applescript_builders import build_click_snippet


def test_click_snippet_uses_offsets_and_resolved_path():
    s = build_click_snippet(120, 340)
    assert "set actionOffsetX to 120" in s
    assert "set actionOffsetY to 340" in s
    assert "cliclickPath & \" c:\"" in s
    # cliclick failures must not abort the run silently
    assert "on error errMsg" in s
    assert "display dialog" in s


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
