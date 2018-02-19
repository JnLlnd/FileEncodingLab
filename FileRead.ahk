#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance force
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


FileEncoding ; Empty or omitted: the system default ASCII/ANSI code page, which is also the default setting.
; FileEncoding, UTF-8 ; UTF-8: Unicode UTF-8, equivalent to CP65001.
; FileEncoding, UTF-16 ; UTF-16: Unicode UTF-16 with little endian byte order, equivalent to CP1200.
; FileEncoding, UTF-8-RAW ; As UTF-8, but no byte order mark is written when a new file is created.
; FileEncoding, UTF-16-RAW ; As UTF-16, but no byte order mark is written when a new file is created.
; FileEncoding, CP1251 ; CPnnn: a code page with numeric identifier nnn. See Code Page Identifiers.

strFileName := "Demo-UTF-16.txt"
; strFileName := "Demo-UTF-16-No_BOM.txt"

IfWinNotExist, %strFileName%
{
	Run, Examples\%strFilename%
	Sleep, 100
	MsgBox, Check the file and click OK`nto see the same file read by AHK...
}

FileRead, OutputVar, Examples\%strFilename%

Gui, Font, s16, Courier New
Gui, Add, Edit, w800 h400 ReadOnly vMyEdit
Gui, Add, Button, Default vClose, Close
GuiControl, Focus, Close
GuiControl, , MyEdit, %OutputVar%
Gui, Show

return

ButtonClose:
ExitApp
