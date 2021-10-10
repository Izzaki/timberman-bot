#NoEnv
SendMode Input
SetKeyDelay, -1, -1

#include modules/Memory.ahk

WinGet, pid, PID, ahk_exe TimbermanVS.exe
hwnd := MemoryOpenFromPID(PID)
last := "{left}"
delay := 250

; addresses
mono := 0x10000000
monoOffset := 0x001F5680

; Gui, Show, w200 h200
; Gui, Add, Text,, Delay: 
; Gui, Add, Text, vspeed, %delay%

$^r::
	MemoryClose(hwnd)
	Reload
return

$NumpadAdd::
	delay := Max(delay - 10, 21)
	; if (delay > 30) {
	; 	delay := Max(delay - 10, 30)
	; } else {
	; 	delay := Max(delay - 1, 0)
	; }
	; GuiControl,,speed, %delay%
return

$NumpadSub::
	delay := delay + 10
	; GuiControl,,speed, %delay%
return


#IfWinActive, ahk_exe TimbermanVS.exe
$^1::

	; normal
	pointerLastAddress := MemoryReadPointer(hwnd, mono + monoOffset, "int", 4, 5, 0x28, 0x58, 0x30, 0x18, 0x8)
	address := pointerLastAddress + 0x14

	; race
	; pointerLastAddress := MemoryReadPointer(hwnd, mono + 0x001F50AC, "int", 4, 6, 0x264, 0x68, 0x19C, 0x1B0, 0x108, 8)
	; address := pointerLastAddress + 0x14

	loop {
		value := MemoryRead(hwnd, address, "int", 1)

		;0 - branch is on the left
		;1 - branch is on the right
		;255 - tree without branches
		if (value == 0) {
			last := "{right}"
		} else if (value == 1) {
			last := "{left}"
		}

		send, %last%
		sleep, %delay%
	}
return
