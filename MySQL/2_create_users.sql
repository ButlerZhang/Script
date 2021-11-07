#切换到要设置的数据库
USE Qing;

#创建拥有完全权限的用户，百分号表示任意IP
#DROP USER IF EXISTS 'butler'@'%';
CREATE USER 'butler'@'%' IDENTIFIED BY 'butler@butler';
GRANT ALL PRIVILEGES ON Qing.* TO 'butler'@'%';

#创建只读权限用户，只赋予SELECT权限
#DROP USER IF EXISTS 'guest'@'%';
CREATE USER 'guest'@'%' IDENTIFIED BY 'guest';
GRANT SELECT ON Qing.* TO 'guest'@'%';

#刷新权限表
FLUSH PRIVILEGES;
