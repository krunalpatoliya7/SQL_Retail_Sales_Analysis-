
--Create table
Create table RetailSales
	(
			transactions_id	int primary key,
			sale_date date,
			sale_time time,	
			customer_id int,	
			gender varchar(10),
			age	int,
			category varchar(30),	
			quantiy int,	
			price_per_unit	float,
			cogs float,	
			total_sale float
);

ALTER TABLE RetailSales
ALTER COLUMN sale_time TIME(0);

--To verify table creation.
select * from RetailSales 

-- to verify the number of rows
select count(*) from RetailSales

-- to identify the null values within table 
-- Data Cleaning Phase
 
Select * from RetailSales
where 
	sale_date is NUll
	or 
	sale_time is NUll
	or
	customer_id is NUll
	or
	sale_date is NUll
	or
	gender is NUll
	or
	category is NUll
	or
	quantiy is NUll
	or
	price_per_unit is NUll
	or
	cogs is NUll
	or	
	total_sale is NUll;
	
-- to delete the rows with null values.
delete from RetailSales
where 
	sale_date is NUll
	or 
	sale_time is NUll
	or
	customer_id is NUll
	or
	sale_date is NUll
	or
	gender is NUll
	or
	category is NUll
	or
	quantiy is NUll
	or
	price_per_unit is NUll
	or
	cogs is NUll
	or	
	total_sale is NUll;






-- Data Exploration and business questions.
select * from RetailSales 

-- How many sales we have?
Select count(*) from RetailSales
-- how many customers we have?
select count(distinct customer_id) as NumberOfCustomer from RetailSales

-- total number of category
select count(distinct category) as Category from RetailSales
-- to get the name of all category
Select distinct category from RetailSales


-- Data Analysis & Business key problems.
--select * from RetailSales 

--Q1 - write a sql query to retrieve all columns for sales made on ' 2022-11-05.

select * 
from RetailSales 
where sale_date = '2022-11-05';



/*Q2 - write a SQL query to retrieve all transactions where category 
is 'clothin and the quantity sold is more than 4 in the month of nov-2022*/

select * 
from RetailSales
where category = 'clothing' 
	and quantiy >=4
	and Month(sale_date) = 11
	and YEAR(sale_date) = 2022;



/* write a SQL Query to calculate total sales for each category.*/
select distinct(category),
sum(Total_sale) as NetSales,
count(*) total_orders
from RetailSales
group by category


/* write a SQL Query to find an average age of customers who purchased items from the
beauty category*/

select AVG(age) as AverageAge
	from RetailSales
where category = 'Beauty'

/* Write a SQL Query to find all transactions 
where the total sales is greater than 1000*/
select * from RetailSales where total_sale >= 1000;

/*write a SQL Query to find the total number of transactions (Transaction_id) 
made by each gender in each category*/

select category, 
		gender as Gender,
		count(transactions_id) as TransactionMade
		
	from RetailSales
			group by gender, 
			category;


--write a SQL query to calculate the average sale for each month.
select	
	year(sale_date) as SaleYear,
	Month(Sale_date) as SaleMonth,
	avg(total_sale) as AverageSale 
from 
	RetailSales 
group by 
	year(sale_date),
	Month(Sale_date)
order by 
	year(sale_date),
	--Month(Sale_date),
	AverageSale desc



/*write a SQL query to calculate the average sale for each month.
find out bease selling month in each year*/
	WITH MonthlyAvg AS (
    SELECT	
        YEAR(sale_date) AS SaleYear,
        MONTH(sale_date) AS SaleMonth,
        AVG(total_sale) AS AverageSale 
    FROM 
        RetailSales 
    GROUP BY 
        YEAR(sale_date),
        MONTH(sale_date)
)
SELECT
    SaleYear,
    SaleMonth,
    AverageSale
FROM MonthlyAvg m
WHERE AverageSale = (
    SELECT MAX(AverageSale)
    FROM MonthlyAvg
    WHERE SaleYear = m.SaleYear
)
ORDER BY SaleYear;





/*write a SQL query to find the top 5 customers based on the highest total sales*/


select 
	top 5 customer_id,
	sum(total_sale) as TotalSales
from 
	RetailSales
group by 
	customer_id
order by 
	TotalSales desc




/*Write a SQL query to find the 
number of unique customers who purchased items from each category*/


select 
	distinct category,
	count(distinct customer_id) as customers
from RetailSales 
group by category


/*Write a SQL query to create each shift and number of orders
(Example Morning<= 12, afternoon between 13&17, evening >17 */

select * from RetailSales

WITH ShiftCounts AS (
    SELECT
        CASE 
            WHEN DATEPART(HOUR, sale_time) <= 12 THEN 'Morning'
            WHEN DATEPART(HOUR, sale_time) BETWEEN 13 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS Shift,
        COUNT(*) AS NumberOfOrders
    FROM RetailSales
    GROUP BY
        CASE 
            WHEN DATEPART(HOUR, sale_time) <= 12 THEN 'Morning'
            WHEN DATEPART(HOUR, sale_time) BETWEEN 13 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END
)
SELECT *
FROM ShiftCounts
ORDER BY 
    CASE Shift
        WHEN 'Morning' THEN 1
        WHEN 'Afternoon' THEN 2
        WHEN 'Evening' THEN 3
    END;



