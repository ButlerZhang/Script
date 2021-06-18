@echo 创建数据库

@echo 读取数据库参数配置
for /f "skip=1 tokens=1,2,3,4,5" %%a in (database.txt) do (
  echo dbname=%%a
  echo sys_user=%%b
  echo sys_passwd=%%c
  echo new_user=%%d
  echo new_passwd=%%e
  set dbname=%%a
  set sys_user=%%b
  set sys_passwd=%%c
  set new_user=%%d
  set new_passwd=%%e
  )

@echo off
@REM 定义变量
set new_tablespace=BUTLER_TABLESPACE
set oracle_sql_file=create_database.sql
set oracle_data_file=C:\ProgramFiles\oradata\orcl\BUTLER.DBF

@REM 连接系统数据库用于创建表空间和用户
@echo CONNECT %sys_user%/%sys_passwd%@%dbname% AS SYSDBA;>>%oracle_sql_file%

@REM 删除旧的表空间和用户
@echo DECLARE>>%oracle_sql_file%
@echo    counter NUMBER;>>%oracle_sql_file%
@echo BEGIN>>%oracle_sql_file%

@echo    SELECT count(*) INTO counter FROM dba_tablespaces WHERE tablespace_name = '%new_tablespace%';>>%oracle_sql_file%
@echo    IF counter ^> 0 THEN>>%oracle_sql_file%
@echo    BEGIN>>%oracle_sql_file%
@echo       EXECUTE IMMEDIATE 'DROP TABLESPACE %new_tablespace% INCLUDING CONTENTS AND DATAFILES CASCADE CONSTRAINTS';>>%oracle_sql_file%
@echo    END;>>%oracle_sql_file%
@echo    END IF;>>%oracle_sql_file%

@echo    SELECT count(*) INTO counter FROM dba_users WHERE username = '%new_user%';>>%oracle_sql_file%
@echo    IF counter ^> 0 THEN>>%oracle_sql_file%
@echo    BEGIN>>%oracle_sql_file%
@echo       EXECUTE IMMEDIATE 'DROP USER %new_user% CASCADE';>>%oracle_sql_file%
@echo    END;>>%oracle_sql_file%
@echo    END IF;>>%oracle_sql_file%

@echo END;>>%oracle_sql_file%
@echo />>%oracle_sql_file%

@REM 创建新的表空间
@echo CREATE TABLESPACE "%new_tablespace%">>%oracle_sql_file%
@echo DATAFILE '%oracle_data_file%' SIZE 200M REUSE>>%oracle_sql_file%
@echo AUTOEXTEND ON NEXT 200M MAXSIZE UNLIMITED>>%oracle_sql_file%
@echo LOGGING ONLINE PERMANENT>>%oracle_sql_file%
@echo EXTENT MANAGEMENT LOCAL AUTOALLOCATE DEFAULT NOCOMPRESS>>%oracle_sql_file%
@echo SEGMENT SPACE MANAGEMENT AUTO;>>%oracle_sql_file%

@REM 创建新用户
@echo CREATE USER %new_user%>>%oracle_sql_file%
@echo IDENTIFIED BY %new_passwd%>>%oracle_sql_file%
@echo DEFAULT TABLESPACE "%new_tablespace%";>>%oracle_sql_file%

@REM 授予用户权限
@echo GRANT CONNECT,RESOURCE,DBA,UNLIMITED TABLESPACE TO %new_user%;>>%oracle_sql_file%

@REM 用新用户登录数据库，在新用户中创建表
@echo CONNECT %new_user%/%new_passwd%@%dbname%;>>%oracle_sql_file%

@REM 添加建表语句
type oracle.sql>>%oracle_sql_file%
@echo quit;>>%oracle_sql_file%

@echo on

@REM 执行总的sql文件
sqlplus /nolog @%oracle_sql_file%

@REM 执行完毕后删除sql文件
del /q /f %oracle_sql_file%

pause
