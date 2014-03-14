--Trigger for hitting max enrollment
CREATE TRIGGER check_max_en
BEFORE INSERT OR UPDATE ON Studentcoursedata
FOR EACH ROW EXECUTE PROCEDURE check_max()


create or replace function check_max()
returns trigger AS $$
DECLARE
enroll_count INTEGER := 0;
max_en INTEGER :=0;
begin
SELECT INTO enroll_count COUNT(*) FROM Studentcoursedata 
WHERE section_id=NEW.section_id;
SELECT INTO max_en e_limit FROM Class WHERE section_id = NEW.section_id;
if enroll_count >= max_en THEN
RAISE EXCEPTION 'MAX LIMIT FOR THIS CLASS HIT. You cant enroll in this class as its full';
END IF;
return new;
end;
$$ LANGUAGE plpgsql;




--trigger for hitting conflicting days
create or replace function check_days()
returns trigger AS $$
DECLARE
row RECORD;
 --TEXT[];
new_days varchar[];
compare_days TEXT[];
pos INTEGER;
day VARCHAR;
BEGIN
  FOR row IN SELECT * FROM Meeting WHERE section_id=NEW.section_id LOOP
    RAISE NOTICE 'All the days are (%)', row.days_of_week;
    --day := regexp_matches(row.days_of_week, '[A-Z]|[A-Z][a-z]' )
    IF (row.start_time <= NEW.start_time AND row.end_time > NEW.start_time) OR
       (row.start_time < NEW.end_time AND row.end_time > NEW.end_time) OR
       (row.start_time >NEW.start_time AND row.end_time < NEW.end_time) THEN
       RAISE NOTICE 'conflicting times at %  %', row.start_time, row.end_time;
      FOR compare_days IN SELECT * FROM regexp_matches(row.days_of_week, '[A-Z]|[A-Z][a-z]', 'g' ) LOOP
        SELECT INTO pos * FROM position(compare_days[1] in NEW.days_of_week);
        IF pos<>0 THEN
          RAISE EXCEPTION 'WOA THERE BUDDY! Your are trying to schedule a meeting time for % to % on %, 
          but that conflicts witht the other meeting times for the % this section, which happens at % and goes until %', 
          NEW.start_time, NEW.end_time, NEW.days_of_week, row.type, row.start_time, row.end_time;
        END IF;
          
        RAISE NOTICE 'the day is (%)', compare_days[1]; 
        RAISE NOTICE 'position is (%)', pos;
      END LOOP;
    END IF;
  END LOOP;
return new;
end;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_the_days
BEFORE INSERT ON Meeting
FOR EACH ROW EXECUTE PROCEDURE check_days()

--trigger for instructor teaching sections that conflict
create or replace function check_instructorof()
returns trigger AS $$
DECLARE
row RECORD;
row2 RECORD;
new_days varchar[];
compare_days TEXT[];
pos INTEGER;
day VARCHAR;
BEGIN
  CREATE TEMP TABLE pot_class_meets ON COMMIT DROP AS
  SELECT * 
  FROM Meeting AS m
  WHERE m.section_id=NEW.section_id;
  FOR row IN SELECT * FROM Instructorof AS io
             JOIN Meeting AS m ON m.section_id=io.section_id
             WHERE io.fac_fname=NEW.fac_fname AND io.fac_lname=NEW.fac_lname LOOP
    RAISE NOTICE 'All the days are (%)', row.days_of_week;
    FOR row2 IN SELECT * FROM pot_class_meets LOOP
      RAISE NOTICE 'the section of the new course is (%)' , row2.section_id;
      RAISE NOTICE 'The days this is sceduled is %', row2.days_of_week;
      RAISE NOTICE 'row days of the week is still %' , row.days_of_week;
      IF (row.start_time <= row2.start_time AND row.end_time > row2.start_time) OR
       (row.start_time < row2.end_time AND row.end_time > row2.end_time) OR
       (row.start_time > row2.start_time AND row.end_time < row2.end_time) THEN
       RAISE NOTICE 'conflicting times at %  %', row.start_time, row.end_time;
        FOR compare_days IN SELECT * FROM regexp_matches(row.days_of_week, '[A-Z]|[A-Z][a-z]', 'g' ) LOOP
          SELECT INTO pos * FROM position(compare_days[1] in row2.days_of_week);
          IF pos<>0 THEN
            RAISE EXCEPTION 'WOA THERE BUDDY! Your are trying to schedule a meeting time for % to % on %, 
            but that conflicts with the other meeting times for the other section % you teach. The % for that section, which happens at % and goes until %', 
            row2.start_time, row2.end_time, row2.days_of_week, row.section_id,  row.type, row.start_time, row.end_time;
          END IF;
      END LOOP;
      END IF;
    END LOOP;

  END LOOP;
RETURN new;
end;
$$ LANGUAGE plpgsql;

CREATE TRIGGER instructor_of
BEFORE INSERT OR UPDATE ON Instructorof
FOR EACH ROW EXECUTE PROCEDURE check_instructorof()



--For the section side
create or replace function check_section_by_instruct()
returns trigger AS $$
DECLARE
instructor RECORD;
row RECORD;
new_days varchar[];
compare_days TEXT[];
pos INTEGER;
day VARCHAR;
BEGIN
  --gives the instructor that teaches this section and all his meeting times
  CREATE TEMP TABLE instructor ON COMMIT DROP AS
  SELECT * 
  FROM Instructorof AS io
  WHERE io.section_id=NEW.section_id;
  
  FOR instructor IN SELECT * FROM instructor LOOP
    RAISE NOTICE 'Instructor is % %', instructor.fac_fname, instructor.fac_lname;
    --should only be one instructor
    FOR row IN SELECT * FROM Instructorof AS io
             JOIN Meeting AS m ON m.section_id=io.section_id
             WHERE io.fac_fname=instructor.fac_fname AND io.fac_lname=instructor.fac_lname LOOP
        RAISE NOTICE 'the section of the new course is (%)' , NEW.section_id;
        RAISE NOTICE 'The days this is sceduled is %', NEW.days_of_week;
        RAISE NOTICE 'row days of the week is still %' , row.days_of_week;
        IF (row.start_time <= NEW.start_time AND row.end_time > NEW.start_time) OR
           (row.start_time < NEW.end_time AND row.end_time > NEW.end_time) OR
           (row.start_time > NEW.start_time AND row.end_time < NEW.end_time) THEN
          RAISE NOTICE 'conflicting times at %  %', row.start_time, row.end_time;
          FOR compare_days IN SELECT * FROM regexp_matches(row.days_of_week, '[A-Z]|[A-Z][a-z]', 'g' ) LOOP
            SELECT INTO pos * FROM position(compare_days[1] in NEW.days_of_week);
            IF pos<>0 THEN
              RAISE EXCEPTION 'WOA THERE BUDDY! Your are trying to schedule a meeting time for % to % on %, 
              but that conflicts with the other meeting times for the other section % you teach. The % for that section, which happens at % and goes until %', 
              NEW.start_time, NEW.end_time, NEW.days_of_week, row.section_id,  row.type, row.start_time, row.end_time;
            END IF;
          END LOOP;
        END IF;
    END LOOP;
  END LOOP;
RETURN new;
end;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_instructor_by_section
BEFORE INSERT OR UPDATE ON Meeting
FOR EACH ROW EXECUTE PROCEDURE check_section_by_instruct()