🔑 How recovery_target_time works
PostgreSQL replays WAL (write‑ahead logs) from your base backup until it reaches the timestamp you specify.

If the timestamp is before a DELETE, the DELETE never happens (row is preserved).

If the timestamp is after a DELETE, the DELETE is included (row is gone).

If the timestamp is between INSERT and DELETE, you’ll see the INSERT but not the DELETE.

So the trick is: capture the exact time right before the unwanted action and use that as recovery_target_time.



🛠 Step‑by‑Step PITR Demo (with demo1):

# 1. Create new table and insert rows :
```bash

sudo -u postgres psql
```
#create table :
```bash

CREATE DATABASE demo1;
```
```bash
\c demo1
```
```bash
CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    role TEXT NOT NULL,
    joined DATE DEFAULT CURRENT_DATE
);
```
```bash
INSERT INTO employees (name, role) VALUES
('Alice', 'Developer'),
('Bob', 'SysAdmin'),
('Charlie', 'DBA');
```
```bash
SELECT * FROM employees;
```
```bash
\q

```

# 2. Take a base backup :

```bash
sudo -u postgres mkdir -p /var/lib/postgresql/16/basebackup_demo1
```
```bash
sudo -u postgres pg_basebackup -D /var/lib/postgresql/16/basebackup_demo1 -Fp -Xs -P
```



#3. Make changes and capture timestamp :

```bash
sudo -u postgres psql
```
```bash
\c demo1
```
-- Add a new row

```bash
INSERT INTO employees (name, role) VALUES ('David', 'Intern');
```
-- Capture timestamp BEFORE delete
```bash
SELECT now();
```
👉 Copy this timestamp (e.g. 2025-11-27 19:40:00). This is your recovery_target_time.:

-- Simulate accidental delete

```bash
DELETE FROM employees WHERE name = 'Alice';
```
```bash
SELECT * FROM employees;
```
```bash
\q
```
#4. Configure recovery :

>> Edit /etc/postgresql/16/main/postgresql.conf:

```bash
restore_command = 'cp /var/lib/postgresql/16/archive/%f %p'
recovery_target_time = '2025-11-27 19:40:00'
recovery_target_action = 'promote'
recovery_target_timeline = 'latest'
```


#Create recovery signal:

```bash
sudo -u postgres touch /var/lib/postgresql/16/main/recovery.signal
```

# 5. Restore base backup

```bash
sudo systemctl stop postgresql
```
```bash
sudo mv /var/lib/postgresql/16/main /var/lib/postgresql/16/main_old
```
```bash
sudo cp -a /var/lib/postgresql/16/basebackup_demo1 /var/lib/postgresql/16/main
```
```bash
sudo chown -R postgres:postgres /var/lib/postgresql/16/main
```
```bash
sudo chmod 0700 /var/lib/postgresql/16/main
```
```bash
sudo systemctl start postgresql
```

#6. Verify recovery (Check logs) :
```bash

sudo tail -f /var/log/postgresql/postgresql-16-main.log

```
#You should see WAL replay until the target time.Connect and check:

```bash
sudo -u postgres psql
```
```bash
\c demo1
```
```bash
SELECT * FROM employees;
```


👉 The key difference this time: use the timestamp from SELECT now() right before the DELETE as recovery_target_time. 
That guarantees PITR stops before the unwanted action.










