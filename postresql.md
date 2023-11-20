# PostgreSQL Database Concurrency Issues Demonstration

## Introduction
This document provides a guide to setting up PostgreSQL with Docker Compose and demonstrates four key database concurrency problems: Lost Update, Dirty Read, Non-Repeatable Read, and Phantom Read. Each section includes SQL commands to replicate these issues and placeholders for screenshots.

## Setup

### Starting PostgreSQL with Docker Compose
Run the following command to start the PostgreSQL service:

```bash
docker compose up -d postgresql adminer
```

### Pre-Setup Commands

For PostgreSQL, the transaction isolation level can be set per session.

## Concurrency Problems

### 1. Lost Update
Occurs when two transactions update the same record, and the last update overwrites the first, leading to a loss of data.

**Session 1:**
```sql
BEGIN;
SELECT balance FROM users WHERE id = 1;
UPDATE users SET balance = balance + 100 WHERE id = 1;
-- Delay until commit in s2
COMMIT;
SELECT balance FROM users WHERE id = 1;
```

**Session 2:**
```sql
BEGIN;
SELECT balance FROM users WHERE id = 1;
UPDATE users SET balance = balance - 50 WHERE id = 1;
COMMIT;
```

![lost-update-1](screenshots/postresql/lost-update-1.png)
![lost-update-2](screenshots/postresql/lost-update-2.png)
![lost-update-3](screenshots/postresql/lost-update-3.png)

### 2. Dirty Read
Occurs when a transaction reads data that has been modified by another transaction but not yet committed. Note: PostgreSQL does not allow dirty reads; the lowest isolation level is READ COMMITTED. In PostgreSQL READ UNCOMMITTED is treated as READ COMMITTED.

**Session 1:**
```sql
BEGIN;
SELECT balance FROM users WHERE id = 1;
UPDATE users SET balance = balance + 100 WHERE id = 1;
-- Delay
COMMIT;
```

**Session 2:**
*Cannot be demonstrated in PostgreSQL as it does not support dirty reads.*

### 3. Non-Repeatable Read
Occurs when a transaction reads the same row twice and gets different data each time due to another transaction's update.

**Preparation:**
```sql
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
```

**Session 1:**
```sql
BEGIN;
SELECT balance FROM users WHERE id = 1;
-- Delay until first select in s2
UPDATE users SET balance = balance + 100 WHERE id = 1;
COMMIT;
```

**Session 2:**
```sql
BEGIN;
SELECT balance FROM users WHERE id = 1;
-- Delay until commit in s1
SELECT balance FROM users WHERE id = 1;
```

![non-repeatable-read-1](screenshots/postresql/non-repeatable-read-1.png)
![non-repeatable-read-2](screenshots/postresql/non-repeatable-read-2.png)
![non-repeatable-read-3](screenshots/postresql/non-repeatable-read-3.png)
![non-repeatable-read-4](screenshots/postresql/non-repeatable-read-4.png)

### 4. Phantom Read
Occurs when a transaction re-executes a query returning a set of rows that satisfy a search condition and finds that the set has changed due to another recently committed transaction.

**Preparation:**
```sql
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
```

**Session 1:**
```sql
BEGIN;
SELECT * FROM users WHERE balance > 600;
-- Delay until insert in s2
SELECT * FROM users WHERE balance > 600;
COMMIT;
```

**Session 2:**
```sql
BEGIN;
INSERT INTO users (name, phone, email, date_of_birth, balance) VALUES ('Codey Johnson', '012-345-6789', 'codey.johnson@email.com', '1967-11-27', 700);
COMMIT;
```

![phantom-read-1](screenshots/postresql/phantom-read-1.png)
![phantom-read-2](screenshots/postresql/phantom-read-2.png)
![phantom-read-3](screenshots/postresql/phantom-read-3.png)

---

### Notes:
- PostgreSQL handles transaction isolation differently than MySQL/Percona. It doesn't support the `READ UNCOMMITTED` isolation level, which prevents the demonstration of dirty reads.
