CREATE TABLE COURSE(
  course_id   VARCHAR(20) PRIMARY KEY,
  grade_opt   VARCHAR(6) NOT NULL,
  labwork     VARCHAR(30) NOT NULL,
  start_units SMALLINT NOT NULL,
  end_units   SMALLINT NOT NULL,
  d_name      VARCHAR(20) NOT NULL
);

INSERT INTO COURSE VALUES
('CSE101', 'LTTR', 'Y', 4, 4, 'CSE'),  
('CSE132', 'LTTR', 'N', 4, 4, 'CSE'),  
('CSE123', 'LTTR', 'N', 1, 8, 'CSE'),
('CSE8', 'P/NP', 'N', 1, 8, 'CSE'),   
('MATH20',  'LTTR', 'N', 4, 4, 'MATH'),
('CSE135',  'LTTR', 'N', 4, 4, 'CSE');

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
('SP14','2014-03-27','2014-06-13'),
('FA15','2015-09-23','2015-12-14');


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
(1011, 'CSE101', 'Algorithm', 'WI14', 100),
(1012, 'CSE101', 'Algorithm', 'WI14', 30),
(201,  'MATH20', 'Algebra', 'WI14', 10),
(202,  'MATH20', 'Algebra', 'WI14', 10),
(1321, 'CSE132', 'Database', 'WI14', 30),
(1231, 'CSE123',  'Network', 'WI14', 40),
(1232, 'CSE123',  'Network', 'FA15', 40),
(81,   'CSE8',  'Java', 'SP13', 15),
(1322, 'CSE132',  'Database', 'WI13', 80),
(1351, 'CSE135',  'Database', 'WI13', 80),
(1323, 'CSE132',  'Database', 'FA13', 80);


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
(1011, 'MW', 1000,  1050, 'Y', 'LE', 'WLH1101'), 
(1011, 'F', 1100,  1150, 'N', 'DI', 'WLH2202'), 
(1012, 'MW', 1200,  1250, 'Y', 'LE', 'WLH2205'), 
(201, 'M', 1000,  1050, 'Y', 'LE', 'WLH2207'), 
(202, 'Tu', 1500,  1550, 'Y', 'LE', 'WLH1101'), 
(1321, 'M', 1200,  1250, 'Y', 'LE', 'WLH1101'), 
(1231, 'Th', 800,  850, 'Y', 'LE', 'WLH1201'); 

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
(1, 1, 'James', '', 'Bond', 'Yes', 'UG'),
(2, 2, 'Joe', '', 'Gates', 'Yes', 'UG'),
(3, 3, 'Michael', 'A', 'Lee', 'Yes', 'MS');


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
(81, 1, 'LTRR', 'A',     'comp'2),
(1012, 1, 'LTRR', 'WIP', 'enrolled'4),
(1012, 3, 'LTRR', 'WIP', 'enrolled'4),
(1231, 1, 'LTRR', 'WIP', 'enrolled'2),
(1322, 1, 'LTRR', 'B',   'comp'4),
(1322, 3, 'LTRR', 'A',   'comp'4),
(1323, 2, 'LTRR', 'C',   'comp'4),
(1351, 1, 'LTRR', 'C',   'comp'4),
(1351, 3, 'LTRR', 'B+',  'comp'4);

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

CREATE TABLE DEGREE(
  name_of_degree VARCHAR(20) NOT NULL,
  type    VARCHAR(3),
  total_units INT NOT NULL,
  PRIMARY KEY (name_of_degree)
);

INSERT INTO DEGREE VALUES
('CS', 'BS', 30),
('Master CS', 'MS', 30);

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
('CS', 'UD', 10, 2.0),
('CS', 'LD', 20, 3.0),
('Master CS', 'Elective', 8, 3.0),
('Master CS', 'Database', 8, 3.0),
('Master CS', 'Network', 8, 3.0);

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
(1, 'Math', 'CS', 'N', 'Warren'),
(2, NULL, 'CS', 'N', 'Warren');



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
(3, 'Master CS', 'Database');


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
('CSE100', 'UD', 'CS'),
('CSE101', 'UD', 'CS'), 
('CSE132', 'UD', 'CS'),
('CSE123', 'UD', 'CS'),
('CSE8',   'LD', 'CS'),
('MATH20', 'LD', 'CS'),
('CSE135', 'UD', 'CS'),
('CSE132', 'Database', 'Master CS'),
('CSE123', 'Network', 'Master CS'),
('CSE135', 'Database', 'Master CS');


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
