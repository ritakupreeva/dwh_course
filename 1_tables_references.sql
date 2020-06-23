CREATE SCHEMA nds;
SET search_path TO nds;

--Таблицы-"справочники"
--Студии
CREATE TABLE studios (
	studio_id serial PRIMARY KEY,
	studio_name varchar(200) NOT NULL UNIQUE
);

INSERT INTO studios (studio_name)
SELECT DISTINCT UNNEST(string_to_array(studio, ', '))
FROM public.films_raw;

--Режиссеры
CREATE TABLE directors (
	director_id serial PRIMARY KEY,
	director_name varchar(150) NOT NULL UNIQUE
);
	
INSERT INTO directors (director_name)
SELECT DISTINCT UNNEST(string_to_array(director, ', '))
FROM public.films_raw;

--Сценаристы
CREATE TABLE script_authors (
	author_id serial PRIMARY KEY,
	author_name varchar(250) NOT NULL UNIQUE
);

INSERT INTO script_authors (author_name)
SELECT DISTINCT UNNEST(string_to_array(script_author, ', '))
FROM public.films_raw;

--Кинооператоры
CREATE TABLE cameramen (
	cameraman_id serial PRIMARY KEY,
	cameraman_name varchar(50) NOT NULL UNIQUE
);

INSERT INTO cameramen (cameraman_name)
SELECT DISTINCT UNNEST(string_to_array(cameraman, ', '))
FROM public.films_raw;

--Возрастные ограничения
CREATE TABLE age_constraints (
	age_id serial PRIMARY KEY,
	age_name varchar(100) NOT NULL UNIQUE
);

INSERT INTO age_constraints (age_name)
SELECT DISTINCT age
FROM public.films_raw;

--Жанры
CREATE TABLE genres (
	genre_id serial PRIMARY KEY,
	genre_name varchar(20) NOT NULL UNIQUE
);

INSERT INTO genres (genre_name)
SELECT DISTINCT genre
FROM public.films_raw;

--Страны
CREATE TABLE countries (
	country_id serial PRIMARY KEY,
	country_name varchar(50) NOT NULL UNIQUE
);

INSERT INTO countries (country_name)
SELECT DISTINCT UNNEST(string_to_array(country, '|'))
FROM public.films_raw;

--Категории
CREATE TABLE categories (
	category_id serial PRIMARY KEY,
	category_name varchar(10) NOT NULL UNIQUE
);

INSERT INTO categories (category_name)
SELECT DISTINCT category
FROM public.films_raw;
