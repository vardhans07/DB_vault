
🛠 Step 1: Launch SQL*Plus
====================================================

```bash

$ sqlplus system/password@ORCL🛠 Git/GitHub Workflow: Create Repo → Push Frontend Files → New Branch → Pull Request → Merge
Step 1: Create a new repository on GitHub
====================================================
Go to GitHub → Click New repository → Name it (e.g., frontend-app) → Click Create repository.

Step 2: Initialize Git locally and connect to GitHub
====================================================
Bashcd my-frontend-project          # Navigate to your project folder
git init                        # Initialize a new Git repository
git remote add origin https://github.com/username/frontend-app.git

Step 3: Add and commit all frontend files
====================================================
Bashgit add .                       # Stage all files
git commit -m "Initial commit with frontend files"

Step 4: Push to GitHub main branch
====================================================
Bashgit branch -M main              # Rename default branch to main
git push -u origin main         # Push code to GitHub and set upstream

Step 5: Make changes locally
====================================================
Edit your frontend files (e.g., update UI components, fix bugs, add features).

Step 6: Create a new branch for your changes
====================================================
Bashgit checkout -b feature-update-ui

Step 7: Stage and commit changes in the new branch
====================================================
Bashgit add .
git commit -m "Updated UI components"

Step 8: Push the new branch to GitHub
====================================================
Bashgit push origin feature-update-ui

Step 9: Open a Pull Request (PR) on GitHub
====================================================
Go to your repository on GitHub.
You will see a prompt to create a Pull Request for the feature-update-ui branch.
Click Compare & pull request → Add a clear description of your changes → Click Create pull request.

Step 10: Review and Merge the Pull Request
====================================================

Team members (or you) review the changes in the Pull Request.
Once approved, click Merge pull request → Confirm the merge into the main branch.


Step 11: Update your local main branch
====================================================
Bashgit checkout main
git pull origin main            # Pull the latest changes from GitHub

⚡ Summary
====================================================
Bash1. Create repo on GitHub
2. git init + remote add origin
3. git add . + git commit
4. git branch -M main + git push -u origin main
5. Make changes locally
6. git checkout -b feature-update-ui
7. git add . + git commit
8. git push origin feature-update-ui
9. Create Pull Request on GitHub
10. Review & Merge PR
11. git checkout main + git pull origin main

✅ Recommended Workflow:
```
You’ll get the SQL> prompt inside SQL*Plus.


🛠 Step 2: Run @ac
====================================================

```bash
SQL> @ac
```
This runs the script file ac.sql.
Typically, DBAs name ac.sql as “Active Sessions” script.
Inside it, you might see queries like:

```bash
SQL>  SELECT sid, serial#, username, status, sql_id
      FROM v$session
      WHERE username IS NOT NULL;
```
Output example:
====================================================

```bash
SID  SERIAL#  USERNAME   STATUS   SQL_ID
---  -------  --------   ------   ----------
 45     1234  HR         ACTIVE   7g3kq9u1b2x1a
 62     5678  SALES      INACTIVE 9h4m2kq8d7x3b
```


🛠 Step 3: Run DEF
====================================================

```bash
SQL> DEF
```
This shows all defined substitution variables in SQL*Plus.

Example output:
====================================================
```bash 
DEFINE _DATE           = "10-APR-26"
DEFINE _USER           = "SYSTEM"
DEFINE _CONNECT_IDENTIFIER = "ORCL"
```


🛠 Step 4: Run @sql_id
====================================================

```bash
SQL> @sql_id
```

This runs a script (often named sql_id.sql) that takes a SQL_ID and shows details.
Inside, it might query:


```bash
SQL>  SELECT sql_id, sql_text, executions, elapsed_time
      FROM v$sql
      WHERE sql_id = '&sql_id';
```
Output example:
====================================================
```bash
SQL_ID        SQL_TEXT                          EXECUTIONS ELAPSED_TIME
----------    -------------------------------- ---------- ------------
7g3kq9u1b2x1a SELECT * FROM employees WHERE...        12        0.05
```

⚡ Summary
====================================================
```bash
@ac → runs a script that lists active sessions and their SQL_IDs.
DEF → shows defined variables in SQL*Plus.
@sql_id → runs a script to display details about a specific SQL_ID.
```

✅ So when you run them in sequence:
====================================================


$ sqlplus system/password@ORCL
====================================================
```bash
 SQL> @ac      → shows active sessions
```
```bash
SQL> DEF      → shows defined variables
```
```bash
 SQL> @sql_id  → shows details of a query by SQL_ID
```



