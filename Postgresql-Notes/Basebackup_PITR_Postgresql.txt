#check path
====================================================

```bash
ls -l /etc/postgresql/16/main/
```

# To enable WAL archiving or PITR:

```bash
sudo nano /etc/postgresql/16/main/postgresql.conf
```
#Add:

```bash
wal_level = replica
archive_mode = on
archive_command = 'cp %p /var/lib/postgresql/16/archive/%f'

```

#Restart PostgreSQL so the new setting takes effect:

```bash

sudo systemctl restart postgresql

```

#Then:

```bash
sudo mkdir -p /var/lib/postgresql/16/archive
```

```bash

sudo chown postgres:postgres /var/lib/postgresql/16/archive
```

```bash
sudo systemctl restart postgresql
```

# if Force a WAL switch to test archiving :                            #if require then use it this cmd

```bash

sudo -u postgres psql -c "SELECT pg_switch_wal();

```

```bash
ls -l /var/lib/postgresql/16/archive
```



>>>Take a base backup

#Create a basebackup directory :

```bash

sudo -u postgres mkdir -p /var/lib/postgresql/16/basebackup
```

# Run base backup (plain format, includes WAL):
```bash

sudo -u postgres pg_basebackup -D /var/lib/postgresql/16/basebackup -Fp -Xs -P
```

>> Make changes, then simulate an “accidental” delete :

#Connect to demo and add a new row

```bash

sudo -u postgres psql
```
```bash
\c demo
```
```bash
INSERT INTO employees (name, role) VALUES ('David', 'Intern');
```
```bash
SELECT * FROM employees;
```

#Note the current time (for recovery target)

```bash

SELECT now();
```

#Simulate the mistaken delete :

```bash

DELETE FROM employees WHERE name = 'Alice';

```
```bash
SELECT * FROM employees;

```

```bash

\q
```

>> Prepare the recovery target configuration :

#Ensure restore_command is set (already added earlier) :

```bash

sudo grep -n "restore_command" /etc/postgresql/16/main/postgresql.conf

```

#It should be:

restore_command = 'cp /var/lib/postgresql/16/archive/%f %p'

#Choose the recovery target time

sudo sed -i '$a recovery_target_time = '\''2025-11-27 12:49:30'\''' /etc/postgresql/16/main/postgresql.conf
sudo sed -i '$a recovery_target_action = '\''promote'\''' /etc/postgresql/16/main/postgresql.conf
sudo sed -i '$a recovery_target_timeline = '\''latest'\''' /etc/postgresql/16/main/postgresql.conf


>> Stop the server and restore the base backup

#Stop PostgreSQL :

```bash

sudo systemctl stop postgresql
```

#Move current data directory aside (safety) :

```bash

sudo mv /var/lib/postgresql/16/main /var/lib/postgresql/16/main_old

```

#Restore basebackup to the data directory :

```bash

sudo cp -a /var/lib/postgresql/16/basebackup /var/lib/postgresql/16/main
```

```bash
sudo chown -R postgres:postgres /var/lib/postgresql/16/main
```

#Create the recovery signal file :

```bash
sudo -u postgres touch /var/lib/postgresql/16/main/recovery.signal
```

>> Start PostgreSQL and let it replay to the target :

# Start PostgreSQL :

```bash

sudo systemctl start postgresql

```

#Watch logs for recovery progress :

```bash

sudo tail -f /var/log/postgresql/postgresql-16-main.log

```

>> Verify the PITR result:

#Check your data state :

```bash

sudo -u postgres psql

```
```bash
\c demo

```

```bash

SELECT * FROM employees;

```
>>Cleanup (optional) :

#Remove recovery.signal if still present (Postgres should remove it after promote, but confirm):

```bash

sudo rm -f /var/lib/postgresql/16/main/recovery.signal

```
#Remove old data dir once you’re confident: 

```bash
sudo rm -rf /var/lib/postgresql/16/main_old
```

