@echo off
set abv=c:\Program Files (x86)\Firebird\Firebird_2_5\bin\bin\
set avb=%CD%\DATA
rm set avb=%CD%
set log=%avb%\backup.log
if Exist %log% del %log%
c:
cd %abv%
rm echo.%avb%\%2
set str=%avb%\%2
set str=%str:_r=%
set name=%2
set name=%name:_r=%
rm echo.%str%
gbak.exe -c -user sysdba -pass masterkey %avb%\%1 %avb%\%2 -v -y %avb%\backup.log
del %str%
rename %avb%\%2 %name%
pause