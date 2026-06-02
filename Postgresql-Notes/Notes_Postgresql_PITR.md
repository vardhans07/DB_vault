🔑 Why recovery.signal is needed
In PostgreSQL 12 and later, recovery settings (recovery_target_time, restore_command, etc.) are placed in postgresql.conf.

To actually trigger recovery, you must create a signal file in the data directory:

recovery.signal → tells PostgreSQL to perform archive recovery / PITR.

standby.signal → tells PostgreSQL to start as a replica / standby.

Without recovery.signal, PostgreSQL will ignore recovery settings and just start normally.




⚙️ What happens when it’s present

1] On startup, PostgreSQL sees recovery.signal.

2] It begins replaying WAL files from your archive/basebackup.

3] It stops when it reaches your recovery_target_time (or other target).

4] It promotes the cluster to normal operation.

5] It automatically removes recovery.signal once recovery is complete.



🧩 Why you had to create it
When you restored your base backup into /var/lib/postgresql/16/main, you needed to tell PostgreSQL: 
"This isn’t a normal startup — this is a recovery run." That’s exactly what touch /var/lib/postgresql/16/main/recovery.signal does.



✅ So in short: recovery.signal is the switch that activates PITR mode. Once recovery finishes, PostgreSQL deletes it, and your cluster runs normally again.

Would you like me to also show you the difference between recovery.signal and the old recovery.conf



############ @@             .history  and 000004.00000028.backup   notes ######################################################




📂 1. 000000010000000000000004.00000028.backup
This is a WAL backup label file.

It gets created when you run a base backup (pg_basebackup or pg_start_backup).

It marks the start and end of the backup inside the WAL stream.

The .backup file tells PostgreSQL:

“This WAL segment contains the point where a backup started.”

It ensures that recovery knows which WAL files are needed to make the base backup consistent.

Without this marker, PostgreSQL wouldn’t know how far to replay WAL to bring the backup to a consistent state.

👉 In your case, 000000010000000000000004.00000028.backup means:

WAL segment 000000010000000000000004 was active when the backup started.

The .00000028 part is an internal offset/identifier for the backup.

📂 2. 00000002.history
This is a timeline history file.

Timelines are created when you do PITR or promote a standby.

Each time recovery ends and the cluster is promoted, PostgreSQL increments the timeline ID (from 1 → 2 → 3, etc.).

The .history file records:

When the new timeline started.

Which WAL segment and LSN (log sequence number) it branched from.

It’s critical for recovery because PostgreSQL must know which timeline to follow when replaying WAL.

👉 In your case:

Timeline switched from 1 → 2 during recovery.

00000002.history records the branching point so future recoveries know where timeline 2 began.

🔑 Why they matter in PITR
.backup → ensures your base backup + WAL replay is consistent.

.history → ensures PostgreSQL knows which timeline to follow after recovery/promotion.

Together, they allow PostgreSQL to:

Validate backups.

Replay WAL correctly.

Handle multiple recovery attempts and promotions without confusion.

✅ So:

.backup = “marker for base backup consistency.”

.history = “marker for timeline switch during recovery.”

Would you like me to show you a timeline diagram (Base Backup → WAL → Recovery Target → New Timeline)
