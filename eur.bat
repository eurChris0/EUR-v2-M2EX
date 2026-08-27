@echo off
cd ..\..
IF EXIST m2ex.exe (start m2ex.exe @%0\..\TATW.cfg) ELSE (
IF EXIST kingdoms.exe (start kingdoms.exe @%0\..\TATW.cfg) ELSE (
IF EXIST medieval2.exe (
start medieval2.exe @%0\..\TATW.cfg) ELSE (
    echo ERROR: Cannot find the M2TW or Kingdoms executable.
    echo You probably installed Vanilla Kingdoms 2023 into the wrong folder.
    pause
	)
  )
)