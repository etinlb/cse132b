CREATE TABLE COURSE(
  course_id   INT PRIMARY KEY,
  grade_opt   VARCHAR(6) NOT NULL,
  labwork     VARCHAR(30) NOT NULL,
  start_units SMALLINT NOT NULL,
  end_units   SMALLINT NOT NULL,
  d_name      VARCHAR(20) NOT NULL
);

INSERT INTO COURSE VALUES
(100, 'P/NP', 'Y', 4, 4, 'CSE'),
(101, 'LTTR', 'Y', 2, 4, 'CSE'),
(102, 'LTTR', 'Y', 1, 4, 'CSE'),
(103, 'LTTR', 'Y', 4, 4, 'COGS'),
(10, 'P/NP', 'Y', 2, 6, 'CSE'),
(11,  'LTTR', 'Y', 4, 4, 'CSE');


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
  course_id   INT NOT NULL,
  old_course_id   INT NOT NULL,
  FOREIGN KEY (course_id) REFERENCES COURSE
);

CREATE TABLE PREREQ (
  pre_course_id INT NOT NULL,
  course_id INT   NOT NULL,
  FOREIGN KEY (pre_course_id) REFERENCES COURSE,
  FOREIGN KEY (course_id) REFERENCES COURSE
);
INSERT INTO PREREQ VALUES
(11, 100),
(10, 11);

CREATE TABLE CLASS (
  section_id  INT PRIMARY KEY,
  course_id   INT NOT NULL,
  c_title     VARCHAR(20) NOT NULL,
  qtr_yr     VARCHAR(10) NOT NULL,
  e_limit SMALLINT NOT NULL,
  FOREIGN KEY  (course_id) REFERENCES COURSE,
  FOREIGN KEY  (qtr_yr) REFERENCES QUARTERPERIODS  
);
INSERT INTO CLASS VALUES
(1, 100, 'DataStrucs', 'WI14', 40),
(2, 101, 'Algorithms', 'WI14', 20),
(3, 102, 'Bigger Algorithms', 'WI14', 10),
(4, 103, 'Brain Junk', 'FA13', 40),
(5, 10, 'OO Programming', 'FA13', 29),
(6, 11,  'OO2 Programming', 'FA13', 40);


CREATE TABLE MEETING (
  section_id  INT NOT NULL,
  days_of_week  VARCHAR(10) NOT NULL,
  start_time  VARCHAR(10) NOT NULL,
  end_time  VARCHAR(10) NOT NULL,
  mandatory   VARCHAR(10) NOT NULL,
  type        CHAR(2) NOT NULL,
  location    VARCHAR(20) NOT NULL,
  FOREIGN KEY (section_id) REFERENCES CLASS
);

INSERT INTO MEETING VALUES
(1, 'MWF', '9:00',  '10:00', 'N', 'LE', 'WARRENT 12'), 
(1, 'F',   '10:00', '11:00', 'N', 'DI', 'WARRENT 1'), 
(2, 'MWF', '9:00',  '10:00', 'N', 'LE', 'WARRENT 122'), 
(2, 'W',   '11:00', '12:00', 'N', 'DI', 'WARRENT 12'), 
(3, 'MWF', '12:00', '1:00',  'N', 'LE', 'WARRENT 12');


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
(12, 1, 'Erik', 'Dude', 'Parreira', 'Yes', 'UG'),
(13, 2, 'Kenny', 'Dude', 'Torres', 'Yes', 'UG'),
(14, 3, 'John', 'Dude', 'John', 'Yes', 'UG');



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
  qtr_yr      VARCHAR(10) NOT NULL,
  units       INT NOT NULL,
  PRIMARY KEY (section_id, student_id),
  FOREIGN KEY (section_id) REFERENCES CLASS,
  FOREIGN KEY (qtr_yr) REFERENCES QUARTERPERIODS,
  FOREIGN KEY (student_id) REFERENCES STUDENT
);

INSERT INTO STUDENTCOURSEDATA VALUES
(1, 1, 'P/NP', 'WIP', 'enrolled', 'WI13', 4),
(2, 1, 'LTTR', 'WIP', 'enrolled', 'FA12', 4),
(3, 1, 'LTTR', 'WIP', 'enrolled', 'WI13', 4),
(4, 1, 'P/NP', 'A',   'comp'    , 'SP13', 4),
(5, 1, 'P/NP', 'B',   'comp'    , 'FA13', 4),
(1, 2, 'P/NP', 'WIP', 'enrolled', 'WI14', 4),
(2, 2, 'P/NP', 'WIP', 'enrolled', 'SP14', 4);


CREATE TABLE FACULTY(
  fac_fname   VARCHAR(20) NOT NULL,
  fac_mname   VARCHAR(20),
  fac_lname   VARCHAR(20) NOT NULL,
  f_title   VARCHAR(20) NOT NULL,
  d_name  VARCHAR(10) NOT NULL,
  PRIMARY KEY (fac_fname, fac_lname)
);

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
  avg_gpa NUMERIC(4,3) NOT NULL,
  PRIMARY KEY (name_of_degree)
);

INSERT INTO DEGREE VALUES
('Computer Science', 3.2),
('MS Computer Science', 3.2);

CREATE TABLE DEGREEREQ (
  name_of_degree VARCHAR(20) NOT NULL,
  category VARCHAR(20) NOT NULL,
  units_req SMALLINT NOT NULL,
  PRIMARY KEY (name_of_degree, category),
  FOREIGN KEY (name_of_degree) REFERENCES DEGREE 
  ON DELETE CASCADE
);

INSERT INTO DEGREEREQ VALUES
('Computer Science', 'UD', 12),
('Computer Science', 'LD', 8);


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
(1, '', 'Computer Science', 'N', 'Sixth'),
(2, '', 'Computer Science', 'N', 'Sixth');

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
(3, 'MS Computer Science', 'MasterGuy');


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
  course_id  INT NOT NULL,
  category   VARCHAR(20) NOT NULL,
  name_of_degree VARCHAR(20) NOT NULL,
  PRIMARY KEY (course_id, category, name_of_degree),
  FOREIGN KEY (name_of_degree, category) REFERENCES DEGREEREQ
);




