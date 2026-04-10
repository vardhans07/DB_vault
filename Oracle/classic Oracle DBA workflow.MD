
##🛠 Step 1: Launch SQL*Plus

--bash

$ sqlplus system/password@ORCL
---
--You’ll get the SQL> prompt inside SQL*Plus.


  --🛠 Step 2: Run @ac

SQL> @ac

--This runs the script file ac.sql.
--Typically, DBAs name ac.sql as “Active Sessions” script.
--Inside it, you might see queries like:

SQL>  SELECT sid, serial#, username, status, sql_id
      FROM v$session
      WHERE username IS NOT NULL;

--Output example:

SID  SERIAL#  USERNAME   STATUS   SQL_ID
---  -------  --------   ------   ----------
 45     1234  HR         ACTIVE   7g3kq9u1b2x1a
 62     5678  SALES      INACTIVE 9h4m2kq8d7x3b



--🛠 Step 3: Run DEF

SQL> DEF

--This shows all defined substitution variables in SQL*Plus.
--Example output:

DEFINE _DATE           = "10-APR-26"
DEFINE _USER           = "SYSTEM"
DEFINE _CONNECT_IDENTIFIER = "ORCL"



--🛠 Step 4: Run @sql_id

SQL> @sql_id

--This runs a script (often named sql_id.sql) that takes a SQL_ID and shows details.
--Inside, it might query:

SQL>  SELECT sql_id, sql_text, executions, elapsed_time
      FROM v$sql
      WHERE sql_id = '&sql_id';

--Output example:

SQL_ID        SQL_TEXT                          EXECUTIONS ELAPSED_TIME
----------    -------------------------------- ---------- ------------
7g3kq9u1b2x1a SELECT * FROM employees WHERE...        12        0.05


--⚡ Summary
--@ac → runs a script that lists active sessions and their SQL_IDs.
--DEF → shows defined variables in SQL*Plus.
--@sql_id → runs a script to display details about a specific SQL_ID.


--✅ So when you run them in sequence:
  
$ sqlplus system/password@ORCL
SQL> @ac      → shows active sessions
SQL> DEF      → shows defined variables
SQL> @sql_id  → shows details of a query by SQL_ID





