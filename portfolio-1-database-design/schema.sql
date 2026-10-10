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
