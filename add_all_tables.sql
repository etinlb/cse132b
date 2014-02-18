CREATE TABLE COURSE(
  course_id   INT PRIMARY KEY,
  grade_opt   VARCHAR(6) NOT NULL,
  labwork   VARCHAR(30) NOT NULL,
  units     INT NOT NULL,
  d_name  VARCHAR(20) NOT NULL
 
);

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
  qtr     VARCHAR(20) NOT NULL,
  year    SMALLINT NOT NULL,
  FOREIGN KEY  (course_id) REFERENCES COURSE
);

CREATE TABLE MEETING (
  section_id  INT NOT NULL,
  days_of_week  VARCHAR(10) NOT NULL,
  time_range  VARCHAR(10) NOT NULL,
  date_range  VARCHAR(10) NOT NULL,
  mandatory   VARCHAR(10) NOT NULL,
  type    CHAR(2) NOT NULL,
  location   VARCHAR(10) NOT NULL,
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
  period      VARCHAR(10) NOT NULL,
  reason      VARCHAR(60) NOT NULL,
  PRIMARY KEY (student_id, period),
  FOREIGN KEY (student_id) REFERENCES STUDENT
);
CREATE TABLE STUDENTCOURSEDATA(
  section_id  INT NOT NULL,
  student_id  INT NOT NULL,
  grade_type  VARCHAR(20),
  grade       VARCHAR(20),
  enrolled_wait_comp  VARCHAR(20),
  qtr         VARCHAR(20),
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
);


CREATE TABLE UGSTUDENTDEGREE (
  student_id INT NOT NULL,
  minor      VARCHAR(20),
  major      VARCHAR(20) NOT NULL,
  MS5yr      CHAR(1) NOT NULL,
  PRIMARY KEY (student_id),
  FOREIGN KEY (student_id) REFERENCES STUDENT,
  FOREIGN KEY (major) REFERENCES DEGREE(name_of_degree)
);

CREATE TABLE MSPHDSTUDENTDEGREE (
  student_id INT NOT NULL,
  name_of_degree VARCHAR(20) NOT NULL,
  concentration VARCHAR(20) NOT NULL,
  PRIMARY KEY (student_id, name_of_degree),
  FOREIGN KEY (student_id) REFERENCES STUDENT,
  FOREIGN KEY (name_of_degree) REFERENCES DEGREE
);

CREATE TABLE THESISCOM (
  student_id INT NOT NULL,
  fac_fname VARCHAR(20) NOT NULL,
  fac_lname VARCHAR(20) NOT NULL,
  PRIMARY KEY (student_id, fac_fname, fac_lname),
  FOREIGN KEY (student_id) REFERENCES STUDENT,
  FOREIGN KEY (fac_fname, fac_lname) REFERENCES FACULTY
);