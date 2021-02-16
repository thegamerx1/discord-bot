@echo off
set asda=%~dp0
git reset --hard
git pull -f
cd %userprofile%\Documents\AutoHotkey\lib
git reset --hard
git pull -f
cd /D %asda%