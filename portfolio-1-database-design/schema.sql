-- UNILAG Academic Records and Result Management Portal Schema
-- Normalised to 3NF

CREATE TABLE FACULTY (
    faculty_id INT AUTO_INCREMENT PRIMARY KEY,
    faculty_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE DEPARTMENT (
    dept_id INT AUTO_INCREMENT PRIMARY KEY,
    dept_name VARCHAR(100) NOT NULL,
    faculty_id INT,
    CONSTRAINT fk_dept_faculty FOREIGN KEY (faculty_id) REFERENCES FACULTY(faculty_id) ON DELETE CASCADE
);

CREATE TABLE STUDENT (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    matric_no VARCHAR(20) NOT NULL UNIQUE,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE,
    dept_id INT,
    enrollment_year YEAR,
    CONSTRAINT fk_student_dept FOREIGN KEY (dept_id) REFERENCES DEPARTMENT(dept_id)
);

CREATE TABLE LECTURER (
    lecturer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    dept_id INT,
    CONSTRAINT fk_lecturer_dept FOREIGN KEY (dept_id) REFERENCES DEPARTMENT(dept_id)
);

CREATE TABLE COURSE (
    course_code VARCHAR(10) PRIMARY KEY,
    course_title VARCHAR(100) NOT NULL,
    credit_units INT NOT NULL CHECK (credit_units BETWEEN 1 AND 6),
    dept_id INT,
    CONSTRAINT fk_course_dept FOREIGN KEY (dept_id) REFERENCES DEPARTMENT(dept_id)
);

CREATE TABLE GRADE_RECORD (
    record_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT,
    course_code VARCHAR(10),
    semester VARCHAR(20),
    ca_score DECIMAL(5,2) DEFAULT 0.00 CHECK (ca_score <= 40),
    exam_score DECIMAL(5,2) DEFAULT 0.00 CHECK (exam_score <= 60),
    total_score DECIMAL(5,2) GENERATED ALWAYS AS (ca_score + exam_score) STORED,
    CONSTRAINT fk_grade_student FOREIGN KEY (student_id) REFERENCES STUDENT(student_id),
    CONSTRAINT fk_grade_course FOREIGN KEY (course_code) REFERENCES COURSE(course_code),
    CONSTRAINT chk_total_score CHECK (total_score <= 100)
);
