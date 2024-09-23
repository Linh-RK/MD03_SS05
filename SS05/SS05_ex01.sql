
-- Bài toán đưa ra sẽ chúng ta sẽ quản lý hệ thống bán hàng
-- Yêu cầu chức năng:
-- 1.Tạo view hiển thị tất cả customer
use QuanLyBanHang;
create view display_all_cus as
select * from Customer;

-- 2.Tạo view hiển thị tất cả order có oTotalPrice trên 150000
use QuanLyBanHang;
create view display_order_g15 as
select * from Orders
where Orders.oTotalPrice> 150000;

-- 3.Đánh index cho bảng customer ở cột cName
create index index_cus_name 
on Customer(name);

-- 4.Đánh index cho bảng product ở cột pName
create index index_product_name 
on Product(pName);

-- 5.Tạo store procedure hiển thị ra đơn hàng có tổng tiền bé nhất
DELIMITER //
CREATE PROCEDURE display_min_order1()
BEGIN
select * from Orders 
order by oTotalPrice limit 1;-- chỉ ra đc 1 kq thôi. thiếu các trường hợp tổng tiền giống nhau
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE display_min_order2()
BEGIN
select * from Orders 
where oTotalPrice = (
select Min(oTotalPrice) from Orders
);
END //
DELIMITER ;

call display_min_order1();
call display_min_order2();

-- 6.Tạo store procedure hiển thị người dùng nào mua sản phẩm “May Giat” ít nhất

create view cus_bought_p as
select c.name,p.pName, sum(odQTY) as total_qty from OrderDetail
left join Product p using(pID)
left join Orders o using(oID)
left join Customer c using(cID)
where p.pName = 'May Giat'
group by c.cID;

DELIMITER //
CREATE PROCEDURE display_min_order()
BEGIN
select *from cus_bought_p
where total_qty =(
select min(total_qty) from cus_bought_p
);
END //
DELIMITER ;

call display_min_order();