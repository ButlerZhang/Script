#�л���Ҫ���õ����ݿ�
USE Qing;

#����ӵ����ȫȨ�޵��û����ٷֺű�ʾ����IP
#DROP USER IF EXISTS 'butler'@'%';
CREATE USER 'butler'@'%' IDENTIFIED BY 'butler@butler';
GRANT ALL PRIVILEGES ON Qing.* TO 'butler'@'%';

#����ֻ��Ȩ���û���ֻ����SELECTȨ��
#DROP USER IF EXISTS 'guest'@'%';
CREATE USER 'guest'@'%' IDENTIFIED BY 'guest';
GRANT SELECT ON Qing.* TO 'guest'@'%';

#ˢ��Ȩ�ޱ�
FLUSH PRIVILEGES;
