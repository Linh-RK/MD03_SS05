-- 1.Tạo store procedure hiển thị ra danh sách môn học có điểm thi là 10
DELIMITER //
CREATE PROCEDURE subject_10()
BEGIN
select * from subject
where subject.subjectId in (
select mark.subject_id from mark 
where mark = 10
);
END //
DELIMITER ;

call subject_10();

-- 2.Tạo store procedure hiển thị thông tin các lớp học có học sinh đạt điểm 10
delimiter //
create procedure nameX ()
begin

select * from class
where classId in (
select class.classId from student 
join class on class.classId = student.class_id
where studentId in (
select mark.student_id from mark 
where mark = 10
)
);
end //
delimiter;

-- 3.Tạo store procedure thêm mới student và trả ra id vừa mới thêm
delimiter //
create procedure add_new_student (IN studentName_new VARCHAR(100),IN address_new VARCHAR(100),IN phone_new VARCHAR(11),IN class_id_new int,IN status_new bit(1), OUT new_id int)
begin
insert into student(studentName,address,phone,class_id,status) 
values (studentName_new,address_new,phone_new,class_id_new,status_new);
set new_id = last_insert_id();
END //
DELIMITER ;
select * from student;
call add_new_student('linh linh','thai binh','0987654321',3,1, @new_id);
select @new_id;
-- 4.Tạo store procedure hiển thị subject chưa được ai thi
DELIMITER //
CREATE PROCEDURE subject_no_mark()
BEGIN
select * from subject
where subject.subjectId  not in
(select DISTINCT subject_id from mark);
END //
DELIMITER ;
call subject_no_mark()
-- Tạo store procedure hiển thị student chưa thi
DELIMITER //
CREATE PROCEDURE student_no_mark()
BEGIN
select * from student
where student.studentId  not in
(select student_id from mark);
END //
DELIMITER ;
call student_no_mark()