# Portfolio 5: Distributed Database Architecture

## 1. Cloud Architecture Strategy
To ensure high availability and performance for the UNILAG academic portal—especially during peak periods like course registration or result publication—the database must transition from a single-node setup to a distributed cloud architecture.

## 2. Replication and High Availability
The proposed architecture utilizes a **Master-Slave (Primary-Replica) Replication** model:
* **Master Node:** Handles all write operations (e.g., lecturers entering new grades, students registering for courses).
* **Read Replicas (Slave Nodes):** Synchronize data from the master node and handle all read-only queries (e.g., students viewing their transcripts or checking their results). 
* **Benefit:** This prevents the database from becoming overwhelmed when thousands of students log in simultaneously, as the read load is distributed across multiple replica servers.

## 3. Sharding Strategy (Horizontal Partitioning)
As the university's historical records grow, we will implement **Horizontal Sharding** based on the `faculty_id` or `department_id`.
* **Example:** All data for the Faculty of Science (`faculty_id = 1`) resides on Shard A, while data for the Faculty of Engineering (`faculty_id = 2`) resides on Shard B. 
* **Benefit:** Queries are routed directly to the specific shard holding that faculty's data, significantly reducing the search space and speeding up database response times.

## 4. Cloud Deployment 
This distributed setup can be deployed using a managed cloud database service like Amazon RDS or Amazon Aurora. These services automatically manage failover (switching to a replica if the master fails), automated backups, and the dynamic scaling of read replicas during peak traffic periods.


## 5. Deployment Evidence (Simulated Configuration)
To provide evidence of how this distributed architecture would be provisioned, below is a simulated `docker-compose.yml` infrastructure-as-code snippet. This configuration deploys the UNILAG portal's Master-Slave replication setup using containerized database instances.

```yaml
version: '3.8'
services:
  unilag-db-master:
    image: mysql:8.0
    container_name: unilag-primary-db
    environment:
      MYSQL_ROOT_PASSWORD: admin_password
      MYSQL_DATABASE: unilag_portal
    ports:
      - "3306:3306"
    command: --server-id=1 --log-bin=mysql-bin --binlog-format=ROW

  unilag-db-replica-1:
    image: mysql:8.0
    container_name: unilag-read-replica
    environment:
      MYSQL_ROOT_PASSWORD: admin_password
    ports:
      - "3307:3306"
    command: --server-id=2 --read-only=1
    depends_on:
      - unilag-db-master
```
