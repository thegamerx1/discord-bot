@echo off
set asda=%~dp0
git pull -f
cd %userprofile%\Documents\AutoHotkey\lib
git pull -f
cd /D %asda%