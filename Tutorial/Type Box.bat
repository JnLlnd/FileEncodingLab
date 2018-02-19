@cls
@echo Changing the DOS command window to code page 1252 (Windows Latin 1 - ANSI)
chcp 1252
@pause
type box-cp437.txt
@pause
@echo Changing to code page 437 (MS DOS Latin US - Extended ASCII)
chcp 437
@pause
type box-cp437.txt
@pause
