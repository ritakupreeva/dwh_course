SET search_path TO nds;

--Таблица films
CREATE TYPE status AS ENUM ('o', 'p', 'e');
CREATE TABLE films (
	id serial PRIMARY KEY,
	film_key int NOT NULL,
	title varchar(400) NOT NULL,
	"year" varchar(100) NOT NULL,
	"age" int NOT NULL,
	genre int NOT NULL,
	category int NOT NULL,
	price varchar(100) NOT NULL,
	"cost" varchar(100) NOT NULL,
	status status,
	start_ts date NOT NULL DEFAULT '1900-01-01',
	end_ts date NOT NULL DEFAULT '2999-12-31',
	is_current boolean NOT NULL,
	create_ts timestamp NOT NULL,
	update_ts timestamp NOT NULL
);

INSERT INTO films(
	film_key,
	title,
	"year",
	"age",
	genre,
	category,
	price,
	"cost",
	status,
	start_ts,
	end_ts,
	is_current,
	create_ts,
	update_ts
)
SELECT 
	fr.id,
	fr.title,
	fr."year",
	a.age_id,
	g.genre_id,
	c.category_id,
	fr.price,
	fr."cost",
	fr.status :: nds.status,
	fr."date" :: date,
	COALESCE(((LEAD(fr."date") OVER w) :: date - INTERVAL '1 DAY') :: date, '2999-12-31' :: date),
	(CASE WHEN ROW_NUMBER () OVER (PARTITION BY fr.id ORDER BY fr."date" DESC) = 1 THEN 1 ELSE 0 END) :: boolean,
	current_timestamp,
	current_timestamp
FROM public.films_raw fr
JOIN age_constraints a ON a.age_name = fr."age"
JOIN genres g ON g.genre_name = fr.genre
JOIN categories c ON c.category_name = fr.category
WINDOW w AS (PARTITION BY fr.id ORDER BY fr."date");