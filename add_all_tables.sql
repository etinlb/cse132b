CREATE TABLE COURSE(
  course_id   INT PRIMARY KEY,
  grade_opt   VARCHAR(6) NOT NULL,
  labwork   VARCHAR(30) NOT NULL,
  units     VARCHAR(10) NOT NULL,
  d_name  VARCHAR(20) NOT NULL
);

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

CREATE TABLE CLASS (
  section_id  INT PRIMARY KEY,
  course_id   INT NOT NULL,
  c_title     VARCHAR(20) NOT NULL,
  qtr_yr     VARCHAR(10) NOT NULL,
  e_limit SMALLINT NOT NULL,
  FOREIGN KEY  (course_id) REFERENCES COURSE,
  FOREIGN KEY  (qtr_yr) REFERENCES QUARTERPERIODS  
);

CREATE TABLE MEETING (
  section_id  INT NOT NULL,
  days_of_week  VARCHAR(10) NOT NULL,
  time_range  VARCHAR(10) NOT NULL,
  mandatory   VARCHAR(10) NOT NULL,
  type        CHAR(2) NOT NULL,
  location    VARCHAR(10) NOT NULL,
  FOREIGN KEY (section_id) REFERENCES CLASS
);


CREATE TABLE STUDENT(
  SSN INT NOT NULL,
  student_id INT NOT NULL PRIMARY KEY,
  FIRSTNAME VARCHAR(20) NOT NULL,
  MIDDLENAME VARCHAR(20),
  LASTNAME VARCHAR(20) NOT NULL,
  RESIDENCY VARCHAR(10) NOT NULL,
  TYPE VARCHAR(10) NOT NULL
);

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

CREATE TABLE DEGREEREQ (
  name_of_degree VARCHAR(20) NOT NULL,
  category VARCHAR(20) NOT NULL,
  units_req SMALLINT NOT NULL,
  PRIMARY KEY (name_of_degree, category),
  FOREIGN KEY (name_of_degree) REFERENCES DEGREE 
  ON DELETE CASCADE
);

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

CREATE TABLE MSPHDSTUDENTDEGREE (
  student_id INT NOT NULL,
  name_of_degree VARCHAR(20) NOT NULL,
  concentration VARCHAR(20) NOT NULL,
  PRIMARY KEY (student_id, name_of_degree),
  FOREIGN KEY (student_id) REFERENCES STUDENT,
  FOREIGN KEY (name_of_degree) REFERENCES DEGREE
  ON DELETE CASCADE
);

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
