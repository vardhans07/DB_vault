# PostgreSQL Point-in-Time Recovery (PITR) Demo

This demo shows how `recovery_target_time` works: PostgreSQL replays WAL logs until the specified timestamp.  

- If the timestamp is **before a DELETE**, the row is preserved.  
- If the timestamp is **after a DELETE**, the row is gone.  
- If the timestamp is **between INSERT and DELETE**, you’ll see the INSERT but not the DELETE.  

👉 The trick is to capture the exact time right before the unwanted action and use that as `recovery_target_time`.

---

## 1. Create Database and Table

```bash
sudo -u postgres psql
```

```bash
CREATE DATABASE demo1;
\c demo1

CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    role TEXT NOT NULL,
    joined DATE DEFAULT CURRENT_DATE
);

INSERT INTO employees (name, role) VALUES
('Alice', 'Developer'),
('Bob', 'SysAdmin'),
('Charlie', 'DBA');

SELECT * FROM employees;
\q
```


2. Take Base Backup

```bash

sudo -u postgres mkdir -p /var/lib/postgresql/16/basebackup_demo1
sudo -u postgres pg_basebackup -D /var/lib/postgresql/16/basebackup_demo1 -Fp -Xs -P


```

3. Make Changes and Capture Timestamp

```bash
sudo -u postgres psql
\c demo1

```

```bash
-- Add a new row
INSERT INTO employees (name, role) VALUES ('David', 'Intern');
```

-- Capture timestamp BEFORE delete
```bash
SELECT now();

```
👉 Copy this timestamp (e.g. 2025-11-27 19:40:00) — this will be your recovery_target_time.



-- Simulate accidental delete

```bash 
DELETE FROM employees WHERE name = 'Alice';
SELECT * FROM employees;
\q
```
4. Configure Recovery

Edit /etc/postgresql/16/main/postgresql.conf:


```bash

restore_command = 'cp /var/lib/postgresql/16/archive/%f %p'
recovery_target_time = '2025-11-27 19:40:00'
recovery_target_action = 'promote'
recovery_target_timeline = 'latest'

```

Create recovery signal:

```bash
sudo -u postgres touch /var/lib/postgresql/16/main/recovery.signal

```

5. Restore Base Backup

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
```
6. Verify Recovery

Check logs:

```bash
sudo tail -f /var/log/postgresql/postgresql-16-main.log

```

Connect and verify:

```bash

sudo -u postgres psql
```
```bash
\c demo1
```
```bash

SELECT * FROM employees;
```

✅ Best Practice
After confirming that recovery has succeeded and your database is back online, you can safely delete the recovery.signal file.
This prevents PostgreSQL from trying to re-enter recovery mode on the next restart.

```bash
sudo -u postgres rm /var/lib/postgresql/16/main/recovery.signal
```




