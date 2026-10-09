**Schema (MySQL v8)**

    -- UNILAG Student Result and Portal Database Schema
    CREATE TABLE FACULTY (
        faculty_id INT AUTO_INCREMENT PRIMARY KEY,
        faculty_code VARCHAR(10) NOT NULL UNIQUE,
        faculty_name VARCHAR(100) NOT NULL
    );
    
    CREATE TABLE DEPARTMENT (
        department_id INT AUTO_INCREMENT PRIMARY KEY,
        department_name VARCHAR(100) NOT NULL,
        faculty_id INT NOT NULL,
        CONSTRAINT fk_dept_faculty FOREIGN KEY (faculty_id) 
            REFERENCES FACULTY(faculty_id) ON DELETE RESTRICT ON UPDATE CASCADE
    );
    
    CREATE TABLE STUDENT (
        student_id INT AUTO_INCREMENT PRIMARY KEY,
        matric_no VARCHAR(20) NOT NULL UNIQUE,
        first_name VARCHAR(50) NOT NULL,
        last_name VARCHAR(50) NOT NULL,
        email VARCHAR(100) NOT NULL UNIQUE,
        phone VARCHAR(20),
        admission_year YEAR NOT NULL,
        department_id INT NOT NULL,
        CONSTRAINT fk_student_dept FOREIGN KEY (department_id) 
            REFERENCES DEPARTMENT(department_id) ON DELETE RESTRICT ON UPDATE CASCADE
    );
    
    CREATE TABLE LECTURER (
        lecturer_id INT AUTO_INCREMENT PRIMARY KEY,
        staff_no VARCHAR(20) NOT NULL UNIQUE,
        first_name VARCHAR(50) NOT NULL,
        last_name VARCHAR(50) NOT NULL,
        email VARCHAR(100) NOT NULL UNIQUE,
        department_id INT NOT NULL,
        CONSTRAINT fk_lecturer_dept FOREIGN KEY (department_id) 
            REFERENCES DEPARTMENT(department_id) ON DELETE RESTRICT ON UPDATE CASCADE
    );
    
    CREATE TABLE COURSE (
        course_id INT AUTO_INCREMENT PRIMARY KEY,
        course_code VARCHAR(10) NOT NULL UNIQUE,
        course_title VARCHAR(150) NOT NULL,
        credit_units TINYINT NOT NULL CHECK (credit_units BETWEEN 1 AND 6),
        level INT NOT NULL,
        department_id INT NOT NULL,
        CONSTRAINT fk_course_dept FOREIGN KEY (department_id) 
            REFERENCES DEPARTMENT(department_id) ON DELETE RESTRICT ON UPDATE CASCADE
    );
    
    CREATE TABLE ACADEMIC_SESSION (
        session_id INT AUTO_INCREMENT PRIMARY KEY,
        session_name VARCHAR(20) NOT NULL,
        semester ENUM('FIRST', 'SECOND') NOT NULL,
        is_active BOOLEAN DEFAULT FALSE,
        CONSTRAINT uq_session_sem UNIQUE (session_name, semester)
    );
    
    CREATE TABLE ENROLLMENT (
        enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
        student_id INT NOT NULL,
        session_id INT NOT NULL,
        registration_date DATETIME DEFAULT CURRENT_TIMESTAMP,
        status ENUM('PENDING', 'APPROVED', 'REJECTED') DEFAULT 'APPROVED',
        CONSTRAINT uq_student_session UNIQUE (student_id, session_id),
        CONSTRAINT fk_enroll_student FOREIGN KEY (student_id) 
            REFERENCES STUDENT(student_id) ON DELETE CASCADE ON UPDATE CASCADE,
        CONSTRAINT fk_enroll_session FOREIGN KEY (session_id) 
            REFERENCES ACADEMIC_SESSION(session_id) ON DELETE RESTRICT ON UPDATE CASCADE
    );
    
    CREATE TABLE GRADE_RECORD (
        grade_id INT AUTO_INCREMENT PRIMARY KEY,
        enrollment_id INT NOT NULL,
        course_id INT NOT NULL,
        ca_score DECIMAL(5,2) DEFAULT 0.00 CHECK (ca_score BETWEEN 0 AND 40),
        exam_score DECIMAL(5,2) DEFAULT 0.00 CHECK (exam_score BETWEEN 0 AND 60),
        total_score DECIMAL(5,2) GENERATED ALWAYS AS (ca_score + exam_score) STORED,
        grade_letter CHAR(1),
        grade_point TINYINT,
        CONSTRAINT uq_enrollment_course UNIQUE (enrollment_id, course_id),
        CONSTRAINT fk_grade_enrollment FOREIGN KEY (enrollment_id) 
            REFERENCES ENROLLMENT(enrollment_id) ON DELETE CASCADE ON UPDATE CASCADE,
        CONSTRAINT fk_grade_course FOREIGN KEY (course_id) 
            REFERENCES COURSE(course_id) ON DELETE RESTRICT ON UPDATE CASCADE
    );
    
    -- ==========================================
    -- MOCK DATA INSERTION
    -- ==========================================
    
    INSERT INTO FACULTY (faculty_code, faculty_name) VALUES 
    ('SCI', 'Science'),
    ('ENG', 'Engineering');
    
    INSERT INTO DEPARTMENT (department_name, faculty_id) VALUES 
    ('Computer Sciences', 1),
    ('Mathematics', 1);
    
    INSERT INTO STUDENT (matric_no, first_name, last_name, email, phone, admission_year, department_id) VALUES 
    ('MIT26001', 'Samuel', 'Okafor', 'samuel.o@student.unilag.edu.ng', '08012345678', 2026, 1),
    ('MIT26002', 'Aisha', 'Bello', 'aisha.b@student.unilag.edu.ng', '08087654321', 2026, 1),
    ('MIT26003', 'Chinedu', 'Eze', 'chinedu.e@student.unilag.edu.ng', '08122334455', 2026, 2);
    
    INSERT INTO LECTURER (staff_no, first_name, last_name, email, department_id) VALUES 
    ('STF1001', 'Dr. Kunle', 'Adebayo', 'kadebayo@unilag.edu.ng', 1),
    ('STF1002', 'Prof. Ngozi', 'Nnaji', 'nnnaji@unilag.edu.ng', 2);
    
    INSERT INTO COURSE (course_code, course_title, credit_units, level, department_id) VALUES 
    ('MIT8103', 'Advanced Database Systems', 3, 800, 1),
    ('MIT8104', 'Network Operations and Routing', 3, 800, 1),
    ('MIT8105', 'Advanced Cryptography', 2, 800, 2);
    
    INSERT INTO ACADEMIC_SESSION (session_name, semester, is_active) VALUES 
    ('2026/2027', 'FIRST', TRUE);
    
    INSERT INTO ENROLLMENT (student_id, session_id, status) VALUES 
    (1, 1, 'APPROVED'),
    (2, 1, 'APPROVED'),
    (3, 1, 'APPROVED');
    
    INSERT INTO GRADE_RECORD (enrollment_id, course_id, ca_score, exam_score, grade_letter, grade_point) VALUES 
    (1, 1, 30.50, 45.00, 'A', 5),
    (1, 2, 28.00, 52.00, 'A', 5),
    (2, 1, 15.00, 35.00, 'C', 3),
    (3, 3, 22.00, 40.00, 'B', 4);

---

**Query #1**

    -- Query 1: Generate Student Transcript for MIT26001
    SELECT 
        s.matric_no, 
        CONCAT(s.first_name, ' ', s.last_name) AS student_name,
        c.course_code, 
        c.course_title, 
        c.credit_units, 
        g.ca_score, 
        g.exam_score, 
        g.total_score, 
        g.grade_letter, 
        g.grade_point
    FROM STUDENT s
    JOIN ENROLLMENT e ON s.student_id = e.student_id
    JOIN GRADE_RECORD g ON e.enrollment_id = g.enrollment_id
    JOIN COURSE c ON g.course_id = c.course_id
    WHERE s.matric_no = 'MIT26001';

| matric_no | student_name  | course_code | course_title                   | credit_units | ca_score | exam_score | total_score | grade_letter | grade_point |
| --------- | ------------- | ----------- | ------------------------------ | ------------ | -------- | ---------- | ----------- | ------------ | ----------- |
| MIT26001  | Samuel Okafor | MIT8103     | Advanced Database Systems      | 3            | 30.5     | 45.0       | 75.5        | A            | 5           |
| MIT26001  | Samuel Okafor | MIT8104     | Network Operations and Routing | 3            | 28.0     | 52.0       | 80.0        | A            | 5           |

---

[View on DB Fiddle](https://www.db-fiddle.com/)
