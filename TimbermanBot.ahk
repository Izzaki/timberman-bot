/**
	Bot for TimbermanVS version: 23.08.2020
	
	Usage:
	Ctrl+1 			Start
	Ctrl+r 			Stop & Reload
	Numpad+ 	Increase speed
	Numpad- 	Decrease speed
*/

#NoEnv
SendMode Input
SetKeyDelay, -1, -1

#include modules/Memory.ahk

WinGet, pid, PID, ahk_exe TimbermanVS.exe
hwnd := MemoryOpenFromPID(PID)

hotkey := "{left}"
delay := 250

mono := 0x10000000
monoOffset := 0x001F5680

BranchFlag := {}
BranchFlag.LEFT := 0
BranchFlag.RIGHT := 1
BranchFlag.MISSING := 255

$^r::
	MemoryClose(hwnd)
	Reload
return

$NumpadAdd::
	delay := Max(delay - 10, 21)
return

$NumpadSub::
	delay := delay + 10
return

#IfWinActive, ahk_exe TimbermanVS.exe
$^1::
	; normal mode
	branch := MemoryReadPointer(hwnd, mono + monoOffset, "int", 4, 5, 0x28, 0x58, 0x30, 0x18, 0x8)
	branchFlag := branch + 0x14

	loop {
		branchFlag := MemoryRead(hwnd, address, "int", 1)

		if (branchFlag == BranchFlag.LEFT) {
			hotkey := "{right}"
		} else if (branchFlag == BranchFlag.RIGHT) {
			hotkey := "{left}"
		}

		send, %hotkey%
		sleep, %delay%
	}
return
