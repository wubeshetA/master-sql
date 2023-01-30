-- Database: parch_posey
-- pull standard_qty, gLOSS_QTY,
-- AND POSTer_qty from the orders table, and the website and the primary_poc from the accounts table.
/*
SELECT ORDERS.STANDARD_QTY,
	ORDERS.GLOSS_QTY,
	ORDERS.POSTER_QTY,
	ACCOUNTS.WEBSITE,
	ACCOUNTS.PRIMARY_POC
FROM ORDERS
JOIN ACCOUNTS ON ORDERS.ACCOUNT_ID = ACCOUNTS.ID;
*/

/* Q1. 
Provide a table for all web_events associated with the account name of Walmart.
There should be three columns. Be sure to include the primary_poc, time of the event, and the channel for each event.
Additionally, you might choose to add a fourth column to assure only Walmart events were chosen.
*/
-- My Solution --
select accounts.primary_poc, web_events.occurred_at,
web_events.channel, accounts.name
from web_events
join accounts
on accounts.id = web_events.account_id
where accounts.name = 'Walmart';

/* Q2.
Provide a table that provides the region for each sales_rep along with their associated accounts.
Your final table should include three columns: the region name, the sales rep name, and the account name. 
Sort the accounts alphabetically (A-Z) according to the account name.
*/
-- My Solution
select region.name as "Region Name", sales_reps.name as "Sales Rep", accounts.name as "Accounts"
from region
join sales_reps
on region.id = sales_reps.region_id
join accounts
on sales_reps.id = accounts.sales_rep_id
order by accounts.name;

/* Q3.
Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order.
Your final table should have 3 columns: region name, account name, and unit price.
A few accounts have 0 for total, so I divided by (total + 0.01) to assure not dividing by zero.
*/

-- My solution

select region.name as Region, accounts.name as Account, (orders.total_amt_usd / (orders.total + 0.0001)) as "Unit price"
from region
join sales_reps
on region.id = sales_reps.region_id
join accounts
on sales_reps.id = accounts.sales_rep_id
join orders
on accounts.id = orders.account_id;

-- NOTICE THE DIFFERENCE BETWEEN THE FOLLWING COMMENTED QUERIES

/*
SELECT orders.*, accounts.*
FROM orders
LEFT JOIN accounts
ON orders.account_id = accounts.id
AND accounts.sales_rep_id = 321500;
*/

------------------------------
/*
SELECT orders.*, accounts.*
FROM orders
LEFT JOIN accounts
ON orders.account_id = accounts.id
WHERE accounts.sales_rep_id = 321500;
*/


/* QUESTION

What are the different channels used by account id 1001? Your final table should have only 2 columns: account name and the different channels.
You can try SELECT DISTINCT to narrow down the results to only the unique values.
*/


select distinct accounts.name, web_events.channel, accounts.id
from accounts
join web_events
on accounts.id = web_events.account_id
where accounts.id = 1001








