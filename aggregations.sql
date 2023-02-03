-- What is the difference between Aggregation and Joins in SQL
-- My response:
/*
Aggregation is an operation to merge multiple records into single result set. Hence,
Aggregation operation happens down column using one or more of the following operators,
SUM, AVG, COUNT, MIN/MAX, GROUP BY, DISTINCT, HAVING, ...
While Joins is used to combine data from multiple tables based on common feilds. Hence,
Joins happen accross rows.

*/ /*NULL

NULL - means no data recorded. it doesn't mean 0 or space. In addition, NULL is
not value, rather it's a property. so when checking if a record is NULL we don't
use =, > or < operators rather we use IS or IS NOT. e.g -> WHERE primary_poc IS NULL
*/ /* 1.
Find the total amount spent on standard_amt_usd and gloss_amt_usd paper for each order in the orders table.
This should give a dollar amount for each order in the table.
*/ -- select sum(standard_amt_usd) as standard
-- sum(gloss_amt_usd) as gloss

SELECT standard_amt_usd,
	gloss_amt_usd,
	(standard_amt_usd + gloss_amt_usd) AS total_amt
FROM orders ;

/*
2.Find the standard_amt_usd per unit of standard_qty paper.
Your solution should use both aggregation and a mathematical operator.

*/
SELECT sum(standard_amt_usd) / sum(standard_qty)
FROM orders;

/*
1. When was the earliest order ever placed? You only need to return the date.

2. Try performing the same query as in question 1 without using an aggregation function.

3. When did the most recent (latest) web_event occur?

4. Try to perform the result of the previous query without using an aggregation function.

5. Find the mean (AVERAGE) amount spent per order on each paper type, as well as the mean amount of each paper type purchased per order.
Your final answer should have 6 values - one for each paper type for the average number of sales, as well as the average amount.

6. Via the video, you might be interested in how to calculate the MEDIAN.
Though this is more advanced than what we have covered so far try finding - what is the MEDIAN total_usd spent on all orders?
*/ -- My Solutions
-- 1.

SELECT max(occurred_at)
FROM orders;

-- 2.

SELECT occurred_at
FROM orders
ORDER BY occurred_at DESC
LIMIT 1;

-- 6.

SELECT *
FROM
	(SELECT total_amt_usd
		FROM orders
		ORDER BY total_amt_usd
		LIMIT 3456) AS inside_table
ORDER BY total_amt_usd DESC
LIMIT 2;

/*
GROUP BY

whenever there is a field in the select statement that's not being aggrigated the quiry expects it to be in the GROUP BY clause.

GROUP BY can be used to aggregate data within subsets of the data. For example,
grouping for different accounts, different regions, or different sales representatives.
Any column in the SELECT statement that is not within an aggregator must be in the GROUP BY clause.
The GROUP BY always goes between WHERE and ORDER BY.
*/ -- Questions
/*
1. Which account (by name) placed the earliest order? Your solution should have the account name and the date of the order.
*/
SELECT accounts.name,
	orders.occurred_at
FROM accounts
JOIN orders ON accounts.id = orders.account_id
ORDER BY orders.occurred_at;

-- 2.
-- Find the total sales in usd for each account. You should include two columns -
-- the total sales for each company's orders in usd and the company name.

SELECT a.name,
	sum(o.total_amt_usd) total_amt_usd
FROM accounts a
JOIN orders o ON a.id = o.account_id
GROUP BY a.name
ORDER BY a.name