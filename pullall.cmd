@echo off
set asda=%~dp0
git fetch --all
git reset --hard
cd %userprofile%\Documents\AutoHotkey\lib
git fetch --all
git reset --hard
cd /D %asda%