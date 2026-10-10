# Portfolio 4: NoSQL Implementation

## 1. NoSQL Use Case (UNILAG LMS Activity Logs)
While the core academic portal (students, courses, grades) is highly structured and best suited for a relational database (MySQL), a university also generates massive amounts of unstructured and semi-structured data. A prime example is the Learning Management System (LMS) activity logs—tracking when students watch lecture videos, download materials, or participate in discussion forums. 

## 2. NoSQL Database Choice: Document Store (MongoDB)
A Document-based NoSQL database like MongoDB is ideal for this use case because LMS event data varies wildly depending on the action performed. It does not fit neatly into rigid relational tables.

## 3. JSON Document Structure
Below is an example of how a student's LMS interaction is stored as a flexible JSON document:

```json
{
  "event_id": "evt_987654321",
  "timestamp": "2026-10-10T14:30:00Z",
  "student_matric_no": "MIT26001",
  "course_code": "MIT8103",
  "event_type": "video_playback",
  "event_details": {
    "video_title": "Introduction to Relational Algebra",
    "playback_duration_seconds": 1240,
    "device_info": {
      "os": "Android",
      "browser": "Chrome Mobile",
      "ip_address": "197.210.64.12"
    }
  }
}
```

## 4. Technical Justification
* **Schema Flexibility:** An event for "downloading a syllabus" will have completely different attributes than an event for "taking a quiz." JSON documents allow us to change the `event_details` object on the fly without altering any database schema.
* **High Write Throughput:** LMS platforms generate thousands of activity logs per minute during peak study times. Document stores handle high-velocity write operations far better than highly normalized relational databases.
* **Scalability:** As more UNILAG faculties adopt e-learning, this NoSQL database can easily be sharded and scaled out horizontally across multiple servers.
