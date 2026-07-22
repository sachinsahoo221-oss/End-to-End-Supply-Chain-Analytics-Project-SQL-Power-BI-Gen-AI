create database SCM_analysis;
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





-- EDA Analysis

-- How many total orders are there?
select count(order_id) total_orders
from orders;

-- How many unique customers placed orders?
select count(Distinct Customer_ID)
from Orders;

-- How many products are available?
select count(distinct Product_ID) Total_products
from products;

-- How many suppliers are there?
select count(distinct supplier_id) total_supplier
from suppliers;

-- How many warehouses are in the database
select count(distinct warehouse_id) Total_warehouse
from Warehouses;

-- Which month has the highest number of orders?
select monthname(Order_Date) as Months, count(order_ID) Total_orders
from orders
group by Months
order by Total_orders desc
limit 1;

-- Which day of the week receives the most orders?
select dayname(Order_Date) week_name, count(order_id) Total_orders
from orders
group by week_name
order by Total_orders desc
limit 1;

-- What is the average number of products per order?
with counts as
(select Order_ID, count(product_ID) Total_products
from Order_items
group by Order_ID)
select round(avg(Total_products),2) Avg_products_per_orders
from counts;

-- Which warehouse processes the highest number of orders?
select warehouse_ID, count(order_id) Total_orders
from orders
group by Warehouse_ID
order by Total_orders desc
limit 1;

-- Find the first and last order dates in the dataset.
select Max(order_date), MIn(order_date)
from orders;

-- Customer Analysis


-- Which customer placed the highest number of orders?
select Customer_ID, count(Order_ID) Total_orders
from orders
group by Customer_ID
order by Total_orders desc;

-- Which city has the most customers?
select City, Count(customer_id) total_customers
from Customers
group by City
order by total_customers desc
limit 1;

-- Which city generated the highest number of orders?
select city, count(Order_ID) total_orders
from orders o
join customers c 
on o.customer_id = c.customer_id
group by city
order by total_orders desc
limit 1;

-- Which customer purchased the highest total quantity of products?
select customer_id, sum(Quantity) as  total_quantity
from orders o 
join order_items ot 
on o.order_id = ot.order_id
group by customer_id
order by total_quantity desc
limit 1   ;

-- Find customers who have placed only one order.
select customer_id, count(Order_id) as  total_order
from orders 
group by customer_id
having total_order < 2;


-- Product Analysis

-- Which product was sold the most by quantity?
select Product_ID, sum(quantity) total_qty
from Order_items
group by Product_ID
order by total_qty desc
limit 1;

-- Which product generated the highest revenue?
select p.Product_ID,p.Product_Name, sum(p.Unit_Price*o.Quantity) as Total_revenue_generated
from products p
join order_items o 
on o.product_id= p.product_id
group by Product_ID,Product_Name
order by Total_revenue_generated desc
limit 1;

-- Which product category contains the most products?
select Category, count(Product_name) Total_products
from Products
group by Category
order by Total_products desc;

-- Which category sold the highest total quantity?
select category, sum(quantity) Total_quantity_ordered
from Products p
join order_items o
on o.Product_id = p.product_id
group by category
order by Total_quantity_ordered desc;

-- Which supplier has the highest number of products?
select s.supplier_id, count(p.product_name) as total_products
from products p
join suppliers s
on s.supplier_id = p.supplier_id
group by s.supplier_id
order by total_products desc;

-- Inventory & Warehouse Analysis




-- Which supplier supplies the most inventory items?

-- Which warehouse has the highest total inventory stock?
select Warehouse_ID, sum(Stock) as Total_stock
from inventory
group by Warehouse_ID
order by Total_stock desc;

-- Which warehouse stores the highest number of unique products?
select Warehouse_id, count(product_id) as total_product_count
from Inventory
group by Warehouse_id
order by total_product_count desc;

-- List products that have zero inventory.
select Product_id, count(stock) Total_avalible_stock
from inventory
group by Product_id
having Total_avalible_stock < 1;

-- Find the top 10 products with the lowest stock.
select Product_id, count(stock) Total_avalible_stock
from inventory
group by Product_id
order by Total_avalible_stock asc
limit 10;

-- Which supplier supplies the most inventory items?
SELECT
    s.Supplier_ID,
    s.Supplier_Name,
    SUM(i.Stock) AS Total_Stock
FROM Suppliers s
JOIN Products p
    ON s.Supplier_ID = p.Supplier_ID
JOIN Inventory i
    ON p.Product_ID = i.Product_ID
GROUP BY
    s.Supplier_ID,
    s.Supplier_Name
ORDER BY Total_Stock DESC
LIMIT 1;



--  Shipment & Return Analysis

-- Calculate the percentage of delayed shipments.
select
round(sum(case when Shipment_status = 'Delayed' then 1 else 0 end) /count(*) *100.0,2) as Delayed_percent
from shipments;

-- Which warehouse has the highest number of delayed shipments?
select warehouse_id, 
sum(case when shipment_status = 'Delayed' then 1 else 0 end) as Delayed_shipments
from shipments
group by warehouse_id
order by Delayed_shipments asc;

select warehouse_id , count(shipment_status)
from shipments
where Shipment_status = 'Delayed'
group by warehouse_id
order by count(shipment_status) asc ;

-- Which return reason occurs most frequently?
select Reason, count(return_id) Total_returns
from returns
group by Reason
order by Total_returns desc;

-- Which month has the highest number of returns?
select monthname(o.order_date) as Month_name, count(r.return_id) total_returns
from orders o 
join returns r 
on o.order_id = r.order_id
group by Month_name
order by total_returns desc;

-- Which products are returned most often?
select o.Product_id, count(r.return_id) as total_returns
from order_items o
join returns r 
on o.order_id = r.order_id
group by  o.Product_id
order by  total_returns desc;

select count(order_id) from orders;