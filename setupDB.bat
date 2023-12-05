
@echo off
cls
chcp 65001

REM Init Database
@echo ---- Creating NC03_QLNhaKhoa...
SQLCMD -E -dmaster -f65001 -i".\createDB.sql"

@echo ---- Creating Partitions...
for %%G in (.\partitions\*.sql) do SQLCMD -E -dmaster -f65001 -i"%%G"

@echo ---- Creating Functions...
for %%G in (.\funcs\*.sql) do SQLCMD -E -dmaster -f65001 -i"%%G"

@echo ---- Creating Stored Procedures...
for %%G in (.\storedProcs\*.sql) do SQLCMD -E -dmaster -f65001 -i"%%G"

REM Populating Data
@echo ---- Populating CUSTOMER...
SQLCMD -E -dmaster -f65001 -i".\data\customer.sql"

@echo ---- Populating CREDIT_CARD...
SQLCMD -E -dmaster -f65001 -i".\data\creditCard.sql"

@echo ---- Updating CUSTOMER_PREFERRED_CARD...
SQLCMD -E -dmaster -f65001 -i".\data\updatePreferedCard.sql"

@echo ---- Populating ORDERS...
SQLCMD -E -dmaster -f65001 -i".\data\orders.sql"

@echo ---- Populating ADVERTISED_ITEM...
SQLCMD -E -dmaster -f65001 -i".\data\advertisedItem.sql"

@echo ---- Populating ORDERED_ITEM...
SQLCMD -E -dmaster -f65001 -i".\data\orderedItem.sql"

@echo ---- Populating SUPPLIER...
SQLCMD -E -dmaster -f65001 -i".\data\supplier.sql"

@echo ---- Populating RESTOCK_ITEM...
SQLCMD -E -dmaster -f65001 -i".\data\restockItem.sql"

REM Creating Indices
@echo ---- Creating Indices...
SQLCMD -E -dmaster -f65001 -i".\indices.sql"

PAUSE