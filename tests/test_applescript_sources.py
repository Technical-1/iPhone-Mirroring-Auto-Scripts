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


def test_calibration_click_count_is_configurable_and_defaults_to_one():
    text = (REPO_ROOT / "Calibration.applescript").read_text()
    assert "set clicksPerCell to 1" in text          # default is a single click
    assert "repeat clicksPerCell times" in text       # loop is driven by the config
    assert "repeat with x from 0 to 4" not in text    # the old hardcoded 5x loop is gone
