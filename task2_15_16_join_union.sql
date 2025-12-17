--2_15_1 Соединение таблиц. Оператор JOIN

-- !!! 1 (11) 
-- Вывести список названий предметов, фамилий студентов с их оценками,
-- полученными по этим предметам.
select *
from student s
inner join exam_marks e on s.student_id = e.student_id
INNER JOIN subject j on e.subj_id = j.subj_id
ORDER BY s.student_id, e.subj_id;

-- !!! 2 (14)
-- Получить список предметов вместе с фамилиями студентов, 
-- первыми сдавших экзамен по данному предмету на "отлично" (mark = 5).
SELECT s.surname, s.name, s.student_id, j.subj_id, e.mark
FROM student s
inner join exam_marks e on s.student_id = e.student_id
INNER JOIN subject j on e.subj_id = j.subj_id
INNER JOIN (select subj_id, min(exam_date) min_date
            from exam_marks
            WHERE mark = 5
            GROUP BY subj_id
            ORDER BY subj_id) stage
ON e.subj_id = stage.subj_id and e.exam_date = min_date
WHERE mark = 5
ORDER BY s.student_id, e.subj_id;

select subj_id, min(exam_date) min_date
from exam_marks
WHERE mark = 5
GROUP BY subj_id
ORDER BY subj_id;

-- !!! 3 (19) 
-- Написать запрос, выполняющий вывод данных об именах и фамилиях студентов,
-- имеющих только "удовлетворительные" (3) оценки.
select *
from student s
inner join exam_marks e on s.student_id = e.student_id
where not EXISTS (
    select mark
    from exam_marks m
    WHERE mark < 5 and m.student_id = s.student_id
)
order by s.student_id;

SELECT *
FROM student s 
    INNER JOIN exam_marks e on s.student_id = e.student_id
WHERE 3 = (SELECT min(mark) from exam_marks e WHERE e.student_id = s.student_id)
AND 3 = (SELECT max(mark) from exam_marks e WHERE e.student_id = s.student_id);

SELECT s.student_id, s.surname, s.name
FROM student s 
    INNER JOIN exam_marks e on s.student_id = e.student_id
GROUP BY s.student_id, s.surname, s.name
HAVING 3 = min(mark) AND 3 = max(mark);

SELECT s.student_id, s.surname, s.name
FROM student s 
    INNER JOIN exam_marks e on s.student_id = e.student_id
GROUP BY s.student_id, s.surname, s.name
HAVING 3 = min(mark) AND COUNT(DISTINCT mark) = 1;


SELECT *
FROM student s 
    INNER JOIN exam_marks e on s.student_id = e.student_id
WHERE 3 = all (SELECT mark from exam_marks e WHERE e.student_id = s.student_id)

-- Выведите имена и фамилии студентов,
-- получивших хотя бы одну пятерку.

-- !!! 4 (22) 
-- Написать запрос, выполняющий вывод имен и фамилий преподавателей (в одном поле),
-- проводящих занятия более, чем в одном семестре.

SELECT l.name || ' ' || l.surname fio,  count(DISTINCT semester)
FROM lecturer l
INNER JOIN subj_lect sl on l.lecturer_id = sl.lecturer_id
INNER JOIN subject sb on sl.subj_id = sb.subj_id
GROUP BY sl.lecturer_id, l.name , l.surname
HAVING count(DISTINCT semester) > 1
ORDER BY count(DISTINCT semester) DESC;

-- !!! 5 (23) 
-- Написать запрос, выполняющий вывод наименований учебных дисциплин с одинаковыми часами, 
-- читаемых более, чем одним преподавателем.

SELECT s1.subj_id, s1.subj_name
FROM subject s1
INNER JOIN subject s2 on s1.hour = s2.hour AND s1.subj_name != s2.subj_name
inner join subj_lect sl on s1.subj_id = sl.subj_id
inner join lecturer l on sl.lecturer_id = l.lecturer_id
GROUP BY s1.subj_id, s1.subj_name
HAVING count(DISTINCT l.lecturer_id) > 1;

INSERT INTO subject (subj_id, subj_name, hour, semester) 
VALUES (15, 'Биохимия', 119, 2);

-- Выведите наименования предметов, читаемых двумя и более препадователями.

-- !!! 6 (25) 
-- Написать запрос, выполняющий вывод фамилий с именами (в одном поле) преподавателей, 
-- учебная нагрузка которых (количество учебных часов) превышает нагрузку преподавателя Николаева.

SELECT l.name || ' ' || l.surname fio
from lecturer l
INNER JOIN subj_lect sl on l.lecturer_id = sl.lecturer_id
inner join subject s on s.subj_id = sl.subj_id
GROUP BY l.lecturer_id,  l.name , l.surname
HAVING SUM(hour) > (
            SELECT SUM(hour)
            from lecturer l
            INNER JOIN subj_lect sl on l.lecturer_id = sl.lecturer_id
            inner join subject s on s.subj_id = sl.subj_id
            WHERE l.surname = 'Николаев'
            GROUP BY l.lecturer_id,  l.name , l.surname
            );

-- !!! 7 (26) 
-- Написать запрос, выполняющий вывод данных о фамилиях преподавателей, 
-- преподающих в университетах с рейтингом, меньшим рейтинга ВГУ.

SELECT *
from lecturer l
    INNER JOIN UNIVERSITY u on l.UNIV_ID = u.UNIV_ID
where rating < (SELECT rating from UNIVERSITY where UNIVERSITY.UNIV_NAME = 'ВГУ');

-- Выведите имена и фамилии преподавателей,
-- преподающих в университетах с рейтингом, меньше 200.


-- !!! 8 (28) 
-- Выведите среднее количество учебных часов предметов обучения, 
-- преподаваемых студентам второго курса ВГУ.

SELECT *
FROM STUDENT s
    INNER JOIN EXAM_MARKS e on s.STUDENT_ID = e.STUDENT_ID
    INNER JOIN SUBJECT sub on sub.SUBJ_ID = e.SUBJ_ID
where kurs = 2
and (SELECT UNIV_ID from UNIVERSITY where UNIV_NAME = 'ВГУ') = s.UNIV_ID;

-- !!! 9 (29) 
-- Выведите имена и фамилии студентов (в одном поле),
-- имеющих две и более отличных оценок в каждом семестре.

SELECT name || ' ' || surname fio
from student s
INNER JOIN (SELECT e.STUDENT_ID, sj.SEMESTER, COUNT(e.MARK)
            FROM EXAM_MARKS e
                INNER JOIN SUBJECT sj ON e.SUBJ_ID = sj.SUBJ_ID
            where e.MARK = 5
            GROUP BY e.STUDENT_ID, sj.SEMESTER
            having COUNT(e.MARK) > 1) stage
            ON s.STUDENT_ID = stage.STUDENT_ID
GROUP BY s.STUDENT_ID, name, s.SURNAME, s.KURS
having count(semester) = kurs * 2;

--2_15_2 Внешнее соединение OUTER JOIN

-- !!! 1 (1) 
--Напишите запрос, который выполняет вывод фамилий и имен всех студентов.  
--Для каждого студента укажите названия предметов, которые он сдавал, 
--и фамилию преподавателя по каждому предмету.

SELECT s.NAME, s.SURNAME, sj.SUBJ_NAME, l.SURNAME
from student s
    LEFT JOIN EXAM_MARKS e on s.STUDENT_ID = e.STUDENT_ID
    LEFT JOIN SUBJECT sj on sj.SUBJ_ID = e.SUBJ_ID
    LEFT JOIN SUBJ_LECT sl on sl.SUBJ_ID = sj.SUBJ_ID
    LEFT JOIN LECTURER l on l.LECTURER_ID = sl.LECTURER_ID;

-- !!! 2 (4) 
--Напишите запрос на выдачу фамилий, имен и университетов всех студентов. 
--Для студентов, сдававших экзамены, укажите названия предметов обучения и оценок для этих экзаменов.

-- !!! 3 (7) 
--Напишите запрос на выдачу списка всех фамилий и имен студентов (в алфавитном порядке)
--вместе с наименованиями университетов (при наличии). 
--Отдельным запросом укажите студентов, для которых в базе данных не указано место их учебы.

-- !!! 4 (10) 
--Получите список фамилий и имен всех преподавателей с названиями университетов, 
--в которых они работают. 
--Отдельным запросом получите список преподавателей не работающих ни в одном университете.

-- !!! 5 (15) 
--Выведите список фамилий и имен всех студентов с их оценками с названиями предметов, по которым они получены.

--2_16 Оператор объединения UNION

-- !!! 1 (1)
--Создайте объединение двух запросов, 
--которые выдают значения названий университетов с городами и рейтингами, 
--отметив при этом университеты с рейтингом большим или равным 300 комментарием ‘Высокий рейтинг’,
--университеты с рейтингом меньшим 300, но большим или равным 200 комментарием – ‘Средний рейтинг’,
--а все остальные, то есть с рейтингом меньшим 200, комментарием – ‘Низкий рейтинг’.

--!!! 2 (4) 
--Выведите объединенный список фамилий, имен и городов студентов и 
--преподавателей МГУ с соответствующими комментариями 
--‘студент’ или ‘преподаватель’.

--!!! 3 (5) 
--Для каждого города привести названия, находящихся в нем университетов, 
--с указанием минимального и максимального для данного города рейтингом. 
-- Пометить соответствующие строки списка метками «min» и «max»,
-- поместив их в дополнительном столбце.

--!!! 4 (7) 
--Для каждого курса студентов ВГУ привести фамилии самого старшего и
--самого младшего студента на их курсе.
--Пометить строки этого списка словами «Младший» и «Старший», 
--поместив их в дополнительном столбце.

--!!! 5 (9) 
--Получить полный список названий университетов вместе с фамилиями и именами
--работающих в них преподавателей.
--Для университетов, для которых ФИО преподавателей в базе отсутствуют,
--поместите маркер NULL.

--!!! 6 (10) 
--Выведите полный список фамилий и имен студентов ВГУ 
--вместе с названиями предметов и оценками, полученными ими на этих экзаменах. 
--Для студентов, не сдававших экзамены, поместите в поля предмет и оценки прочерк (символ "-").

--2_15_1 Соединение таблиц. Оператор JOIN

-- !!! 1 (11)
-- Вывести список названий предметов, фамилий студентов с их оценками,
-- полученными по этим предметам.

-- !!! 2 (14)
-- Получить список предметов вместе с фамилиями студентов,
-- первыми сдавших экзамен по данному предмету на "отлично" (mark = 5).

-- !!! 3 (19)
-- Написать запрос, выполняющий вывод данных об именах и фамилиях студентов,
-- имеющих только "удовлетворительные" (3) оценки.

-- Выведите имена и фамилии студентов,
-- получивших хотя бы одну пятерку.

-- !!! 4 (22)
-- 21. Напишите запрос, выполняющий вывод имен и фамилий преподавателей,
-- проводящих занятия на первом курсе

-- Написать запрос, выполняющий вывод имен и фамилий преподавателей (в одном поле),
-- 1)проводящих занятия более, чем в одном семестре.
-- 2) проводящих занятия в двух и более семестрах.


-- !!! 5 (23)
-- Написать запрос, выполняющий вывод наименований учебных дисциплин с одинаковыми часами,
-- читаемых более, чем одним преподавателем.

-- Выведите наименования предметов, читаемых двумя и более препадователями.

-- !!! 6 (25)
-- Написать запрос, выполняющий вывод фамилий с именами (в одном поле) преподавателей,
-- учебная нагрузка которых (количество учебных часов) превышает нагрузку преподавателя Николаева.

-- !!! 7 (26)
-- Написать запрос, выполняющий вывод данных о фамилиях преподавателей,
-- преподающих в университетах с рейтингом, меньшим рейтинга ВГУ.

-- Выведите имена и фамилии преподавателей,
-- преподающих в университетах с рейтингом, меньше 200.


-- !!! 8 (28)
-- Выведите среднее количество учебных часов предметов обучения,
-- преподаваемых студентам второго курса ВГУ.

-- !!! 9 (29)
-- Выведите имена и фамилии студентов (в одном поле),
-- имеющих две и более отличных оценок в каждом семестре.


--2_15_2 Внешнее соединение OUTER JOIN

-- !!! 1 (1)
--Напишите запрос, который выполняет вывод фамилий и имен всех студентов.
--Для каждого студента укажите названия предметов, которые он сдавал,
--и фамилию преподавателя по каждому предмету.

-- !!! 2 (4)
--Напишите запрос на выдачу фамилий, имен и университетов всех студентов.
--Для студентов, сдававших экзамены, укажите названия предметов обучения и оценок для этих экзаменов.

-- !!! 3 (7)
--Напишите запрос на выдачу списка всех фамилий и имен студентов (в алфавитном порядке)
--вместе с наименованиями университетов (при наличии).
--Отдельным запросом укажите студентов, для которых в базе данных не указано место их учебы.

-- !!! 4 (10)
--Получите список фамилий и имен всех преподавателей с названиями университетов,
--в которых они работают.
--Отдельным запросом получите список преподавателей не работающих ни в одном университете.

-- !!! 5 (15)
--Выведите список фамилий и имен всех студентов с их оценками с названиями предметов, по которым они получены.

--2_16 Оператор объединения UNION

-- !!! 1 (1)
--Создайте объединение двух запросов,
--которые выдают значения названий университетов с городами и рейтингами,
--отметив при этом университеты с рейтингом большим или равным 300 комментарием ‘Высокий рейтинг’,
--университеты с рейтингом меньшим 300, но большим или равным 200 комментарием – ‘Средний рейтинг’,
--а все остальные, то есть с рейтингом меньшим 200, комментарием – ‘Низкий рейтинг’.

SELECT UNIV_NAME, city, rating, 'high rating' mark
from UNIVERSITY
WHERE RATING >= 300
UNION
SELECT UNIV_NAME, city, rating, 'mid rating' mark
from UNIVERSITY
WHERE RATING < 300 and rating >= 200
UNION
SELECT UNIV_NAME, city, rating, 'low rating' mark
from UNIVERSITY
WHERE RATING < 200
ORDER BY mark;

--!!! 2 (4)
--Выведите объединенный список фамилий, имен и городов студентов и
--преподавателей МГУ с соответствующими комментариями
--‘студент’ или ‘преподаватель’.

--!!! 3 (5)
--Для каждого города привести названия, находящихся в нем университетов,
--с указанием минимального и максимального для данного города рейтингом.
-- Пометить соответствующие строки списка метками «min» и «max»,
-- поместив их в дополнительном столбце.

--!!! 4 (7)
--Для каждого курса студентов ВГУ привести фамилии самого старшего и
--самого младшего студента на их курсе.
--Пометить строки этого списка словами «Младший» и «Старший»,
--поместив их в дополнительном столбце.

SELECT *
from student s
UNION
SELECT MIN(s.BIRTHDAY), MAX(s.BIRTHDAY)
FROM STUDENT s
where s.UNIV_ID = (SELECT UNIV_ID from UNIVERSITY where UNIV_NAME = 'ВГУ')
GROUP BY s.UNIV_ID, s.KURS
ORDER BY s.UNIV_ID, s.KURS;

SELECT surname, name, birthday, kurs, 'младший'
from student s
where s.UNIV_ID = (SELECT UNIV_ID from UNIVERSITY where UNIV_NAME = 'ВГУ')
and s.BIRTHDAY = (SELECT MIN(BIRTHDAY) from student s2 where s.UNIV_ID = s2.UNIV_ID)
UNION
SELECT surname, name, birthday, kurs, 'старший'
from student s
where s.UNIV_ID = (SELECT UNIV_ID from UNIVERSITY where UNIV_NAME = 'ВГУ')
and s.BIRTHDAY = (SELECT MAX(BIRTHDAY) from student s2 where s.UNIV_ID = s2.UNIV_ID);

--!!! 5 (9)
--Получить полный список названий университетов вместе с фамилиями и именами
--работающих в них преподавателей.
--Для университетов, для которых ФИО преподавателей в базе отсутствуют,
--поместите маркер NULL.

--!!! 6 (10)
--Выведите полный список фамилий и имен студентов ВГУ
--вместе с названиями предметов и оценками, полученными ими на этих экзаменах.
--Для студентов, не сдававших экзамены, поместите в поля предмет и оценки прочерк (символ "-").

SELECT surname, name, sj.SUBJ_NAME, cast(e.MARK as varchar(2)) mark
FROM student s
    INNER JOIN EXAM_MARKS e on s.STUDENT_ID = e.STUDENT_ID
    INNER JOIN SUBJECT sj on sj.SUBJ_ID = e.SUBJ_ID
where s.UNIV_ID = (SELECT UNIV_ID from UNIVERSITY where UNIV_NAME = 'ВГУ')
union ALL
SELECT SURNAME, name, '-', '-'
FROM student s
    LEFT JOIN EXAM_MARKS e on s.STUDENT_ID = e.STUDENT_ID
    LEFT JOIN SUBJECT sj on sj.SUBJ_ID = e.SUBJ_ID
where s.UNIV_ID = (SELECT UNIV_ID from UNIVERSITY where UNIV_NAME = 'ВГУ')
and e.mark is NULL
ORDER BY 3;
