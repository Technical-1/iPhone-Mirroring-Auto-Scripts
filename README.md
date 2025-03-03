# iPhone-Mirroring-Auto-Scripts

This repository provides a set of scripts designed to automate actions within the **iPhone Mirroring** macOS app by leveraging AppleScript and Python. The main goal is to let you **calibrate** your mirrored iPhone window, then **generate** AppleScript snippets that click or type at coordinates derived from that calibration.

## Scripts Included

1. **calibration.scpt**  
   - An AppleScript that clicks through a grid of points in the mirrored window, logs their relative/absolute coordinates, and takes a screenshot of the window.

2. **screenOffset.py**  
   - A Python script that uses the logged grid offsets to interactively calibrate the screenshot. This produces `calibrated_offsets.txt` describing precise pixel offsets for each cell in the grid.

3. **applescriptgen.py**  
   - A Python script for creating a custom AppleScript file (`GeneratedActions.scpt`) that automates clicks/typing at the calibrated locations you select in the screenshot.

4. **screenshotter.scpt**  
   - An AppleScript that captures a **standardized screenshot** of the iPhone Mirroring window.  
   - Use this if you want consistent, repeatable screenshots for subsequent actions with `applescriptgen.py`.  
   - By ensuring the window is always the same size and position, you can reliably generate scripts that click or type in the right places.

---

## Purpose and Overview

1. **Grid Calibration**  
   - The idea is to capture the mirrored window size and grid offsets for each cell.  
   - `calibration.scpt` systematically clicks at a grid of positions within the iPhone Mirroring app, logs those positions, and takes a screenshot of the window.

2. **Interactive Offset Adjustment**  
   - Next, you feed the screenshot and the click-logging results (`grid_offsets.txt`) into `screenOffset.py`.  
   - It helps you align the grid overlay by moving it, using W/A/S/D keys, until the grid lines up perfectly with the actual iPhone UI in the screenshot.  
   - Then you save those positions to `calibrated_offsets.txt`.

3. **Action Building**  
   - Finally, you use `applescriptgen.py` along with your screenshots and the new `calibrated_offsets.txt`.  
   - This lets you interactively pick points on the screenshot and define actions: click or type.  
   - Each chosen point is converted into an AppleScript snippet (stored in `GeneratedActions.scpt`) that will automatically click or type at the correct coordinates in the mirrored iPhone window.

---

## Requirements

- macOS (for the iPhone Mirroring app and AppleScript)
- [Python 3.x](https://www.python.org/)
- [OpenCV for Python](https://opencv.org/) 
    ```
    pip install opencv-python
    ```
- [cliclick](https://github.com/BlueM/cliclick) installed via Homebrew or similar:  
  ```bash
  brew install cliclick
  ```

---

## How to Use

### 0. Initial Setup (iPhone Mirroring + Notes App)

1. Connect your iPhone to your Mac via the iPhone Mirroring app so that the phone’s screen is visible on your Mac.  
2. On the phone, open the Notes app and create a new note.  
3. Tap the Draw button (or the pencil icon in the toolbar) to open the drawing canvas.  
4. Set the drawing tool to the highlighter and set it to be the largest width and thickness.
5. Leave the note in that state (with the drawing canvas open). This provides a convenient target for calibration and later automation actions.  

### 1. Grid Calibration (AppleScript)

1. Open `calibration.scpt` in Script Editor (or any AppleScript editor).  
2. Run `calibration.scpt`. It will:
   - Bring the “iPhone Mirroring” window to the front.
   - Click through the grid of points.
   - Log absolute and relative coordinates in `grid_offsets.txt` (saved to your Desktop).
   - Take a screenshot of the mirrored window and save it as `grid_screenshot.png` on the Desktop.

### 2. Interactive Calibration (Python)

1. Open a terminal and navigate to the directory containing `screenOffset.py`.  
2. Run (adjust paths as needed):
    ```
    python3 screenOffset.py /path/to/grid_screenshot.png /path/to/grid_offsets.txt
    ```

3. A window named "Calibration Overlay" will appear. Use:
   - W/S to move the overlay up/down
   - A/D to move left/right
   - c to commit and save the final offsets
   - q to quit without saving
4. Once committed, a file called `calibrated_offsets.txt` is created. This file maps each grid cell to precise (x, y) coordinates on the screenshot.

### 3. Taking Screenshots (screenshotter.scpt)

For consistent screenshots to be used in generating scripts:

1. Open `screenshotter.scpt` in Script Editor.  
2. Run the script to capture the iPhone Mirroring window at the current size and position.  
3. A standardized screenshot will be saved (the path may be defined in the script).  
4. Use this screenshot later with `applescriptgen.py` to ensure all offsets match up to a consistent window capture.

### 4. Generating AppleScript Snippets (Python)

1. After you have a screenshot (via `screenshotter.scpt`), run:
    ```
    python3 applescriptgen.py /path/to/screenshot.png /path/to/calibrated_offsets.txt
    ```

2. A window named "Phone Automation Builder" appears. Each time you click in the image:
   - You’ll be prompted in the terminal to choose whether it’s a (c)lick or (t)ype action.
   - For a type action, you’ll type in the text to be typed in the iPhone Mirroring app.
3. Each action is appended to `GeneratedActions.scpt`, which is created (or updated) automatically.
4. Press q in the image window when finished.

### 5. Executing the Generated AppleScript

- Open or double-click `GeneratedActions.scpt` to run it.
- Ensure that "iPhone Mirroring" is open.
- The AppleScript will perform the clicks/typing you specified at the correct coordinates.

---

## Repository Structure

.
 |── calibration.scpt          # AppleScript for grid-based calibration  
 |── screenshotter.scpt        # AppleScript to capture a standardized screenshot  
 |── screenOffset.py           # Python script for interactive offset refinement  
 |── applescriptgen.py         # Python script to build AppleScript snippets  
└── README.md                 # This file  

---

## Notes & Tips

- `screenOffset.py` relies on OpenCV to display and update the overlay. Make sure OpenCV (pip install opencv-python) is installed and available on your system.
- `cliclick` must be installed in /opt/homebrew/bin/cliclick or you must modify the scripts to point to your local installation path.
- If you run into permission issues on macOS (e.g., controlling the screen or simulating clicks), grant the necessary Accessibility and Screen Recording permissions in System Preferences.