@ECHO OFF

ECHO Input database host:
SET /p dbhost=

ECHO.
ECHO Input database user:
SET /p dbuser=

ECHO.
ECHO Input database password:
SET /p dbpasswd=

SET dbname=Qing

ECHO.
ECHO starting process sql files...

ECHO.
sqlcmd -S %dbhost% -U %dbuser% -P %dbpasswd% -i "1_create_database.sql"

ECHO.
sqlcmd -S %dbhost% -U %dbuser% -P %dbpasswd% -i "2_create_users.sql"

ECHO.
sqlcmd -S %dbhost% -U %dbuser% -P %dbpasswd% -d %dbname% -i "3_create_tables.sql"

ECHO.
ECHO finished
PAUSE
