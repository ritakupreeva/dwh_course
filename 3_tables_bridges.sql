SET search_path TO nds;

--�������-"������"
--������
CREATE TABLE films_studios_bridge (
	film_id int NOT NULL REFERENCES films(id),
	studio_id int NOT NULL REFERENCES studios(studio_id)
);

INSERT INTO films_studios_bridge (film_id, studio_id)
WITH t AS (
	SELECT DISTINCT id AS film_key, UNNEST(string_to_array(studio, ', ')) AS studio_name
	FROM public.films_raw
)
SELECT f.id, s.studio_id
FROM t
JOIN films f ON f.film_key = t.film_key
JOIN studios s ON s.studio_name = t.studio_name;

--���������
CREATE TABLE films_directors_bridge (
	film_id int NOT NULL REFERENCES films(id),
	director_id int NOT NULL REFERENCES directors(director_id)
);

INSERT INTO films_directors_bridge (film_id, director_id)
WITH t AS (
	SELECT DISTINCT id AS film_key, UNNEST(string_to_array(director, ', ')) AS director_name
	FROM public.films_raw
)
SELECT f.id, d.director_id
FROM t
JOIN films f ON f.film_key = t.film_key
JOIN directors d ON d.director_name = t.director_name;

--����������
CREATE TABLE films_authors_bridge (
	film_id int NOT NULL REFERENCES films(id),
	author_id int NOT NULL REFERENCES script_authors(author_id)
);

INSERT INTO films_authors_bridge (film_id, author_id)
WITH t AS (
	SELECT DISTINCT id AS film_key, UNNEST(string_to_array(script_author, ', ')) AS author_name
	FROM public.films_raw
)
SELECT f.id, a.author_id
FROM t
JOIN films f ON f.film_key = t.film_key
JOIN script_authors a ON a.author_name = t.author_name;

--�������������
CREATE TABLE films_cameramen_bridge (
	film_id int NOT NULL REFERENCES films(id),
	cameraman_id int NOT NULL REFERENCES cameramen(cameraman_id)
);

INSERT INTO films_cameramen_bridge (film_id, cameraman_id)
WITH t AS (
	SELECT DISTINCT id AS film_key, UNNEST(string_to_array(cameraman, ', ')) AS cameraman_name
	FROM public.films_raw
)
SELECT f.id, c.cameraman_id
FROM t
JOIN films f ON f.film_key = t.film_key
JOIN cameramen c ON c.cameraman_name = t.cameraman_name;

--������
CREATE TABLE films_countries_bridge (
	film_id int NOT NULL REFERENCES nds.films(id),
	country_id int NOT NULL REFERENCES nds.countries(country_id)
);

INSERT INTO films_countries_bridge (film_id, country_id)
WITH t AS (
	SELECT DISTINCT id AS film_key, UNNEST(string_to_array(country, '|')) AS country_name
	FROM public.films_raw
)
SELECT f.id, c.country_id
FROM t
JOIN films f ON f.film_key = t.film_key
JOIN nds.countries c ON c.country_name = t.country_name;
