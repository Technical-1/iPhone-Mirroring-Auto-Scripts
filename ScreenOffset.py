#!/usr/bin/env python3
import cv2
import re
import argparse
import sys
import os

def parse_grid_offsets(log_file):
    """
    Reads the grid offsets log file and extracts:
      - Window Size: (winW x winH)
      - Each cell's Relative (rx, ry) coordinate and (row,col)
    Returns (winW, winH, cells) where cells is a list of dicts:
      { 'row': int, 'col': int, 'relX': float, 'relY': float }
    """
    winW = None
    winH = None
    cells = []
    
    with open(log_file, 'r') as f:
        for line in f:
            size_match = re.search(r"Window Size:\s*\((\d+)\s*x\s*(\d+)\)", line)
            if size_match:
                winW = int(size_match.group(1))
                winH = int(size_match.group(2))
            cell_match = re.search(
                r"Cell\s+(\d+),(\d+):\s+Relative\s+\((\d+),\s*(\d+)\)",
                line
            )
            if cell_match:
                colIndex = int(cell_match.group(1))
                rowIndex = int(cell_match.group(2))
                rx = float(cell_match.group(3))
                ry = float(cell_match.group(4))
                cells.append({
                    'row': rowIndex,
                    'col': colIndex,
                    'relX': rx,
                    'relY': ry
                })
    
    return winW, winH, cells

def draw_overlay(image, cells, scale_x, scale_y, offset_x=0, offset_y=0):
    """
    Draws green circles and cell labels on a copy of the image.
    Applies scaling and an additional (x,y) offset.
    """
    overlay = image.copy()
    for cell in cells:
        relX = cell['relX']
        relY = cell['relY']
        drawX = int(relX * scale_x + offset_x)
        drawY = int(relY * scale_y + offset_y)
        cv2.circle(overlay, (drawX, drawY), 15, (0, 255, 0), -1)
        label = f"{cell['col']},{cell['row']}"
        cv2.putText(overlay, label, (drawX + 10, drawY),
                    cv2.FONT_HERSHEY_SIMPLEX, 0.7, (0, 255, 0), 2)
    return overlay

def interactive_calibration(screenshot_path, log_file):
    # Load screenshot image.
    image = cv2.imread(screenshot_path)
    if image is None:
        print("Error loading screenshot.")
        sys.exit(1)
    
    # Parse grid offsets from log.
    winW, winH, cells = parse_grid_offsets(log_file)
    if winW is None or winH is None or not cells:
        print("Error: Could not parse grid offsets from log file.")
        sys.exit(1)
    
    # Determine scale based on the screenshot and window size.
    scr_h, scr_w = image.shape[:2]
    scale_x = scr_w / float(winW)
    scale_y = scr_h / float(winH)
    
    # Offsets to adjust the overlay.
    offset_x = 0
    offset_y = 0
    
    print("Interactive Calibration:")
    print("Use WASD keys to adjust the overlay offset:")
    print("  W: move up")
    print("  S: move down")
    print("  A: move left")
    print("  D: move right")
    print("Press 'c' to commit calibration and save offsets, or 'q' to quit without saving.")
    
    while True:
        overlay = draw_overlay(image, cells, scale_x, scale_y, offset_x, offset_y)
        cv2.imshow("Calibration Overlay", overlay)
        key = cv2.waitKey(0) & 0xFF
        if key == ord('q'):
            print("Exiting calibration without saving.")
            break
        elif key == ord('c'):
            print("Calibration committed.")
            # Generate calibrated offsets (in screenshot coordinates) for each cell.
            calibrated_offsets = []
            for cell in cells:
                new_x = int(cell['relX'] * scale_x + offset_x)
                new_y = int(cell['relY'] * scale_y + offset_y)
                calibrated_offsets.append({'col': cell['col'], 'row': cell['row'], 'x': new_x, 'y': new_y})
            with open("calibrated_offsets.txt", "w") as f:
                # Write the window size line first.
                f.write(f"Window Size: ({winW} x {winH})\n")
                # Write each cell's calibrated offsets.
                for co in calibrated_offsets:
                    f.write(f"Cell {co['col']},{co['row']}: ({co['x']}, {co['y']})\n")
            print("Calibrated offsets saved to calibrated_offsets.txt")
            break
        elif key == ord('w'):
            offset_y -= 1
        elif key == ord('s'):
            offset_y += 1
        elif key == ord('a'):
            offset_x -= 1
        elif key == ord('d'):
            offset_x += 1
        else:
            print("Key not recognized. Use WASD to adjust, 'c' to commit, 'q' to quit.")
    
    cv2.destroyAllWindows()

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Interactive calibration of grid offsets.")
    parser.add_argument("screenshot", help="Path to the screenshot file")
    parser.add_argument("logfile", help="Path to the grid offsets log file")
    args = parser.parse_args()
    interactive_calibration(args.screenshot, args.logfile)
