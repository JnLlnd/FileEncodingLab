#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance force
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; Empty or omitted: the system default ANSI code page, which is also the default setting.
; UTF-8: Unicode UTF-8, equivalent to CP65001.
; UTF-16: Unicode UTF-16 with little endian byte order, equivalent to CP1200.
; UTF-8-RAW or UTF-16-RAW: As above, but no byte order mark is written when a new file is created.
; CPnnn: a code page with numeric identifier nnn. See Code Page Identifiers.

FileEncoding ; empty = ASCII/ANSI
; FileEncoding, UTF-8
; FileEncoding, UTF-16
; FileEncoding, UTF-16-RAW
; FileEncoding, UTF-8-RAW

strFileName := "QAP-ES-UTF-16-No_BOM.txt"
; strFileName := "QAP-ES-UTF-16.txt"

IfWinNotExist, %strFileName%
{
	Run, Examples\%strFilename%
	Sleep, 100
	MsgBox, Check the file and click OK`nto see the same file read by AHK...
}

FileRead, OutputVar, Examples\%strFilename%

Gui, Font, s18, Courier New
Gui, Add, Edit, w800 h400 ReadOnly vMyEdit
Gui, Add, Button, Default vClose, Close
GuiControl, Focus, Close
GuiControl, , MyEdit, %OutputVar%
Gui, Show

return

ButtonClose:
ExitApp
