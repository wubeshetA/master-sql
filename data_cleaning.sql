-- Data cleaning


-- Questions

/*
1. In the accounts table, there is a column holding the website for each company.
The last three digits specify what type of web address they are using.
A list of extensions (and pricing) is provided here. Pull these extensions and
provide how many of each website type exist in the accounts table.
*/

SELECT RIGHT(website, 3) as domain_name, count(*) as d_count
from accounts
group by 1;

/*
2. There is much debate about how much the name (or even the first letter of a company name) matters.
Use the accounts table to pull the first letter of each company name to see the distribution of
company names that begin with each letter (or number).
*/

SELECT left(name, 1),
	count(*)
FROM accounts
GROUP BY 1
ORDER BY 2 DESC;

/*
3. Use the accounts table and a CASE statement to create two groups:
one group of company names that start with a number and the second group of those company names
that start with a letter. What proportion of company names start with a letter?
*/

select sum(num) as total_num, sum(letter) as total_letter
from (
	select accounts.name, case when left(upper(name), 1) in ('0','1','2','3','4','5','6','7','8','9')
				then 1 else 0 end as num,
				case when left (upper(name), 1) in ('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I',
													'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R',
													'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z')
				then 1 else 0 end as letter
	from accounts
) as sub


/*
4. Consider vowels as a, e, i, o, and u. What proportion of company names start with a vowel,
and what percent start with anything else?
*/

-- select sum(counter)
-- from (
-- 	select left(name, 1) as starts_with,
-- 	case when left(upper(name), 1) = 'A' or
-- 	left(upper(name), 1) = 'E' or
-- 	left(upper(name), 1) = 'I' or
-- 	left(upper(name), 1) = 'O' or
-- 	left(upper(name), 1) = 'U'
-- 	then 1
-- 	else 0 end as counter
-- 	from accounts
-- ) as t1

select sum(vowels) sum_vowels, sum(other) as sum_const
from (
	select left(name, 1) as starts_with,
	case when left(upper(name), 1) in ('A', 'E', 'I', 'O', 'U')
	then 1 else 0 end as vowels,
	case when left(upper(name), 1) not in ('A', 'E', 'I', 'O', 'U')
	then 1 else 0 end as other
	from accounts
) as t1

-- alternative solutions

SELECT SUM(vowels) vowels, SUM(other) other
FROM (SELECT name, CASE WHEN LEFT(UPPER(name), 1) IN ('A','E','I','O','U') 
                           THEN 1 ELSE 0 END AS vowels, 
             CASE WHEN LEFT(UPPER(name), 1) IN ('A','E','I','O','U') 
                          THEN 0 ELSE 1 END AS other
            FROM accounts) t1;
