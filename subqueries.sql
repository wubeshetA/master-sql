/*
SUBQUERIES (Inner queries)


*/

-- QUIZ

-- 1. find the number of events that occur for each day for each channel
SELECT channel,
	avg(event_count)
FROM
	(SELECT date_trunc('day', occurred_at),
			channel,
			count(occurred_at) AS event_count
		FROM web_events
		GROUP BY 1, 2
		ORDER BY 3 DESC) sub
GROUP BY 1
ORDER BY 2
;
-- 2. Pull month level information about the first order ever made.
-- Use the result of this query to find orders that took place only on the
-- in the same month and year and pull the average for each type of paper qty in this month.

SELECT avg(standard_qty) std_avg,
	avg(gloss_qty) gloss_avg,
	avg(poster_qty) AS poster_qty
FROM orders
WHERE date_trunc('month', occurred_at) =
		(SELECT date_trunc('month', min(occurred_at))
			FROM orders)
			
;
-- QUIZES
/*
1. Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales.
*/
select t3.sales_rep, t2.region, t2.total_max
from
(SELECT region, max(total) total_max
FROM (SELECT s.name sales_rep,
		r.name region,
		sum(o.total_amt_usd) total
	FROM region r
	JOIN sales_reps s ON r.id = s.region_id
	JOIN accounts a ON a.sales_rep_id = s.id
	JOIN orders o ON o.account_id = a.id
	GROUP BY s.name, r.name
	ORDER BY 3 desc) as t1
GROUP BY 1) as t2

JOIN

(SELECT s.name sales_rep,
		r.name region,
		sum(o.total_amt_usd) total
	FROM region r
	JOIN sales_reps s ON r.id = s.region_id
	JOIN accounts a ON a.sales_rep_id = s.id
	JOIN orders o ON o.account_id = a.id
	GROUP BY s.name, r.name) AS t3

ON t2.region = t3.region and t3.total = t2.total_max


/*
2. For the region with the largest (sum) of sales total_amt_usd,
how many total (count) orders were placed?
*/
