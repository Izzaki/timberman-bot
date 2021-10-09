#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.

position :={x:848, y:540}
positionX := position.x
positionY := position.y

endPosition :={x:850, y:620}
endPositionX := endPosition.x
endPositionY := endPosition.y

r_position :={x:1068, y:540}
r_positionX := r_position.x
r_positionY := r_position.y

r_endPosition :={x:1070, y:620}
r_endPositionX := r_endPosition.x
r_endPositionY := r_endPosition.y

last:="{left}"

$^r::
Reload
return

#IfWinActive,ahk_exe TimbermanVS.exe

$^1::

loop {
	; PixelGetColor, pixelColor, positionX, positionY
	PixelSearch, foundPixelX, foundPixelY, positionX, positionY, endPositionX, endPositionY, 0x000000, 30, Fast
	PixelSearch, r_foundPixelX, r_foundPixelY, r_positionX, r_positionY, r_endPositionX, r_endPositionY, 0x000000, 30, Fast

	; NoActivate
	width := endPositionX - positionX
	height := endPositionY - positionY

	; Gui, Show, x%positionX% y%positionY% w200 h%height%, elo
	; Gui, Add, Text,, coords: %foundPixelX% %foundPixelY%
	; Gui, Add, Text, c%pixelColor%, %pixelColor%

	; Gui, Show, x%r_positionX% y%r_positionY% w200 h%height%, elo
	; Gui, Add, Text,, coords: %r_foundPixelX% %r_foundPixelY%
	; Gui, Add, Text, c%pixelColor%, %pixelColor%

	if (foundPixelX > 0 && foundPixelY > 0) {
		send, {right}
		last := "{right}"
	} else if (r_foundPixelX > 0 && r_foundPixelX > 0) {
		send, {left}
		last := "{left}"
	} else {
		send %last%
	}

	sleep 120
}
return
