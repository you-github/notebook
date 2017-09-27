# mysql在非root权限下安装步骤
1、下载二进制安装包并解压 
2、设置PATH路径
```bash
source /home/ybq-2/ENV/CAD/database/mysql/env.bashrc
```
3、初始化数据库
```bash
/home/ybq-2/ENV/CAD/database/mysql/scripts/mysql_install_db --user=ybq-2 --basedir=/home/ybq-2/ENV/CAD/database/mysql --datadir=/home/ybq-2/mysql-data/data
```
4、启动mysql数据库
```bash
mysqld_safe --defaults-file=/home/ybq-2/mysql-data/my.cnf --basedir=/home/ybq-2/ENV/CAD/database/mysql --ledir=/home/ybq-2/ENV/CAD/database/mysql/bin \
--datadir=/home/ybq-2/mysql-data/data --skip-grant-tables
```

## my.cnf配置
```bash
# For advice on how to change settings please see
# http://dev.mysql.com/doc/refman/5.6/en/server-configuration-defaults.html

[mysqld]

# Remove leading # and set to the amount of RAM for the most important data
# cache in MySQL. Start at 70% of total RAM for dedicated server, else 10%.
# innodb_buffer_pool_size = 128M

# Remove leading # to turn on a very important data integrity option: logging
# changes to the binary log between backups.
# log_bin

# These are commonly set, remove the # and set as required.
 basedir = /home/ybq-2/ENV/CAD/database/mysql
# datadir = .....
 port = 3306
# server_id = .....
socket = /tmp/mysql.sock  

datadir         = /home/ybq-2/mysql-data/data

#[safe_mysqld]

#err-log = /var/log/mysqld.log
#pid-file = /var/lib/mysql/localhost.localdomain.pid

# Remove leading # to set options mainly useful for reporting servers.
# The server defaults are faster for transactions and fast SELECTs.
# Adjust sizes as needed, experiment to find the optimal values.
# join_buffer_size = 128M
# sort_buffer_size = 2M
# read_rnd_buffer_size = 2M 

sql_mode=NO_ENGINE_SUBSTITUTION,STRICT_TRANS_TABLES 

```
5、设置密码以及创建用户、数据库以及给用户授权

## 去掉--skip-grant-tables（记得这一步）

```bash
//root登录设置密码
mysql -uroot

use mysql;

select * from user;

update user set password=PASSWORD('123456') where user='root';

flush privileges;

exit;

mysql -uroot -p123456 -hlocalhost -P3306
//远程访问
create user 'raven'@'%' identified by '123456';

grant all on avk.* to 'raven'@'%';

flush privileges;
//本地访问
create user 'raven'@'localhost' identified by '123456';

grant all on avk.* to 'raven'@'localhost';

flush privileges;

```








