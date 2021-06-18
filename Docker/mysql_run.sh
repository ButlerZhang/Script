#!/bin/bash

#sed用来编辑文件，-i表示直接对文本文件进行操作。
#格式：sed [-hnV] [-e<script>][-f<script>] [文本文件]
sed -i 's/127.0.0.1/0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf

#chown将指定文件的拥有者改为指定的用户或组，-R处理指定目录及其子目录下的所有文件。
#格式：chown [-cfhvR] [--help] [--version] user[:group] file ...
chown -R mysql:mysql /var/lib/mysql var/run/mysqld

#启动mysql服务。
service mysql start
echo "=====change password====="

#运行mysql命令，参数-e表示可以在shell下执行各种SQL语句。
#mysql语句：grant 权限1,权限2,...,权限n on 数据库名称.表名称 to 用户名@用户地址 identified by '连接口令';
mysql -u root -e "grant all privileges on *.* to 'root'@'%' identified WITH mysql_native_password by 'root';"
mysql -u root -e "grant all privileges on *.* to 'root'@'localhost' identified WITH mysql_native_password by 'root';"

#重启mysql服务。
service mysql restart

#让容器运行bash。
echo "=====enter bash====="

/bin/bash
