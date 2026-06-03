# Tech Stack

## Core Technologies

| Category | Technology | Version | Why this choice |
|----------|------------|---------|-----------------|
| Automation language | AppleScript | macOS system | The only practical way to read iPhone Mirroring window geometry and drive System Events |
| Scripting language | Python | 3.x | Fast iteration for the interactive OpenCV tooling and string generation |
| Click synthesis | cliclick | Homebrew | Sends real mouse clicks at absolute coordinates, which AppleScript alone can't reliably do |
| Image/UI | OpenCV (`opencv-python`) | latest | Lightweight window + overlay rendering for interactive calibration |

## Backend / Runtime

- **Platform**: macOS (depends on the iPhone Mirroring app, System Events, and `screencapture`)
- **Execution model**: Two AppleScript entry points (`Calibration.scpt`, `Screenshotter.scpt`) plus a generated `GeneratedActions.scpt`, orchestrated by two Python tools
- **Permissions**: Accessibility (control + keystrokes) and Screen Recording (window capture)

## Development Tools

- **Package Manager**: pip
- **Testing**: pytest — unit tests for the pure snippet builders, plus `osacompile` checks that generated/edited AppleScript actually compiles
- **AppleScript build**: `osacompile` / `osadecompile` to compile text sources to `.scpt` and back

## Key Dependencies

| Package | Purpose |
|---------|---------|
| `opencv-python` | Renders screenshots and the interactive calibration/action-builder windows |
| `cliclick` | Performs the actual clicks at computed screen coordinates |
| `pytest` (dev) | Runs the builder unit tests and AppleScript compile checks |

## Notable absence of dependencies

`applescript_builders.py` deliberately imports nothing beyond the standard library. Keeping the generation logic dependency-free is what allows it to be unit-tested without spinning up OpenCV or any GUI.
