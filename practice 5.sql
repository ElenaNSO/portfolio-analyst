-- ПРАКТИЧЕСКАЯ РАБОТА № 5

-- ШАГ 1. ПРОСТЫЕ ВЫБОРКИ: ИЗ ОДНОЙ ТАБЛИЦЫ
-- 1.1 SELECT , LIMIT - ВЫБРАТЬ 5 ЗАПИСЕЙ ИЗ ТАБЛИЦЫ MOVIES
SELECT 
    *
FROM
    movies
LIMIT 5;


-- 1.2 WHERE, LIKE - ВЫБРАТЬ ИЗ ТАБЛИЦЫ LINKS ВСЁ ЗАПИСИ, У КОТОРЫХ IMDBID ОКАНЧИВАЕТСЯ НА "42", А ПОЛЕ MOVIEID МЕЖДУ 100 И 1000
SELECT 
    *
FROM
    links
WHERE
    IMDBID LIKE '%42';


-- 1.3 DESC, ORDER BY, LIMIT - ВЫБРАТЬ ТОП-5 ФИЛЬМОВ C МАКСИМАЛЬНОМ ПРИБЫЛЬЮ (прибыль: доход REVENUE-бюджет BUDGET)
SELECT 
    TITLE, REVENUE, BUDGET, (REVENUE - BUDGET) AS 'Прибыль'
FROM
    movies
ORDER BY Прибыль DESC
LIMIT 5;


-- ШАГ 2. СЛОЖНЫЕ ВЫБОРКИ: ОБЪЕДИНЕНИЕ ТАБЛИЦ
-- 2.1  JOIN, DISTINCT - ВЫБРАТЬ ИЗ ТАБЛИЦЫ MOVIES УНИКАЛЬНЫЕ НАЗВАНИЯ ФИЛЬМОВ (TITLE), КОТОРЫМ СТАВИЛИ ОЦЕНКУ 5.
-- ВЫВЕСТИ ПЕРВЫЕ 5
select distinct TITLE
from
movies as mov
join
ratings as rat
on mov.ID = rat.MOVIEID 
where rat.RATING like '5%'
limit 5;
 

-- ШАГ 3. АГГРЕГАЦИЯ ДАННЫХ: БАЗОВЫЕ СТАТИСТИКИ
-- 3.1 COUNT(), DISTINCT - ПОСЧИТАТЬ КОЛИЧЕСТВО ФИЛЬМОВ, КОТОРЫМ СТАВИЛИ ОЦЕНКУ 1.
SELECT 
    COUNT(DISTINCT MOVIEID) AS countFilm
FROM
    ratings
WHERE
    RATING LIKE '1%';


-- 3.2 GROUP BY, ORDER BY, COUNT() - ВЫВЕСТИ НАЗВАНИЯ ТОП-5 САМЫХ ПОПУЛЯРНЫХ ФИЛЬМОВ (TITLE) 
-- (ПОПУЛЯРНОСТЬ СЧИТАТЬ ПО КОЛИЧЕСТВУ ОЦЕНОК в таблице ratings)
SELECT 
    movies.TITLE, countF.pop
FROM
    (SELECT 
        ratings.MOVIEID AS i, COUNT(ratings.RATING) AS pop
    FROM
        ratings
    GROUP BY MOVIEID
    ORDER BY COUNT(RATING) DESC
    LIMIT 5) countF
        JOIN
    movies ON countF.i = movies.ID
ORDER BY countF.pop DESC;


-- ШАГ 4. ИЕРАРХИЧЕСКИЕ ЗАПРОСЫ
-- 4.1 ПОДЗАПРОСЫ: ВЫВЕСТИ НАЗВАНИЯ И КОЛИЧЕСТВО ОЦЕНОК (ИЗ ТАБЛИЦЫ RATINGS) У ФИЛЬМОВ C МАКСИМАЛЬНЫМ СРЕДНИМ РЕЙТИНГОМ (VOTE_AVERAGE ИЗ ТАБЛИЦЫ MOVIES).
SELECT 
    movies.ID,
    movies.TITLE,
    COUNT(ratings.RATING) as countRating,
    MAX(movies.VOTE_AVERAGE) AS maxR
FROM
    movies
        JOIN
    ratings ON movies.ID = ratings.MOVIEID
GROUP BY movies.TITLE
HAVING maxR IN (SELECT 
        MAX(movies.VOTE_AVERAGE)
    FROM
        movies)
ORDER BY maxR DESC , movies.TITLE;


-- ШАГ 5. ЗАГРУЗИТЬ ФАЙЛ РАСШИРЕНИЯ *.SQL НА ПЛАТФОРМУ ODIN.