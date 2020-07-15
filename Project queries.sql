/*Query 1- What is the number of rental orders per each family friendly movie category?*/

SELECT f.title,cy.name, COUNT(r.rental_date) rental_count
FROM film f
JOIN film_category fc
ON f.film_id = fc.film_id
JOIN inventory iy
ON f.film_id = iy.film_id
JOIN category cy
ON fc.category_id = cy.category_id
JOIN rental r
ON r.inventory_id = iy.inventory_id
WHERE cy.name LIKE 'Animation' OR cy.name LIKE 'Family' OR cy.name LIKE 'Classics' OR cy.name LIKE 'Comedy' OR cy.name LIKE 'Children' OR cy.name LIKE 'Music'
GROUP BY 1,2
ORDER BY 2


/*Query 2 - What is the total number of rental orders for each store per month?*/


SELECT table1.rental_month,table1.rental_year,table1.store_id, COUNT(CONCAT(table1.store_id,' ',table1.rental_month,' ',table1.rental_year))
FROM(SELECT c.store_id,DATE_PART('month',rental_date) AS rental_month,DATE_PART('year',rental_date) AS rental_year
FROM rental r
JOIN customer c
ON c.customer_id = r.customer_id) table1
GROUP BY 1,2,3
ORDER BY 4 DESC

/*Query 3 - Who are the top ten customers and how is their payment count?*/

SELECT DATE_TRUNC('month',p.payment_date) payment_mon, CONCAT(c.first_name,' ',c.last_name) fullname, SUM(p.amount) total_payment, COUNT(DATE_TRUNC('month',p.payment_date)) pay_countpermon
FROM payment p
JOIN customer c
ON p.customer_id = c.customer_id
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 10

/*Query 4 - Who are the customers with highest payment difference across successive month?*/

WITH table2 AS(SELECT DATE_TRUNC('month',p.payment_date) payment_mon, CONCAT(c.first_name,' ',c.last_name) fullname, SUM(p.amount) total_payment, COUNT(DATE_TRUNC('month',p.payment_date)) pay_countpermon
FROM payment p
JOIN customer c
ON p.customer_id = c.customer_id
GROUP BY 1,2)

SELECT table2.payment_mon,table2.fullname,SUM(table2.total_payment), SUM(table2.total_payment )-LAG(SUM(table2.total_payment)) OVER (PARTITION BY table2.fullname ORDER BY table2.payment_mon) lag_difference
FROM table2
WHERE table2.fullname IN('Eleanor Hunt','Arnold Havens','Gordon Allard','Rhonda Kennedy','Clara Shaw','Tommy Collazo','Karl Seal','Marsha Douglous', 'Daisy Bates','Eleanor Hunt')
GROUP BY 1,2
