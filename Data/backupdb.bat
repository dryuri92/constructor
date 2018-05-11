@echo
set abv=c:\Program Files (x86)\Firebird\Firebird_2_5\bin\bin\
set avb=%CD%\data\
c:
cd %abv%
gbak.exe -b -g -user SYSDBA -pass masterkey localhost:%avb%\%1 %avb%\%2 -v
pause