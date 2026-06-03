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

set screenshotFile to (POSIX path of (path to desktop)) & "new_screenshot.png"

-- Capture the window region using the 'screencapture' command.
set captureCmd to "screencapture -R" & winX & "," & winY & "," & winW & "," & winH & " " & quoted form of screenshotFile
try
	do shell script captureCmd
on error errMsg
	display dialog "screencapture failed (check Screen Recording permission): " & errMsg buttons {"OK"} default button "OK"
end try
