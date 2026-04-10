# 📘 SQL Commands Cheat Sheet

---

## 1. DDL - Data Definition Language
| Command  | Description | Syntax |
|----------|-------------|--------|
| **CREATE** | Create database objects (table, index, function, views, stored procedure, triggers) | `CREATE TABLE table_name (column1 data_type, column2 data_type, ...);` |
| **DROP**   | Delete objects from the database | `DROP TABLE table_name;` |
| **ALTER**  | Alter the structure of the database | `ALTER TABLE table_name ADD COLUMN column_name data_type;` |
| **TRUNCATE** | Remove all records from a table (space is also freed) | `TRUNCATE TABLE table_name;` |
| **COMMENT** | Add comments to the data dictionary | `COMMENT ON TABLE table_name IS 'comment_text';` |
| **RENAME**  | Rename an existing object | `RENAME old_table_name TO new_table_name;` |

---

## 2. DML - Data Manipulation Language
| Command  | Description | Syntax |
|----------|-------------|--------|
| **INSERT** | Insert data into a table | `INSERT INTO table_name (column1, column2, ...) VALUES (value1, value2, ...);` |
| **UPDATE** | Update existing data within a table | `UPDATE table_name SET column1 = value1, column2 = value2 WHERE condition;` |
| **DELETE** | Delete records from a table | `DELETE FROM table_name WHERE condition;` |

---

## 3. DQL - Data Query Language
| Command  | Description | Syntax |
|----------|-------------|--------|
| **SELECT** | Retrieve data from the database | `SELECT column1, column2 FROM table_name WHERE condition;` |

---

## 4. DCL - Data Control Language
| Command  | Description | Syntax |
|----------|-------------|--------|
| **GRANT** | Give privileges to users | `GRANT SELECT, INSERT ON table_name TO user;` |
| **REVOKE** | Remove privileges from users | `REVOKE SELECT, INSERT ON table_name FROM user;` |

---

## 5. TCL - Transaction Control Language
| Command  | Description | Syntax |
|----------|-------------|--------|
| **COMMIT** | Save changes permanently | `COMMIT;` |
| **ROLLBACK** | Undo changes | `ROLLBACK;` |
| **SAVEPOINT** | Set a point to roll back to | `SAVEPOINT savepoint_name;` |
| **SET TRANSACTION** | Configure transaction properties | `SET TRANSACTION READ ONLY;` |

---

✅ This structure makes your notes **easy to scan, attractive, and GitHub‑friendly**.  
- Use **tables** for clarity.  
- Use **code blocks** for syntax.  
- Use **emojis or icons** for visual appeal.  

---

Would you like me to also create a **flowchart‑style Markdown section** (like a mini diagram of how DDL → DML → DQL → DCL → TCL fit together) so your notes look even more like a Jupyter notebook learning guide?
