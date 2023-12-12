<a name="readme-top"></a>

# AdvDB Homework A2 - Physical Design with ORDERENTRY

-   Group homework from HCMUS's 2023 Advanced Database course.

## Content

All the folders and files are pretty self-explanatory, but here are some notable files,

-   `setupDB.bat` constructs the database and populating all data.
-   `A2_PhysicalDesign_CLC.pdf` contains all the tasks and requirements of the project.
    -   Ain't no way I'm translating all those Vietnamese.
-   `Report.pdf` includes our documentation for all the designs and required tasks.
    -   Had to write in Vietnamese tho...

## Getting Started

### Prerequisites

-   Windows, of course, preferably...
-   SQL Server 2022 Developer and SQL Server Management Studio (SSMS) 19.2.
-   _(Optional)_ Any IDE, preferably VSCode.
    -   It just makes editing the database's source code easier.

### Installation

-   Clone the repo.

## Usage

### To set up the database

1. Start the SQL Server and connect to it.
    - Make sure you have sufficient privileges.
2. Run `setupDB.bat`.
    - The partition files will be stored in the `C` drive, inside a folder named `N03_SQLPartitions`, which is created by `setupDB.bat`.
        - If this storage should be moved, the filepath specified in `setupdDB.bat`, and all `FILENAME` fields in every script belonging to the `partitions` folder need to be updated accordingly.
        - If the `setupDB.bat`'s path is not changed, you need to manually create the new storage folder. Otherwise, **_SQL Server won't generate the folder if it doesn't exist_**.
    - The average time for the setup to complete falls in the range of **_45min to 1h_**. It's possible to manually run each script, however, the execution order in `setupDB.bat` should still be respected.

## Built With

[sqlservericon]: https://upload.wikimedia.org/wikipedia/de/thumb/8/8c/Microsoft_SQL_Server_Logo.svg/90px-Microsoft_SQL_Server_Logo.svg.png
[sqlserverurl]: https://www.microsoft.com/en-us/sql-server/sql-server-downloads
[ssmsicon]: https://i.imgur.com/cIfvzqP.png
[ssmsurl]: https://learn.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms?view=sql-server-ver16
[vscodeicon]: https://skillicons.dev/icons?i=vscode&theme=dark
[vscodeurl]: https://code.visualstudio.com/
[windowsicon]: https://cdn.jsdelivr.net/gh/devicons/devicon/icons/windows8/windows8-original.svg
[windowsurl]: https://www.microsoft.com/en-us/windows/

| [![SQLServer][sqlservericon]][sqlserverurl] | [![SSMS][ssmsicon]][ssmsurl] | [![VSCode][vscodeicon]][vscodeurl] | [![Windows][windowsicon]][windowsurl] |
| :-----------------------------------------: | :--------------------------: | :--------------------------------: | :-----------------------------------: |
|               Developer 2022                |          19.2.56.2           |               1.84.2               |     &nbsp;&nbsp; 11 &nbsp;&nbsp;      |

## Meet The Team

<div align="center">
  <a href="https://github.com/phongan1x5"><img alt="phongan1x5" src="https://github.com/phongan1x5.png" width="60px" height="auto"></a>&nbsp;&nbsp;&nbsp;
  <a href="https://github.com/kru01"><img alt="kru01" src="https://github.com/kru01.png" width="60px" height="auto"></a>&nbsp;&nbsp;&nbsp;
  <a href="https://github.com/faithdanghuy"><img alt="faithdanghuy" src="https://github.com/faithdanghuy.png" width="60px" height="auto"></a>&nbsp;&nbsp;&nbsp;
  <a href="https://github.com/sinful-johnny"><img alt="sinful-johnny" src="https://github.com/sinful-johnny.png" width="60px" height="auto"></a>&nbsp;&nbsp;&nbsp;
  <a href="https://github.com/KyleKennyNelson"><img alt="KyleKennyNelson" src="https://github.com/KyleKennyNelson.png" width="60px" height="auto"></a>&nbsp;&nbsp;&nbsp;
</div>

<p align="right">(<a href="#readme-top">back to top</a>)</p>
