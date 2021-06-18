@echo ȥ������Ҫ�ķǿ�Լ����ֻ����������Ҫ�ǿ�Լ��

@echo off
setlocal enabledelayedexpansion

@REM Դ�ļ��ͽ���ļ�
set file=oracle.sql
set resultfile=resultfile.txt

@REM ��ʱ�ļ�
set tempfile=temp.txt
set tablefile=table.txt
set indexfile=index.txt

@REM �ж�дtable�ļ�����index�ļ�
set choose=

@REM ��ʼ��Ϊ���ļ��������ظ�������ɾ��
type NUL > %tempfile%
type NUL > %tablefile%
type NUL > %indexfile%
type NUL > %resultfile%

for %%i in ("%file%") do set file=%%~fi
for /f "delims=" %%i in ('type "%file%"') do (
    set str=%%i
    echo !str!

    if not "!str:create table=%!"=="!str!" (
        @REM ������һ�ű�֮ǰ�Ȱ���һ�ű�Ľ��д������ļ�
        type %tablefile%>>%resultfile%
        type %indexfile%>>%resultfile%

        @REM ����ļ�׼����һ�ű�ļ�¼
        type NUL > %tempfile%
        type NUL > %tablefile%
        type NUL > %indexfile%

        @REM ���choose��ʾ�������ļ�¼��д��table�ļ�
        set choose=table
        echo !str!>%tablefile%
    )^
    else if not "!str:create unique index=%!"=="!str!" (
        @REM ���choose��ʾ�������ļ�¼��д��index�ļ�
        set choose=index
        echo !str!>>%indexfile%
    )^
    else if not "!str:create index=%!"=="!str!" (
        @REM ���choose��ʾ�������ļ�¼��д��index�ļ�
        set choose=index
        echo !str!>>%indexfile%
    )^
    else if "!choose!"=="table" (
        @REM дtable�ļ�ǰ��ȥ�����зǿ�Լ��
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
            @REM ��β�ַ���ֱ��д��index�ļ�
            echo !str!>>%indexfile%
        )^
        else if not "!str:/*=%!"=="!str!" (
            @REM ע���ַ���ֱ��д��index�ļ�
            echo !str!>>%indexfile%
        )^
        else (
            @REM ����ÿһ�����������˶�table�ļ���ӷǿ�Լ��
            echo !str!>>%indexfile%

            @REM ��һ���ַ�����������
            for /f "tokens=1" %%a in ("!str!") do (

                @REM ����table�ļ���ÿһ��
                for /f "delims=" %%b in ('type "%tablefile%"') do (
                    set line_str=%%b

                    if not "!line_str:not null=%!"=="!line_str!" (
                        @REM �Ѿ����ڷǿ�Լ���Ͳ���Ҫ�����
                        echo !line_str!>>%tempfile%
                    )^
                    else if not "!line_str:/*=%!"=="!line_str!" (
                        @REM ע�Ͳ���Ҫ��ӷǿ�Լ��
                        echo !line_str!>>%tempfile%
                    )^
                    else if not "!line_str:create=%!"=="!line_str!" (
                        @REM Create��䲻��Ҫ��ӷǿ�Լ��
                        echo !line_str!>>%tempfile%
                    )^
                    else if not "!line_str:%%a=%!"=="!line_str!" (
                        for /f "tokens=1" %%c in ("!line_str!") do (
                            if "%%a"=="%%c" (
                                @REM �ַ�����ȫƥ�����Ҫ��ӷǿ�Լ��
                                set last_str=!line_str:~-1!

                                if "!last_str!"=="," (
                                    @REM ���һ���ַ��Ƕ�����Ӷ���
                                    set line_str=!line_str:~0,-1!
                                    set line_str=!line_str! not null,
                                )^
                                else (
                                    @REM ���һ���ַ����Ƕ��žͲ�Ҫ�Ӷ���
                                    set line_str=!line_str! not null
                                )

                                echo !line_str!>>%tempfile%
                            )^
                            else (
                                @REM �ַ�������ȫƥ�䣬���п������Ӵ�����ƥ��
                                echo !line_str!>>%tempfile%
                            )
                        )
                    )^
                    else (
                        @REM �����������ֱ��д�ļ�
                        echo !line_str!>>%tempfile%
                    )
                )

                @REM ������˷ǿ�Լ��������д��table�ļ�
                type %tempfile% > %tablefile%

                @REM ���temp�ļ�׼���ж���һ������
                type NUL > %tempfile%

                @REM �����õ���ͣ
                @REM pause
            )
        )
    )^
    else (
        @REM ����������ַ�������Ҫ���κδ���
        echo !str!>>%resultfile%
    )
)

@REM ����ѭ����Ҫд���һ�ű������
type %tablefile%>>%resultfile%
type %indexfile%>>%resultfile%

@REM ɾ����ʱ�ļ�
del /q /f %tempfile%
del /q /f %tablefile%
del /q /f %indexfile%

@REM �������ļ�
move %resultfile% %file%
