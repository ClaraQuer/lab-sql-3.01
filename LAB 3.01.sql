USE sakila;

SELECT *
FROM sakila.staff;

## Activity 1.

## 1.1 

ALTER TABLE staff
DROP picture;

## 1.2

SELECT *
FROM sakila.customer
WHERE first_name = 'TAMMY' AND last_name = 'SANDERS';

INSERT INTO sakila.staff(staff_id, first_name, last_name, address_id, email, store_id, active, username, last_update)
VALUES (3, 'Tammy', 'Sanders', 79, 'tammy.sanders@sakilastaff.com', 2, 1, 'Tammy',current_date());

## 1.3 
 
-- Checking which copies of the film are actually available in store 1:
SELECT inventory_id
FROM sakila.rental
WHERE inventory_id IN(
						(SELECT inventory_id i
						FROM sakila.film f
							JOIN sakila.inventory i
								USING(film_id)
						WHERE title = 'Academy Dinosaur'
						AND store_id = (SELECT store_id
										FROM sakila.staff
										WHERE first_name = 'Mike')
						)
                        )
AND rental_date < current_date()
AND (return_date <= current_date()
		OR return_date IS NULL)
GROUP by inventory_id
;

-- All of them are available (1, 2, 3 and 4)

INSERT INTO sakila.rental(rental_id, rental_date, inventory_id, customer_id, staff_id, last_update)
VALUES (16050, current_date(), 1, 130, 1, current_date());

SELECT *
FROM sakila.rental
WHERE rental_id = 16050;

## Activity 2

USE information_schema;

SELECT table_name, referenced_table_name
FROM REFERENTIAL_CONSTRAINTS
WHERE UNIQUE_CONSTRAINT_SCHEMA = 'sakila';

-- We have checked for the database's referential constraints and they are all in place, so there is no need to improve that. 

-- Next, we check that there is no more than one category_id for every film_id, so we can remove the category - film table. 
select film_id
		, count(category_id) AS c_count
from sakila.film_category 
group by film_id
order by c_count DESC
;

-- We see there is only one category_id per film_id. 