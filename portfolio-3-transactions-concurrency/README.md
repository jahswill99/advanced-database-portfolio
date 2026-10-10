# Portfolio 3: Transactions and Concurrency

## 1. Transaction Scenario: Grade Update and Concurrency Control
In the UNILAG academic portal, multiple administrators or lecturers might attempt to update a student's grade simultaneously. Without proper concurrency control, this can lead to a "lost update" anomaly, where one person's changes overwrite another's without accounting for the latest data. 

To prevent this, we implement a transaction using row-level locking (`SELECT ... FOR UPDATE`).

## 2. SQL Implementation
The following transaction locks a specific grade record before updating it. Any other transaction attempting to read or modify this specific row will be forced to wait until this transaction completes.

```sql
START TRANSACTION;

-- Step 1: Read and lock the specific grade record
SELECT ca_score, exam_score, total_score 
FROM GRADE_RECORD 
WHERE grade_id = 1 
FOR UPDATE;

-- Step 2: Update the exam score (total_score is auto-computed by the schema)
UPDATE GRADE_RECORD 
SET exam_score = 48.50 
WHERE grade_id = 1;

-- Step 3: Commit the changes and release the lock
COMMIT;
```

## 3. ACID Properties Demonstrated
* **Atomicity:** The `START TRANSACTION` and `COMMIT` commands ensure that all steps in the grade update succeed together. If an error occurs before the commit, the entire transaction can be rolled back.
* **Consistency:** The database schema enforces rules (e.g., `exam_score <= 60`). The transaction will fail if the update violates these constraints, keeping the database logically consistent.
* **Isolation:** The `FOR UPDATE` clause ensures that this transaction is isolated. Other concurrent sessions cannot modify `grade_id = 1` until the lock is released.
* **Durability:** Once the `COMMIT` is successful, the updated grade is permanently saved to the database and will survive any subsequent system crashes.
