
-- 1.Tạo thủ tục thêm mới cho bảng Customer 
use QuanLyBanHang
DELIMITER //
CREATE PROCEDURE add_new_c( IN name VARCHAR(255), IN age INT)
BEGIN
insert into Customer(name,cAge) values
(name,age);
END //
DELIMITER ;
call add_new_c('linh linh',30);
call add_new_c('hung',30);
call add_new_c('yen',30);

-- 2. Tạo thủ tục sửa của bảng customer 
DELIMITER //
CREATE PROCEDURE update_c( IN id int, IN cname VARCHAR(255), IN cage INT)
BEGIN

UPDATE Customer
SET cname = name, cAge = cage
WHERE cID = id;

END //
DELIMITER ;
call update_c(4, 'huong', 30);

-- 3. Tạo thủ tục xóa bảng customer id 
DELIMITER //
CREATE PROCEDURE delete_c(IN id int)
BEGIN
DELETE FROM Customer WHERE cID=id;
END //
DELIMITER ;
call delete_c(4);
-- 4. Tạo thủ tục lấy danh sách đơn hàng id,ten_kh,order_date,total_price 
DELIMITER //
CREATE PROCEDURE show_all_order()
BEGIN
select Orders.oID, Customer.name,Orders.oDate,Orders.oTotalPrice from Orders 
join Customer using(cID);
END //
DELIMITER ;
call show_all_order();

-- 5. Tạo thủ tục phân trang customer() 
-- . (truyền vào số trạng hiện tại và số limit) trả về danh sách tương ứng (Limit offset)
DELIMITER //
CREATE PROCEDURE pagination(IN current_page INT, IN page_size INT)
BEGIN
    DECLARE page_start INT;
    SET page_start = (current_page - 1) * page_size;
    SELECT * FROM Customer 
    LIMIT page_start, page_size;
END //
DELIMITER ;
call pagination(2,3);