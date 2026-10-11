# pgBackRest Setup & Administration Guide (PostgreSQL 18 on Kali/Debian)

A complete reference guide for installing, configuring, securing, and operating pgBackRest with PostgreSQL 18.

---

## 1. Inventory of Manually Created & Modified Files

### Manually Created Files
| Path | Ownership | Permissions | Description |
| :--- | :--- | :--- | :--- |
| `/etc/pgbackrest/pgbackrest.conf` | `postgres:postgres` | `0640` | Main pgBackRest configuration file (defines stanzas & repositories). |
| `/var/log/pgbackrest/pgbackrest.log` | `postgres:postgres` | `0640` | Execution and diagnostic log file. |

### Manually Created Directories
| Path | Ownership | Permissions | Description |
| :--- | :--- | :--- | :--- |
| `/etc/pgbackrest` | `postgres:postgres` | `0750` | Holds configuration files. |
| `/var/log/pgbackrest` | `postgres:postgres` | `0750` | Holds runtime log files. |
| `/var/lib/pgbackrest` | `postgres:postgres` | `0750` | Main repository for backup manifests and archived WAL segments. |

### Modified PostgreSQL Configuration Files
* **`/etc/postgresql/18/main/postgresql.conf`**
  * Appended parameters: `wal_level = replica`, `archive_mode = on`, `archive_command = 'pgbackrest --stanza=demo archive-push %p'`, `max_wal_senders = 3`.
* **`/etc/postgresql/18/main/pg_hba.conf`**
  * Changed local Unix domain socket authentication method from `md5` to `peer` (or `trust` for testing) so `pgbackrest` can authenticate non-interactively as system user `postgres`.

---

## 2. Step-by-Step Installation & Setup

### Step 1: Install pgBackRest
```bash
sudo apt update
sudo apt install -y pgbackrest
pgbackrest version
```

### Step 2: Create Required Directories & Set Permissions
```bash
sudo mkdir -p /etc/pgbackrest /var/log/pgbackrest /var/lib/pgbackrest
sudo touch /var/log/pgbackrest/pgbackrest.log

sudo chmod 750 /etc/pgbackrest /var/log/pgbackrest /var/lib/pgbackrest
sudo chown -R postgres:postgres /etc/pgbackrest /var/log/pgbackrest /var/lib/pgbackrest
```

### Step 3: Configure `/etc/pgbackrest/pgbackrest.conf`
```bash
sudo cat << 'EOF' > /etc/pgbackrest/pgbackrest.conf
[demo]
pg1-path=/var/lib/postgresql/18/main

[global]
repo1-path=/var/lib/pgbackrest
repo1-retention-full=2
process-max=2
log-level-console=info
log-level-file=detail
start-fast=y

[global:archive-push]
compress-level=3
EOF

sudo chown -R postgres:postgres /etc/pgbackrest
sudo chmod 750 /etc/pgbackrest
sudo chmod 640 /etc/pgbackrest/pgbackrest.conf
```

### Step 4: Configure PostgreSQL WAL Archiving
Append to `/etc/postgresql/18/main/postgresql.conf`:
```ini
# pgBackRest Archive Settings
wal_level = replica
archive_mode = on
archive_command = 'pgbackrest --stanza=demo archive-push %p'
max_wal_senders = 3
```

### Step 5: Adjust `pg_hba.conf` (Allow Peer Authentication)
In `/etc/postgresql/18/main/pg_hba.conf`, ensure local socket connections use `peer`:
```text
local   all             postgres                                peer
local   all             all                                     peer
```
Then restart PostgreSQL:
```bash
sudo systemctl restart postgresql
```

Verify that non-interactive login works:
```bash
sudo -u postgres psql -c "SELECT current_user;"
```

---

## 3. Stanza Initialization & Verification

### Step 1: Create the Stanza
A **stanza** connects a PostgreSQL cluster (`pg1-path`) to a backup repository (`repo1-path`):
```bash
sudo -u postgres pgbackrest --stanza=demo stanza-create
```

### Step 2: Validate Archive & Communication
```bash
sudo -u postgres pgbackrest --stanza=demo check
```
*Expected result:* Ends with `check command end: completed successfully`.

---

## 4. Backup Operations

### 1. Full Backup (Baseline)
Copies every database block and system file:
```bash
sudo -u postgres pgbackrest --stanza=demo --type=full backup
```

### 2. Differential Backup (Diff)
Copies only database files modified since the last **full** backup:
```bash
sudo -u postgres pgbackrest --stanza=demo --type=diff backup
```

### 3. Incremental Backup (Incr)
Copies only database files modified since the last backup (full, diff, or incr):
```bash
sudo -u postgres pgbackrest --stanza=demo --type=incr backup
```

### 4. Check Backup Status
```bash
sudo -u postgres pgbackrest --stanza=demo info
```

---

## 5. Restoration & Recovery (Disaster Recovery Simulation)

### Step 1: Stop PostgreSQL Service
```bash
sudo systemctl stop postgresql
```

### Step 2: Perform Delta Restore
Delta mode verifies existing checksums and only restores changed or missing files:
```bash
sudo -u postgres pgbackrest --stanza=demo --delta restore
```

### Step 3: Start PostgreSQL & Verify Data
```bash
sudo systemctl start postgresql
sudo -u postgres psql -d postgres -c "SELECT * FROM test_backup;"
```

---

## 6. Troubleshooting Common Errors

### Error: `unable to open file '/etc/pgbackrest/pgbackrest.conf' [13] Permission denied`
* **Cause:** User `postgres` does not own or have read access to the directory or config file.
* **Fix:**
  ```bash
  sudo chown -R postgres:postgres /etc/pgbackrest
  sudo chmod 750 /etc/pgbackrest
  sudo chmod 640 /etc/pgbackrest/pgbackrest.conf
  ```

### Error: `[056]: unable to find primary cluster ... fe_sendauth: no password supplied`
* **Cause:** `pg_hba.conf` is configured for `md5` or password authentication on local Unix sockets.
* **Fix:** Change `local` records in `/etc/postgresql/18/main/pg_hba.conf` to `peer` and run `systemctl reload postgresql`.
