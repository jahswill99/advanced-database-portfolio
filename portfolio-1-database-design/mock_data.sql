-- 1. Insert Faculties
INSERT INTO FACULTY (faculty_code, faculty_name) VALUES 
('SCI', 'Science'),
('ENG', 'Engineering');

-- 2. Insert Departments
INSERT INTO DEPARTMENT (department_name, faculty_id) VALUES 
('Computer Sciences', 1),
('Mathematics', 1);

-- 3. Insert Students
INSERT INTO STUDENT (matric_no, first_name, last_name, email, phone, admission_year, department_id) VALUES 
('MIT26001', 'Samuel', 'Okafor', 'samuel.o@student.unilag.edu.ng', '08012345678', 2026, 1),
('MIT26002', 'Aisha', 'Bello', 'aisha.b@student.unilag.edu.ng', '08087654321', 2026, 1),
('MIT26003', 'Chinedu', 'Eze', 'chinedu.e@student.unilag.edu.ng', '08122334455', 2026, 2);

-- 4. Insert Lecturers
INSERT INTO LECTURER (staff_no, first_name, last_name, email, department_id) VALUES 
('STF1001', 'Dr. Kunle', 'Adebayo', 'kadebayo@unilag.edu.ng', 1),
('STF1002', 'Prof. Ngozi', 'Nnaji', 'nnnaji@unilag.edu.ng', 2);

-- 5. Insert Courses
INSERT INTO COURSE (course_code, course_title, credit_units, level, department_id) VALUES 
('MIT8103', 'Advanced Database Systems', 3, 800, 1),
('MIT8104', 'Network Operations and Routing', 3, 800, 1),
('MIT8105', 'Advanced Cryptography', 2, 800, 2);

-- 6. Insert Academic Session
INSERT INTO ACADEMIC_SESSION (session_name, semester, is_active) VALUES 
('2026/2027', 'FIRST', TRUE);

-- 7. Insert Enrollments
INSERT INTO ENROLLMENT (student_id, session_id, status) VALUES 
(1, 1, 'APPROVED'),
(2, 1, 'APPROVED'),
(3, 1, 'APPROVED');

-- 8. Insert Grade Records (Total Score is generated automatically by our schema)
INSERT INTO GRADE_RECORD (enrollment_id, course_id, ca_score, exam_score, grade_letter, grade_point) VALUES 
(1, 1, 30.50, 45.00, 'A', 5),
(1, 2, 28.00, 52.00, 'A', 5),
(2, 1, 15.00, 35.00, 'C', 3),
(3, 3, 22.00, 40.00, 'B', 4);
