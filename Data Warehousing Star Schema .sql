---------------------------------------
--Data Warehousing Assignment 1
--My Northwind's DW Script File
--Student ID:   #######
--Student Name: MyName MySurname
------------------------------------

print '***************************************************************'
print '****** Section 1: Creating DW Tables'
print '***************************************************************'
print 'Drop all DW tables (except dimTime)'
--Add drop statements below...
--DO NOT DROP dimTime table as you must have used Script provided on the Moodle to create it
DROP TABLE factOrders;
DROP TABLE dimCustomers;
DROP TABLE dimProducts;
DROP TABLE dimSuppliers;

print 'Creating ALL dimension tables'
--Add statements below... IMPORTANT! A Primary key is a surrogate key and MUST BE auto-increment 
CREATE TABLE dimCustomers
(
CustomerKey int IDENTITY(1,1) PRIMARY KEY,

CustomerID	Nchar(5) 	not null,
CompanyName	Nvarchar(40),
contactName	Nvarchar(30),	
ContactTitle	Nvarchar(30),	
Address	Nvarchar(60),		
City	Nvarchar(15),				
Region	Nvarchar(15),			
PostalCode	Nvarchar(10),		
Country	Nvarchar(15),		
Phone	Nvarchar(24),			
Fax	Nvarchar(24)				
);

print 'Creating dimProducts table'


CREATE TABLE dimProducts
(
ProductKey	int IDENTITY(1,1) PRIMARY KEY,

ProductID	Int 	not null,
ProductName	nvarchar(40)	not null,
QuantityPerUnit	nvarchar(20)	not null,
UnitPrice	Money,
UnitsInStock	smallint,	
UnitsOnOrder	Smallint,	
ReorderLevel	Smallint,	
Discontinued	Bit	 not null,
CategoryName 	nvarchar(15) not null,
Description	ntext,
Picture	Image,
);

print 'Creating dimSuppliers table'

CREATE TABLE dimSuppliers
(
SupplierKey Int IDENTITY(1,1) PRIMARY KEY,
SupplierID	int,
CompanyName	nvarchar(40)	not null,
ContactName	nvarchar(30),	
ContactTitle	nvarchar(30),	
Address	nvarchar(60),	
City	nvarchar(15),	
Region	nvarchar(15),	
PostalCode	nvarchar(10),	
Country	nvarchar(15),	
Phone	nvarchar(24),	
Fax	nvarchar(24),	
HomePage	ntext,
);




print 'Creating a fact table'
--Add statements below... IMPORTANT! A Primary key is a composite PRIMARY KEY and is NOT auto-increment!!
--Also make sure that you have correct FOREIGN KEYS!!

CREATE TABLE factOrders
(
ProductKey	Int	Foreign Key references dimProducts(ProductKey),
CustomerKey	Int	 Foreign Key references dimCustomers(CustomerKey),
SupplierKey Int Foreign Key references dimSuppliers(SupplierKey),
OrderDateKey	Int	 Foreign Key references dimTime(TimeKey),
RequiredDateKey Int	 Foreign Key references dimTime(TimeKey),
ShippedDateKey Int Foreign Key References dimTime(timeKey),

OrderID		 int not null,
UnitPrice	Money	Not null,
Qty	smallint	not null,
Discount	real	not null,
TotalPrice	Money	not null,
ShipperCompany nvarchar(40),
ShipperPhone nvarchar(40),
primary key(ProductKey,CustomerKey,OrderDateKey,SupplierKey)
);


print '***************************************************************'
print '****** Section 2: Populate DW Dimension Tables (except dimTime)'
print '***************************************************************'
print 'Populating ALL dimension tables from northwind3 and northwind4'
--Add statements below... 


--Populate dimCustomers northwind 3
MERGE INTO dimCustomers dc
USING
(
SELECT * FROM northwind3.dbo.Customers
) c ON (dc.CustomerID = c.CustomerID) -- Assume CustomerID is unique
WHEN MATCHED THEN -- if CustomerID matched, do nothing
UPDATE SET dc.CompanyName = c.CompanyName -- Dummy update
WHEN NOT MATCHED THEN -- Otherwise, insert a new customer
INSERT(CustomerID, CompanyName, ContactName, ContactTitle, Address,
City, Region, PostalCode, Country, Phone, Fax)
VALUES(c.CustomerID, c.CompanyName, c.ContactName, c.ContactTitle,
c.Address, c.City, C.Region, c.PostalCode, c.Country, c.Phone,
c.Fax);

--Populate dimCustomers northwind 4
MERGE INTO dimCustomers dc
USING
(
SELECT * FROM northwind4.dbo.Customers
) c ON (dc.CustomerID = c.CustomerID) -- Assume CustomerID is unique
WHEN MATCHED THEN -- if CustomerID matched, do nothing
UPDATE SET dc.CompanyName = c.CompanyName -- Dummy update
WHEN NOT MATCHED THEN -- Otherwise, insert a new customer
INSERT(CustomerID, CompanyName, ContactName, ContactTitle, Address,
City, Region, PostalCode, Country, Phone, Fax)
VALUES(c.CustomerID, c.CompanyName, c.ContactName, c.ContactTitle,
c.Address, c.City, C.Region, c.PostalCode, c.Country, c.Phone,
c.Fax);



print 'Populating dimProducts from northwind3'
--Add statements below... 
MERGE INTO dimProducts dp
USING
(
SELECT ProductID, ProductName,QuantityPerUnit,UnitPrice,
UnitsInStock,UnitsOnOrder,ReorderLevel,Discontinued,
CategoryName,Description,Picture
FROM northwind3.dbo.Products p1, northwind3.dbo.Categories c1
WHERE p1.CategoryID=c1.CategoryID
) pc ON (dp.ProductID = pc.ProductID) -- Assume ProductID is unique
WHEN MATCHED THEN -- if ProductID matched, do nothing
UPDATE SET dp.ProductName = pc.ProductName -- Dummy update
WHEN NOT MATCHED THEN -- Otherwise, insert a new product
INSERT(ProductID, ProductName, QuantityPerUnit, UnitPrice,
UnitsInStock, UnitsOnOrder, ReorderLevel, Discontinued, CategoryName,
Description, Picture)
VALUES(pc.ProductID, pc.ProductName, pc.QuantityPerUnit,
pc.UnitPrice, pc.UnitsInStock, pc.UnitsOnOrder, pc.ReorderLevel,
pc.Discontinued, pc.CategoryName, pc.Description, pc.Picture);

print 'Populating dimProducts from northwind4'
--Add statements below... 
MERGE INTO dimProducts dp
USING
(
SELECT ProductID, ProductName,QuantityPerUnit,UnitPrice,
UnitsInStock,UnitsOnOrder,ReorderLevel,Discontinued,
CategoryName,Description,Picture
FROM northwind4.dbo.Products p1, northwind4.dbo.Categories c1
WHERE p1.CategoryID=c1.CategoryID
) pc ON (dp.ProductID = pc.ProductID) -- Assume ProductID is unique
WHEN MATCHED THEN -- if ProductID matched, do nothing
UPDATE SET dp.ProductName = pc.ProductName -- Dummy update
WHEN NOT MATCHED THEN -- Otherwise, insert a new product
INSERT(ProductID, ProductName, QuantityPerUnit, UnitPrice,
UnitsInStock, UnitsOnOrder, ReorderLevel, Discontinued, CategoryName,
Description, Picture)
VALUES(pc.ProductID, pc.ProductName, pc.QuantityPerUnit,
pc.UnitPrice, pc.UnitsInStock, pc.UnitsOnOrder, pc.ReorderLevel,
pc.Discontinued, pc.CategoryName, pc.Description, pc.Picture);

print 'Populating dimSuppliers from northwind3'
--Add statements below... 

MERGE INTO dimSuppliers ds
USING
(
SELECT *
FROM northwind3.dbo.Suppliers 
) s ON (ds.SupplierID = s.SupplierID) -- Assume SupplierID is unique
WHEN MATCHED THEN
UPDATE SET ds.CompanyName = s.CompanyName --check the dummy one
WHEN NOT MATCHED THEN --OTHER wise
INSERT(SupplierID,CompanyName,ContactName,ContactTitle,Address,
City,Region,PostalCode,Country,Phone,Fax,HomePage)
VALUES (s.SupplierID,s.CompanyName,s.ContactName,s.ContactTitle,s.Address,
s.City,s.Region,s.PostalCode,s.Country,s.Phone,s.Fax,s.HomePage);


print 'Populating dimSuppliers from northwind4'

MERGE INTO dimSuppliers ds
USING
(
SELECT *
FROM northwind4.dbo.Suppliers 
) s ON (ds.SupplierID = s.SupplierID) -- Assume SupplierID is unique
WHEN MATCHED THEN
UPDATE SET ds.CompanyName = s.CompanyName --check the dummy one
WHEN NOT MATCHED THEN --OTHER wise
INSERT(SupplierID,CompanyName,ContactName,ContactTitle,Address,
City,Region,PostalCode,Country,Phone,Fax,HomePage)
VALUES (s.SupplierID,s.CompanyName,s.ContactName,s.ContactTitle,s.Address,
s.City,s.Region,s.PostalCode,s.Country,s.Phone,s.Fax,s.HomePage);




print '***************************************************************'
print '****** Section 3: Populate DW Fact Table'
print '***************************************************************'
print 'Populating factOrders from northwind3 and northwind4'
--Add statements below... 


-- Populating factTable from northwind 3
--What we need to add extra are the columns into the DW:
--CompanyName and Phone from Shippers TABLE
--ShippedDate
--How do we get that data?
--ELT
--ALL KEYS, ORDERID, UNITPRICE,QTY, DISCOUNT, TOTALPRICE, SHIPPERCOMPANY, SHIPPERPHONE, times
--From these tables
--ORDER , SHIPPER , ORDER DETAILS , DIMCUSTOMERS ,DIMPRODUCTS, TIMETABLES, dimSuppliers


MERGE INTO factOrders fo
USING
(
SELECT ProductKey, CustomerKey, SupplierKey, 
dt1.TimeKey as [OrderDatekey], -- from dimTime
dt2.TimeKey as [RequiredDatekey], -- from dimTime 
dt3.TimeKey as [ShippedDatekey], --from dimTime
o.OrderID as	[OrderID], -- ordertable
od.UnitPrice as [UnitPrice], --orderdetails
Quantity as [Qty], -- orderdetails
Discount, -- orderdetails
od.UnitPrice*od.Quantity as [TotalPrice], -- OrderDetails!
shp.companyName as [ShipperCompany], --SHIPPER table
shp.Phone as [ShipperPhone] -- SHIPPER table
FROM northwind3.dbo.Orders o, 
--order 
northwind3.dbo.[Order Details] od, 
northwind3.dbo.[Shippers] shp,
northwind3.dbo.Suppliers s,
northwind3.dbo.products p,
--orderdetails
dimCustomers dc, 
dimProducts dp, 
dimSuppliers ds,
--time
dimTime dt1, 
dimTime dt2, 
dimTime dt3

--JOIN
WHERE od.OrderID=o.OrderID
--orderID in orderDetails table == orderID in Order Table
AND dp.ProductID=od.ProductID 
--dimProducts.productid == orderdetails.productid
AND od.ProductID = p.ProductID
--suppliers with products
AND p.SupplierID =s.SupplierID
--oderdetails.productID with products.porductID
AND o.CustomerID=dc.CustomerID
--orders.customerID = dimCustomers.customerID
AND s.SupplierID=ds.SupplierID
--Suppliers.supplierID = dimSupplier.SupplierID
AND o.shipVia = shp.shipperID
--orders.shipVia = shipper.shipperID
AND dt1.Date=o.OrderDate -- Each dt1,dt2 needs join!
AND dt2.Date=o.RequiredDate
AND dt3.Date=o.ShippedDate
) o ON (o.ProductKey = fo.ProductKey -- Assume All Keys are unique
AND o.CustomerKey=fo.CustomerKey
AND o.SupplierKey=fo.SupplierKey
AND o.OrderDateKey=fo.OrderDateKey)
--AND o.shippedDate = fo.
--When these conditions are true 
WHEN MATCHED THEN -- if they matched, do nothing
UPDATE SET fo.OrderID = o.OrderID -- Dummy update
WHEN NOT MATCHED THEN -- Otherwise, insert a new row
INSERT(ProductKey, CustomerKey, SupplierKey, OrderDateKey, RequiredDateKey, ShippedDateKey,
OrderID, UnitPrice, Qty, Discount, TotalPrice,ShipperCompany,ShipperPhone)
VALUES(o.ProductKey,o.CustomerKey,o.SupplierKey,o.OrderDateKey,o.RequiredDateKey, o.ShippedDateKey,
o.OrderID,o.UnitPrice,o.Qty,o.Discount, o.TotalPrice, o.ShipperCompany,o.ShipperPhone);



print 'Populating factOrders from northwind4'
--Add statements below... NW4
MERGE INTO factOrders fo
USING
(
SELECT ProductKey, CustomerKey, SupplierKey, 
dt1.TimeKey as [OrderDatekey], -- from dimTime
dt2.TimeKey as [RequiredDatekey], -- from dimTime 
dt3.TimeKey as [ShippedDatekey], --from dimTime
o.OrderID as	[OrderID], -- ordertable
od.UnitPrice as [UnitPrice], --orderdetails
Quantity as [Qty], -- orderdetails
Discount, -- orderdetails
od.UnitPrice*od.discount as [TotalPrice], -- OrderDetails!
shp.companyName as [ShipperCompany], --SHIPPER table
shp.Phone as [ShipperPhone] -- SHIPPER table
FROM northwind4.dbo.Orders o, 
--order 
northwind4.dbo.[Order Details] od, 
northwind4.dbo.[Shippers] shp,
northwind4.dbo.Suppliers s,
northwind4.dbo.products p,
--orderdetails
dimCustomers dc, 
dimProducts dp, 
dimSuppliers ds,
--time
dimTime dt1, 
dimTime dt2, 
dimTime dt3

--JOIN
WHERE od.OrderID=o.OrderID
--orderID in orderDetails table == orderID in Order Table
AND dp.ProductID=od.ProductID 
--dimProducts.productid == orderdetails.productid
AND od.ProductID = p.ProductID
--suppliers with products
AND p.SupplierID =s.SupplierID
--oderdetails.productID with products.porductID
AND o.CustomerID=dc.CustomerID
--orders.customerID = dimCustomers.customerID
AND s.SupplierID=ds.SupplierID
--Suppliers.supplierID = dimSupplier.SupplierID
AND o.shipVia = shp.shipperID
--orders.shipVia = shipper.shipperID
AND dt1.Date=o.OrderDate -- Each dt1,dt2 needs join!
AND dt2.Date=o.RequiredDate
AND dt3.Date=o.ShippedDate
) o ON (o.ProductKey = fo.ProductKey -- Assume All Keys are unique
AND o.CustomerKey=fo.CustomerKey
AND o.SupplierKey=fo.SupplierKey
AND o.OrderDateKey=fo.OrderDateKey)
--AND o.shippedDate = fo.
--When these conditions are true 
WHEN MATCHED THEN -- if they matched, do nothing
UPDATE SET fo.OrderID = o.OrderID -- Dummy update
WHEN NOT MATCHED THEN -- Otherwise, insert a new row
INSERT(ProductKey, CustomerKey, SupplierKey, OrderDateKey, RequiredDateKey, ShippedDateKey,
OrderID, UnitPrice, Qty, Discount, TotalPrice,ShipperCompany,ShipperPhone)
VALUES(o.ProductKey,o.CustomerKey,o.SupplierKey,o.OrderDateKey,o.RequiredDateKey, o.ShippedDateKey,
o.OrderID,o.UnitPrice,o.Qty,o.Discount, o.TotalPrice, o.ShipperCompany,o.ShipperPhone);






print '***************************************************************'
print '****** Section 4: Counting rows of OLTP and DW Tables'
print '***************************************************************'
print 'Checking Number of Rows of each table in the source databases and the DW Database'

-- Write SQL queries to get answers to fill in the information below
-- ****************************************************************************
-- FILL IN THE ##### 
-- ****************************************************************************
-- Source table					Northwind3	Northwind4	Target table 	DW	
-- ****************************************************************************
-- Customers					13			78			dimCustomers	91
-- Products						77			77			dimProducts		77
-- Suppliers					29			29			dimSuppliers	29
-- Orders join [Order Details] 	352			1801		factOrders		2080
-- ****************************************************************************
--Add statements below
-- Orders join [Order Details]  NW3
SELECT count(*) 
FROM northwind3.dbo.Orders o,northwind3.dbo.[Order Details] od
WHERE o.OrderID = od.OrderID
-- Orders join [Order Details]  NW4
SELECT count(*) 
FROM northwind4.dbo.Orders o,northwind4.dbo.[Order Details] od
WHERE o.OrderID = od.OrderID
--dimOrders 
SELECT count(*)
FROM factOrders

-- Customers NW3
SELECT count(*)
FROM northwind3.dbo.Customers
--Customers NW4
SELECT count(*)
FROM northwind4.dbo.Customers
--dimCustomers
SELECT count(*)
FROM dimCustomers

--Products NW3
SELECT count(*)
FROM northwind3.dbo.Products
--Products NW4
SELECT count(*)
FROM northwind4.dbo.Products
--dimProducts
SELECT count(*)
FROM dimProducts

-- Suppliers NW3
SELECT count(*)
FROM northwind3.dbo.Suppliers 
--Suppliers NW4
SELECT count(*)
FROM northwind4.dbo.Suppliers 
--dimSuppliers 
SELECT count(*)
FROM dimSuppliers



print '***************************************************************'
print 'My Northwind DW creation is now completed'
print '***************************************************************'