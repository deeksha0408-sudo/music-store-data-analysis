/* =========================================================
   QUESTION SET 1 - EASY
   ========================================================= */

/* Q1: Who is the senior most employee based on job title? */
SELECT title, last_name, first_name
FROM employee
ORDER BY levels DESC
LIMIT 1;

/* Q2: Which country has the most invoices? */
SELECT billing_country, COUNT(*) AS c
FROM invoice
GROUP BY billing_country
ORDER BY c DESC
LIMIT 1;

/* Q3: What are the top 3 values of total invoice? */
SELECT total
FROM invoice
ORDER BY total DESC
LIMIT 3;

/* Q4: Which city has the best customers?
   Return the city with the highest sum of invoice totals. */
SELECT billing_city,
       SUM(total) AS InvoiceTotal
FROM invoice
GROUP BY billing_city
ORDER BY InvoiceTotal DESC
LIMIT 1;

/* Q5: Who is the best customer?
   Return the customer who has spent the most money. */
SELECT c.customer_id,
       c.first_name,
       c.last_name,
       SUM(i.total) AS total_spending
FROM customer c
JOIN invoice i
    ON c.customer_id = i.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spending DESC
LIMIT 1;


/* =========================================================
   QUESTION SET 2 - MODERATE
   ========================================================= */

/* Q1: Return email, first name, last name and genre
   of all Rock Music listeners. */
SELECT DISTINCT
       c.email,
       c.first_name,
       c.last_name
FROM customer c
JOIN invoice i
    ON c.customer_id = i.customer_id
JOIN invoice_line il
    ON i.invoice_id = il.invoice_id
WHERE il.track_id IN (
    SELECT t.track_id
    FROM track t
    JOIN genre g
        ON t.genre_id = g.genre_id
    WHERE g.name = 'Rock'
)
ORDER BY c.email;


/* Q2: Top 10 artists with the most Rock tracks */
SELECT a.artist_id,
       a.name,
       COUNT(*) AS number_of_songs
FROM track t
JOIN album al
    ON al.album_id = t.album_id
JOIN artist a
    ON a.artist_id = al.artist_id
JOIN genre g
    ON g.genre_id = t.genre_id
WHERE g.name = 'Rock'
GROUP BY a.artist_id, a.name
ORDER BY number_of_songs DESC
LIMIT 10;


/* Q3: Tracks longer than the average song length */
SELECT name,
       milliseconds
FROM track
WHERE milliseconds > (
    SELECT AVG(milliseconds)
    FROM track
)
ORDER BY milliseconds DESC;


/* =========================================================
   QUESTION SET 3 - ADVANCED
   ========================================================= */

/* Q1: Amount spent by each customer on the best-selling artist */
WITH best_selling_artist AS (
    SELECT a.artist_id,
           a.name AS artist_name,
           SUM(il.unit_price * il.quantity) AS total_sales
    FROM invoice_line il
    JOIN track t
        ON t.track_id = il.track_id
    JOIN album al
        ON al.album_id = t.album_id
    JOIN artist a
        ON a.artist_id = al.artist_id
    GROUP BY a.artist_id, a.name
    ORDER BY total_sales DESC
    LIMIT 1
)
SELECT c.customer_id,
       c.first_name,
       c.last_name,
       bsa.artist_name,
       SUM(il.unit_price * il.quantity) AS amount_spent
FROM customer c
JOIN invoice i
    ON c.customer_id = i.customer_id
JOIN invoice_line il
    ON il.invoice_id = i.invoice_id
JOIN track t
    ON t.track_id = il.track_id
JOIN album al
    ON al.album_id = t.album_id
JOIN best_selling_artist bsa
    ON bsa.artist_id = al.artist_id
GROUP BY c.customer_id,
         c.first_name,
         c.last_name,
         bsa.artist_name
ORDER BY amount_spent DESC;


/* Q2: Most popular genre for each country */
WITH popular_genre AS (
    SELECT
        COUNT(il.quantity) AS purchases,
        c.country,
        g.name,
        g.genre_id,
        ROW_NUMBER() OVER (
            PARTITION BY c.country
            ORDER BY COUNT(il.quantity) DESC
        ) AS RowNo
    FROM invoice_line il
    JOIN invoice i
        ON i.invoice_id = il.invoice_id
    JOIN customer c
        ON c.customer_id = i.customer_id
    JOIN track t
        ON t.track_id = il.track_id
    JOIN genre g
        ON g.genre_id = t.genre_id
    GROUP BY c.country,
             g.name,
             g.genre_id
)
SELECT *
FROM popular_genre
WHERE RowNo = 1;


/* Q3: Customer who spent the most on music in each country */
WITH customer_with_country AS (
    SELECT
        c.customer_id,
        c.first_name,
        c.last_name,
        i.billing_country,
        SUM(i.total) AS total_spending,
        ROW_NUMBER() OVER (
            PARTITION BY i.billing_country
            ORDER BY SUM(i.total) DESC
        ) AS RowNo
    FROM customer c
    JOIN invoice i
        ON c.customer_id = i.customer_id
    GROUP BY c.customer_id,
             c.first_name,
             c.last_name,
             i.billing_country
)
SELECT *
FROM customer_with_country
WHERE RowNo = 1;