@echo 去掉Drop语句的索引约束并且捕获Drop语句异常

@echo off
setlocal enabledelayedexpansion

@REM 源文件和结果文件
set file=oracle.sql
set resultfile=resultfile.txt

@REM 如果存在结果文件则清空内容
type NUL > %resultfile%

for %%i in ("%file%") do set file=%%~fi
for /f "delims=" %%i in ('type "%file%"') do (
    set str=%%i
    echo !str!

    if not "!str:drop table=%!"=="!str!" (
        @REM 处理drop table语句

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
        @REM 处理drop index语句

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
        @REM 其它语句不用处理
        echo !str!>>%resultfile%
    )
)

@REM 保存结果文件
move %resultfile% %file%
