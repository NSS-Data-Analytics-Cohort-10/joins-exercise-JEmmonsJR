-- 1. Give the name, release year, and worldwide gross of the lowest grossing movie.
SELECT
	s.film_title,
	s.release_year,
	r.worldwide_gross
FROM specs AS s
INNER JOIN revenue AS r
USING(movie_id)
ORDER BY r.worldwide_gross
LIMIT 1;

--ANSWERS: Semi-Tough, 1997, $37,187,139

-- 2. What year has the highest average imdb rating?

SELECT
	s.release_year AS year,
	AVG(r.imdb_rating) AS avg_rating
FROM specs AS s
INNER JOIN rating AS r
USING(movie_id)
GROUP BY year
ORDER BY avg_rating DESC
LIMIT 1;

--ANSWER: 1991

-- 3. What is the highest grossing G-rated movie? Which company distributed it?

SELECT
	s.film_title AS title,
	s.mpaa_rating AS rating,
	r.worldwide_gross AS gross,
	d.company_name AS company
FROM specs AS s
INNER JOIN distributors AS d
ON s.domestic_distributor_id = d.distributor_id
INNER JOIN revenue AS r
ON s.movie_id = r.movie_id
WHERE LOWER(s.mpaa_rating) LIKE 'g'
ORDER BY gross DESC
LIMIT 1;

--ANSWERS:Toy Story 4; Walt Disney

--4. Write a query that returns, for each distributor in the distributors table, the distributor name and the number of movies associated with that distributor in the movies table. Your result set should include all of the distributors, whether or not they have any movies in the movies table.

SELECT
	d.company_name AS company,
	COUNT(s.movie_id) AS num_movies
FROM distributors AS d
LEFT JOIN specs AS s
ON d.distributor_id = s.domestic_distributor_id
GROUP BY company;

--5. Write a query that returns the five distributors with the highest average movie budget.

SELECT
	d.company_name AS company,
	AVG(r.film_budget) AS avg_budget
FROM distributors AS d
LEFT JOIN specs AS s
ON d.distributor_id = s.domestic_distributor_id
INNER JOIN revenue AS r
ON s.movie_id = r.movie_id
GROUP BY company
ORDER BY avg_budget DESC
LIMIT 5;

--6. How many movies in the dataset are distributed by a company which is not headquartered in California? Which of these movies has the highest imdb rating?

SELECT
	COUNT(s.movie_id)
FROM specs AS s
FULL OUTER JOIN distributors AS d
ON s.domestic_distributor_id = d.distributor_id
WHERE LOWER(d.headquarters) NOT LIKE '%california%';

SELECT
	s.film_title AS title,
	r.imdb_rating AS imdb
FROM specs AS s
FULL OUTER JOIN distributors AS d
ON s.domestic_distributor_id = d.distributor_id
FULL OUTER JOIN rating AS r
ON s.movie_id = r.movie_id
WHERE LOWER(d.headquarters) NOT LIKE '%california%'
AND r.imdb_rating IS NOT NULL
ORDER BY imdb DESC
LIMIT 1;

--ANSWERS: 419, The Dark Knight

--7. Which have a higher average rating, movies which are over two hours long or movies which are under two hours?
