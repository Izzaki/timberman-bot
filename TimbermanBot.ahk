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


;0 - branch is on the left
;1 - branch is on the right
;255 - empty

; Gui, Show, w200 h200
; Gui, Add, Text,, Delay: 
; Gui, Add, Text, vspeed, %delay%

$^r::
	MemoryClose(hwnd)
	Reload
return

$^2::
	pointerLastAddress := MemoryReadPointer(hwnd, mono + monoOffset, "int", 4, 5, 0x28, 0x58, 0x30, 0x18, 0x8)
	value := MemoryRead(hwnd, pointerLastAddress, "int", 1, 0x14)
	msgbox 0x%pointerLastAddress%: %value%
return

$^3::
	ControlSend,,{up down}, ahk_exe TimbermanVS.exe
	sleep 100
	ControlSend,,{up up}, ahk_exe TimbermanVS.exe
return

$NumpadAdd::
	delay := Max(delay - 10, 30)
	; GuiControl,,speed, %delay%
return

$NumpadSub::
	delay := delay + 10
	; GuiControl,,speed, %delay%
return


#IfWinActive, ahk_exe TimbermanVS.exe
$^1::
	pointerLastAddress := MemoryReadPointer(hwnd, mono + monoOffset, "int", 4, 5, 0x28, 0x58, 0x30, 0x18, 0x8)
	address := pointerLastAddress + 0x14

	loop {
		value := MemoryRead(hwnd, address, "int", 1)

		if (value == 0) {
			last := "{right}"
		} else if (value == 1) {
			last := "{left}"
		}

		send, %last%
		sleep, %delay%
	}
return
