# Portfolio 4: NoSQL and Advanced Data Models

## 1. Selected NoSQL Data Model
**Model Type:** Document-Based Database (e.g., MongoDB)
**Case Study Application:** UNILAG E-Learning & LMS Activity Log

## 2. Explanation of Suitability
While the relational SQL database efficiently handles rigid, transactional data like financial payments and official exam grades, the university portal also generates massive amounts of semi-structured data, such as student LMS activity, forum posts, and login metadata. 

A Document-based NoSQL database is highly suitable for this because:
* **Flexible Schema:** Not every student will interact with the LMS in the same way. Some will have arrays of forum comments; others will have none. Document databases do not require empty columns for missing data.
* **Nested Data Structures:** We can store a student's recent assignments and device login history within a single document using arrays, eliminating the need for complex `JOIN` operations across multiple tables.
* **Horizontal Scalability:** As thousands of students generate daily LMS logs, document databases can be easily sharded across multiple servers to handle the heavy write load.

## 3. NoSQL Implementation Example (JSON Document)
Below is a JSON document representing a single student's LMS activity log.

```json
{
  "_id": "log_98374592",
  "student_matric_no": "MIT26001",
  "session_name": "2026/2027",
  "last_login": {
    "timestamp": "2026-10-09T08:30:00Z",
    "ip_address": "197.210.64.12",
    "device": "Google Pixel 9"
  },
  "forum_activity": [
    {
      "course_code": "MIT8103",
      "post_id": "post_001",
      "content": "Can someone explain the difference between B-Trees and Hash Indexes?",
      "upvotes": 4,
      "date_posted": "2026-10-08T14:15:00Z"
    }
  ],
  "recent_submissions": [
    {
      "course_code": "MIT8104",
      "assignment_name": "Subnetting Practice",
      "file_url": "[https://unilag-lms-storage.edu.ng/mit26001/subnetting.pdf](https://unilag-lms-storage.edu.ng/mit26001/subnetting.pdf)",
      "submitted_at": "2026-10-07T22:45:00Z"
    }
  ]
}
