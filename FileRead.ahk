#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance force
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; UTF-8: Unicode UTF-8, equivalent to CP65001.
; UTF-16: Unicode UTF-16 with little endian byte order, equivalent to CP1200.
; UTF-8-RAW or UTF-16-RAW: As above, but no byte order mark is written when a new file is created.
; CPnnn: a code page with numeric identifier nnn. See Code Page Identifiers.
; Empty or omitted: the system default ANSI code page, which is also the default setting.
FileEncoding, UTF-8

FileRead, OutputVar, UTF-8.txt

MsgBox, %OutputVar%
