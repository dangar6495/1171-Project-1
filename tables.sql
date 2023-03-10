
CREATE TABLE faculties (
faculty_id VARCHAR(4) PRIMARY KEY,
faculty_name VARCHAR(100) NOT NULL,
faculty_description TEXT NOT NULL
);

CREATE TABLE programs (
program_id CHAR(4) PRIMARY KEY,
faculty_id VARCHAR(4) NOT NULL,
program_name VARCHAR(50) NOT NULL,
program_location VARCHAR(50),
program_description TEXT NOT NULL,
FOREIGN KEY (faculty_id)
	REFERENCES faculties(faculty_id)
); 

CREATE TABLE instructors (
instructor_id INT PRIMARY KEY,
email VARCHAR(50) NOT NULL,
instructor_name VARCHAR(50) NOT NULL,
office_location VARCHAR(50) NOT NULL,
telephone CHAR(20) NOT NULL,
degree VARCHAR(5) NOT NULL
);

CREATE TABLE courses (
course_id INT PRIMARY KEY,
code CHAR(8) NOT NULL,
year INT NOT NULL,
semester INT NOT NULL,
section VARCHAR(10) NOT NULL,
title VARCHAR(100) NOT NULL,
credits INT NOT NULL,
modality VARCHAR(50) NOT NULL,
modality_type VARCHAR(20) NOT NULL,
instructor_id INT NOT NULL,
class_venue VARCHAR(100) NOT NULL,
communicatioin_tool VARCHAR(25) NOT NULL,
course_platform VARCHAR(25) NOT NULL,
field_trips VARCHAR(3) NOT NULL,
resources_required TEXT NOT NULL,
resources_recommended TEXT NOT NULL,
resources_other TEXT NOT NULL,
description TEXT NOT NULL,
outline_url TEXT NOT NULL,
FOREIGN KEY (instructor_id)
	REFERENCES instructors (instructor_id)
);

CREATE TABLE courses_programs(
course_id INT PRIMARY KEY,
program_id CHAR(4) NOT NULL,
FOREIGN KEY (program_id)
	REFERENCES programs (program_id),
FOREIGN KEY (course_id)
	REFERENCES courses (course_id)
);

CREATE TABLE pre_requisites(
  course_id INT NOT NULL,
  prereq_id VARCHAR(8) NOT NULL,
  PRIMARY Key(prereq_id,course_id),
  FOREIGN Key(course_id)
   REFERENCES courses (course_id)
);

--What faculties id’s at UB end in S?
SELECT faculty_id FROM faculties WHERE faculty_id LIKE '%S';

--What programs are offered in Belize City?
SELECT program_name FROM programs WHERE program_location IN ('Belize City');

--What courses does Mrs. Vernelle Sylvester teach?
SELECT code , title FROM courses AS c 
INNER JOIN instructors AS i ON c.instructor_id = i.instructor_id 
WHERE i.instructor_name IN ('Vernelle Sylvester');

--Which instructors have a Masters Degree?
SELECT instructor_name FROM instructors WHERE degree IN ('M.Sc.');

--What are the prerequisites for Programming 2? (join 2 tables) *extra credit nested sql query to return name
SELECT c.title as Course, STRING_AGG(CONCAT(PR.prereq_id,'-',(SELECT courses.title FROM courses WHERE courses.code IN (PR.prereq_id))), ', ') AS Prerequisites 
FROM courses AS C INNER JOIN pre_requisites as PR ON C.course_id = PR.course_id WHERE c.title in ('Priciples of Programming 2') GROUP BY c.title;

--. List the code, year, semester, section and title for all courses.
SELECT code, year, semester, section , title FROM courses;

-- List the program_name and code, year, semester section and title for all courses in the AINT program. *hint join 3 tables
SELECT c.code, c.year, c.semester, c.section, c.title, p.program_name FROM courses AS c 
INNER JOIN courses_programs AS cp ON c.course_id = cp.course_id 
INNER JOIN programs AS p ON p.program_id = cp.program_id WHERE cp.program_id IN ('AINT');

--List the faculty_name and code, year, semester section and title for all courses offered by FST. *hint join 4 tables
SELECT c.code, c.year, c.semester, c.section, c.title, p.program_name, f.faculty_id FROM courses AS c 
INNER JOIN courses_programs AS cp ON c.course_id = cp.course_id 
INNER JOIN programs AS p ON p.program_id = cp.program_id 
INNER JOIN faculties AS f ON f.faculty_id = p.faculty_id WHERE f.faculty_id IN ('FST');