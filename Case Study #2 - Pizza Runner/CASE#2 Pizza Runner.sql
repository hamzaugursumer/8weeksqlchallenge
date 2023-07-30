--Data
CREATE SCHEMA pizza_runner;
SET search_path = pizza_runner;

DROP TABLE IF EXISTS runners;
CREATE TABLE runners (
  "runner_id" INTEGER,
  "registration_date" DATE
);
INSERT INTO runners
  ("runner_id", "registration_date")
VALUES
  (1, '2021-01-01'),
  (2, '2021-01-03'),
  (3, '2021-01-08'),
  (4, '2021-01-15');


DROP TABLE IF EXISTS customer_orders;
CREATE TABLE customer_orders (
  "order_id" INTEGER,
  "customer_id" INTEGER,
  "pizza_id" INTEGER,
  "exclusions" VARCHAR(4),
  "extras" VARCHAR(4),
  "order_time" TIMESTAMP
);

INSERT INTO customer_orders
  ("order_id", "customer_id", "pizza_id", "exclusions", "extras", "order_time")
VALUES
  ('1', '101', '1', '', '', '2020-01-01 18:05:02'),
  ('2', '101', '1', '', '', '2020-01-01 19:00:52'),
  ('3', '102', '1', '', '', '2020-01-02 23:51:23'),
  ('3', '102', '2', '', NULL, '2020-01-02 23:51:23'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '2', '4', '', '2020-01-04 13:23:46'),
  ('5', '104', '1', 'null', '1', '2020-01-08 21:00:29'),
  ('6', '101', '2', 'null', 'null', '2020-01-08 21:03:13'),
  ('7', '105', '2', 'null', '1', '2020-01-08 21:20:29'),
  ('8', '102', '1', 'null', 'null', '2020-01-09 23:54:33'),
  ('9', '103', '1', '4', '1, 5', '2020-01-10 11:22:59'),
  ('10', '104', '1', 'null', 'null', '2020-01-11 18:34:49'),
  ('10', '104', '1', '2, 6', '1, 4', '2020-01-11 18:34:49');


DROP TABLE IF EXISTS runner_orders;
CREATE TABLE runner_orders (
  "order_id" INTEGER,
  "runner_id" INTEGER,
  "pickup_time" VARCHAR(19),
  "distance" VARCHAR(7),
  "duration" VARCHAR(10),
  "cancellation" VARCHAR(23)
);

INSERT INTO runner_orders
  ("order_id", "runner_id", "pickup_time", "distance", "duration", "cancellation")
VALUES
  ('1', '1', '2020-01-01 18:15:34', '20km', '32 minutes', ''),
  ('2', '1', '2020-01-01 19:10:54', '20km', '27 minutes', ''),
  ('3', '1', '2020-01-03 00:12:37', '13.4km', '20 mins', NULL),
  ('4', '2', '2020-01-04 13:53:03', '23.4', '40', NULL),
  ('5', '3', '2020-01-08 21:10:57', '10', '15', NULL),
  ('6', '3', 'null', 'null', 'null', 'Restaurant Cancellation'),
  ('7', '2', '2020-01-08 21:30:45', '25km', '25mins', 'null'),
  ('8', '2', '2020-01-10 00:15:02', '23.4 km', '15 minute', 'null'),
  ('9', '2', 'null', 'null', 'null', 'Customer Cancellation'),
  ('10', '1', '2020-01-11 18:50:20', '10km', '10minutes', 'null');


DROP TABLE IF EXISTS pizza_names;
CREATE TABLE pizza_names (
  "pizza_id" INTEGER,
  "pizza_name" TEXT
);
INSERT INTO pizza_names
  ("pizza_id", "pizza_name")
VALUES
  (1, 'Meatlovers'),
  (2, 'Vegetarian');


DROP TABLE IF EXISTS pizza_recipes;
CREATE TABLE pizza_recipes (
  "pizza_id" INTEGER,
  "toppings" TEXT
);
INSERT INTO pizza_recipes
  ("pizza_id", "toppings")
VALUES
  (1, '1, 2, 3, 4, 5, 6, 8, 10'),
  (2, '4, 6, 7, 9, 11, 12');


DROP TABLE IF EXISTS pizza_toppings;
CREATE TABLE pizza_toppings (
  "topping_id" INTEGER,
  "topping_name" TEXT
);
INSERT INTO pizza_toppings
  ("topping_id", "topping_name")
VALUES
  (1, 'Bacon'),
  (2, 'BBQ Sauce'),
  (3, 'Beef'),
  (4, 'Cheese'),
  (5, 'Chicken'),
  (6, 'Mushrooms'),
  (7, 'Onions'),
  (8, 'Pepperoni'),
  (9, 'Peppers'),
  (10, 'Salami'),
  (11, 'Tomatoes'),
  (12, 'Tomato Sauce');
--*****************************************************--  

--CLEANED DATA (customer_orders)

  CREATE TABLE customer_orders_clean AS
SELECT * 
FROM customer_orders

UPDATE customer_orders_clean
SET exclusions =
    (CASE 
        WHEN exclusions = '' OR exclusions LIKE '%null%'
            THEN NULL 
        ELSE exclusions END)
    , extras = 
    (CASE 
        WHEN extras = '' OR extras LIKE '%null%' OR extras is NULL
            THEN NULL
        ELSE extras END)
		
		
	drop table customer_orders	
	
	alter table customer_orders_clean rename to customer_orders
  
--DATA CLEAN

CREATE TABLE runner_orders_clean AS
SELECT *
FROM runner_orders	

UPDATE runner_orders_clean
SET pickup_time = 
    (CASE 
        WHEN pickup_time LIKE '%null%' THEN NULL
        ELSE pickup_time END)
    , distance = 
    (CASE
        WHEN distance LIKE '%null%'
            THEN NULL
        WHEN distance LIKE '%km'
            THEN TRIM(distance, 'km')
        ELSE distance END)
    , duration = 
    (CASE 
        WHEN duration LIKE '%null%'
            THEN NULL
        WHEN duration LIKE '%minutes%'
            THEN TRIM(duration, 'minutes')
        WHEN duration LIKE '%mins%'
            THEN TRIM(duration, 'mins')
        WHEN duration LIKE '%minute%'
            THEN TRIM(duration, 'minute')
        ELSE duration END)
    , cancellation =
        (CASE 
            WHEN cancellation LIKE '%null' OR cancellation = ''
                THEN NULL
            ELSE cancellation END)
			
drop table runner_orders	

alter table runner_orders_clean rename to runner_orders

--SOLITIONS

--A. Pizza Metrics--

--1 How many pizzas were ordered?
--(Kaç pizza sipariş edildi?)

select count(order_id) as ordered_pizza 
from customer_orders

--2 How many unique customer orders were made?
--(Kaç adet benzersiz müşteri siparişi verildi)?

select count(distinct order_id) as unique_order 
from customer_orders

--3 How many successful orders were delivered by each runner?
--(Her bir koşucu tarafından kaç başarılı sipariş teslim edildi?)
select
*
from customer_orders as co
left join runner_orders as ro
ON ro.order_id = co.order_id

select
	runner_id,
count(distinct co.order_id) as count_order
from customer_orders as co
left join runner_orders as ro
ON ro.order_id = co.order_id
where ro.cancellation is null
group by 1

--4 How many of each type of pizza was delivered?
--(Her pizza türünden kaç tane teslim edildi?)

select
	pizza_id,
count(co.order_id) as count_order
from customer_orders as co
left join runner_orders as ro
ON ro.order_id = co.order_id
where ro.cancellation is null
group by 1


--5 How many Vegetarian and Meatlovers were ordered by each customer?
--(Her bir müşteri kaç Vejetaryen ve Meatlovers sipariş etti?)

select pizza_name,
	   customer_id,
	   count(pa.pizza_id) as count_pizza
from customer_orders as co
left join pizza_names as pa
ON pa.pizza_id = co.pizza_id
group by 1,2


--6 What was the maximum number of pizzas delivered in a single order?
--(Tek bir siparişte teslim edilen maksimum pizza sayısı ne kadardı?)

with table1 as 
(
select co.order_id,
       count(co.order_id) as order_count
from customer_orders co
left join runner_orders as ro
ON co.order_id = ro.order_id
where cancellation is null
group by 1
order by order_count desc
)
select max(order_count)
from table1

--7 For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
--(Her bir müşteri için, teslim edilen pizzaların kaç tanesinde en az 1 değişiklik yapıldı ve kaç tanesinde değişiklik yapılmadı?)

select co.customer_id,
	   count(case when co.exclusions is not null or co.extras is not null then 'change' end) as change,
	   count(case when co.exclusions is null and co.extras is null then 'not change' end) as not_change
from customer_orders as co
left join runner_orders as ro
ON ro.order_id = co.order_id
where cancellation is null
group by 1

--8 How many pizzas were delivered that had both exclusions and extras?
--(Hem istisnaları hem de ekstraları olan kaç pizza teslim edildi?)

select
	count(case when co.exclusions is not null and co.extras is not null then 'both' end) as both_change
from customer_orders as co
left join runner_orders as ro
ON ro.order_id = co.order_id
where cancellation is null 


--9 What was the total volume of pizzas ordered for each hour of the day?
--(Günün her saati için sipariş edilen pizzaların toplam hacmi ne kadardı?)

select to_char(co.order_time, 'hh24') as hour_of_day,
	   count(co.order_id) as order_count
from customer_orders as co
group by 1
order by 2 desc

-- 10 What was the volume of orders for each day of the week?
--(Haftanın her günü için sipariş hacmi ne kadardı?)

select to_char(co.order_time, 'day') as day_of_week,
	   count(co.order_id) as order_count
from customer_orders as co
group by 1
order by 2 desc



--B. Runner and Customer Experience--

--1 How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
--(Her 1 haftalık dönem için kaç koşucu kaydoldu? (yani hafta 2021-01-01'de başlar))

select 
	to_char(registration_date, 'w') as weeks_
	count(runner_id),
from runners
group by 2
order by 2 


--2 What was the average time in minutes it took for each runner to arrive at the Pizza
--(Her bir koşucunun Pizza'ya varması için geçen ortalama süre dakika cinsinden neydi?)

with table1 as 
(
select ro.runner_id,
	   avg(ro.pickup_time::timestamp-co.order_time) as avg_pickup_time
from customer_orders as co
left join runner_orders as ro
ON ro.order_id = co.order_id
group by 1
)
select runner_id, 
	   extract (minute from avg_pickup_time) as avg_pickup_min
from table1
order by 2 


--3 Is there any relationship between the number of pizzas and how long the order takes to prepare?
--(Pizza sayısı ile siparişin ne kadar sürede hazırlandığı arasında bir ilişki var mı?)

with table1 as 
(
select 
count(co.order_id) as order_count,
ro.pickup_time::timestamp-co.order_time as prepare_time
from customer_orders as co
left join runner_orders as ro
ON ro.order_id = co.order_id
group by 2                                    /* sipariş sayısı arttıkça ortalama hazırlanma süresi artmaktadır*/ 
)
select order_count,
	   extract(minute from avg(prepare_time)) as avg_prepare_time
from table1 
group by 1



--4 What was the average distance travelled for each customer?
--(Her bir müşteri için kat edilen ortalama mesafe neydi?)


select co.customer_id,
	   round(avg(ro.distance::numeric),2) as avg_distance
from customer_orders as co
left join runner_orders as ro
ON ro.order_id = co.order_id
group by 1
order by 1


--5 What was the difference between the longest and shortest delivery times for all orders?
--(Tüm siparişler için en uzun ve en kısa teslimat süreleri arasındaki fark neydi?)


with table1 as 
(
select max(duration::numeric) as max_duration,
	   min(duration::numeric) as min_duration
from runner_orders 
where cancellation is null
)
select (max_duration-min_duration) as diff_duration
from table1 


--6 What was the average speed for each runner for each delivery and do you notice any trend for these values?
--(Her koşucu için her teslimatta ortalama hız ne kadardı ve bu değerlerde herhangi bir eğilim fark ettiniz mi?)

--V=X/t

select order_id, 
	   runner_id, 
       round(avg(distance::numeric / (duration::numeric/60)),2) AS average_speed
from runner_orders
where cancellation is null
group by 1,2
order by 2

--7 What is the successful delivery percentage for each runner?
--(Her bir koşucu için başarılı teslimat yüzdesi nedir?)

--çözüm1
with table1 as 
(
select ro.runner_id,
	   round(avg(order_id),2) as order_count,
	   round(avg(duration::numeric),2) as avg_duration
from runner_orders as ro
where cancellation is null
group by 1
)
select runner_id,
	   round((order_count/avg_duration)*100,2) as succ_perc
from table1 


--çözüm2
SELECT runner_id, 
  round(count(distance)::numeric/ count(runner_id) * 100) AS delivery_percentage
FROM runner_orders
GROUP BY runner_id;


--C. Ingredient Optimisation--

--1 What are the standard ingredients for each pizza?
--(Her pizza için standart malzemeler nelerdir?)

with table1 as 
(
select 
	unnest(string_to_array(toppings,', '))::numeric as recipes_id,
	pr.pizza_id,
	pizza_name
from pizza_recipes as pr
left join pizza_names as pn
ON pn.pizza_id = pr.pizza_id
)
select pizza_name,
	   pt.topping_name		 
from table1 as t1
left join pizza_toppings as pt
ON t1.recipes_id = pt.topping_id
order by pizza_id

--2 What was the most commonly added extra?
--(En sık eklenen ekstra neydi?)

with table1 as 
(
select order_id,
	   unnest(string_to_array(extras,', '))::numeric as extras_id
from customer_orders as co
where extras is not null
)
select count(order_id),
	   pt.topping_name
from table1 as t1
left join pizza_toppings as pt
ON pt.topping_id = t1.extras_id
group by 2
order by 1 desc


--3 What was the most common exclusion?
--(En yaygın kullanılmayan malzeme neydi?)

with table1 as 
(
select order_id,
	   unnest(string_to_array(exclusions, ', '))::numeric as exclusions_id
from customer_orders as co
)
select count(exclusions_id) as count_exclusions,
	   topping_name
from table1 as t1
left join pizza_toppings as pt
ON pt.topping_id = t1.exclusions_id
group by 2
order by 1 desc


/* 5 
Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders 
table and add a 2x in front of any relevant ingredients
for example: "Meat Lovers: 2xBacon, Beef, ... , Salami"

--(customer_orders tablosundan her pizza siparişi için alfabetik olarak sıralanmış 
virgülle ayrılmış bir malzeme listesi oluşturun ve ilgili malzemelerin önüne 2x ekleyin
Örneğin: "Et Sevenler: 2xPastırma, Sığır eti, ... , Salam")*/

with table1 as 
(
select customer_id,
	   order_id,
	   pizza_id,
	   unnest(string_to_array(exclusions, ', '))::numeric as exclusions_id,
	   unnest(string_to_array(extras, ', '))::numeric as extras_id
from customer_orders as co
),
table2 as 
(
	with table22 as
	(
	select pizza_id ,
		   unnest(string_to_array(toppings,', ')) as topping_id
	from pizza_recipes as pr
	)
	select t22.topping_id,
		   pt.topping_name,
		   pizza_id
	from table22 as t22
	left join pizza_toppings as pt
	ON pt.topping_id = t22.topping_id::numeric
)
select DISTINCT
  t1.order_id,
  CASE
    WHEN t1.exclusions_id = t2.topping_id::numeric THEN 'Meatlovers - exc '||t1.exclusions_id
    WHEN t1.extras_id = t2.topping_id::numeric THEN 'Meatlover - ext 2x '||t1.extras_id
	else 'non exc or ext'
  END AS topping_segment
from table1 as t1
left join table2 as t2
ON t1.pizza_id = t2.pizza_id
where t1.pizza_id = 1
order by order_id


-- D. Pricing and Ratings--

/* 1 
If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money 
has Pizza Runner made so far if there are no delivery fees?
--(Eğer bir Et Severler pizzası 12$ ve Vejetaryen 10$ ise ve değişiklik için ücret alınmıyorsa - 
Pizza Runner teslimat ücreti olmadan şimdiye kadar ne kadar para kazanmıştır?)*/

with meatlovers as
		(
select 
	 count(co.order_id) as order_count
from customer_orders as co
left join runner_orders as ro
ON ro.order_id = co.order_id
where pizza_id = 1 and cancellation is null
		),
vegetarian as 
		(
select 
	count(co.order_id) as order_count
from customer_orders as co
left join runner_orders as ro
ON ro.order_id = co.order_id
where pizza_id = 2 and cancellation is null
		)
select concat((m.order_count*12+v.order_count*10),'$') as total_cost
from meatlovers as m
cross join vegetarian as v


/* 2
What if there was an additional $1 charge for any pizza extras?
Add cheese is $1 extra
--(Herhangi bir pizza ekstrası için 1 dolar ek ücret alınsa nasıl olur?
Peynir eklemek ekstra 1 dolar)*/

with t1 as 
(
    select *,
           length(extras) - length(replace(extras, ',', '')) + 1 as topping_count
    from customer_orders
    inner join pizza_names using (pizza_id)
    inner join runner_orders using (order_id)
    where cancellation is null
    order by order_id
),

t2 as 
(
select sum(case when pizza_id = 1 then 12 else 10 end) as pizza_revenue,
       sum(topping_count) as topping_revenue
from t1
)
select concat('$', topping_revenue + pizza_revenue) as total_revenue
from t2;

/* 3
The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, 
how would you design an additional table for this new dataset - generate a schema for this new table and insert 
your own data for ratings for each successful customer order between 1 to 5.
--(Pizza Runner ekibi şimdi müşterilerin koşucularını derecelendirmelerine olanak tanıyan ek bir derecelendirme 
sistemi eklemek istiyor, bu yeni veri kümesi için ek bir tabloyu nasıl tasarlarsınız - bu yeni tablo için bir 
şema oluşturun ve her başarılı müşteri siparişi için 1 ila 5 arasında derecelendirmeler için kendi verilerinizi ekleyin.)*/



CREATE TABLE runner_rating (order_id INTEGER, 
							rating INTEGER, 
							review TEXT)
-- rating point 1-5
-- Order 6 and 9 were cancelled
INSERT INTO runner_rating
VALUES ('1', '1'),
       ('2', '1'),
       ('3', '4'),
       ('4', '1'),
       ('5', '2'),
       ('7', '5'),
       ('8', '2'),
       ('10', '5')

select * from runner_rating


/* 4 Using your newly generated table - can you join all of the information together to 
form a table which has the following information for successful deliveries?
customer_id
order_id
runner_id
rating
order_time
pickup_time
Time between order and pickup
Delivery duration
Average speed
Total number of pizzas
--(Yeni oluşturduğunuz tabloyu kullanarak - başarılı teslimatlar için aşağıdaki bilgileri içeren bir tablo oluşturmak üzere tüm bilgileri birleştirebilir misiniz?
müşteri_id order_id runner_id derecelendirme order_time teslim alma_zamanı Sipariş ile teslim alma arasındaki süre Teslimat süresi
Ortalama hız Toplam pizza sayısı)*/


select
		co.customer_id,
		co.order_id,
		ro.order_id,
		rr.rating,
		co.order_time,
		ro.pickup_time,
	    EXTRACT(minute FROM AGE(ro.pickup_time::timestamp, co.order_time::timestamp))::numeric AS delivery_duration,
		ro.duration,
		round(ro.distance::numeric*60/ro.duration::numeric,2) as avg_speed,
		count(co.order_id) as order_count
from customer_orders as co
left join pizza_names as pn
ON pn.pizza_id= co.pizza_id
left join runner_orders as ro
ON ro.order_id = co.order_id
left join runner_rating as rr
ON rr.order_id = ro.order_id
where ro.cancellation is null
group by 1,2,3,4,5,6,7,8,9
order by customer_id


/* 5 
If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner 
is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?
--(Eğer Et Severler için pizza 12$ ve Vejetaryen için 10$ sabit fiyatlıysa ve her bir koşucuya kat edilen kilometre 
başına 0,30$ ödeniyorsa - Pizza Runner'ın bu teslimatlardan sonra ne kadar parası kalır?)*/

with table1 as 
(
select  sum(case 
		when pizza_id = 1 then 12 else 10 end) as total_cost,
		round(sum(distance::numeric)*0.30,2) as sum_distance
from customer_orders as co
left join runner_orders as ro
ON ro.order_id = co.order_id
where cancellation is null
)
select total_cost-sum_distance as runner_orders_cost
from table1 



