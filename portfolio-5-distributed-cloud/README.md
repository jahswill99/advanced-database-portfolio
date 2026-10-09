# Portfolio 5: Distributed and Cloud Database Architecture

## 1. Cloud Deployment Strategy for UNILAG Portal
To guarantee high availability and handle the massive concurrent traffic during semester registration and result publication weeks, the UNILAG academic database is designed to be deployed on a distributed cloud platform (such as AWS RDS or Azure SQL Database).

## 2. Replication and Availability
During peak periods, 90% of the database traffic consists of students reading their results, while only 10% consists of lecturers writing grades. 
* **Master-Slave Replication:** The architecture utilizes a single Primary (Master) node to handle all write operations (e.g., course enrollment, grade entry). 
* **Read Replicas:** Multiple Read Replicas are deployed across different Availability Zones (AZs). When students query their transcripts, the load balancer routes their requests to the read replicas, preventing the primary node from crashing.
* **High Availability:** If the primary node fails, an automated failover mechanism immediately promotes one of the synchronized read replicas to become the new primary node, ensuring zero downtime.

## 3. Database Sharding (Horizontal Partitioning)
As the university accumulates decades of academic records, a single database server will reach its storage and I/O limits. 
* **Sharding Key:** To solve this, the `GRADE_RECORD` and `ENROLLMENT` tables are horizontally sharded based on the `faculty_id` or `admission_year`. 
* **Implementation:** Records for the Faculty of Engineering and Faculty of Science are stored on separate physical database shards. This reduces the size of the indexes and dramatically speeds up query processing times.

## 4. Consistency vs. Availability (CAP Theorem)
* **Strong Consistency:** For financial transactions (tuition payments) and course registration (where a class has a strict limit of 50 seats), the database enforces strong consistency. All nodes must reflect the same data simultaneously to prevent overbooking.
* **Eventual Consistency:** For the NoSQL LMS activity logs (discussed in Portfolio 4), the system tolerates eventual consistency. If a student's forum post takes a few extra milliseconds to replicate across all cloud nodes, it does not impact the integrity of the university's academic operations.
