# Project Q&A

## Overview

This is a small macOS toolkit that automates interactions inside Apple's **iPhone Mirroring** app. The mirrored phone is just an opaque window to the Mac — there's no API for tapping a button or typing into it. The toolkit works around that by calibrating the window to a coordinate grid, letting you pick targets on a screenshot, and generating AppleScript that replays clicks and typing against the live window. The interesting engineering is in making generated automation *reliable*: coordinates that survive the window moving, typed text that can't break the script, and a single artifact that runs on both Intel and Apple Silicon.

## Problem Solved

iPhone Mirroring has no scripting interface. If you want to repeat a sequence of taps and text entry on the phone from your Mac, you're stuck doing it by hand. This project bridges that gap: calibrate once, point-and-click to define an action sequence, and get a runnable script that performs it.

## Target Users

- **Tinkerers automating repetitive phone tasks** — anyone who wants to script a fixed sequence of taps/typing on a mirrored iPhone.
- **Mac power users** — people comfortable running AppleScript and granting Accessibility/Screen Recording permissions who want a coordinate-accurate macro tool.

## Key Features

### Grid calibration
Clicks a configurable grid across the mirrored window, logs each point's relative and absolute coordinates, and captures a reference screenshot — the basis for translating screenshot pixels into real clicks.

### Interactive overlay alignment
Overlays the logged grid on the screenshot in an OpenCV window so you can nudge it with WASD until it matches the real UI, accounting for capture scaling and offsets, then saves precise per-cell coordinates.

### Point-and-click action builder
Open a standardized screenshot, click where you want to act, and choose "click" or "type." Each choice is converted to a window-relative offset and appended to a runnable `GeneratedActions.scpt`.

### Resilient generated scripts
Generated scripts re-read the live window position, resolve `cliclick` at runtime, escape arbitrary typed text, and surface clear dialogs on failure.

## Technical Highlights

### Round-tripping screenshot pixels to window coordinates
The captured PNG and the window's logical size aren't 1:1 (Retina scaling, capture framing). `ScreenOffset.py` computes a scale factor and a user-tunable offset to map logged coordinates onto screenshot pixels, and `ApplescriptGen.py` inverts that mapping (`rel = pixel * winSize / screenshotSize`) so a click on the image becomes a correct window-relative offset.

### Escaping arbitrary text into valid AppleScript
Typed text is embedded into AppleScript source, where an unescaped quote or backslash produces a script that won't compile. `applescript_string_literal` in `applescript_builders.py` escapes `\` and `"` and converts newlines/tabs into AppleScript's `return`/`tab` constants joined with `&`, so any input yields a compilable `keystroke` expression. The behavior is locked by unit tests plus an `osacompile` end-to-end compile check.

### Focus re-assertion before typing
A "type" action clicks a target, waits, then sends keystrokes — but a delay or focus change in between can route keys to the wrong app. The generated type snippet re-asserts `set frontmost of process "iPhone Mirroring" to true` immediately before the `keystroke`, so keys land where intended.

### Architecture-agnostic binary resolution
Rather than hardcoding `cliclick`'s Homebrew path, the scripts resolve it at runtime with `command -v cliclick`. The same generated script runs unchanged on Apple Silicon and Intel, and a missing install produces an install hint instead of a cryptic error.

## Engineering Decisions

### Relative offsets over absolute coordinates
- **Constraint**: The mirrored window can move or be reopened between building and running a script.
- **Options**: Bake absolute screen coordinates into the script, or store relative offsets and resolve the origin at run time.
- **Choice**: Store window-relative offsets; re-read the live window origin when the script runs.
- **Why**: Absolute coordinates break on any window move; relative offsets only assume a consistent window size, which the screenshotter enforces.

### Pure builder module over inline generation
- **Constraint**: Generation logic was trapped inside an OpenCV mouse-callback and couldn't be tested.
- **Options**: Test through the GUI somehow, or extract the logic.
- **Choice**: Move escaping and snippet assembly into a dependency-free module.
- **Why**: Pure string-returning functions are directly unit-testable and compile-checkable, separating "is the generated AppleScript correct" from "does the GUI work."

### Text sources compiled to `.scpt`
- **Constraint**: Compiled AppleScript is a binary that can't be diffed or syntax-tested.
- **Options**: Edit the `.scpt` directly in Script Editor, or keep text sources and compile.
- **Choice**: Treat `.applescript` text as the source of truth, compile to `.scpt` with `osacompile`.
- **Why**: Reviewable diffs and automated compile checks, while still shipping the double-clickable script users run.

## Frequently Asked Questions

### How does a click on a screenshot become a click on the phone?
The screenshot pixel is scaled back to a window-relative offset using the window-vs-screenshot size ratio, then at run time that offset is added to the live window origin and clicked with `cliclick`.

### Why does it need `cliclick` instead of pure AppleScript?
AppleScript can read window geometry and send keystrokes reliably, but synthesizing precise mouse clicks at arbitrary coordinates is far more dependable through `cliclick`.

### What permissions does it need?
Accessibility (to read window geometry, set the app frontmost, and send keystrokes) and Screen Recording (for `screencapture`). The scripts show a dialog if a command fails so missing permissions are easy to diagnose.

### Will my generated script break if I move the window?
No — generated scripts read the current window position at run time and use relative offsets, so moving the window is fine. Resizing it is what to avoid; use the screenshotter for a consistent frame.

### Can I type special characters or multi-line text?
Yes. Typed text is escaped before being embedded, and newlines/tabs are converted to AppleScript `return`/`tab`, so quotes, backslashes, and line breaks all generate valid scripts.

### Why does calibration click each point more than once in some setups?
By default each grid point is clicked once. The `clicksPerCell` value at the top of `Calibration.applescript` lets you raise that if your target needs repeated taps to register.

### How do I edit the AppleScript safely?
Edit the `.applescript` text file, then recompile with `osacompile -o Calibration.scpt Calibration.applescript`. The test suite includes compile checks to catch syntax errors.
