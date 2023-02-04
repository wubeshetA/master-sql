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
ORDER BY a.name /* 3.
Via what channel did the most recent (latest) web_event occur, which account was associated with this web_event?
Your query should return only three values - the date, channel, and account name.
*/
SELECT w.channel,
	w.occurred_at,
	a.name
FROM accounts AS a
JOIN web_events AS w ON a.id = w.account_id
ORDER BY w.occurred_at DESC
LIMIT 1;

/* 4.
Find the total number of times each type of channel from the web_events was used.
Your final table should have two columns - the channel and the number of times the channel was used.

*/
SELECT w.channel,
	count(*) AS total
FROM web_events AS w
GROUP BY w.channel;

/* 5.
Who was the primary contact associated with the earliest web_event?
*/
SELECT a.primary_poc
FROM accounts a
JOIN web_events w ON a.id = w.account_id
ORDER BY w.occurred_at DESC
LIMIT 1;

/* 6.
What was the smallest order placed by each account in terms of total usd.
Provide only two columns - the account name and the total usd.
Order from smallest dollar amounts to largest.
*/
SELECT a.name,
	min(o.total_amt_usd) smallest_order
FROM accounts a
JOIN orders o ON a.id = o.account_id
GROUP BY a.name
ORDER BY smallest_order -- GROUP BY PART 2
/* 1.
For each account, determine the average amount of each type of paper they purchased across their orders.
Your result should have four columns - one for the account name and one for the average spent on each of the paper types.
*/
SELECT a.name,
	avg(o.standard_amt_usd) standard,
	avg(o.poster_amt_usd) poster,
	avg(o.gloss_amt_usd) gloss
FROM accounts a
JOIN orders o ON a.id = o.account_id
GROUP BY a.name
ORDER BY standard,
	poster,
	gloss;

/* 2.
Determine the number of times a particular channel was used in the web_events table for each sales rep.
Your final table should have three columns - the name of the sales rep, the channel, and the number of occurrences.
Order your table with the highest number of occurrences first.
*/
SELECT s.name,
	w.channel,
	count(w.channel) occurrence
FROM sales_reps s
JOIN accounts a ON s.id = a.sales_rep_id
JOIN web_events w ON a.id = w.account_id
GROUP BY s.name,
	w.channel
ORDER BY occurrence DESC;

--  or
 -- SELECT s.name, w.channel, COUNT(*) num_events
-- FROM accounts a
-- JOIN web_events w
-- ON a.id = w.account_id
-- JOIN sales_reps s
-- ON s.id = a.sales_rep_id
-- GROUP BY s.name, w.channel
-- ORDER BY num_events DESC;
 -------------- Date Functions---------
 /* 1.
Find the sales in terms of total dollars for all orders in each year, ordered from
greatest to least. Do you notice any trends in the yearly sales totals?

*/
SELECT date_trunc('year',

								occurred_at) AS YEAR,
	sum(total_amt_usd)
FROM orders
GROUP BY 1
ORDER BY 1 ;

/* 2.
Which month did Parch & Posey have the greatest sales in terms of total dollars?
Are all months evenly represented by the dataset?
*/ --

SELECT date_part('month',

								occurred_at) AS MONTH,
	sum(total_amt_usd)
FROM orders
GROUP BY 1
ORDER BY 2 DESC;

-- Answer: 12th month = December has the greatest sales
 /*
In which month of which year did Walmart spend the most on gloss paper in terms of dollars?
*/
SELECT date_trunc('month', o.occurred_at),
	sum(o.gloss_amt_usd) AS gloss_total
FROM accounts a
JOIN orders o ON a.id = o.account_id
WHERE a.name = 'Walmart'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;