use SCM_analysis;

select * from customers;
select * from inventory;
select * from order_items;
select * from orders;
select * from payments;
select* from Products;
select * from returns;
select * from shipments; 
select * from suppliers;
select * from warehouses;

-- 1. Rank the top 10 customers based on total revenue using RANK().
with rnk_cte as
(select c.Customer_ID, c.Customer_Name, sum(ot.Quantity*p.Unit_Price) Total_revenue,
rank() over(order by sum(ot.Quantity*p.Unit_Price) desc) rnk
from order_items ot 
join Products p 
on ot.product_id = p.product_id
join orders o 
on o.order_id = ot.order_id
join customers c 
on c.customer_id = o.customer_id
group by c.Customer_ID, c.Customer_Name)
select * from rnk_cte
where rnk <= 10;


-- 2. Display each product's revenue along with its rank within its category using DENSE_RANK().
select p.Category, p.Product_name, sum(p.Unit_Price*ot.Quantity) Total_Revenue,
dense_rank() over(partition by Category order by sum(p.Unit_Price*ot.Quantity) desc) rnk
from order_items ot 
join Products p
on ot.product_id = p.product_id
group by p.Category, p.Product_name;


-- 3. Assign a unique row number to every order for each customer based on the order date using ROW_NUMBER().
select Customer_ID, Order_Date, order_id,
row_number() over(partition by Customer_ID order by Order_Date) rnk
from orders
group by Customer_ID,Order_Date, order_id;


-- 4. Calculate the running total of revenue by month.
with total as 
(select monthname(o.order_date) month_name, sum(p.unit_price* ot.quantity) as total_orders_per_month
from orders o 
join order_items ot 
on ot.order_id = o.order_id 
join products p 
on p.product_id = ot.product_id
group by month_name)
select *,
sum(total_orders_per_month) over( order by month_name ) Running_total
from total; 


-- 5. For each product category, show the previous product's revenue using LAG() and the next product's revenue using LEAD().
WITH Product_Revenue AS
(
    SELECT
        p.Category,
        p.Product_Name,
        SUM(ot.Quantity * p.Unit_Price) AS Total_Revenue
    FROM Order_Items ot
    JOIN Products p
        ON ot.Product_ID = p.Product_ID
    GROUP BY
        p.Category,
        p.Product_Name
)

SELECT
    Category,
    Product_Name,
    Total_Revenue,
    LAG(Total_Revenue) OVER (
        PARTITION BY Category
        ORDER BY Total_Revenue DESC
    ) AS Previous_Product_Revenue,
    LEAD(Total_Revenue) OVER (
        PARTITION BY Category
        ORDER BY Total_Revenue DESC
    ) AS Next_Product_Revenue
FROM Product_Revenue;