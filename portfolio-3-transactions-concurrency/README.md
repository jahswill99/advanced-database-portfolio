# Portfolio 3: Transactions and Concurrency

## 1. Concurrency Control and Isolation (COMMIT)
In the UNILAG academic portal, multiple lecturers might attempt to update a student's grade simultaneously. To prevent a "lost update" anomaly, we implement row-level locking (`SELECT ... FOR UPDATE`). This ensures **Isolation** by forcing concurrent transactions to wait until the lock is released.

**SQL Implementation:**
```sql
START TRANSACTION;

-- Step 1: Lock the specific grade record for MIT26001 (grade_id = 1)
SELECT ca_score, exam_score, total_score 
FROM GRADE_RECORD 
WHERE grade_id = 1 
FOR UPDATE;

-- Step 2: Update the exam score
UPDATE GRADE_RECORD 
SET exam_score = 48.50 
WHERE grade_id = 1;

-- Step 3: Persist the changes
COMMIT;
```

**Output Evidence (After Commit):**
| grade_id | enrollment_id | course_id | ca_score | exam_score | total_score | grade_letter |
| -------- | ------------- | --------- | -------- | ---------- | ----------- | ------------ |
| 1        | 1             | 1         | 30.50    | 48.50      | 79.00       | A            |

<img width="1360" height="609" alt="image" src="https://github.com/user-attachments/assets/6d954eb9-6ab6-4930-8457-130cf17201b3" />

---

## 2. Transaction Error Handling (ROLLBACK)
Transactions ensure **Atomicity**. If an operation violates university policy (e.g., entering an exam score greater than the maximum 60 marks), the system triggers an error, and the entire transaction is rolled back to keep the database consistent.

**SQL Implementation:**
```sql
START TRANSACTION;

-- Step 1: Attempt an invalid update (85 is over the 60 mark limit)
UPDATE GRADE_RECORD 
SET exam_score = 85.00 
WHERE grade_id = 1;

-- ERROR 3819 (HY000): Check constraint 'chk_exam_score' is violated.
-- Step 2: Revert the transaction to maintain data integrity
ROLLBACK;
```

**Output Evidence (After Rollback):**
*The query fails and the record reverts to its previous state, preserving consistency.*
| grade_id | enrollment_id | course_id | ca_score | exam_score | total_score | grade_letter |
| -------- | ------------- | --------- | -------- | ---------- | ----------- | ------------ |
| 1        | 1             | 1         | 30.50    | 48.50      | 79.00       | A            |

<img width="1365" height="482" alt="image" src="https://github.com/user-attachments/assets/9b463dfa-4bd8-4533-bea7-a0e8cf496b55" />

