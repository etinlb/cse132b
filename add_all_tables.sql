CREATE TABLE COURSE(
  course_id   VARCHAR(20) PRIMARY KEY,
  grade_opt   VARCHAR(6) NOT NULL,
  labwork     VARCHAR(30) NOT NULL,
  start_units SMALLINT NOT NULL,
  end_units   SMALLINT NOT NULL,
  d_name      VARCHAR(20) NOT NULL
);

INSERT INTO COURSE VALUES
('CSE100', 'P/NP', 'Y', 4, 4, 'CSE'),  
('CSE101', 'LTTR', 'Y', 2, 4, 'CSE'),  
('CSE102', 'LTTR', 'Y', 1, 4, 'CSE'),  
('COGS103', 'LTTR', 'Y', 4, 4, 'COGS'),
('CSE10', 'P/NP', 'Y', 2, 6, 'CSE'),   
('CSE11',  'LTTR', 'Y', 4, 4, 'CSE'),  
('CSE200',  'LTTR', 'Y', 4, 4, 'CSE'), 
('CSE201',  'LTTR', 'Y', 4, 4, 'CSE'), 
('CSE202',  'LTTR', 'Y', 4, 4, 'CSE'), 
('CSE203',  'LTTR', 'Y', 4, 4, 'CSE'), 
('CSE204',  'LTTR', 'Y', 4, 4, 'CSE'), 
('CSE205',  'LTTR', 'Y', 4, 4, 'CSE'); 


CREATE TABLE QUARTERPERIODS (
  qtr_yr      VARCHAR(10) PRIMARY KEY,
  s_period    DATE NOT NULL, /*YYYY-MM-DD*/
  e_period    DATE NOT NULL /*YYYY-MM-DD*/
);

INSERT INTO QUARTERPERIODS VALUES 
('FA12','2012-09-23','2012-12-14'),
('WI13','2013-01-02','2013-03-14'),
('SP13','2013-03-27','2013-06-13'),
('FA13','2013-09-23','2013-12-14'),
('WI14','2014-01-02','2014-03-14'),
('SP14','2014-03-27','2014-06-13');


CREATE TABLE OLDCOURSENAME (
  course_id   VARCHAR(20) NOT NULL,
  old_course_id   INT NOT NULL,
  FOREIGN KEY (course_id) REFERENCES COURSE
);

CREATE TABLE PREREQ (
  pre_course_id VARCHAR(20) NOT NULL,
  course_id     VARCHAR(20) NOT NULL,
  FOREIGN KEY (pre_course_id) REFERENCES COURSE,
  FOREIGN KEY (course_id) REFERENCES COURSE
);
INSERT INTO PREREQ VALUES
('CSE11', 'CSE100'),
('CSE10', 'CSE11');

CREATE TABLE CLASS (
  section_id  INT PRIMARY KEY,
  course_id   VARCHAR(20) NOT NULL,
  c_title     VARCHAR(40) NOT NULL,
  qtr_yr     VARCHAR(10) NOT NULL,
  e_limit SMALLINT NOT NULL,
  FOREIGN KEY  (course_id) REFERENCES COURSE,
  FOREIGN KEY  (qtr_yr) REFERENCES QUARTERPERIODS  
);
INSERT INTO CLASS VALUES
(1, 'CSE100', 'DataStrucs', 'WI14', 40),
(2, 'CSE101', 'Algorithms', 'WI14', 20),
(3, 'CSE102', 'Bigger Algorithms', 'WI14', 10),
(4, 'COGS103', 'Brain Junk', 'FA13', 40),
(5, 'CSE10', 'OO Programming', 'FA13', 29),
(6, 'CSE200',  'Master Class', 'WI14', 40),
(7, 'CSE201',  'Another master class', 'WI14', 40),
(8, 'CSE202',  'Stuff and things', 'FA13', 40),
(9, 'CSE203',  'Quantum Moonstuff', 'FA13', 40),
(10, 'CSE204',  'OO3 Prgramming', 'WI14', 40), --random stuff here
(11, 'CSE205',  'OO4 Programming', 'WI14', 40),
(12, 'CSE201',  'Stuff and things Advanced', 'WI14', 40),
(13, 'CSE201',  'Stuff and things Advanced', 'WI14', 40),
(14, 'CSE202',  'Stuff and things', 'WI14', 40),
(15, 'CSE202',  'Stuff and things', 'WI14', 40),
(16, 'CSE203',  'BOOM', 'FA13', 40),
(17, 'COGS103',  'This is a course', 'FA13', 40),
(18, 'CSE102',  'YEE BUDDY', 'FA13', 40),
(19, 'CSE102',  'YEE BUDDY', 'FA13', 40),
(20, 'CSE100',  'YEE BUDDY', 'FA13', 40),
(21, 'CSE10',  'OO2 Prgramming', 'SP13', 40),
(22, 'CSE11',  'OO2 Prgramming', 'SP13', 40);

CREATE TABLE MEETING (
  section_id  INT NOT NULL,
  days_of_week  VARCHAR(10) NOT NULL,
  start_time  INT NOT NULL,
  end_time  INT NOT NULL,
  mandatory   VARCHAR(10) NOT NULL,
  type        CHAR(2) NOT NULL,
  location    VARCHAR(20) NOT NULL,
  FOREIGN KEY (section_id) REFERENCES CLASS
);

INSERT INTO MEETING VALUES
(1, 'MWF', 900,  1000, 'N', 'LE', 'WARRENT 12'), 
(1, 'F',   1000, 1100, 'N', 'DI', 'WARRENT 1'), 
(2, 'MWF', 900,  1000, 'N', 'LE', 'WARRENT 122'), 
(2, 'W',   1100, 1200, 'N', 'DI', 'WARRENT 12'), 
(3, 'MWF', 1200, 1300,  'N', 'LE', 'WARRENT 12'),
(4, 'MWF', 1200, 1300,  'N', 'LE', 'WARRENT 12'),
(5, 'MWF', 1300, 1400,  'N', 'LE', 'WARRENT 12'),
(6, 'MWF', 1300, 1400,  'N', 'LE', 'WARRENT 12'),
(7, 'MWF', 1400, 1500,  'N', 'LE', 'WARRENT 12'),
(8, 'MWF', 1400, 1500,  'N', 'LE', 'WARRENT 12'),
(10, 'MWF', 1600, 1700,  'N', 'LE', 'WARRENT 12'),
(11, 'MWF', 1600, 1700,  'N', 'LE', 'WARRENT 12'),
(12, 'MWF', 1700, 1800,  'N', 'LE', 'WARRENT 12'),
(13, 'MWF', 1700, 1800,  'N', 'LE', 'WARRENT 12'),
(14, 'MWF', 1700, 1800,  'N', 'LE', 'WARRENT 12'),
(15, 'MWF', 900, 1000,  'N', 'LE', 'WARRENT 12'),
(16, 'MWF', 900, 1000,  'N', 'LE', 'WARRENT 12'),
(17, 'MWF', 900, 1000,  'N', 'LE', 'WARRENT 12'),
(18, 'MWF', 1600, 1700,  'N', 'LE', 'WARRENT 12'),
(19, 'MWF', 1600, 1700,  'N', 'LE', 'WARRENT 12'),
(21, 'MWF', 1600, 1700,  'N', 'LE', 'WARRENT 12'),
(22, 'MWF', 1600, 1700,  'N', 'LE', 'WARRENT 12'),
(2, 'MWF', 1600, 1700,  'N', 'LE', 'WARRENT 12');

CREATE TABLE STUDENT(
  SSN INT NOT NULL,
  student_id INT NOT NULL PRIMARY KEY,
  FIRSTNAME VARCHAR(20) NOT NULL,
  MIDDLENAME VARCHAR(20),
  LASTNAME VARCHAR(20) NOT NULL,
  RESIDENCY VARCHAR(10) NOT NULL,
  TYPE VARCHAR(10) NOT NULL
);

INSERT INTO STUDENT VALUES
(112, 1, 'Erik', 'Dude', 'Parreira', 'Yes', 'UG'),
(131, 2, 'Kenny', 'Dude', 'Torres', 'Yes', 'UG'),
(141, 3, 'John', 'Dude', 'John', 'Yes', 'UG'),
(123, 4, 'Merik', NULL, 'Karreira', 'Yes', 'UG'),
(134, 5, 'Jenny', NULL, 'Flores', 'No', 'UG'),
(242, 6, 'Ron', NULL, 'Vento', 'Yes', 'UG'),
(223, 7, 'Tetrik', NULL, 'Potter', 'No', 'UG'),
(331, 8, 'Fey', NULL, 'Jordan', 'Yes', 'UG'),
(441, 9, 'Alex', NULL, 'Kiss', 'Yes', 'UG'),
(223, 10, 'Kendrik', NULL, 'Lamar', 'Yes', 'MS'),
(331, 11, 'Robert', NULL, 'Son', 'Yes', 'PhD'),
(441, 12, 'James', NULL, 'Bond', 'No', 'PhD');



CREATE TABLE PROBATIONPERIODS (
  student_id  INT NOT NULL,
  s_period    DATE NOT NULL, /*YYYY-MM-DD*/
  e_period    DATE NOT NULL, /*YYYY-MM-DD*/
  reason      VARCHAR(60) NOT NULL,
  PRIMARY KEY (student_id, s_period, e_period),
  FOREIGN KEY (student_id) REFERENCES STUDENT
);


CREATE TABLE STUDENTCOURSEDATA(
  section_id  INT NOT NULL,
  student_id  INT NOT NULL,
  grade_type  VARCHAR(20),
  grade       VARCHAR(20),
  enrolled_wait_comp  VARCHAR(20),
  units       INT NOT NULL,
  PRIMARY KEY (section_id, student_id),
  FOREIGN KEY (section_id) REFERENCES CLASS,
  FOREIGN KEY (student_id) REFERENCES STUDENT
);

INSERT INTO STUDENTCOURSEDATA VALUES
(1, 1, 'P/NP', 'WIP', 'enrolled', 4),
(2, 1, 'LTTR', 'WIP', 'enrolled', 4),
(3, 1, 'LTTR', 'WIP', 'enrolled', 4),
(4, 1, 'P/NP', 'A', 'comp', 4),
(5, 1, 'P/NP', 'B', 'comp', 4),
(1, 2, 'P/NP', 'WIP', 'enrolled', 4),
(6, 3, 'LTTR', 'WIP', 'enrolled', 4),
(7, 3, 'LTTR', 'WIP', 'enrolled', 4),
(8, 3, 'LTTR', 'A', 'enrolled', 4),
(9, 3, 'LTTR', 'A', 'enrolled', 4),
(10, 3, 'LTTR', 'B', 'enrolled', 4),
(12, 3, 'LTTR', 'B', 'enrolled', 4),
(1, 3, 'P/NP', 'WIP', 'enrolled', 4),
(2, 4, 'LTTR', 'WIP', 'enrolled', 4),
(3, 5, 'LTTR', 'WIP', 'enrolled', 4),
(4, 6, 'P/NP', 'A', 'comp', 4),
(5, 7, 'P/NP', 'B', 'comp', 4),
(1, 8, 'P/NP', 'WIP', 'enrolled', 4),
(6, 9, 'LTTR', 'WIP', 'enrolled', 4),
(7, 10, 'LTTR', 'C', 'comp', 4),
(8, 11, 'LTTR', 'A', 'comp', 4),
(9, 12, 'LTTR', 'A', 'comp', 4),
(10, 11, 'LTTR', 'B', 'comp', 4),
(12, 4, 'LTTR', 'B', 'comp', 4);


CREATE TABLE FACULTY(
  fac_fname   VARCHAR(20) NOT NULL,
  fac_mname   VARCHAR(20),
  fac_lname   VARCHAR(20) NOT NULL,
  f_title   VARCHAR(20) NOT NULL,
  d_name  VARCHAR(10) NOT NULL,
  PRIMARY KEY (fac_fname, fac_lname)
);

INSERT INTO FACULTY VALUES
('ALIN', NULL, 'DEUTSCH', 'PROFESSOR', 'CSE'),
('RICK', NULL, 'ORD', 'PROFESSOR', 'CSE'),
('JOSEPH', NULL, 'PASQUALE', 'PROFESSOR', 'CSE'),
('ERIC', NULL, 'PARRIER', 'PROFESSOR', 'CSE'),
('NAT', NULL, 'TOOLY', 'PROFESSOR', 'COGS' ),
('ANDREAS', NULL, 'ADJIOSK', 'PROFESSOR', 'COGS' ),
('KEN', NULL, 'FUNCTION', 'PROFESSOR', 'MATH' ),
('BRIAN', 'CAR', 'MICHAEL', 'PROFESSOR', 'MATH' );

CREATE TABLE INSTRUCTOROF (
  fac_fname   VARCHAR(20) NOT NULL,
  fac_lname   VARCHAR(20) NOT NULL,
  section_id  INT NOT NULL,
  PRIMARY KEY (fac_fname, fac_lname, section_id),
  FOREIGN KEY (section_id) REFERENCES CLASS,
  FOREIGN KEY (fac_fname, fac_lname) REFERENCES FACULTY  
);

INSERT INTO INSTRUCTOROF VALUES
('ALIN',  'DEUTSCH', 1 ),
('RICK',  'ORD', 2),
('RICK',  'ORD', 5),
('ALIN', 	'DEUTSCH', 3),
('RICK', 	'ORD', 1),
('JOSEPH','PASQUALE', 4),
('ERIC', 	'PARRIER', 5),
('NAT', 	'TOOLY', 6),
('ANDREAS','ADJIOSK', 7),
('KEN', 	'FUNCTION', 8),
('BRIAN', 'MICHAEL', 9), 
('ALIN',  'DEUTSCH', 10),
('RICK',  'ORD', 12),
('RICK',  'ORD', 11),
('ALIN',  'DEUTSCH', 8),
('RICK',  'ORD', 7),
('JOSEPH','PASQUALE', 6),
('ERIC', 	'PARRIER', 12),
('NAT', 	'TOOLY', 4),
('ANDREAS','ADJIOSK', 3),
('KEN', 	'FUNCTION', 7),
('BRIAN', 'MICHAEL', 10);

CREATE TABLE DEGREE(
  name_of_degree VARCHAR(20) NOT NULL,
  type    VARCHAR(3),
  total_units INT NOT NULL,
  PRIMARY KEY (name_of_degree)
);

INSERT INTO DEGREE VALUES
('Computer Science', 'BS', 30),
('Cognitive Science','BS', 30),
('Database Design',  'MS', 30);

CREATE TABLE DEGREEREQ (
  name_of_degree VARCHAR(20) NOT NULL,
  category VARCHAR(20) NOT NULL,
  units_req SMALLINT NOT NULL,
  avg_gpa NUMERIC(4,3) NOT NULL,
  PRIMARY KEY (name_of_degree, category),
  FOREIGN KEY (name_of_degree) REFERENCES DEGREE 
  ON DELETE CASCADE
);

INSERT INTO DEGREEREQ VALUES
('Computer Science', 'UD', 12, 3.2),
('Computer Science', 'LD', 8, 3.2),
('Cognitive Science', 'UD', 8, 3.2),
('Cognitive Science', 'LD', 8, 3.2),
('Database Design', 'Databases', 12, 3.2),
('Database Design', 'Er Schemas', 12, 3.2);


CREATE TABLE UGSTUDENTDEGREE (
  student_id INT NOT NULL,
  minor      VARCHAR(20),
  major      VARCHAR(20) NOT NULL,
  MS5yr      CHAR(1) NOT NULL,
  college    VARCHAR(20) NOT NULL,
  PRIMARY KEY (student_id),
  FOREIGN KEY (student_id) REFERENCES STUDENT,
  FOREIGN KEY (major) REFERENCES DEGREE(name_of_degree)
  ON DELETE CASCADE
);

INSERT INTO UGSTUDENTDEGREE VALUES
(1, NULL, 'Computer Science', 'N', 'Sixth'),
(2, NULL, 'Computer Science', 'N', 'Sixth'), 
(4, NULL,  'Computer Science', 'N', 'Sixth'),
(5, NULL,  'Computer Science', 'N', 'Sixth'),
(6, NULL,  'Computer Science', 'N', 'Sixth'),
(7, NULL,  'Computer Science', 'N', 'Sixth'),
(8, NULL,  'Computer Science', 'N', 'Sixth'),
(9, NULL,  'Computer Science', 'N', 'Sixth');


CREATE TABLE MSPHDSTUDENTDEGREE (
  student_id INT NOT NULL,
  name_of_degree VARCHAR(20) NOT NULL,
  concentration VARCHAR(20) NOT NULL,
  PRIMARY KEY (student_id, name_of_degree),
  FOREIGN KEY (student_id) REFERENCES STUDENT,
  FOREIGN KEY (name_of_degree) REFERENCES DEGREE
  ON DELETE CASCADE
);
INSERT INTO MSPHDSTUDENTDEGREE VALUES
(3, 'Database Design', 'Databases'),
(10,'Database Design', 'Er Schemas'),
(11,'Database Design', 'Databases'),
(12,'Database Design', 'Databases');


CREATE TABLE THESISCOM (
  student_id INT NOT NULL,
  fac_fname VARCHAR(20) NOT NULL,
  fac_lname VARCHAR(20) NOT NULL,
  PRIMARY KEY (student_id, fac_fname, fac_lname),
  FOREIGN KEY (student_id) REFERENCES STUDENT,
  FOREIGN KEY (fac_fname, fac_lname) REFERENCES FACULTY
);

CREATE TABLE ENROLLMENTPERIOD (
  student_id INT NOT NULL,
  qtr_yr     VARCHAR(10) NOT NULL,
  PRIMARY KEY (student_id, qtr_yr),
  FOREIGN KEY (student_id) REFERENCES STUDENT,
  FOREIGN KEY (qtr_yr) REFERENCES QUARTERPERIODS
);

CREATE TABLE CLASSCATEGORY (
  course_id  VARCHAR(20) NOT NULL,
  category   VARCHAR(20) NOT NULL,
  name_of_degree VARCHAR(20) NOT NULL,
  PRIMARY KEY (course_id, category, name_of_degree),
  FOREIGN KEY (name_of_degree, category) REFERENCES DEGREEREQ
);

INSERT INTO CLASSCATEGORY VALUES
('CSE100', 'UD', 'Computer Science'),
('CSE101', 'UD', 'Computer Science'),
('CSE102', 'UD', 'Computer Science'),
('COGS103', 'UD', 'Cognitive Science'),
('CSE10',  'LD', 'Computer Science'),
('CSE11',  'LD', 'Computer Science'),
('CSE200',  'Databases', 'Database Design'),
('CSE201',  'Databases', 'Database Design'),
('CSE202',  'Databases', 'Database Design'),
('CSE203',  'Databases', 'Database Design'),
('CSE204',  'Databases', 'Database Design'),
('CSE200',  'Er Schemas', 'Database Design'),
('CSE201',  'Er Schemas', 'Database Design'),
('CSE205',  'Databases', 'Database Design');


CREATE TABLE GRADE_CONVERSION
( LETTER_GRADE CHAR(2) NOT NULL,
NUMBER_GRADE DECIMAL(2,1)
);

insert into grade_conversion values('A+', 4.3);
insert into grade_conversion values('A', 4);
insert into grade_conversion values('A-', 3.7);
insert into grade_conversion values('B+', 3.4);
insert into grade_conversion values('B', 3.1);
insert into grade_conversion values('B-', 2.8);
insert into grade_conversion values('C+', 2.5);
insert into grade_conversion values('C', 2.2);
insert into grade_conversion values('C-', 1.9);
insert into grade_conversion values('D', 1.6); 
