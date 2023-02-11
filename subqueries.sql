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
			
			
			