-- Window functions

SELECT id,
       account_id,
       standard_qty,
       DATE_TRUNC('month', occurred_at) AS month,
       DENSE_RANK() OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS dense_rank,
       SUM(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS sum_std_qty,
       COUNT(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS count_std_qty,
       AVG(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS avg_std_qty,
       MIN(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS min_std_qty,
       MAX(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS max_std_qty
FROM orders;
-- see the difference between the above the below output
SELECT id,
       account_id,
       standard_qty,
       DATE_TRUNC('month', occurred_at) AS month,
       DENSE_RANK() OVER (PARTITION BY account_id ) AS dense_rank,
       SUM(standard_qty) OVER (PARTITION BY account_id ) AS sum_std_qty,
       COUNT(standard_qty) OVER (PARTITION BY account_id ) AS count_std_qty,
       AVG(standard_qty) OVER (PARTITION BY account_id ) AS avg_std_qty,
       MIN(standard_qty) OVER (PARTITION BY account_id ) AS min_std_qty,
       MAX(standard_qty) OVER (PARTITION BY account_id ) AS max_std_qty
FROM orders
order by account_id;


-- Ranking
-- 1. Row number - In this kind of ranking, ranking is distnict even with ties in what the table is ranked against.
-- 2. Rank - Ranking is same for tied records and ranks skip for subsquent records
-- 3. Dense Rank - Ranking is the same amongst tied values and ranks do not skip for subsequent values.

/*
Select the id, account_id, and total variable from the orders table, then create a column called total_rank
that ranks this total amount of paper ordered (from highest to lowest) for each account using a partition.
Your final table should have these four columns.
*/

SELECT id,
	account_id,
	total,
	row_number() over(PARTITION BY account_id ORDER BY total DESC) AS total_rank
FROM orders;


-- Comparing a Row to Previous Row - LAG

select account_id, standard_sum,
lag(standard_sum) over (order by standard_sum),
standard_sum - lag(standard_sum) over (order by standard_sum) as lag_difference

from(
	select
		account_id,
		sum(standard_qty) standard_sum
	from orders
	group by 1
	) sum
	

-- PERCENTILES

-- Questions
/*
Use the NTILE functionality to divide the accounts into 4 levels in terms of the amount of standard_qty for their orders.
Your resulting table should have the account_id, the occurred_at time for each order, the total amount of standard_qty paper
purchased, and one of four levels in a standard_quartile column.
*/

select account_id, occurred_at, standard_qty,
NTILE (4) over (PARTITION BY account_id order by standard_qty desc) as quartile
from orders

