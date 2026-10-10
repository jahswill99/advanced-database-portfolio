# Portfolio 1: Database Design and Modelling

## Chosen Case Study Description
The selected case study is the University of Lagos (UNILAG) – Academic Records and Result Management Portal. This relational database system is designed to manage the core academic administration processes of a university. It tracks hierarchical institutional structures (Faculties and Departments), manages student enrollment data across academic sessions, assigns lecturers, and maintains a comprehensive course catalog. Crucially, the system records student academic performance, enforcing constraints on Continuous Assessment (CA) and Examination scores, and automatically computes total grades to facilitate transcript generation.

## Normalisation Explanation (to 3NF)
The database schema has been meticulously designed and normalized up to the Third Normal Form (3NF) to ensure data integrity and eliminate redundancy:
* **First Normal Form (1NF):** All tables have a defined primary key (e.g., `student_id`, `course_id`). All attributes contain atomic, indivisible values (e.g., `first_name` and `last_name` are separate columns). There are no repeating groups.
* **Second Normal Form (2NF):** The schema meets 1NF, and all non-key attributes are fully functionally dependent on the primary key. 
* **Third Normal Form (3NF):** The schema meets 2NF, and there are no transitive dependencies. Non-key attributes depend *only* on the primary key. For instance, the `ENROLLMENT` table links `student_id` and `session_id` as foreign keys rather than storing redundant student or session details directly.

## Entity-Relationship (ER) Diagram

```mermaid
erDiagram
    FACULTY ||--o{ DEPARTMENT : "contains"
    DEPARTMENT ||--o{ STUDENT : "enrolls"
    DEPARTMENT ||--o{ LECTURER : "employs"
    DEPARTMENT ||--o{ COURSE : "offers"
    STUDENT ||--o{ ENROLLMENT : "has"
    ACADEMIC_SESSION ||--o{ ENROLLMENT : "records"
    ENROLLMENT ||--o{ GRADE_RECORD : "receives"
    COURSE ||--o{ GRADE_RECORD : "assessed_in"

    FACULTY {
        int faculty_id PK
        string faculty_code
        string faculty_name
    }
    DEPARTMENT {
        int department_id PK
        string department_name
        int faculty_id FK
    }
    STUDENT {
        int student_id PK
        string matric_no
        string first_name
        string last_name
        string email
        string phone
        year admission_year
        int department_id FK
    }
    LECTURER {
        int lecturer_id PK
        string staff_no
        string first_name
        string last_name
        string email
        int department_id FK
    }
    COURSE {
        int course_id PK
        string course_code
        string course_title
        tinyint credit_units
        int level
        int department_id FK
    }
    ACADEMIC_SESSION {
        int session_id PK
        string session_name
        string semester
        boolean is_active
    }
    ENROLLMENT {
        int enrollment_id PK
        int student_id FK
        int session_id FK
        datetime registration_date
        string status
    }
    GRADE_RECORD {
        int grade_id PK
        int enrollment_id FK
        int course_id FK
        decimal ca_score
        decimal exam_score
        decimal total_score
        char grade_letter
        tinyint grade_point
    }
```
