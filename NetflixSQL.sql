SELECT TOP 100 * FROM NetflixTitles$;

-- Cleaning step 1: Replace NULLs with 'Unknown' in director, cast, and country

UPDATE NetflixTitles$
SET director = ISNULL(director, 'Unknown'),
    cast = ISNULL(cast, 'Unknown'),
    country = ISNULL(country, 'Unknown');

-- Cleaning step 2: Trim whitespace from all NVARCHAR columns

UPDATE NetflixTitles$
SET show_id = LTRIM(RTRIM(show_id)),
    type = LTRIM(RTRIM(type)),
    title = LTRIM(RTRIM(title)),
    director = LTRIM(RTRIM(director)),
    cast = LTRIM(RTRIM(cast)),
    country = LTRIM(RTRIM(country)),
    rating = LTRIM(RTRIM(rating)),
    duration = LTRIM(RTRIM(duration)),
    listed_in = LTRIM(RTRIM(listed_in)),
    description = LTRIM(RTRIM(description));

--Update the Date Column - to Year-Month-Date only 

ALTER TABLE NetflixTitles$ ALTER COLUMN date_added date 

--Drop and alter columns (hard to quantify)

ALTER TABLE NetflixTitles$ DROP COLUMN description; 

DELETE FROM NetflixTitles$  -- Use DELETE to remove rows
WHERE duration LIKE '%min%';

-- Count the number of movies and TV shows

SELECT type, COUNT(*) AS count
FROM NetflixTitles$
GROUP BY type;

DELETE FROM NetflixTitles$  
WHERE rating LIKE '%min%';
-- Analyze the distribution of ratings

SELECT rating, COUNT(*) AS count
FROM NetflixTitles$
GROUP BY rating;

UPDATE NetflixTitles$
SET rating = ISNULL(rating, 'Unknown');

-- List unique countries represented in the dataset

SELECT DISTINCT country
FROM NetflixTitles$;

-- Retrieve all  produced in the United States

SELECT *
FROM NetflixTitles$
WHERE country = 'United States' ;

-- Count the number of titles released each year

SELECT release_year, COUNT(*) AS count
FROM NetflixTitles$
GROUP BY release_year
ORDER BY release_year;

-- List the top countries by the number of titles

SELECT country, COUNT(*) AS count
FROM NetflixTitles$
GROUP BY country
ORDER BY count DESC;

-- List popular directors by the number of titles

SELECT director, COUNT(*) AS count
FROM NetflixTitles$
WHERE director IS NOT NULL
GROUP BY director
ORDER BY count DESC;