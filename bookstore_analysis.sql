/* =========
SCHEMA
========= */

CREATE TABLE BOOKS (
	BOOK_ID SERIAL PRIMARY KEY,
	TITLE CHAR(100) NOT NULL,
	AUTHOR CHAR(50) NOT NULL,
	GENRE CHAR(50) NOT NULL,
	PUBLISHED_YEAR INT,
	PRICE NUMERIC(10, 2),
	STOCK INT
);

CREATE TABLE CUSTOMERS (
	CUSTOMER_ID SERIAL PRIMARY KEY,
	NAME CHAR(100) NOT NULL,
	EMAIL VARCHAR(150) UNIQUE,
	PHONE VARCHAR(15) NOT NULL,
	CITY CHAR(50),
	COUNTRY CHAR(100)
);

CREATE TABLE ORDERS (
	ORDER_ID SERIAL PRIMARY KEY,
	CUSTOMER_ID INT REFERENCES CUSTOMERS (CUSTOMER_ID),
	BOOK_ID INT REFERENCES BOOKS (BOOK_ID),
	ORDER_DATE DATE,
	QUANTITY INT,
	TOTAL_AMOUNT NUMERIC(10, 2)
);



/* ============
DATA LOAD
============ */

COPY BOOKS (BOOK_ID, TITLE, AUTHOR, GENRE, PUBLISHED_YEAR, PRICE, STOCK)
FROM
	'C:\Program Files\PostgreSQL\18\data\Books.csv' CSV HEADER;

COPY CUSTOMERS (CUSTOMER_ID, NAME, EMAIL, PHONE, CITY, COUNTRY)
FROM
	'C:\Program Files\PostgreSQL\18\data\Customers.csv' CSV HEADER;

COPY ORDERS (ORDER_ID, CUSTOMER_ID, BOOK_ID, ORDER_DATE, QUANTITY, TOTAL_AMOUNT)
FROM
	'C:\Program Files\PostgreSQL\18\data\Orders.csv' CSV HEADER;



/* =================
ANALYSIS QUERIES
================= */


--1.Retrieve all books in the "Fiction" genre
SELECT
	*
FROM
	BOOKS
WHERE
	GENRE = 'Fiction';

--2.Find books published after the year 1950
SELECT
	*
FROM
	BOOKS
WHERE
	PUBLISHED_YEAR > 1950;

--3.List all customers from the Canada
SELECT
	*
FROM
	CUSTOMERS
WHERE
	COUNTRY = 'Canada';

--4.Showing orders placed in November 2023
SELECT
	*
FROM
	ORDERS
WHERE
	ORDER_DATE BETWEEN '2023-11-01' AND '2023-11-30';

--5.Retrieve the total stock of books available
SELECT
	SUM(STOCK) AS TOTAL_STOCK
FROM
	BOOKS;

--6.Find the details of the most expensive book(TOP 5)
SELECT
	*
FROM
	BOOKS
ORDER BY
	PRICE DESC
LIMIT
	5;

--7.Showing all customers who ordered more than 1 quantity of a book
SELECT
	*
FROM
	ORDERS
WHERE
	QUANTITY > 1;

--8.Showing all customers who ordered more than 1 quantity of a book (with customer_name & book_name)
SELECT
	C.NAME AS CUSTOMER_NAME,
	B.TITLE AS BOOK_TITLE,
	O.QUANTITY,
	O.TOTAL_AMOUNT
FROM
	ORDERS O
	JOIN CUSTOMERS C ON O.CUSTOMER_ID = C.CUSTOMER_ID
	JOIN BOOKS B ON O.BOOK_ID = B.BOOK_ID
WHERE
	O.QUANTITY > 1
ORDER BY
	QUANTITY ASC;

--9.Retrieve all orders where the total amount exceeds $20
SELECT
	*
FROM
	ORDERS
WHERE
	TOTAL_AMOUNT > 20;

--10.List all genres available in the Books table
SELECT DISTINCT
	GENRE AS GENRE_LIST
FROM
	BOOKS;

--11.Find the book with the lowest stock
SELECT
	TITLE,
	STOCK
FROM
	BOOKS
ORDER BY
	STOCK ASC;

--12.Calculate the total revenue generated from all orders
SELECT
	SUM(TOTAL_AMOUNT) AS FINAL_SALES
FROM
	ORDERS;

--13.Retrieve the total number of books sold for each genre
SELECT
	B.GENRE,
	SUM(O.QUANTITY) AS BOOK_SOLD
FROM
	BOOKS B
	JOIN ORDERS O ON B.BOOK_ID = O.BOOK_ID
GROUP BY
	B.GENRE;

--14.The average price of books in the "Fantasy" genre
SELECT
	AVG(PRICE) AS AVG_RATE
FROM
	BOOKS
WHERE
	GENRE = 'Fantasy';

--15.List of customers who have placed at least 2 orders
SELECT
	O.CUSTOMER_ID,
	C.NAME,
	COUNT(O.ORDER_ID) AS ORDER_COUNT
FROM
	ORDERS O
	JOIN CUSTOMERS C ON O.CUSTOMER_ID = C.CUSTOMER_ID
GROUP BY
	O.CUSTOMER_ID,
	C.NAME
HAVING
	COUNT(ORDER_ID) >= 2;

--16.The most frequently ordered book
SELECT
	B.TITLE,
	O.BOOK_ID,
	COUNT(O.ORDER_ID) AS MOST_LIKE_BOOK
FROM
	BOOKS B
	JOIN ORDERS O ON B.BOOK_ID = O.BOOK_ID
GROUP BY
	O.BOOK_ID,
	B.TITLE
ORDER BY
	MOST_LIKE_BOOK DESC
LIMIT
	1;

--17.The top 3 most expensive books of 'Fantasy' Genre 
SELECT
	TITLE
FROM
	BOOKS
WHERE
	GENRE = 'Fantasy'
ORDER BY
	PRICE DESC
LIMIT
	3;

--18.Retrieved the total quantity of books sold by each author
SELECT DISTINCT
	B.AUTHOR,
	SUM(O.QUANTITY) AS NUM_OF_BOOK_SOLD
FROM
	BOOKS B
	JOIN ORDERS O ON B.BOOK_ID = O.BOOK_ID
GROUP BY
	B.AUTHOR;

--19.List of the cities where customers who spent over $30 are located
SELECT
	C.CITY,
	TOTAL_AMOUNT
FROM
	ORDERS O
	JOIN CUSTOMERS C ON O.CUSTOMER_ID = C.CUSTOMER_ID
WHERE
	O.TOTAL_AMOUNT > 30;

--20.The customer who spent the most on orders
SELECT
	C.CUSTOMER_ID,
	C.NAME,
	SUM(O.TOTAL_AMOUNT) AS MONEY_SPEND
FROM
	ORDERS O
	JOIN CUSTOMERS C ON O.CUSTOMER_ID = C.CUSTOMER_ID
GROUP BY
	C.CUSTOMER_ID,
	C.NAME
ORDER BY
	MONEY_SPEND DESC
LIMIT
	1;

--21.The stock remained after fulfilling all order
SELECT
	B.BOOK_ID,
	B.TITLE,
	B.STOCK,
	COALESCE(SUM(O.QUANTITY), 0) AS ORDER_QUANTITY,
	B.STOCK - COALESCE(SUM(O.QUANTITY), 0) AS REMAINING_QUANTITY
FROM
	BOOKS B
	LEFT JOIN ORDERS O ON B.BOOK_ID = O.BOOK_ID
GROUP BY
	B.BOOK_ID;