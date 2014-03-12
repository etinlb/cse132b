--final trigger
CREATE TRIGGER bullshit
BEFORE INSERT ON Studentcoursedata
FOR EACH ROW EXECUTE PROCEDURE fuckyou()


create or replace function fuckyou()
returns trigger AS $$
DECLARE
enroll_count INTEGER := 0;
max_en INTEGER :=0;
begin
SELECT INTO enroll_count COUNT(*) FROM Studentcoursedata 
WHERE section_id=NEW.section_id;
SELECT INTO max_en e_limit FROM Class WHERE section_id = NEW.section_id;
if enroll_count >= max_en THEN
RAISE EXCEPTION 'Cannot do that';
END IF;
return new;
end;
$$ LANGUAGE plpgsql;




--scratch 
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