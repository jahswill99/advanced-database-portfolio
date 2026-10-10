# Portfolio 1: Database Design and Modelling

## Chosen Case Study Description
The selected case study is the University of Lagos (UNILAG) – Academic Records and Result Management Portal. This relational database system is designed to manage the core academic administration processes of a university. It tracks hierarchical institutional structures (Faculties and Departments), manages student enrollment data, assigns lecturers to departments, and maintains a comprehensive course catalog. Crucially, the system records student academic performance, enforcing constraints on Continuous Assessment (CA) and Examination scores, and automatically computes total grades to facilitate transcript generation.

## Normalisation Explanation (to 3NF)
The database schema has been meticulously designed and normalized up to the Third Normal Form (3NF) to ensure data integrity and eliminate redundancy:
* **First Normal Form (1NF):** All tables have a defined primary key (e.g., `student_id`, `course_code`). All attributes contain atomic, indivisible values (e.g., `first_name` and `last_name` are separate columns). There are no repeating groups.
* **Second Normal Form (2NF):** The schema meets 1NF, and all non-key attributes are fully functionally dependent on the primary key. 
* **Third Normal Form (3NF):** The schema meets 2NF, and there are no transitive dependencies. Non-key attributes depend *only* on the primary key. For instance, the `STUDENT` table stores `dept_id` as a foreign key rather than storing the `dept_name` directly, ensuring that departmental details are managed in the `DEPARTMENT` table.

## Entity-Relationship (ER) Diagram

```mermaid
erDiagram
    FACULTY ||--o{ DEPARTMENT : "contains"
    DEPARTMENT ||--o{ STUDENT : "enrolls"
    DEPARTMENT ||--o{ LECTURER : "employs"
    DEPARTMENT ||--o{ COURSE : "offers"
    STUDENT ||--o{ GRADE_RECORD : "has"
    COURSE ||--o{ GRADE_RECORD : "recorded_in"

    FACULTY {
        int faculty_id PK
        string faculty_name
    }
    DEPARTMENT {
        int dept_id PK
        string dept_name
        int faculty_id FK
    }
    STUDENT {
        int student_id PK
        string matric_no
        string first_name
        string last_name
        date date_of_birth
        int dept_id FK
        year enrollment_year
    }
    LECTURER {
        int lecturer_id PK
        string first_name
        string last_name
        string email
        int dept_id FK
    }
    COURSE {
        string course_code PK
        string course_title
        int credit_units
        int dept_id FK
    }
    GRADE_RECORD {
        int record_id PK
        int student_id FK
        string course_code FK
        string semester
        decimal ca_score
        decimal exam_score
        decimal total_score
    }
```
