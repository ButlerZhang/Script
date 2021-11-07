PRINT 'start create users'

--�л���Ҫ���õ����ݿ�
USE Qing
GO

--����ӵ����ȫȨ�޵��û�
IF NOT EXISTS (SELECT * FROM Qing.dbo.syslogins WHERE loginname = N'butler')
BEGIN

    --������¼�û�������������
    CREATE LOGIN butler WITH PASSWORD='butler@butler', DEFAULT_DATABASE=Qing
    
    --�������ݿ��û������¼�û��󶨣�ͬʱ�󶨵�dbo
    CREATE USER butler FOR LOGIN butler WITH DEFAULT_SCHEMA=dbo
    
    --�������ݿ��û�ӵ����ȫȨ��
    EXEC sp_addrolemember 'db_owner', 'butler'

END
GO

--����ֻ��Ȩ���û�
IF NOT EXISTS (SELECT * FROM Qing.dbo.syslogins WHERE loginname = N'guest')
BEGIN

    CREATE LOGIN guest WITH PASSWORD='guest', DEFAULT_DATABASE=Qing
    CREATE USER guest FOR LOGIN guest WITH DEFAULT_SCHEMA=dbo
    EXEC sp_addrolemember 'db_datareader', 'guest'

END
GO
