
@echo off
cls
chcp 65001

REM Init Database
@echo ---- Creating NC03_QLNhaKhoa...
SQLCMD -E -dmaster -f65001 -i".\createDB.sql"

@echo ---- Creating Partitions...
if not exist "C:\N03_SQLPartitions" (
    md "C:\N03_SQLPartitions"
    @echo Successfully created N03_SQLPartitions folder in C drive.
)
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

@echo ---- Updating CUSTOMER_PREFERRED_CARD...
SQLCMD -E -dmaster -f65001 -i".\data\updatePreferedCard.sql"

REM Creating Indices
@echo ---- Creating Indices...
SQLCMD -E -dmaster -f65001 -i".\indices.sql"

PAUSE