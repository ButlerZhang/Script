PRINT 'start create users'

--切换到要设置的数据库
USE Qing
GO

--创建拥有完全权限的用户
IF NOT EXISTS (SELECT * FROM Qing.dbo.syslogins WHERE loginname = N'butler')
BEGIN

    --创建登录用户，并设置密码
    CREATE LOGIN butler WITH PASSWORD='butler@butler', DEFAULT_DATABASE=Qing
    
    --创建数据库用户，与登录用户绑定，同时绑定到dbo
    CREATE USER butler FOR LOGIN butler WITH DEFAULT_SCHEMA=dbo
    
    --设置数据库用户拥有完全权限
    EXEC sp_addrolemember 'db_owner', 'butler'

END
GO

--创建只读权限用户
IF NOT EXISTS (SELECT * FROM Qing.dbo.syslogins WHERE loginname = N'guest')
BEGIN

    CREATE LOGIN guest WITH PASSWORD='guest', DEFAULT_DATABASE=Qing
    CREATE USER guest FOR LOGIN guest WITH DEFAULT_SCHEMA=dbo
    EXEC sp_addrolemember 'db_datareader', 'guest'

END
GO
