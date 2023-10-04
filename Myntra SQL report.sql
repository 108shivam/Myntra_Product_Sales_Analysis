show databases;
create database myntra;
use myntra;
select * from fashion; 
drop table fashion;

-- total products in each brand
select brand_tag, count(product_name) products from fashion group by brand_tag order by products desc;

-- Average rating of brands (non_zeros)
select brand_tag as Brands, round(avg(rating),2) rating from fashion where rating != 0.0 group by brand_tag order by rating desc;

-- Top most expensive products based on marked_price
select * from fashion where marked_price = (select max(marked_price) from fashion);

-- Top most expensive product based on selling price (discounted_price)
select * from fashion where discounted_price = (select max(discounted_price) from fashion);

-- Top discounted products of each brand
with discrank as (select distinct upper(brand_name) as Brand, upper(product_tag) as Product, marked_price as MRP, discounted_price as SP, 
discount_percent as 'Flat Discount%', upper(State) as State, row_number() over(partition by brand_name) as brand_rank
 from fashion
order by discount_percent desc)
select Brand,Product, MRP, SP, `Flat Discount%`, State from discrank where brand_rank = 1;

-- total brands and avg discount% given in respect of state
select State, count(brand_name) as Brands, round(avg(discount_percent),2) as 'Discount%' from fashion group by state order by brands desc;

-- which brand is giving the highest discount on their products
select distinct brand_tag as brands, round(avg(discount_percent),2) as 'Discount%'
from fashion group by brands order by round(avg(discount_percent),2) desc;

-- 10 brands giving least discount
select distinct brand_tag as brands, round(avg(discount_percent),2) as 'Discount%'
from fashion where discount_percent != 0 group by brands order by round(avg(discount_percent),2) limit 10;

-- Most expensive brand of each state
with BrandRank as (
select upper(State) as State, upper(brand_tag) as Brands, discounted_price as 'Selling Price', row_number() over(partition by State) as brand_rank 
from fashion )
select State, Brands, `Selling Price`, brand_rank from BrandRank where Brand_rank = 1 order by `Selling Price` desc;

-- Total products in each brand
select brand_tag as Brands, product_tag as Products, count(Product_tag) as Total_items 
from fashion 
group by Products, Brands 
order by Products, total_items desc;

-- Highest rating product
select product_tag as Product, round(avg(rating),2) as Rating  from fashion where rating != 0 group by Product order by Rating desc;

