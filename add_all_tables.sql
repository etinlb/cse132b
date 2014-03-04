SELECT s.qtr_yr, SUM(s.number_grade * s.units)/s.units as acc
FROM CLASS as c, STUDENTCOURSEDATA s INNER JOIN GRADE_CONVERSION g on st.grade = g.letter_grade
WHERE s.student_id = 1 AND s.section_id = c.section_id AND s.grade <> 'WIP' AND s.grade <> 'IN'
GROUP BY s.qtr_yr;