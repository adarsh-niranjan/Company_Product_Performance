-- 1. Aim: To obtain all the cities in south-east region where products were dilivered.
select DISTINCT(city) AS "Cities_from_South_East", region as "Region" from customer where region IN ('South', 'East') order by city;

-- 2. Aim: To obtain the details of all the people who's age fall in range of 65 - 70.
select customer_name as "Name", age as "Age" from customer where age BETWEEN 65 AND 70 order by age;

-- 3. Aim: Obtain the top 10 youngest customers in eastern region that ordered office segment products.
select customer_name AS "Name", age as "Age", region as "Region" from customer where segment LIKE '%Office%' AND region='East' order by age limit 10;

-- 4. Aim: To find the total amount of sale per customer.
select customer_id as "ID", sum(sales) as "Total sales" from sale group by customer_id order by "Total sales" desc;

-- 5. Aim: To find average age of customer from south-eastern region.
select ROUND(avg(age)) AS Average_age from customer where region IN ('East', 'South');

-- 6. Aim: To find the age gap of customers from Philadelphia.
select max(age) AS "Oldest", min(age) AS "Youngest",(max(age)-min(age)) as "Age Gap" from customer where city='Philadelphia';

/* 7. Aim: To find
1. Total amount of sales
2. Total quantity of sales
3. Total number of orders
4. Maximum sales value
5. Minimum sales value
6. Average sales value
Based on Product ID */
select 
	sum(sales) AS Sale_per_item,
	sum(quantity) AS Total_sold,
	count(order_id) AS Order_count,
	max(sales) AS Max_sale_per_order,
	min (sales) AS Min_sale_per_order,
	ROUND(avg(sales)) AS Average_sale_per_order,
	order_id AS ID
from sale group by order_id order by Sale_per_Item desc;

-- 8. Aim: To list all the product ID's which in total possess more than 10 sale quantity.
select sum(quantity) AS "Total Quantity", order_id as "ID" from sale group by order_id having(sum(quantity)>10) order by "Total Quantity" desc; 

-- 9. Aim: Based on total sale of each product categorise them as High value and Normal if sale is more or less than 10k
select order_id AS "ID", 
	CASE WHEN sum(sales)>10000 THEN 'High Value' ELSE 'Normal' END AS "Priority", 
	sum(sales) AS "Sale" 
from sale group by order_id order by sum(sales) desc;

-- 10. Aim: To group products based on subcategory and show the relation between corresponding category and product ID
select DISTINCT(a.sub_category) as "Sub Category",
	a.category as "Category",
	SUBSTRING(a.product_id FOR 3) as "Category ID from PID",
	b.product_range "Products"
from product as a
INNER JOIN
(select sub_category, STRING_AGG(product_name,' / ') as product_range from product group by sub_category) as b
ON a.Sub_Category = b.sub_category;

-- 11. Aim: To list details of customers with middle names in the record.
select * from customer where customer_name ~*'^[a-z]{2,}\s[a-z]{2,}\s[a-z]{2,}$';

-- 12. Aim: To get sales data in every Month and check if products of all three categories were sold in each
select TO_CHAR(order_date, 'Month') as "MONTH",
	TO_CHAR(sum(sales),'L 99,99,99,999.99') as "TOTAL SALES",
	STRING_AGG(DISTINCT(SUBSTRING(product_id FOR 3)),', ') as "Category"
from sale group by "MONTH" order by "TOTAL SALES";

-- 13. Aim: To find total sale and running total for each customer.
select cs.*, sum(cs.total_sale) OVER (ORDER BY cs.name) as running_total
from (select c.customer_name as name, round(sum(s.sales)) as total_sale
from customer as c INNER JOIN sale as s 
ON c.customer_id = s.customer_id group by customer_name order by total_sale) as cs;

-- 14. Aim: To find the total sales based on states
select sum(s.sales) as "Total Sales", c.state as "State" 
from sale as s
INNER JOIN
customer as c
ON s.customer_id = c.customer_id
GROUP BY c.state
ORDER BY sum(s.sales) DESC;

-- 15. Aim: To find vital information about products based on total sales and quantity sold per product.
select p.product_id as "Product ID", 
	p.product_name as "Name", 
	p.category as "Category", 
	sum(s.sales) as "Total Sales", 
	sum(s.quantity) as "Total Quanity" 
from product as p
INNER JOIN
sale as s
ON p.product_id = s.product_id
group by p.product_id
order by "Total Sales" desc;

-- 16. Aim: To find customer name, age, all the corresponding sales data along with products they purchased including category
select c.customer_name as "Name", c.age as "Age", sp.* from customer as c
INNER JOIN
(select
 	s.customer_id as "id",
	sum(s.sales) as "Total Sales",
 	sum(s.quantity) as "Total Quantity",
 	sum(s.profit) as "Total Profit",
 	STRING_AGG(DISTINCT(p.category),',') as "Category",
 	STRING_AGG(DISTINCT(p.product_name),',') as "Products"
 from sale as s
 INNER JOIN
 product as p
 ON s.product_id = p.product_id group by s.customer_id) as sp
ON c.customer_id = sp.id;

-- 17. Aim: To Save the order line, ID, sales, and discount of products sold on the most recent date for future use
CREATE VIEW Last_order_details as 
select order_line as "Order line",
	product_id as "ID", 
	sales as "Sales", 
	discount as "Discount per item", 
	order_date as "Order date" 
from sale where order_date = (select max(order_date) from sale);
select * from last_order_details;