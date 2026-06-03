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
