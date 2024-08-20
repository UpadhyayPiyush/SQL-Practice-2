select * from sales;
select amount,customers from sales;
select * from sales;
select * from sales where amount > 10000;
select * from sales where amount >20000 order by amount DESC LIMIT 5;
select SaleDate, Amount, Boxes, weekday(SaleDate) as 'day of week' from sales where weekday(SaleDate) = 4;

select * from people;
select * from people where Team='Delish' or Team='Jucies';
select * from people where Team In('Delish' , 'Jucies');  
select * from people where Salesperson like 'b%';

show tables;
desc sales;

select SaleDate, Amount,
		case when amount <1000 then 'under 1k'
			 when amount <5000 then 'under 5k'
             when amount <10000 then 'under 10k'
			else '10k or more'
            end as 'Amount Category'
 from sales;

/*Print details of shipments (sales) where amounts are > 2,000 and boxes are <100?*/
select * from sales where amount > 2000 and boxes <100;

/*top 5 shipments (sales) each of the sales persons had in the month of January 2022?*/
select p.Salesperson, count(*) as 'shipment'
from sales s
join people p on p.spid=s.spid
where SaleDate between '2022-01-01' and '2022-01-31'
group by p.Salesperson
order by shipment desc
Limit 5;

/*Which product sells more boxes? Milk Bars or Eclairs?*/
select pr.Product, sum(s.Boxes) as TotalBoxes 
from sales s
join products pr on pr.pid=s.pid
where pr.Product in ('Milk bars','Eclairs')
group by pr.Product 
order by totalboxes desc;

/*Which product sold more boxes in the first 7 days of February 2022? Milk Bars or Eclairs?*/
select pr.Product, sum(s.Boxes) as TotalBoxes
from sales s
join products pr on pr.pid=s.pid
where  pr.Product in ('Milk bars','Eclairs') and s.SaleDate between '2022-02-01' and '2022-02-07'
group by pr.Product
order by totalboxes desc;

/*(wrong)Which shipments had under 100 customers & under 100 boxes? Did any of them occur on Wednesday?*/
select * from sales
where customers < 100 and boxes < 100;

select *,
case when weekday(saledate)=2 then ‘Wednesday’
else ”
end as ‘Shipment’
from sales
where customers < 100 and boxes < 100;

/*What are the names of salespersons who had at least one shipment (sale) in the first 7 days of January 2022?*/
SELECT DISTINCT p.Salesperson
FROM sales s
JOIN people p ON p.spid = s.SPID
WHERE s.SaleDate BETWEEN '2022-01-01' AND '2022-01-07';

/*Which salespersons did not make any shipments in the first 7 days of January 2022?*/
SELECT p.salesperson
FROM people p
WHERE p.spid NOT IN 
(SELECT DISTINCT s.spid FROM sales s WHERE s.SaleDate BETWEEN '2022-01-01' AND '2022-01-07');

/*How many times we shipped more than 1,000 boxes in each month?*/
select year(saledate) 'Year', month(saledate) 'Month', count(*) 'Times we shipped 1k boxes'
from sales
where boxes>1000
group by year(saledate), month(saledate)
order by year(saledate), month(saledate);

/*(wrong)Did we ship at least one box of ‘After Nines’ to ‘New Zealand’ on all the months?*/
set @product_name = 'After Nines';
set @country_name = 'New Zealand';

select year(saledate) 'Year', month(saledate) 'Month',
if(sum(boxes)>1, 'Yes','No') 'Status'
from sales s
join products pr on pr.PID = s.PID
join geo g on g.GeoID=s.GeoID
where pr.Product = @product_name and g.Geo = @country_name
group by year(saledate), month(saledate)
order by year(saledate), month(saledate);

/*— India or Australia? Who buys more chocolate boxes on a monthly basis?*/
select year(saledate) 'Year', month(saledate) 'Month',
sum(CASE WHEN g.geo='India' = 1 THEN boxes ELSE 0 END) 'India Boxes',
sum(CASE WHEN g.geo='Australia' = 1 THEN boxes ELSE 0 END) 'Australia Boxes'
from sales s
join geo g on g.GeoID=s.GeoID
group by year(saledate), month(saledate)
order by year(saledate), month(saledate);