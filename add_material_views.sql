/* In here is the views required to complete cse132b project */

/*Groups and displays tuples Course, Prof, Grade, Qtr*/
CREATE TABLE CPQG AS             
SELECT c.course_id, c.qtr_yr, fac_fname, i.fac_lname,
sum(case when grade LIKE 'A%' then 1 else 0 end) Acount,
sum(case when grade LIKE 'B%' then 1 else 0 end) Bcount,
sum(case when grade LIKE 'C%' then 1 else 0 end) Ccount,
sum(case when grade LIKE 'D%' then 1 else 0 end) Dcount
FROM Instructorof AS i LEFT JOIN class AS c ON i.section_id = c.section_id
LEFT JOIN studentcoursedata as s on i.section_id = s.section_id
LEFT JOIN grade_conversion as g on s.grade = g.letter_grade 
AND s.grade <> 'WIP' AND s.grade <> 'IN'
GROUP BY i.fac_fname, i.fac_lname, c.qtr_yr, c.course_id;


/*same as above but does not display the quarter*/
CREATE TABLE CPG AS             
SELECT c.course_id, fac_fname, i.fac_lname, 
sum(case when grade LIKE 'A%' then 1 else 0 end) Acount,
sum(case when grade LIKE 'B%' then 1 else 0 end) Bcount,
sum(case when grade LIKE 'C%' then 1 else 0 end) Ccount,
sum(case when grade LIKE 'D%' then 1 else 0 end) Dcount
FROM Instructorof AS i LEFT JOIN class AS c ON i.section_id = c.section_id
LEFT JOIN studentcoursedata as s on i.section_id = s.section_id
LEFT JOIN grade_conversion as g on s.grade = g.letter_grade 
AND s.grade <> 'WIP' AND s.grade <> 'IN'
GROUP BY i.fac_fname, i.fac_lname, c.course_id;


CREATE TRIGGER CPQG_update 
AFTER INSERT ON studentcoursedata
FOR EACH ROW
WHEN ( new.grade <> 'WIP' AND new.grade <> 'IN' )
EXECUTE PROCEDURE CPQG_update ();

DROP FUNCTION CPQG_update() CASCADE

CREATE FUNCTION CPQG_update () RETURNS trigger AS $CPQG_update$
  DECLARE
  c_id course.course_id%TYPE := (select course_id from class where section_id = new.section_id);
  fname faculty.fac_fname%TYPE := (select fac_fname from instructorof where section_id = new.section_id);
  lname faculty.fac_lname%TYPE := (select fac_lname from instructorof where section_id = new.section_id);
  qtr   class.qtr_yr%TYPE := (select qtr_yr from class where section_id = new.section_id);
  a int :=  case when NEW.grade LIKE 'A%' then 1 else 0 end;
  b int :=  case when NEW.grade LIKE 'B%' then 1 else 0 end;
  c int :=  case when NEW.grade LIKE 'C%' then 1 else 0 end;
  d int :=  case when NEW.grade LIKE 'D%' then 1 else 0 end;
  BEGIN
  IF (new.section_id NOT IN (SELECT c.section_id
        FROM CPQG AS s LEFT JOIN class AS c ON s.course_id = c.course_ID 
        WHERE c.section_id = new.section_id)) THEN
            INSERT INTO CPQG VALUES (c_id, fname, lname, qtr, a, b, c, d);
  ELSIF ( a != 0 ) THEN
    UPDATE CPQG SET Acount = Acount + 1 WHERE c_id = course_id AND fname = fac_fname AND lname = fac_lname AND qtr = qtr_yr;
  ELSIF ( b != 0 ) THEN
    UPDATE CPQG SET Bcount = Bcount + 1 WHERE c_id = course_id AND fname = fac_fname AND lname = fac_lname AND qtr = qtr_yr;
  ELSIF ( c != 0 ) THEN
    UPDATE CPQG SET Ccount = Ccount + 1 WHERE c_id = course_id AND fname = fac_fname AND lname = fac_lname AND qtr = qtr_yr;
  ELSIF ( d != 0 ) THEN
    UPDATE CPQG SET Dcount = Dcount + 1 WHERE c_id = course_id AND fname = fac_fname AND lname = fac_lname AND qtr = qtr_yr;
  END IF;
   RETURN NULL;
  END;
$CPQG_update$ LANGUAGE plpgsql;



CREATE TRIGGER CPG_update 
AFTER INSERT ON studentcoursedata
FOR EACH ROW
WHEN ( new.grade <> 'WIP' AND new.grade <> 'IN' )
EXECUTE PROCEDURE CPG_update ();

DROP FUNCTION CPG_update() CASCADE

CREATE FUNCTION CPG_update () RETURNS trigger AS $CPG_update$
  DECLARE
  c_id course.course_id%TYPE := (select course_id from class where section_id = new.section_id);
  fname faculty.fac_fname%TYPE := (select fac_fname from instructorof where section_id = new.section_id);
  lname faculty.fac_lname%TYPE := (select fac_lname from instructorof where section_id = new.section_id);
  a int :=  case when NEW.grade LIKE 'A%' then 1 else 0 end;
  b int :=  case when NEW.grade LIKE 'B%' then 1 else 0 end;
  c int :=  case when NEW.grade LIKE 'C%' then 1 else 0 end;
  d int :=  case when NEW.grade LIKE 'D%' then 1 else 0 end;
  BEGIN
  IF (new.section_id NOT IN (SELECT c.section_id
        FROM CPG AS s LEFT JOIN class AS c ON s.course_id = c.course_ID 
        WHERE c.section_id = new.section_id)) THEN
            INSERT INTO CPG VALUES (c_id, fname, lname, a, b, c, d);
  ELSIF ( a != 0 ) THEN
    UPDATE CPG SET Acount = Acount + 1 WHERE c_id = course_id AND fname = fac_fname AND lname = fac_lname;
  ELSIF ( b != 0 ) THEN
    UPDATE CPG SET Bcount = Bcount + 1 WHERE c_id = course_id AND fname = fac_fname AND lname = fac_lname;
  ELSIF ( c != 0 ) THEN
    UPDATE CPG SET Ccount = Ccount + 1 WHERE c_id = course_id AND fname = fac_fname AND lname = fac_lname;
  ELSIF ( d != 0 ) THEN
    UPDATE CPG SET Dcount = Dcount + 1 WHERE c_id = course_id AND fname = fac_fname AND lname = fac_lname;
  END IF;
   RETURN NULL;
  END;
$CPG_update$ LANGUAGE plpgsql;
