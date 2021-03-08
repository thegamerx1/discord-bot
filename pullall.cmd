@echo off
set asda=%~dp0
git reset --hard
git pull -f
cd lib
git reset --hard
git pull -f
cd ..