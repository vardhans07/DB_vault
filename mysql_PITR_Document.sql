
[client-server]
port=3316
#datadir = /data/MARIADB/irctc_db
#
# include all files from the config directory
#
!includedir /etc/my.cnf.d
[mysqld]
datadir=/sbig_prd_tenant/mysql/
socket=/sbig_prd_tenant/mysql/mysql.sock
log-error=/var/log/mysql/mysqld.log

pid-file=/run/mariadb/mariadb.pid

[client]
socket=/sbig_prd_tenant/mysql/mysql.sock


sudo scp irctc_sql.tar root@172.16.114.241:/sbig_prd_tenant/dd

UserName:- opensource and  Password:-opensrc@123


SHOW VARIABLES LIKE 'general_log';
rsync -av /var/lib/mysql/ /sbig_prd_tenant/mysql/
mysql -u username -p database_name < backup.sql








mysqlbinlog /data/MARIADB/irctc_db/mysql-bin.000015 | less


mysqlbinlog /data/MARIADB/irctc_db/mysql-bin.000001 | grep -i "drop table"
mysqlbinlog /data/MARIADB/irctc_db/mysql-bin.000001 | grep -i "Query"


/data/mysqldbbak/


find / -name "testdb.sql" 2>/dev/null


1. Take a Base Backup

Using mysqldump:

mysqldump -u root -p --all-databases --routines --triggers --events > testdb.sql


Using mariabackup:
mariabackup --backup --target-dir=/backup/2025-12-15
Then prepare it:
mariabackup --prepare --target-dir=/backup/2025-12-15



1. Prepare the Backup

mysql -u root -p testdb < testdb.sql

2. Identify Binary Logs

mysql> SHOW BINARY LOGS;

3. Extract Transactions from Logs

mysqlbinlog \
  --start-datetime="2025-12-15 10:45:00" \
  --stop-datetime="2025-12-18 11:55:59" \
  /data/MARIADB/irctc_db/mysql-bin.000013 \
  /data/MARIADB/irctc_db/mysql-bin.000014 \
  /data/MARIADB/irctc_db/mysql-bin.000015 > replay.sql

4.Inspect the SQL File (Safety Check)

less replay.sql


5. Apply Transactions to Database

mysql testdb < replay.sql

mysqlbinlog /data/MARIADB/irctc_db/mysql-bin.000020 | grep -B 3 -i "DROP TABLE"




 sudo mysqlbinlog   --start-datetime="2025-12-15 10:45:00"   --stop-datetime="2025-12-22 11:37:59"   /data/MARIADB/irctc_db/mysql-bin.000013   /data/MARIADB/irctc_db/mysql-bin.000014   /data/MARIADB/irctc_db/mysql-bin.000015   /data/MARIADB/irctc_db/mysql-bin.000016   /data/MARIADB/irctc_db/mysql-bin.000017 | mysql  testdb


sudo mysqlbinlog   --start-datetime="2025-12-15 10:45:00"   --stop-datetime="2025-12-22 11:37:59"  
 /data/MARIADB/irctc_db/mysql-bin.000013   /data/MARIADB/irctc_db/mysql-bin.000014  
 /data/MARIADB/irctc_db/mysql-bin.000015   /data/MARIADB/irctc_db/mysql-bin.000016  
 /data/MARIADB/irctc_db/mysql-bin.000017 | mysql  testdb
 
 
 
 

 
 
 
 
