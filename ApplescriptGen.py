import cv2
import argparse
import re
import sys

from applescript_builders import build_header, build_click_snippet, build_type_snippet

def parse_calibrated_offsets(file_path):
    """
    Parses the calibrated_offsets.txt file.
    Expected lines include a window size:
      Window Size: (? x ?)
    and lines for cells, e.g.:
      Cell 1,1: (?, ?)
    Returns (winW, winH, cells), where cells is a list of dicts.
    """
    winW = None
    winH = None
    cells = []
    with open(file_path, 'r') as f:
        for line in f:
            size_match = re.search(r"Window Size:\s*\((\d+)\s*x\s*(\d+)\)", line)
            if size_match:
                winW = int(size_match.group(1))
                winH = int(size_match.group(2))
            cell_match = re.search(r"Cell\s+(\d+),(\d+):\s*\((\d+),\s*(\d+)\)", line)
            if cell_match:
                cell = f"{cell_match.group(1)},{cell_match.group(2)}"
                x = int(cell_match.group(3))
                y = int(cell_match.group(4))
                cells.append({'cell': cell, 'x': x, 'y': y})
    return winW, winH, cells

def draw_calibrated_overlay(image, cells):
    """
    Draws blue circles and cell labels on the image for reference.
    """
    overlay = image.copy()
    for cell in cells:
        cv2.circle(overlay, (cell['x'], cell['y']), 8, (255, 0, 0), -1)
        cv2.putText(overlay, cell['cell'], (cell['x'] + 10, cell['y']),
                    cv2.FONT_HERSHEY_SIMPLEX, 0.6, (255, 0, 0), 2)
    return overlay

# Global variables
global_winW = None
global_winH = None
global_scr_w = None
global_scr_h = None
img_display = None
output_file = "GeneratedActions.scpt"

def reset_output_file():
    """Start a fresh GeneratedActions.scpt for this session.

    Truncates any existing file and writes the AppleScript header once. Actions
    are appended during the session as the user clicks.
    """
    with open(output_file, "w") as f:
        f.write(build_header())
    print("Header written to GeneratedActions.scpt")

def mouse_callback(event, x, y, flags, param):
    global img_display, global_winW, global_winH, global_scr_w, global_scr_h, output_file
    if event == cv2.EVENT_LBUTTONDOWN:
        # Convert screenshot coordinates (x,y) to relative window offsets.
        rel_offset_x = int(x * global_winW / global_scr_w)
        rel_offset_y = int(y * global_winH / global_scr_h)
        print(f"Clicked at screenshot coords ({x}, {y}) -> relative offset ({rel_offset_x}, {rel_offset_y})")
        
        action_type = input("Enter action for this point - (c)lick or (t)ype: ").strip().lower()
        snippet = ""
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
        
        # Append the generated snippet to output file.
        with open(output_file, "a") as f:
            f.write(snippet + "\n")
        print("Generated AppleScript snippet:")
        print(snippet)
        
        # Draw a marker on the display image.
        cv2.circle(img_display, (x, y), 10, marker_color, -1)
        cv2.putText(img_display, label, (x + 10, y), cv2.FONT_HERSHEY_SIMPLEX, 0.7, marker_color, 2)
        cv2.imshow("Phone Automation Builder", img_display)

def main():
    global img_display, global_winW, global_winH, global_scr_w, global_scr_h, output_file
    parser = argparse.ArgumentParser(
        description="Phone Automation Builder using calibrated offsets and screenshot."
    )
    parser.add_argument("screenshot", help="Path to the screenshot file")
    parser.add_argument("calibrated_offsets", help="Path to the calibrated_offsets.txt file")
    args = parser.parse_args()
    
    # Write header if needed.
    reset_output_file()
    
    # Load the screenshot image.
    img = cv2.imread(args.screenshot)
    if img is None:
        print("Error: Could not load screenshot.")
        sys.exit(1)
    
    # Parse the calibrated offsets to extract window size and cell data.
    winW, winH, cells = parse_calibrated_offsets(args.calibrated_offsets)
    if winW is None or winH is None:
        print("Error: Could not parse window size from calibrated offsets file.")
        sys.exit(1)
    global_winW = winW
    global_winH = winH
    
    # Get screenshot dimensions.
    global_scr_h, global_scr_w = img.shape[:2]
    
    # Draw the calibrated overlay (blue markers) for reference.
    img_display = draw_calibrated_overlay(img, cells)
    
    cv2.namedWindow("Phone Automation Builder")
    cv2.setMouseCallback("Phone Automation Builder", mouse_callback)
    
    print("Phone Automation Builder:")
    print(" - Click on the image to choose a target point.")
    print(" - Then, in the Terminal, specify whether to (c)lick or (t)ype at that location.")
    print(" - Generated AppleScript snippets (using relative offsets) are appended to 'GeneratedActions.scpt'.")
    print(" - Press 'q' in the window to quit and finish.")
    
    while True:
        cv2.imshow("Phone Automation Builder", img_display)
        key = cv2.waitKey(1) & 0xFF
        if key == ord('q'):
            break
    
    cv2.destroyAllWindows()
    print(f"Final AppleScript saved in '{output_file}'.")

if __name__ == "__main__":
    main()
