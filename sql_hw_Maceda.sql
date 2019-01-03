USE sakila;
SELECT * FROM actor;



-- 1a. Display the first and last names of 
-- all actors from the table `actor`.
SELECT first_name, last_name FROM actor;



-- 1b. Display the first and last name of each actor 
-- in a single column in upper case letters. 
-- Name the column `Actor Name`.
SELECT CONCAT(first_name,' ',last_name) AS actor_name 
FROM actor;



-- 2a. You need to find the ID number, first name, 
-- and last name of an actor, of whom you know only the first name, 
-- "Joe." What is one query would you use to obtain this information?
SELECT * FROM actor
WHERE first_name = 'JOE';



-- 2b. Find all actors whose last name contain the letters `GEN`.
SELECT * FROM actor
WHERE last_name LIKE '%GEN%';



-- 2c. Find all actors whose last names contain the letters `LI`. 
-- This time, order the rows by last name and first name, in that order.
SELECT * FROM actor
WHERE last_name LIKE '%LI%'
ORDER BY last_name, first_name;



-- 2d. Using `IN`, display the `country_id` and `country` columns 
-- of the following countries: Afghanistan, Bangladesh, and China
SELECT country_id, country 
FROM country
WHERE country IN (
'Afghanistan', 
'Bangladesh', 
'China'
); 



-- 3a. You want to keep a description of each actor. 
-- You don't think you will be performing queries on a description, 
-- so create a column in the table `actor` named `description` 
-- and use the data type `BLOB` (Make sure to research the type `BLOB`, 
-- as the difference between it and `VARCHAR` are significant).
ALTER TABLE actor ADD description BLOB; 



-- 3b. Very quickly you realize that entering descriptions 
-- for each actor is too much effort. Delete the `description` column. 
ALTER TABLE actor DROP description;



-- 4a. List the last names of actors, 
-- as well as how many actors have that last name.
SELECT last_name, COUNT(*)
FROM actor GROUP BY last_name;



-- 4b. List last names of actors and the 
-- number of actors who have that last name, 
-- but only for names that are shared by at least two actors
SELECT last_name, COUNT(*)
FROM actor
GROUP BY last_name
HAVING COUNT(*) >= 2;



-- 4c. The actor `HARPO WILLIAMS` was 
-- accidentally entered in the `actor` 
-- table as `GROUCHO WILLIAMS`. 
-- Write a query to fix the record.
SELECT * FROM actor
WHERE first_name = 'GROUCHO'; -- to find actor_id

UPDATE actor
SET first_name = 'HARPO'
WHERE (first_name = 'GROUCHO') AND (last_name = 'WILLIAMS');

SELECT * FROM actor
WHERE actor_id = 172;




-- 4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. 
-- It turns out that `GROUCHO` was the correct name after all! 
-- In a single query, if the first name of the actor is currently `HARPO`, 
-- change it to `GROUCHO`.
UPDATE actor
SET first_name = 'GROUCHO'
WHERE first_name = 'HARPO';

SELECT * FROM actor
WHERE actor_id = 172;



-- 5a. You cannot locate the schema of the `address` table. 
-- Which query would you use to re-create it?
SHOW CREATE TABLE address;


-- 6a. Use `JOIN` to display the first and last names, 
-- as well as the address, of each staff member. 
-- Use the tables `staff` and `address`
SELECT * FROM staff;

SELECT staff.first_name, staff.last_name, address.address
FROM STAFF
INNER JOIN ADDRESS ON staff.address_id=address.address_id;



-- 6b. Use `JOIN` to display the total amount rung up 
-- by each staff member in August of 2005. 
-- Use tables `staff` and `payment`.
SELECT * FROM payment;

SELECT staff.first_name, staff.last_name, SUM(payment.amount) AS TOTAL
FROM staff
LEFT JOIN payment 
ON staff.staff_id=payment.staff_id
GROUP BY staff.first_name, staff.last_name;



-- 6c. List each film and the number of actors 
-- who are listed for that film. Use tables `film_actor` 
-- and `film`. Use inner join.
SELECT * FROM film;

SELECT * FROM film_actor;

SELECT film.title, COUNT(film_actor.film_id) AS NUM_OF_ACTORS
FROM film
INNER JOIN film_actor
ON film.film_id = film_actor.film_id
GROUP BY film_actor.film_id;



-- 6d. How many copies of the film `Hunchback Impossible` 
-- exist in the inventory system?
SELECT * FROM inventory;

SELECT film.title, COUNT(inventory.film_id) AS INVENTORY
FROM film
INNER JOIN inventory
ON film.film_id = inventory.film_id
WHERE title = 'Hunchback Impossible';



-- 6e. Using the tables `payment` and `customer` 
-- and the `JOIN` command, list the total paid by each customer. 
-- List the customers alphabetically by last name
SELECT * FROM customer;

SELECT last_name, first_name, SUM(amount)
FROM payment p
INNER JOIN customer c
ON p.customer_id = c.customer_id
GROUP BY p.customer_id
ORDER BY last_name ASC;



-- 7a. The music of Queen and Kris Kristofferson have seen an 
-- unlikely resurgence. As an unintended consequence, films 
-- starting with the letters `K` and `Q` have also soared in popularity. 
-- Use subqueries to display the titles of movies starting with the letters 
-- `K` and `Q` whose language is English.
SELECT * FROM language;




SELECT title
FROM film
WHERE language_id IN(
	SELECT language_id
	FROM language
	WHERE name = 'English'
	)
AND (title LIKE 'K%') OR (title LIKE 'Q%');




-- 7b. Use subqueries to display all actors who 
-- appear in the film `Alone Trip`.
SELECT first_name, last_name
FROM actor
WHERE actor_id IN
	(
	SELECT actor_id
    FROM film_actor
    WHERE film_id IN
		(
		SELECT film_id
		FROM film
		WHERE title = 'ALONE TRIP'
        )
	);


-- 7c. You want to run an email marketing campaign in Canada, 
-- for which you will need the names and email addresses of all 
-- Canadian customers. Use joins to retrieve this information.
SELECT * FROM country;

SELECT first_name, last_name, email
FROM customer cu
LEFT JOIN address a
ON cu.address_id = a.address_id
LEFT JOIN city cy 
ON a.city_id = cy.city_id
LEFT JOIN country c
ON cy.country_id = c.country_id
WHERE c.country = 'Canada';



-- 7d. Sales have been lagging among young families, 
-- and you wish to target all family movies for a promotion. 
-- Identify all movies categorized as _family_ films.
SELECT * FROM film_category;

SELECT * FROM category;



SELECT title
FROM film
WHERE film_id IN
	(
	SELECT film_id
    FROM film_category
    WHERE category_id IN
		(
		SELECT category_id
		FROM category
		WHERE name = 'Family'
		)
	);
    
    
    
-- 7e. Display the most frequently rented movies 
-- in descending order.
SELECT * FROM rental;

SELECT * FROM inventory;

SELECT * FROM film;

SELECT f.title, COUNT(r.rental_id) AS RENT_COUNT
FROM film f
LEFT JOIN inventory i
ON f.film_id = i.film_id
LEFT JOIN rental r
ON i.inventory_id = r.inventory_id
GROUP BY f.title
ORDER BY COUNT(r.rental_id) DESC;




-- 7f. Write a query to display how much 
-- business, in dollars, each store brought in.
SELECT * FROM store;
SELECT * FROM staff;
SELECT * FROM payment;

SELECT str.store_id, SUM(p.amount) AS AMT_PAID
FROM store str
LEFT JOIN staff stf
ON str.store_id = stf.store_id
LEFT JOIN payment p
ON stf.staff_id = p.staff_id
GROUP BY str.store_id;




-- 7g. Write a query to display for each store its 
-- store ID, city, and country.
SELECT * FROM country;
SELECT * FROM city;
SELECT * FROM address;
SELECT * FROM store;

SELECT str.store_id, cy.city, c.country
FROM store str
LEFT JOIN address a
ON str.address_id = a.address_id
LEFT JOIN city cy
ON a.city_id = cy.city_id
LEFT JOIN country c
ON cy.country_id = c.country_id
GROUP BY str.store_id;



-- 7h. List the top five genres in gross revenue in 
-- descending order. (**Hint**: you may need to use 
-- the following tables: category, film_category, 
-- inventory, payment, and rental.)
SELECT * FROM category;
SELECT * FROM film_category;
SELECT * FROM inventory;
SELECT * FROM payment;
SELECT * FROM rental;

SELECT cat.name, SUM(p.amount) AS GROSS_REV
FROM category cat
LEFT JOIN film_category f_c
ON cat.category_id = f_c.category_id
LEFT JOIN inventory i
ON f_c.film_id = i.film_id
LEFT JOIN rental r
ON i.inventory_id = r.inventory_id
LEFT JOIN payment p
ON r.rental_id = p.rental_id
GROUP BY cat.name
ORDER BY SUM(p.amount) DESC
LIMIT 5;



-- 8a. In your new role as an executive, 
-- you would like to have an easy way of 
-- viewing the Top five genres by gross revenue. 
-- Use the solution from the problem above to 
-- create a view. If you haven't solved 7h, 
-- you can substitute another query to create a view.
CREATE OR REPLACE VIEW top_five_genres AS 
    SELECT cat.name, SUM(p.amount) AS GROSS_REV
	FROM category cat
	LEFT JOIN film_category f_c
	ON cat.category_id = f_c.category_id
	LEFT JOIN inventory i
	ON f_c.film_id = i.film_id
	LEFT JOIN rental r
	ON i.inventory_id = r.inventory_id
	LEFT JOIN payment p
	ON r.rental_id = p.rental_id
	GROUP BY cat.name
	ORDER BY SUM(p.amount) DESC
	LIMIT 5;




-- 8b. How would you display the view that you created in 8a?
SELECT * FROM top_five_genres;



-- 8c. You find that you no longer need the view 
-- `top_five_genres`. Write a query to delete it.
DROP VIEW top_five_genres;


