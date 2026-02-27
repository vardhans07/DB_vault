INSERT INTO bookings (id, passenger_name, train_no, booking_date)
VALUES
(3, 'Ravi Sharma', 12345, '2025-12-18 10:00:00'),
(4, 'Sneha Patel', 98765, '2025-12-19 16:45:00');



# Recover with INSERT only (before DELETE)
mysqlbinlog --stop-datetime="2025-12-23 11:44:00" /data/MARIADB/irctc_db/mysql-bin.000020 | mysql  irtctcdb

# Recover with INSERT + DELETE
mysqlbinlog --stop-datetime="2025-12-18 10:10:00" /var/lib/mysql/mariadb-bin.000001 | mysql -u root -p irtctcdb


mysqlbinlog --stop-datetime="2025-12-18 10:05:00" /data/MARIADB/irctc_db/mysql-bin.000001 | mysql irtctcdb
mysqlbinlog /data/MARIADB/irctc_db/mysql-bin.000020 | grep -i "drop table"

mysqlbinlog --stop-datetime="2025-12-23 11:45:00" /data/MARIADB/irctc_db/mysql-bin.000020 | mysql  irtctcdb
mysqlbinlog /data/MARIADB/irctc_db/mysql-bin.000020 | less
mysqlbinlog /data/MARIADB/irctc_db/mysql-bin.000020 | grep -B 3 -i "DELETE FROM"


sudo mysqlbinlog   --start-datetime="2025-12-15 10:45:00" \
  846    --stop-datetime="2025-12-19 11:32:59" \
  847    /data/MARIADB/irctc_db/mysql-bin.000013 \
  848    /data/MARIADB/irctc_db/mysql-bin.000014 \
  849    /data/MARIADB/irctc_db/mysql-bin.000015 \
  850    /data/MARIADB/irctc_db/mysql-bin.000016 \
  851  | mysql  testdb


# Repeat for other binlog files if needed:

for f in /data/MARIADB/irctc_db/mysql-bin.0000*; do
  echo "=== $f ==="
  mysqlbinlog $f | grep -B 3 -i "DELETE FROM"
done



i insert value at 12:53:55 and drop on 12:55:55 suppoose if i want pir but i want back that inserted valued in db what i droped 12:55:55
and use this below cmd and value not neted back beauase i put value stop-datetime="2025-12-23 12:56:55" if correct this stop-datetime="2025-12-23 12:55:00"
it will succeful pitr right 
 at mysqlbinlog --stop-datetime="2025-12-23 12:56:55" /data/MARIADB/irctc_db/mysql-bin.000020 | mysql  irtctcdb

#251222 12:55:55 server id 1  end_log_pos 625510 CRC32 0xa59c5bac       Annotate_rows:
#Q> DELETE FROM bookings WHERE id=1

/data/MARIADB/irctc_db



CREATE DATABASE pitr_testdb;
RENAME TABLE irtctcdb.bookings TO pitr_testdb.bookings,
             irtctcdb.train TO pitr_testdb.train;


CREATE TABLE train (
  id INT PRIMARY KEY,
  passenger_name VARCHAR(50),
  train_no INT,
);


INSERT INTO train VALUES(4 ,avi arma ,2345 );

INSERT INTO train (id, passenger_name, train_no) VALUES
    (1, 'Priya Singh', 54321),
    (2, 'Amit Kumar', 67890),
    (3, 'Ravi Sharma', 12345),
    (4, 'avi arma', 2345);


# Take Base Backup

mysqldump pitr_testdb > /data/mariadbbackup/train_backup.sql


Insert More Values
	
INSERT INTO train VALUES
(5, 'av arma', 345),
(6, 'neha Pat', 765);


DELETE FROM train
WHERE id = 6;
DELETE FROM train WHERE id IN (5,6);


# Drop the Table

>> DROP TABLE train;


# Restore Base Backup

>> mysql pitr_testdb < /data/mariadbbackup/train_backup.sql

# Perform PITR to Recover Missing Entries

mysqlbinlog /data/MARIADB/irctc_db/mysql-bin.000025 |more
mysqlbinlog /data/MARIADB/irctc_db/mysql-bin.000023 | grep -B 3 -i "INSERT INTO"
mysqlbinlog /data/MARIADB/irctc_db/mysql-bin.000023 | grep -B 3 -i "DROP TABLE"
mysqlbinlog /data/MARIADB/irctc_db/mysql-bin.000023 | grep -B 3 -i "Create TABLE"
mysqlbinlog /data/MARIADB/irctc_db/mysql-bin.000023 | grep -B 3 -i "DELETE FROM"
mysqlbinlog /data/MARIADB/irctc_db/mysql-bin.000024 | grep -B 3 -i "DROP TABLE" | tail -n 30
mysqlbinlog /data/MARIADB/irctc_db/mysql-bin.000032 | grep -B 3 -i "DELETE FROM" | tail -n 30

mysqlbinlog \
  --start-datetime="2025-12-29 16:01:00" \
  --stop-datetime="2025-12-29 16:58:30" \
  /data/MARIADB/irctc_db/mysql-bin.000023 | grep -B 3 -i "DROP TABLE train"| tail -n 30
  
  mysqlbinlog \
  --start-datetime="2025-12-30 11:04:10 " \
  --stop-datetime="2025-12-30 11:25:15 " \
  /data/MARIADB/irctc_db/mysql-bin.000024 \
  | grep -B 3 -i "DROP TABLE.*train" \
  | tail -n 30
 
  mysqlbinlog \
  --start-datetime="2025-12-30 11:04:10 " \
  --stop-datetime="2025-12-30 11:25:15 " \
  /data/MARIADB/irctc_db/mysql-bin.000024 \
  | grep -B 3 -i "DELETE FROM train.*train" \
  | tail -n 30 
  
  mysqlbinlog --verbose --base64-output=DECODE-ROWS \
  --start-datetime="2025-12-30 11:04:10" \
  --stop-datetime="2025-12-30 11:25:15" \
  /data/MARIADB/irctc_db/mysql-bin.000023 | grep -i "train"

# To see row-level inserts, you must decode them:
 mysqlbinlog \
  --start-datetime="2025-12-30 11:04:10" \
  --stop-datetime="2025-12-30 11:25:15" \
  /data/MARIADB/irctc_db/mysql-bin.000023 \
  | grep -B 3 -i "INSERT INTO train VALUES" \
  | tail -n 30

 
date -d @1767073790



#Replay Binlog up to Before DROP

mysqlbinlog --stop-datetime="2025-12-29 12:45:00" /data/MARIADB/irctc_db/mysql-bin.000020 | mysql irtctcdb
mysqlbinlog --skip-duplicate-check --stop-datetime="2025-12-23 12:45:00" /data/MARIADB/irctc_db/mysql-bin.000020 | mysql irtctcdb
mysqlbinlog --start-position="2025-12-23 12:45:00" --stop-position=8052 /data/MARIADB/irctc_db/mysql-bin.000020 | mysql irtctcdb
mysqlbinlog --start-position=5550 --stop-position=5704 /data/MARIADB/irctc_db/mysql-bin.000020 | mysql irtctcdb



#Pitr 

mysqlbinlog   --start-datetime="2026-01-01 09:35:00   "   --stop-datetime="2026-01-01  12:20:25     " /data/MARIADB/irctc_db/mysql-bin.000030   /data/MARIADB/irctc_db/mysql-bin.000031   /data/MARIADB/irctc_db/mysql-bin.000032 | mysql pitr_testdb

mysqlbinlog   --start-datetime="2025-12-29 15:33:00"   --stop-datetime="2025-12-29 15:36:59" /data/MARIADB/irctc_db/mysql-bin.000021   /data/MARIADB/irctc_db/mysql-bin.000022   /data/MARIADB/irctc_db/mysql-bin.000023 | mysql --force  pitr_testdb





#Or use position for precision:

mysqlbinlog --stop-position=3456 /data/MARIADB/irctc_db/mysql-bin.000020 | mysql -u root -p irtctcdb


sudo mysqlbinlog --start-datetime="2025-12-15 16:52:00"   --stop-datetime="2025-12-24 18:12:13 "   --database=testdb   /data/MARIADB/irctc_db/mysql-bin.000017   /data/MARIADB/irctc_db/mysql-bin.000018   /data/MARIADB/irctc_db/mysql-bin.000019   /data/MARIADB/irctc_db/mysql-bin.000020   /data/MARIADB/irctc_db/mysql-bin.000021 | mysql -u root -p testdb


sudo mysqlbinlog \   --start-datetime="2025-12-26 11:31:00" \   --stop-datetime="2025-12-26 11:38:00" \    /data/MARIADB/irctc_db/mysql-bin.000019   /data/MARIADB/irctc_db/mysql-bin.000020   /data/MARIADB/irctc_db/mysql-bin.000021 | mysql  pitr_testdb
















# Verify with verbose mode  

mysqlbinlog --verbose --base64-output=DECODE-ROWS \
  --start-datetime="2025-12-30 11:14:00" \
  --stop-datetime="2025-12-30 11:53:00" \
  /data/MARIADB/irctc_db/mysql-bin.000024 | less




[root@PS18VMAP246 mariadbbackup]# mysqlbinlog /data/MARIADB/irctc_db/mysql-bin.000024 | grep -B 3 -i "DELETE FROM" | tail -n 30
# at 416510183
# at 416510241
#251230 11:15:07 server id 1  end_log_pos 416510241 CRC32 0x61962976    Annotate_rows:
#Q> DELETE FROM train WHERE id IN (5,6)
--
# at 996929768
# at 996929826
#251230 11:52:27 server id 1  end_log_pos 996929826 CRC32 0xe98ef3d7    Annotate_rows:
#Q> DELETE FROM train WHERE id IN (5,6)
[root@PS18VMAP246 mariadbbackup]#




https://dev.mysql.com/doc/refman/8.4/en/point-in-time-recovery-positions.html
https://dev.mysql.com/doc/refman/8.4/en/point-in-time-recovery-binlog.html
