@REM 需要以管理员身份运行

@REM 修改系统窗口为眼睛保护色
reg add "HKCU\Control Panel\Colors" /v Window /t REG_SZ /d "202 234 206" /f

@REM 系统重启后仍然为眼睛保护色
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\DefaultColors\Standard" /v Window /t REG_DWORD /d 13298382 /f

pause
