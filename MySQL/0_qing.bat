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
SET sqlpath=%~dp0

ECHO.
ECHO starting process sql files...

ECHO.
ECHO create database...
mysql -h%dbhost% -u%dbuser% -p%dbpasswd% < %sqlpath%/1_create_database.sql

ECHO.
ECHO create users...
mysql -h%dbhost% -u%dbuser% -p%dbpasswd% < %sqlpath%/2_create_users.sql

ECHO.
ECHO create tables...
mysql -h%dbhost% -u%dbuser% -p%dbpasswd%  -D %dbname% < %sqlpath%/3_create_tables.sql

ECHO.
ECHO finished
PAUSE
