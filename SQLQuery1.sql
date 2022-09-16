use dastgyr;
GO

create table Users(
users_id int null,
name VARCHAR(50),
gender VARCHAR(20),
is_active VARCHAR(20),
is_verify VARCHAR(20),
created_at VARCHAR(40),
refer_by VARCHAR(50),
refer_at VARCHAR(50),
ref_code VARCHAR(40)
);

BULK INSERT Users
FROM 'E:\Dastgyr\Data\Users.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n'
)
GO

select * from users;


create table Orders(
id int not null,
users_id int null,
orderNo VARCHAR(40),
InvoiceNo VARCHAR(40),
note VARCHAR(40),
status int,
created_At VARCHAR(40),
wallet_ID VARCHAR(40),
created_By VARCHAR(40),
coupon_ID VARCHAR(40)
);

BULK INSERT Orders
FROM 'E:\Dastgyr\Data\Orders.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n'
)
GO

select * from Orders;

select COUNT(*) AS [Total Records] from Users;

select COUNT(refer_by) AS [Total Refer Code on Order booking] from Users;

select COUNT(*) - 8566 AS [Users Onboarding Refer Code Count] from Users;
select * from Orders;

CREATE VIEW Orderbooking 
AS 
	SELECT Users.users_id, Users.name, Users.created_at, Users.refer_by, Users.refer_at, Users.ref_code
FROM Orders
INNER JOIN Users
ON Users.users_id = Orders.users_id;
GO

CREATE VIEW OrderGroup 
AS 
select *, ntile(5) over(order by users_id) AS [GroupNo] from Orderbooking;

select * from OrderGroup;


SELECT refer_by, count(refer_by) AS [COUNT], avg(GroupNo) as GroupNo
FROM OrderGroup
GROUP BY refer_by
ORDER BY GroupNo DESC;



create table CancellationReasonList(
order_id int not null, 
cancellation_reason_id int, 
cancel_reason_text VARCHAR(100),
);

BULK INSERT CancellationReasonList
FROM 'E:\Dastgyr\Data\Cancellation_Reasons_List.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n'
)
GO

select * from CancellationReasonList;

SELECT cancel_reason_text, count(cancel_reason_text) AS [COUNT]
FROM CancellationReasonList
Group BY cancel_reason_text
ORDER BY [COUNT]  DESC;

select COUNT(*) AS [Total Cancelled Order] from Orders where status = 6;

create table SKU(
ID int not null, 
ProductID int, 
Price int,
Discount float,
Stock int, 
IsActive VARCHAR(40), 
IsStock VARCHAR(40), 
Weight VARCHAR(40), 
Unit VARCHAR(40), 
AllTypes VARCHAR(40), 
IsDeal VARCHAR(40)
);

BULK INSERT SKU
FROM 'E:\Dastgyr\Data\SKU.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n'
)
GO




create table ProductCategories(
CategoryID int not null, 
ProductID int, 
);

BULK INSERT ProductCategories
FROM 'E:\Dastgyr\Data\ProductCategories.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n'
)
GO

select * from ProductCategories;

select * from SKU;

Create View SKUProducts
AS
SELECT SKU.ID, SKU.ProductID, SKU.Price, SKU.Discount, SKU.Stock, ProductCategories.CategoryID
FROM SKU
INNER JOIN ProductCategories
ON SKU.ProductID = ProductCategories.ProductID;
GO

select ID, ProductID, CategoryID, stock from SKUProducts
ORDER BY Stock;

