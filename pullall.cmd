@echo off
echo BOT
git reset --hard
git pull -f
echo LIB
cd %userprofile%/documents/Autohotkey/lib
git reset --hard
git pull -f