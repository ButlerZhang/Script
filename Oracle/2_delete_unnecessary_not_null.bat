@echo 去掉不必要的非空约束，只有主键才需要非空约束

@echo off
setlocal enabledelayedexpansion

@REM 源文件和结果文件
set file=oracle.sql
set resultfile=resultfile.txt

@REM 临时文件
set tempfile=temp.txt
set tablefile=table.txt
set indexfile=index.txt

@REM 判断写table文件还是index文件
set choose=

@REM 初始化为空文件，避免重复创建和删除
type NUL > %tempfile%
type NUL > %tablefile%
type NUL > %indexfile%
type NUL > %resultfile%

for %%i in ("%file%") do set file=%%~fi
for /f "delims=" %%i in ('type "%file%"') do (
    set str=%%i
    echo !str!

    if not "!str:create table=%!"=="!str!" (
        @REM 处理下一张表之前先把上一张表的结果写到结果文件
        type %tablefile%>>%resultfile%
        type %indexfile%>>%resultfile%

        @REM 清空文件准备下一张表的记录
        type NUL > %tempfile%
        type NUL > %tablefile%
        type NUL > %indexfile%

        @REM 标记choose表示接下来的记录都写到table文件
        set choose=table
        echo !str!>%tablefile%
    )^
    else if not "!str:create unique index=%!"=="!str!" (
        @REM 标记choose表示接下来的记录都写到index文件
        set choose=index
        echo !str!>>%indexfile%
    )^
    else if not "!str:create index=%!"=="!str!" (
        @REM 标记choose表示接下来的记录都写到index文件
        set choose=index
        echo !str!>>%indexfile%
    )^
    else if "!choose!"=="table" (
        @REM 写table文件前先去除所有非空约束
        if not "!str:0 not null=%!"=="!str!" (
            set "str=!str:0 not null=0!"
        )^
        else if not "!str:not null=%!"=="!str!" (
            set "str=!str:not null=!"
        )

        echo !str!>>%tablefile%
    )^
    else if "!choose!"=="index" (
        if not "!str:);=%!"=="!str!" (
            @REM 结尾字符串直接写到index文件
            echo !str!>>%indexfile%
        )^
        else if not "!str:/*=%!"=="!str!" (
            @REM 注释字符串直接写到index文件
            echo !str!>>%indexfile%
        )^
        else (
            @REM 遍历每一个主键并依此对table文件添加非空约束
            echo !str!>>%indexfile%

            @REM 第一个字符串是主键名
            for /f "tokens=1" %%a in ("!str!") do (

                @REM 遍历table文件的每一行
                for /f "delims=" %%b in ('type "%tablefile%"') do (
                    set line_str=%%b

                    if not "!line_str:not null=%!"=="!line_str!" (
                        @REM 已经存在非空约束就不需要再添加
                        echo !line_str!>>%tempfile%
                    )^
                    else if not "!line_str:/*=%!"=="!line_str!" (
                        @REM 注释不需要添加非空约束
                        echo !line_str!>>%tempfile%
                    )^
                    else if not "!line_str:create=%!"=="!line_str!" (
                        @REM Create语句不需要添加非空约束
                        echo !line_str!>>%tempfile%
                    )^
                    else if not "!line_str:%%a=%!"=="!line_str!" (
                        for /f "tokens=1" %%c in ("!line_str!") do (
                            if "%%a"=="%%c" (
                                @REM 字符串完全匹配才需要添加非空约束
                                set last_str=!line_str:~-1!

                                if "!last_str!"=="," (
                                    @REM 最后一个字符是逗号则加逗号
                                    set line_str=!line_str:~0,-1!
                                    set line_str=!line_str! not null,
                                )^
                                else (
                                    @REM 最后一个字符不是逗号就不要加逗号
                                    set line_str=!line_str! not null
                                )

                                echo !line_str!>>%tempfile%
                            )^
                            else (
                                @REM 字符串不完全匹配，但有可能是子串部分匹配
                                echo !line_str!>>%tempfile%
                            )
                        )
                    )^
                    else (
                        @REM 其它所有情况直接写文件
                        echo !line_str!>>%tempfile%
                    )
                )

                @REM 把添加了非空约束的内容写到table文件
                type %tempfile% > %tablefile%

                @REM 清空temp文件准备判断下一个索引
                type NUL > %tempfile%

                @REM 调试用的暂停
                @REM pause
            )
        )
    )^
    else (
        @REM 来到这里的字符串不需要做任何处理
        echo !str!>>%resultfile%
    )
)

@REM 跳出循环后还要写最后一张表和索引
type %tablefile%>>%resultfile%
type %indexfile%>>%resultfile%

@REM 删除临时文件
del /q /f %tempfile%
del /q /f %tablefile%
del /q /f %indexfile%

@REM 保存结果文件
move %resultfile% %file%
