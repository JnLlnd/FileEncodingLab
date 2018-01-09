﻿;============================================================
/*
File Encoding Explorer
Written using AutoHotkey v1.1.26.01 (http://www.ahkscript.org/)
By JnLlnd on AHK forum

Copyright 2017 Jean Lalonde
--------------------------------
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

Version history
---------------

2018-01-03 v1.0

*/
;============================================================

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance force
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

;------------------------------------------------------------
; Build Gui 1

Gui, Add, ListView, r20 w150 vf_lvDataFile, Pos|Dec|Hexa|Value
Gui, Font, s12, Courier
Gui, Add, Edit, yp x+20 h369 w700 vf_Edit ReadOnly 
gui, Font
Gui, Add, Button, x10 gLoadFile, Load another file
Gui, Font, w700
Gui, Add, Text, yp x180 w700 vf_Filename gOpenInNotepad
Gui, Font
Gui, Add, Text, y+2 x180 gOpenInNotepad, (open in Notepad)
Gui, Add, Button, gReference x10, Reference
Gui, Add, Button, gCancel yp x+10, Close
Gui, Add, Text, yp x180, Encoding detected: 
Gui, Add, Edit, yp x+10 w60 vf_Detected ReadOnly 
Gui, Add, Text, yp x+20, If UTF not detected, load as:
Gui, Add, DropDownList, yp x+10 w85 vf_strFileEncoding gLoadFileEncoded, ANSI|UTF-8|UTF-16|UTF-8-RAW|UTF-16-RAW|CP1252|CP437|CP863
Gui, Show

gosub, LoadFile
; gosub, Reference

return
;============================================================


;------------------------------------------------------------
LoadFile:
;------------------------------------------------------------

if !StrLen(strTextFileName)
	; first time open this file
	strTextFileName := A_ScriptDir . "\ASCII.txt"
else
	FileSelectFile, strTextFileName, 3, %A_ScriptDir%, , Text Files (*.txt)

if !StrLen(strTextFileName)
	return

LV_Delete()
gosub, Display
gosub, LoadFileEncoded

return
;------------------------------------------------------------


;------------------------------------------------------------
Display:
;------------------------------------------------------------

f := FileOpen(strTextFileName, "r")

GuiControl, , f_Filename, %strTextFileName%
GuiControl, , f_Detected, % f.Encoding
GuiControl, % (InStr(f.Encoding, "UTF") ? "Disable" : "Enable"), f_strFileEncoding
f.Seek(0, 0) ; to include BOM when file has one
Loop, 20
{
	int := f.RawRead(strRead, 1)
	if !(int)
		break
	LV_Add(, Format("{:02d}", A_Index), Format("{:03d}", Asc(strRead)), Format("{:02X}", Asc(strRead)), strRead)
}
GuiControl, 1:ChooseString, f_strFileEncoding, % (StrLen(f.Encoding) ? f.Encoding : "ANSI")
GuiControl, 1:Focus, f_strFileEncoding

return
;------------------------------------------------------------


;------------------------------------------------------------
LoadFileEncoded:
;------------------------------------------------------------
Gui, Submit, NoHide

strEncoding := f_strFileEncoding
if (strEncoding = "ANSI")
	strEncoding := ""
; ###_V("", f.Encoding, f_strFileEncoding, strEncoding, A_FileEncoding)

FileEncoding, %strEncoding%
GuiControl, , f_Edit, %A_Space%
Sleep, 50
FileRead, strFull, %strTextFileName%
GuiControl, , f_Edit, %strFull%

return
;------------------------------------------------------------


;------------------------------------------------------------
OpenInNotepad:
;------------------------------------------------------------
Gui, Submit, NoHide

Run, % "Notepad.exe """ . strTextFileName . """"

return
;------------------------------------------------------------


;------------------------------------------------------------
Reference:
;------------------------------------------------------------

strWidth := "120|120|120|180|240|400"
StringSplit, arrWidth, strWidth, |
Loop, % arrWidth%0%
	intTotalWidth += arrWidth%A_Index% + 10

strReference = 
(
Encoding|AHK Encoding|Notepad label|Header|Char length|Notes
ASCII|Empty or omitted|ANSI|(none)|1 byte (8 bits) per char|US-ASCII -  7-bit - no chars over Chr(127)`t(see: <a href="http://www.asciitable.com/">http://www.asciitable.com/</a>)
ANSI|Empty or omitted|ANSI|(none)|1 byte (8 bits) per char|Also called "Extended ASCII" - 8-bit - with additional chars from Chr(128) to Chr(255), chars displayed depending on system locale.`tSee DOS command CHCP.`tThere are more than 220 MS-DOS and Windows code pages (or locales). Some examples:`t• CP1252: Windows Latin 1 - ANSI`t• CP437: MS DOS Latin US (same as Extended ASCII)`t• CP863: MS DOS French Canada`t•CP10000: Macintosh Roman`t(see: <a href="https://msdn.microsoft.com/en-us/library/cc195051.aspx">https://msdn.microsoft.com/en-us/library/cc195051.aspx</a>)
Unicode UTF-8|UTF-8|UTF-8|EF BB BF`tï»¿|1 to 4 bytes per char, depending on the Unicode code point of the char|see: <a href="https://en.wikipedia.org/wiki/UTF-8">https://en.wikipedia.org/wiki/UTF-8</a>
Unicode UTF-8 No BOM|UTF-8-RAW|n/a|(none)|Same as above|No byte order mark (BOM)`tMany UTF-8 files have no BOM, especially if they originated on non-Windows systems.
Unicode UTF-16 Little Endian|UTF-16|Unicode|FF FE`tÿþ|1 or 2 x 2 bytes (16-bit), depending on the Unicode code point of the char|
Unicode UTF-16 Big Endian|n/a|Unicode big endian|FE FF`tþÿ|1 or 2 x 2 bytes (16-bit), depending on the Unicode code point of the char|
Unicode UTF-16 No BOM|UTF-16-RAW|n/a|(none)|Same as above|No byte order mark (BOM)
UTF-32|n/a|n/a|00 00 FE FF (for Big Endian)`tFF FE 00 00 (for Little Endian).|exactly 4 bytes (32-bit) per Unicode code point|fixed-length encoding
)
StringSplit, arrRowsReference, strReference, `n

Gui, 2:Default
Gui, Font, s12 w700
Gui, Add, Text, x10 y10, File Encoding Reference
Gui, Font

intH := 40
Loop, % arrRowsReference%0%
{
	intRow := A_Index
	StringSplit, arrColsReference%intRow%, arrRowsReference%A_Index%, |
	intH += intMaxH + 5
	if (intRow > 1)
		Gui, Add, Text, % "x10 y" . intH . " w" . intTotalWidth . " 0x10"
	intH += 5
	Loop, % arrColsReference%intRow%%0%
	{
		if (intRow = 1 or A_Index = 1)
			Gui, Font, s10 w700
		else
			Gui, Font, s10 w500
		Gui, Add, Link, % (A_Index = 1 ? "x10 y" . intH : "x+10 yp") . " w" . arrWidth%A_Index% . " vf_cell" . intRow . "_" . A_Index, % StrReplace(arrColsReference%intRow%%A_Index%, "`t", "`n")
		GuiControlGet, arrPos, Pos, % "f_cell" . intRow . "_" . A_Index
		if (A_Index = 1)
			intMaxH := 0
		if (arrPosH > intMaxH)
			intMaxH := arrPosH
	}

}
Gui, Font, w700
Gui, Add, Link, x10 y+30, Glossary (<a href="http://unicode.org/glossary/">http://unicode.org/glossary/</a>)
Gui, Font, s10 w500
Gui, Add, Text, x10 y+5, ASCII (American Standard Code for Information Interchange): a 7-bit coded character set for information interchange, set of 128 Unicode characters from 0 to 127, including control codes and graphic characters.`nANSI (American National Standards Institute): collective name for all Windows code pages. Sometimes used specifically for code page 1252.`nBOM (Byte Order Mark): used to indicate the byte order of a text, highest valued byte for a character first (little endian) or last (big endian) in the bytes sequence.`nCP (Code Page): A coded character set, often referring to set used by a PC, for example, PC code page 437 is the default coded character set used by the U.S. English version of the DOS operating system.`nCode Point: any value in the Unicode range of numerical values available for encoding characters (for the Unicode Standard, a range of integers from 0 to 10FFFF

Gui, Show

Gui, 1:Default

return
;------------------------------------------------------------

LaunchWebPage:
; Run, 
return


;------------------------------------------------------------
2GuiClose:
;------------------------------------------------------------

Gui, 2:Destroy

return
;------------------------------------------------------------


;------------------------------------------------------------
Cancel:
;------------------------------------------------------------

ExitApp
;------------------------------------------------------------