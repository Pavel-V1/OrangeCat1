--УПРАЖНЕНИЯ группировка GROUP BY
--1. Напишите запрос для подсчета количества студентов, сдававших
--экзамен по предмету обучения с идентификатором 20.
select COUNT(STUDENT_ID)
    from EXAM_MARKS q
        where q.SUBJ_ID = 20;

--2. Напишите запрос, который позволяет подсчитать в таблице
--EXAM_MARKS количество различных предметов обучения.
select COUNT(distinct(SUBJ_ID))
    from EXAM_MARKS hi;

--3. Напишите запрос, который для каждого студента выполняет вы-
--борку его идентификатора и минимальной из полученных им
--оценок.
SELECT q.STUDENT_ID, MIN(MARK)
    from EXAM_MARKS q
        GROUP BY STUDENT_ID
        ORDER by STUDENT_ID;

--4. Напишите запрос, который для каждого студента выполняет вы-
--борку его идентификатора и максимальной из полученных им
--оценок.
SELECT STUDENT_ID, max(MARK)
    from EXAM_MARKS
        GROUP BY STUDENT_ID
        order by STUDENT_ID;

--5. Напишите запрос, выполняющий вывод первой по алфавиту фа-
--милии студента, начинающейся на букву ‘И’.
select min(surname)
from student
where surname like 'И%';

--6. Напишите запрос, который для каждого предмета обучения вы-
--водит наименование предмета и максимальное значение номера
--семестра, в котором этот предмет преподается.
select subj_name,
       max(semester)
  from subject
 group by subj_name;

--7. Напишите запрос, который для каждого конкретного дня сдачи
--экзамена выводит данные о количестве студентов, сдававших
--экзамен в этот день.
select exam_date,
       count(distinct student_id)
  from exam_marks
 group by exam_date;

--8. Напишите запрос, выдающий средний балл для каждого
--студента.
SELECT q.student_id AS st
	 , ROUND(AVG(q.mark), 2)
FROM exam_marks q
GROUP BY st
ORDER BY st;

--9. Напишите запрос, выдающий средний балл для каждого
--экзамена.
SELECT (exam_date, subj_id) AS ex
	   , ROUND(AVG(mark), 2)
FROM exam_marks
GROUP BY ex;

--10. Напишите запрос, определяющий количество сдававших студен-
--тов для каждого экзамена.
SELECT subj_id, COUNT(student_id)
FROM exam_marks
GROUP BY subj_id, exam_date;

--11. Напишите запрос для определения количества предметов, изучаемых на каждом курсе.
SELECT semester, COUNT(DISTINCT subj_id)
FROM subject
GROUP BY semester;

--12. Для каждого университета напишите запрос, 
--выводящий суммарную стипендию обучающихся в нем студентов, с последующей
--сортировкой списка по этому значению.
SELECT univ_id, SUM(stipend)
FROM student
GROUP BY univ_id
ORDER BY univ_id;

--13. Для каждого семестра напишите запрос, выводящий общее
--количество часов, отводимое на изучение соответствующих
--предметов.
SELECT s.semester, SUM(s.hour)
FROM subject s
GROUP BY semester
ORDER BY semester;

--14. Для каждого студента напишите запрос, выводящий среднее зна-
--чение оценок, полученных им на всех экзаменах.
SELECT student_id
	   , AVG(mark)
FROM exam_marks
GROUP BY student_id
ORDER BY student_id;

--15. Для каждого студента напишите запрос, выводящий среднее зна-
--чение оценок, полученных им по каждому предмету.
SELECT student_id, subj_id, ROUND(AVG(mark)) AS avg_mark
FROM exam_marks
GROUP BY student_id, subj_id
ORDER BY student_id, subj_id;

--16. Напишите запрос, выводящий количество студентов, проживаю-
--щих в каждом городе. Список отсортировать в порядке убывания
--количества студентов.
SELECT CITY, count(distinct STUDENT_ID) as cnt
  FROM student
  GROUP BY CITY
  order BY cnt;
  --order BY 2 DESC;
  --order BY count(DISTINCT STUDENT_ID);

--17. Для каждого университета напишите запрос, выводящий количе-
--ство обучающихся в нем студентов, с последующей сортировкой
--списка по этому количеству.
SELECT univ_id, COUNT(student_id) AS cat
FROM student
WHERE univ_id IS NOT NULL
GROUP BY univ_id
ORDER BY cat;

--18. Для каждого университета напишите запрос, выводящий коли-
--чество работающих в нем преподавателей, с последующей сорти-
--ровкой списка по этому количеству.
select univ_id,
       count(lecturer_id)
  from lecturer
 group by ( univ_id )
 order by count(lecturer_id) desc;

--SELECT * 
--FROM LECTURER
--order BY univ_id

--19. Для каждого университета напишите запрос, выводящий сумму
--стипендии, выплачиваемой студентам каждого курса.

SELECT UNIV_ID, KURS, sum(STIPEND)
FROM student
GROUP BY UNIV_ID, KURS
order by UNIV_ID, KURS;

--20. Для каждого города напишите запрос, выводящий максимальный
--рейтинг университетов, в нем расположенных, с последующей
--сортировкой списка по значениям рейтингов.
SELECT max(rating)
	 , city
FROM university
GROUP BY city
ORDER BY max(rating);

--21. Для каждого дня сдачи экзаменов напишите запрос, выводящий
--среднее значение всех экзаменационных оценок.
SELECT exam_date
	 , round(avg(mark), 2)
FROM exam_marks
GROUP BY exam_date
ORDER BY exam_date;

--22. Для каждого дня сдачи экзаменов напишите запрос, выводящий
--максимальные оценки, полученные по каждому предмету.
SELECT exam_date
	 , subj_id
	 , max(mark) AS max_mark
FROM exam_marks
GROUP BY exam_date, subj_id
ORDER BY exam_date, subj_id;

--23. Для каждого дня сдачи экзаменов напишите запрос, выводящий
--общее количество студентов, сдававших экзамены.
SELECT exam_date
	 , COUNT(student_id) AS count_of_stud
FROM exam_marks
GROUP BY exam_date
ORDER BY exam_date;

--24. Для каждого дня сдачи экзаменов напишите запрос, выводящий
--общее количество экзаменов, сдававшихся каждым студентом.
SELECT exam_date
	 , student_id
	 , COUNT(exam_id)
FROM exam_marks
GROUP BY exam_date, student_id
ORDER BY exam_date, student_id;

--25. Для каждого преподавателя напишите запрос, выводящий коли-
--чество преподаваемых им предметов.
SELECT lecturer_id
	 , count(subj_id)
FROM subj_lect
GROUP BY lecturer_id
ORDER BY lecturer_id;

--26. Для каждого предмета напишите запрос, выводящий количество
--преподавателей, ведущих по нему занятия.
SELECT subj_id
	 , count(lecturer_id)
FROM subj_lect
GROUP BY subj_id
ORDER BY subj_id;

--27. Напишите запрос, выполняющий вывод количества студентов,
--имеющих только отличные оценки.
select count(*)
  from (
   select student_id,
          min(mark)
     from exam_marks
    group by student_id
   having min(mark) = 5
) ;

--28. Напишите запрос, выполняющий вывод количества экзаменов,
--сданных (с положительной оценкой) студентом с идентификатором 32.
select count(exam_id)
  from exam_marks
 where student_id = 32
   and mark >= 3;


-- 0,1-0,1 --------- -- 01 --
-- 0,1-1,1 (1,1-0,1) -- 02 --
-- 1,1-1,1 --------- -- 03 --
-- 0,m-0,1 --------- -- 04 --
-- 1,m-0,1 --------- -- 05 --
-- 0,m-1,1 --------- -- 06 --
-- 1,m-1,1 --------- -- 07 --
-- 0,m-0,n --------- -- 08 --
-- 1,m-0,n (0,m-1,n) -- 09 --
-- 1,m-1,n --------- -- 10 --
