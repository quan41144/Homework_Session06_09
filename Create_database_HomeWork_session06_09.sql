-- Create database Homework_session06_09
create database Homework_session06_09;
-- Create table product
create table product(
	id serial primary key,
	name varchar(100),
	category varchar(50),
	price numeric(10,2)
);
-- Create table OrderDetail
create table orderdetail(
	id serial primary key,
	order_id int,
	product_id int,
	quantity int
);
insert into product(name, category, price) values
    ('iPhone 15 Pro', 'Điện thoại', 28000000.00),
    ('Samsung Galaxy S24', 'Điện thoại', 20000000.00),
    ('Macbook Air M2', 'Laptop', 25000000.00),
    ('Dell XPS 13', 'Laptop', 30000000.00),
    ('Chuột Logitech MX', 'Phụ kiện', 1500000.00),
    ('Bàn phím cơ Keychron', 'Phụ kiện', 2000000.00),
    ('Màn hình LG 27inch', 'Màn hình', 5000000.00),
    ('Tai nghe Sony WH', 'Phụ kiện', 6000000.00),
    ('Sạc dự phòng Anker', 'Phụ kiện', 800000.00),
    ('Loa Bluetooth JBL', 'Loa', 2500000.00);
insert into orderdetail (order_id, product_id, quantity) values
    (1, 1, 1),
    (1, 5, 2),
    (2, 3, 1),
    (3, 9, 5),
    (4, 4, 2),
    (4, 10, 1),
    (5, 5, 1),
    (6, 2, 1),
    (6, 8, 1),
    (7, 6, 3);
select * from product;
select * from orderdetail;
-- Tính tổng doanh thu từng sản phẩm, hiển thị product_name, total_sales (SUM(price * quantity))
select p.name as product_name, sum(p.price * od.quantity) as total_sales
from product p join orderdetail od on p.id = od.product_id
group by p.id, p.name;

-- Tính doanh thu trung bình theo từng loại sản phẩm (GROUP BY category)
select p.category as category_name, avg(p.price * od.quantity) as avg_total_sales
from product p join orderdetail od on p.id = od.product_id
group by p.category;

-- Chỉ hiển thị các loại sản phẩm có doanh thu trung bình > 20 triệu (HAVING)
select p.category as category_name, avg(p.price * od.quantity) as avg_total_sales
from product p join orderdetail od on p.id = od.product_id
group by p.category
having avg(p.price * od.quantity) > 20000000;

-- Hiển thị tên sản phẩm có doanh thu cao hơn doanh thu trung bình toàn bộ sản phẩm 
select p.name, sum(p.price * od.quantity) as avg_total_sales
from product p join orderdetail od on p.id = od.product_id
group by p.id, p.name
having sum(p.price * od.quantity) > (
	select avg(sum_total)
	from (
		select sum(p2.price * od2.quantity) as sum_total
		from product p2 join orderdetail od2 on p2.id = od2.product_id
		group by p2.id
	) as sub_table
);

-- Liệt kê toàn bộ sản phẩm và số lượng bán được (nếu có) – kể cả sản phẩm chưa có đơn hàng 
select p.name as product_name, coalesce(sum(od.quantity), 0) as total_quantity
from product p left join orderdetail od on p.id = od.product_id
group by p.id, p.name;