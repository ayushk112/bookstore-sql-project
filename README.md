# Bookstore SQL Analysis Project

## Overview
This project demonstrates practical SQL skills using a fictional bookstore dataset for analysis and reporting.
It focuses on relational database design, joins, filtering, aggregation, and business-oriented queries.

## Dataset
The project is based on three CSV files:
- `books.csv` — book details such as title, genre, price, and stock
- `customers.csv` — customer information
- `orders.csv` — order-level transaction data

## Database Schema
The database consists of three tables with the following relationships:
- `orders.customer_id` → `customers.customer_id`
- `orders.book_id` → `books.book_id`

A schema overview is available in the screenshots section.

## Key SQL Concepts Used
- INNER JOIN
- Filtering with WHERE
- Aggregation using SUM and COUNT
- GROUP BY
- ORDER BY for ranking and insights

## Key Queries & Insights
- Customers who ordered more than one quantity of a book
- Total revenue generated from all orders
- Total number of books sold per genre
- Customer with the highest total spending

## Project Structure

bookstore-sql-project/
├── data/
│   ├── books.csv
│   ├── customers.csv
│   └── orders.csv
├── sql/
│   └── bookstore_analysis.sql
├── screenshots/
│   ├── schema_tables.png
│   ├── query_customers_quantity_gt_1.png
│   ├── query_total_revenue.png
│   ├── query_books_sold_by_genre.png
│   └── query_top_spending_customer.png
└── README.md


## How to Run
1. Create tables using the SQL statements in `bookstore_analysis.sql`
2. Load data from the CSV files
3. Execute the analysis queries in PostgreSQL

## Tools Used
- PostgreSQL
- pgAdmin
- SQL


---
Created by Ayush Kandwal
