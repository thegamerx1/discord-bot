@echo off
cd ..
git reset --hard
git pull -f

cd %userprofile%/documents/Autohotkey/lib
git reset --hard
git pull -f