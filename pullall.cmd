@echo off
set asda=%~dp0
git reset --hard origin/master
git pull origin master
cd %userprofile%\Documents\AutoHotkey\lib
git fetch --all
git reset --hard origin/master
cd /D %asda%