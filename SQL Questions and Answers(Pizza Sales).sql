--Retrieve the total number of orders placed.

select count(order_id)as 'Total Number of orders Placed' from orders

--Calculate the total revenue generated from pizza sales.

select round(sum(price * quantity),2) as 'Total Revenue'
from pizzas join order_details 
on pizzas.pizza_id = order_details.pizza_id

--Identify the highest-priced pizza.

select top 1 name,round(price,2),pizzas.pizza_id
from pizzas join pizza_types
on pizzas.pizza_type_id = pizza_types.pizza_type_id
order by price desc

--Identify the most common pizza size ordered.

select pizzas.size,count(order_details_id) as 'order count'
from pizzas join order_details
on pizzas.pizza_id = order_details.pizza_id
group by pizzas.size 
order by pizzas.size

--List the top 5 most ordered pizza types along with their quantities.

select top 5 pizza_types.name,sum(quantity) as 'Total Pizzas Ordered' 
from order_details join pizzas
on pizzas.pizza_id = order_details.pizza_id
join pizza_types
on pizzas.pizza_type_id = pizza_types.pizza_type_id
group by name
order by sum(quantity) desc

--Join the necessary tables to find the total quantity of each pizza category ordered.

select pizza_types.category,sum(quantity) as 'Total Pizzas Ordered' 
from order_details join pizzas
on pizzas.pizza_id = order_details.pizza_id
join pizza_types
on pizzas.pizza_type_id = pizza_types.pizza_type_id
group by category
order by sum(quantity) desc

--Determine the distribution of orders by hour of the day.
select DATEPART(HOUR, orders.time) as 'Time',count(orders.order_id) as 'orders'
from orders
group by DATEPART(HOUR, orders.time)
order by DATEPART(HOUR, orders.time)

	--select * from orders
	--select count(distinct(order_details_id)) from order_details

--Join relevant tables to find the category-wise distribution of pizzas.

/*select category,sum(price * quantity) as'Total sales in Dollar',sum(quantity) as 'Total Quantity'
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details 
on pizzas.pizza_id =order_details.pizza_id
group by category*/

select category,count(name) as 'Total pizza of this category' from pizza_types
group by category

--Group the orders by date and calculate the total number of pizzas ordered per day.

select orders.date as 'Date Wise Orders',sum(order_details.quantity) as 'Total Pizza Ordered' from 
orders join order_details
on orders.order_id = order_details.order_id
group by orders.date
order by orders.date

--Group the orders by date and calculate the average number of pizzas ordered per day.

select sum(quantity)/count(distinct(date)) as 'avg_Pizzas_ordered_per_day'
from orders join order_details
on orders.order_id = order_details.order_id


--Determine the top 3 most ordered pizza types based on revenue.
 
select top 3 sum(price*quantity) as 'Total Sales',name,pizzas.pizza_type_id
from pizzas join order_details
on pizzas.pizza_id = order_details.pizza_id
join pizza_types 
on pizzas.pizza_type_id =pizza_types.pizza_type_id
group by name,pizzas.pizza_type_id
order by sum(price*quantity) desc


--Calculate the percentage contribution of each pizza type to total revenue.


select pizza_type_id as 'Types of Pizza',(sum(price * quantity)*100/(select(sum(price*quantity)) 
from pizzas join order_details on  pizzas.pizza_id = order_details.pizza_id)) as 'Percentage of total sales'
from pizzas join order_details
on pizzas.pizza_id = order_details.pizza_id 
group by pizzas.pizza_type_id
order by sum(price * quantity) desc

--Analyze the cummulative revenue generated over time.
with sales as 
(select DATEPART(HOUR, orders.time) as 'Time',sum(price*quantity) as 'revenue' 
from order_details join orders
on order_details.order_id = orders.order_id
join pizzas
on pizzas.pizza_id = order_details.pizza_id
group by DATEPART(HOUR, orders.time))
SELECT Time ,SUM([Revenue]) OVER (ORDER BY Time) AS [Cumulative Revenue]
FROM sales


--Determine the top 3 most ordered pizza types based on revenue for each pizza category
with sales as
(select  sum(price*quantity) as 'revenue',pizza_types.category as 'category',name as 'Name' from 
pizza_types join pizzas 
on pizza_types.pizza_type_id = pizzas.pizza_type_id 
join order_details
on pizzas.pizza_id = order_details.pizza_id
group by pizza_types.category,name)
SELECT   revenue ,Name,category, rank() OVER (partition by category order by revenue desc ) as 'rn' 
FROM sales



























































































































































































































































