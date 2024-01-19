create table sales(
	Sale_ID int ,
	Data_venda date,
	Store_ID int,
	Product_ID int,
	Units int,
primary key (Product_ID,Sale_ID,Store_ID),
foreign key (Product_ID) references products(Product_ID),
foreign key (Store_ID) references stores(Store_ID)
);

create table products(
	Product_ID int primary key,
	Product_Name varchar(255),
	Product_Category varchar(255),
	Product_Cost varchar(255),
	Product_Price varchar(255)
);

create table stores(
	Store_ID int primary key,
	Store_Name varchar(255),
	Store_City varchar(255),
	Store_Location varchar(255),
	Store_Open_Location Date
);

create table inventory(
	Store_ID int,
	Product_ID int ,
	Stock_On_Hand int,
primary key(Store_ID,Product_ID),
foreign key(Store_ID) references stores(Store_ID),
foreign key(Product_ID) references products(Product_ID)
);


select * from sales
select * from products
select * from stores
select * from inventory


--mudando as colunas de varchar para numeric

alter table products
alter column Product_Cost type numeric
using(trim(both '$' From Product_Cost)::numeric);

alter table products
alter column Product_Price type numeric
using(trim(both '$' From Product_Price)::numeric);

--os 5 produtos mais rentáveis
select Product_Name,Product_Category, Product_Price - Product_Cost as lucro_produto
from products
order by lucro_produto desc
limit 5

--Total de vendas por loja
select stores.Store_Name, products.Product_Category, SUM(sales.units * products.Product_Price) as total_vendas
from stores
cross join products
left join sales on stores.Store_ID = sales.Store_ID and products.Product_ID = sales.Product_ID
group by stores.Store_Name,products.Product_Category
order by total_vendas desc

--Produtos em falta e a loja onde o produto está em falta
select products.Product_ID,products.Product_Name ,stores.Store_Name
from products
left join inventory on products.Product_ID = inventory.Product_ID
join stores on inventory.Store_ID = stores.Store_ID
where coalesce(inventory.Stock_On_Hand,0) = 0

--Os 10 produtos que mais venderam, o dinheiro ganho e o nome da loja  
select stores.Store_ID,Store_Name,products.Product_ID,products.Product_Name,
sum(sales.Units) as Total_vendas,
sum(sales.Units * products.Product_Price) as dinheiro_ganho
from sales
join products on products.Product_ID = sales.Product_ID
join stores on stores.Store_ID = sales.Store_ID
group by products.Product_ID,products.Product_Name,stores.Store_ID
order by  Total_vendas desc
Limit  10;
