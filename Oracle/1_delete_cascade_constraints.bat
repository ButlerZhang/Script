@echo ȥ��Drop��������Լ�����Ҳ���Drop����쳣

@echo off
setlocal enabledelayedexpansion

@REM Դ�ļ��ͽ���ļ�
set file=oracle.sql
set resultfile=resultfile.txt

@REM ������ڽ���ļ����������
type NUL > %resultfile%

for %%i in ("%file%") do set file=%%~fi
for /f "delims=" %%i in ('type "%file%"') do (
    set str=%%i
    echo !str!

    if not "!str:drop table=%!"=="!str!" (
        @REM ����drop table���

        set target=!str:~11,-1!
        echo DECLARE>>%resultfile%
        echo     table_not_exists EXCEPTION;>>%resultfile%
        echo     PRAGMA EXCEPTION_INIT (table_not_exists, -942^);>>%resultfile%
        echo BEGIN>>%resultfile%
        echo     EXECUTE IMMEDIATE 'drop table !target!';>>%resultfile%
        echo EXCEPTION>>%resultfile%
        echo    WHEN table_not_exists>>%resultfile%
        echo    THEN>>%resultfile%
        echo        NULL;>>%resultfile%
        echo END;>>%resultfile%
        echo />>%resultfile%
    )^
    else if not "!str:drop index=%!"=="!str!" (
        @REM ����drop index���

        set target=!str:~11,-1!
        echo DECLARE>>%resultfile%
        echo     index_not_exists EXCEPTION;>>%resultfile%
        echo     PRAGMA EXCEPTION_INIT (index_not_exists, -1418^);>>%resultfile%
        echo BEGIN>>%resultfile%
        echo     EXECUTE IMMEDIATE 'drop index !target!';>>%resultfile%
        echo EXCEPTION>>%resultfile%
        echo    WHEN index_not_exists>>%resultfile%
        echo    THEN>>%resultfile%
        echo        NULL;>>%resultfile%
        echo END;>>%resultfile%
        echo />>%resultfile%
    )^
    else (
        @REM ������䲻�ô���
        echo !str!>>%resultfile%
    )
)

@REM �������ļ�
move %resultfile% %file%
