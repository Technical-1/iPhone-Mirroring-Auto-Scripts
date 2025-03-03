tell application "System Events"
    tell process "iPhone Mirroring"
        set frontmost to true
        set {winX, winY} to position of UI element 1
    end tell
end tell

set actionOffsetX to 109
set actionOffsetY to 239

set clickX to winX + actionOffsetX
set clickY to winY + actionOffsetY

do shell script "/opt/homebrew/bin/cliclick c:" & (clickX as integer) & "," & (clickY as integer)
delay 0.5
tell application "System Events"
    keystroke "boom"
    delay 0.5
end tell

