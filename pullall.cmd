@echo off
git fetch origin master
git reset --hard FETCH_HEAD
cd %userprofile%\Documents\AutoHotkey\lib
git fetch origin master
git reset --hard FETCH_HEAD
cd %userprofile%\Documents\disco\discord-bot
