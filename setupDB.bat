
@echo off
cls
chcp 65001

@echo ---- Creating NC03_QLNhaKhoa...
SQLCMD -E -dmaster -f65001 -i".\createDB.sql"

@echo ---- Creating Functions...
for %%G in (.\funcs\*.sql) do SQLCMD -E -dmaster -f65001 -i"%%G"

@echo ---- Creating Stored Procedures...
for %%G in (.\storedProcs\*.sql) do SQLCMD -E -dmaster -f65001 -i"%%G"

@echo ---- Populating Data...
for %%G in (.\data\*.sql) do SQLCMD -E -dmaster -f65001 -i"%%G"

PAUSE