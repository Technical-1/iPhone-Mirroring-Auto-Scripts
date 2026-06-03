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


@requires_osacompile
def test_type_snippet_with_only_whitespace_compiles(tmp_path):
    # Text that is only a newline / only a tab emits a bare return/tab
    # constant; confirm `keystroke return` style still compiles end-to-end.
    script = (
        build_header()
        + build_type_snippet(0, 0, "\n")
        + "\n"
        + build_type_snippet(0, 0, "\t")
    )
    src = tmp_path / "ws.applescript"
    src.write_text(script)
    out = tmp_path / "ws.scpt"
    result = subprocess.run(
        [osacompile, "-o", str(out), str(src)],
        capture_output=True,
        text=True,
    )
    assert result.returncode == 0, result.stderr
