-- 1.Tạo store procedure hiển thị tất cả thông tin account mà đã tạo ra 5 đơn hàng trở lên
CREATE VIEW acc_bill AS
SELECT 
    accounts.id, 
    accounts.username, 
    COUNT(bill.acc_id) AS bill_count
FROM accounts
RIGHT JOIN bill ON bill.acc_id = accounts.id
GROUP BY accounts.id, accounts.username;

DELIMITER //
CREATE PROCEDURE display_min_order2()
BEGIN
select * from accounts
where accounts.id in (
select acc_bill.id from acc_bill
where acc_bill.bill_count >=2);
END //
DELIMITER ;

call display_min_order2();


-- 2.Tạo store procedure hiển thị top 2 sản phẩm được bán nhiều nhất

create view bill_detail_pro as 
select * from bill_detail
left join product on product.id = bill_detail.product_id;


DELIMITER //
CREATE PROCEDURE best_sale()
BEGIN
select product.id, product.name as product, sum(quantity) as total_sale  from bill_detail
left join product on product.id = bill_detail.product_id
group by bill_detail.product_id
order by total_sale desc limit 2;
END //
DELIMITER ;

call best_sale();


-- 3.Tạo store procedure thêm tài khoản
DELIMITER //
CREATE PROCEDURE add_acc(IN userName_new VARCHAR(100), IN password_new VARCHAR(10), IN address_new VARCHAR(100), IN status_new BIT(1))
BEGIN
insert into accounts(userName,password,address,status) values
(userName_new,password_new,address_new,status_new);
END //
DELIMITER ;

call add_acc('linh','123456','TB',1);
call add_acc('huong','123456','HN',1);
call add_acc('hung','123456','BN',1);
call add_acc('yen','123456','HN',1);
call add_acc('tac','123456','TB',1);


-- 4.Tạo store procedure truyền vào bill_id và sẽ hiển thị tất cả bill_detail của bill_id đó

DELIMITER //
CREATE PROCEDURE show_bill_detail_byID( IN id int)
BEGIN
select * from bill_detail
where bill_detail.bill_id = id;
END //
DELIMITER ;

call show_bill_detail_byID(1);


-- 5.Tạo ra store procedure thêm mới bill và trả về bill_id vừa mới tạo
create view list_old_id as
select bill.id from bill;

DELIMITER //
CREATE PROCEDURE add_new_bill_return_id( IN bill_type_new bit(1),IN acc_id_new int , IN created_new DATETIME,IN auth_date_new DATETIME, OUT new_id INT)
BEGIN
insert into bill(bill_type,acc_id,created,auth_date) 
values
(bill_type_new,acc_id_new,created_new,auth_date_new);

set new_id = last_insert_id();
END //
DELIMITER ;
-- ket qua thieu mat id 5 ma tang len 6 luon ??
CALL add_new_bill_return_id(1, 5, '2024-09-23 10:00:00', '2024-09-24 12:00:00', @new_id);
CALL add_new_bill_return_id(1, 4, '2024-09-23 10:00:00', '2024-09-24 12:00:00', @new_id);
CALL add_new_bill_return_id(1, 3, '2024-09-23 10:00:00', '2024-09-24 12:00:00', @new_id);
SELECT @new_id;

-- 6.Tạo store procedure hiển thị tất cả sản phẩm đã được bán trên 5 sản phẩm

create view pro_sale_g5 as
select product_id,sum(quantity) as sale from bill_detail
group by product_id
having sale >5;

DELIMITER //
CREATE PROCEDURE sale_g5()
BEGIN
select * from product
where product.id in (
select product_id from bill_detail
where product_id in (
select product_id from pro_sale_g5
)
);
END //
DELIMITER ;

call sale_g5();