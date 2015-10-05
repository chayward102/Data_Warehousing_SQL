-------------------------------------------------------
--Data Quality Checking and Logging for Data Warehouse
--Check For DW: Northwind DW
-------------------------------------------------------
DROP TABLE DQLog;

CREATE TABLE DQLog
(
LogID 		int PRIMARY KEY IDENTITY,
RowID 		varbinary(32),		-- This is a physical address of a row stored on a disk and it is UNIQUE
DBName 		nchar(20),
TableName	nchar(20),
RuleNo		smallint,
Action		nchar(6) CHECK (action IN ('allow','fix','reject')) -- Action can be ONLY 'allow','fix','reject'
);


print '***************************************************************'
print '****** Section 2: DQ Checking and Logging based on DQ Rules'
print '***************************************************************'

print '================ BEGIN RULE 1 CHECKING =================='
print 'DQ Rule 1: 	UnitPrice is 0 or negative'
print 'Action: 		Reject'
print 'Database: 	Northwind5 and northwind6'
print '------------------------'
print 'Table: 		Products'
print '------------------------'
-- From Week 8 Worksheet - Step D.1. 
-- Write your SQL statement below... 

INSERT INTO DQLog(RowID, DBName, TableName, RuleNo, Action)
SELECT %%physloc%%, 'northwind5','Products',1,'reject'
FROM northwind5.dbo.Products
--go to this table and find where unitprice <=0 and cature the phiscal address %%physloc%%
WHERE UnitPrice<=0
--1 row affected

SELECT * from DQLOG
--find row affected RowID = 0xD801000001000000 

SELECT *
FROM northwind5.dbo.Products p
WHERE p.%%physloc%% = 0xD801000001000000

--finds product affected UnitPrice = 0.00

--same steps for Northwind 6
INSERT INTO DQLog(RowID, DBName, TableName, RuleNo, Action)
SELECT %%physloc%%, 'northwind6','Products',1,'reject'
FROM northwind6.dbo.Products
WHERE UnitPrice<=0

-- From Week 8 Worksheet - Step D.2. 
-- Write your SQL statement below... 
SELECT * from DQLOG
--find row affected RowID =  0xB001000001000100

SELECT *
FROM northwind6.dbo.Products p
WHERE p.%%physloc%% = 0xB001000001000100

-- From Week 8 Worksheet - Step D.3. 
-- Write your SQL statement below... 


print '------------------------'
print 'Table: 		[Order Details]'
print '------------------------'
-- From Week 8 Worksheet - Step D.4. 
-- Write your SQL statement below... 
INSERT INTO DQLog(RowID, DBName, TableName, RuleNo, Action)
SELECT %%physloc%%, 'northwind5','Order Details',1,'reject'
FROM northwind5.dbo.[Order Details]
WHERE UnitPrice<=0


-- From Week 8 Worksheet - Step D.5. 
-- Write your SQL statement below... 
SELECT * FROM DQLOG

SELECT * 
FROM northwind5.dbo.[Order Details] od
WHERE od.%%physloc%% = 0x4001000001000000


-- From Week 8 Worksheet - Step D.6. 
-- Write your SQL statement below... 
INSERT INTO DQLog(RowID, DBName, TableName, RuleNo, Action)
SELECT %%physloc%%, 'northwind6','Order Details',1,'reject'
FROM northwind6.dbo.[Order Details]
WHERE UnitPrice<=0

SELECT * 
FROM DQLOG

SELECT * 
FROM northwind6.dbo.[Order Details] od
WHERE od.%%physloc%% =0x4801000001000000

print '=============== END RULE 1 CHECKING ===================='


print '================ BEGIN RULE 2 CHECKING =================='
print 'DQ Rule 2: 	Quantity is 0 or negative'
print 'Action: 		Reject'
print 'Database: 	Northwind5 and northwind6'
print '------------------------'
print 'Table: 		[Order Details]'
print '------------------------'
-- From Week 8 Worksheet - Step E. 
-- Write your SQL statement below... 
INSERT INTO DQLog(RowID, DBName, TableName, RuleNo, Action)
SELECT %%physloc%%, 'northwind5','Order Details',2,'reject'
FROM northwind5.dbo.[Order Details]
WHERE Quantity <= 0

SELECT * FROM DQLOG

SELECT * 
FROM northwind5.dbo.[Order Details] od
WHERE od.%%physloc%% = 0x4001000001000600
--NW6
INSERT INTO DQLog(RowID, DBName, TableName, RuleNo, Action)
SELECT %%physloc%%, 'northwind6','Order Details',2,'reject'
FROM northwind6.dbo.[Order Details]
WHERE Quantity <= 0


print '=============== END RULE 2 CHECKING ===================='


print '================ BEGIN RULE 3 CHECKING =================='
print 'DQ Rule 3: 	Discount is more than 50% (0.50)'
print 'Action: 		Allow'
print 'Database: 	Northwind5 and northwind6'
print '------------------------'
print 'Table: 		[Order Details]'
print '------------------------'
-- From Week 8 Worksheet - Step F. 
-- Write your SQL statement below... 

--NW 5
INSERT INTO DQLog(RowID, DBName, TableName, RuleNo, Action)
SELECT %%physloc%%, 'northwind5','Order Details',3,'allow'
FROM northwind5.dbo.[Order Details]
WHERE discount > 0.50

SELECT * FROM DQLOG

SELECT *
FROM northwind5.dbo.[Order Details] od
WHERE od.%%physloc%% = 0x4001000001000300



--NW 6
INSERT INTO DQLog(RowID, DBName, TableName, RuleNo, Action)
SELECT %%physloc%%, 'northwind6','Order Details',3,'allow'
FROM northwind6.dbo.[Order Details]
WHERE discount > 0.50

SELECT * FROM DQLOG

SELECT *
FROM northwind6.dbo.[Order Details] od
WHERE od.%%physloc%% = 0x4801000001000200





print '=============== END RULE 3 CHECKING ===================='


print '================ BEGIN RULE 4 CHECKING =================='
print 'DQ Rule 4: 	Customer with wrong Country format'
print 'Action: 		Fix'
print 'Database: 	Northwind5 and northwind6'
print '------------------------'
print 'Table: 		Customers'
print '------------------------'
-- From Week 8 Worksheet - Step G. 
-- Write your SQL statement below... 
INSERT INTO DQLog(RowID, DBName, TableName, RuleNo, Action)
SELECT %%physloc%%, 'northwind5','Customers',4,'fix'
FROM northwind5.dbo.Customers
WHERE Country IN('US','United States','United Kingdom','Britain')

SELECT * FROM DQLOG

SELECT * 
FROM northwind5.dbo.Customers c
WHERE c.%%physloc%% = 0x5801000001000000
OR c.%%physloc%% = 0x5801000001000200
OR c.%%physloc%% = 0x5801000001000300

--NW6
INSERT INTO DQLog(RowID, DBName, TableName, RuleNo, Action)
SELECT %%physloc%%, 'northwind6','Customers',4,'fix'
FROM northwind6.dbo.Customers
WHERE Country IN('US','United States','United Kingdom','Britain')

SELECT * FROM DQLOG

SELECT * 
FROM northwind6.dbo.Customers c
WHERE c.%%physloc%% = 0x3001000001000300
OR c.%%physloc%% = 0x3001000001000F00
OR c.%%physloc%% = 0x3101000001000400
OR c.%%physloc%% = 0x3101000001001000
OR c.%%physloc%% = 0x3201000001000300


print '=============== END RULE 4 CHECKING ===================='


print '================ BEGIN RULE 5 CHECKING ===================='
print 'DQ Rule 5: 	US Customer with the length of PostalCode is not 5'
print 'Action: 		Allow'
print 'Database: 	Only Northwind5' -- Why does northwind6 not need to be checked?
print '------------------------'
print 'Table: 		Customers'
print '------------------------'
-- From Week 8 Worksheet - Step H. 
-- Write your SQL statement below... 
INSERT INTO DQLog(RowID, DBName, TableName, RuleNo, Action)
SELECT %%physloc%%, 'northwind5','Customers',5,'allow'
FROM northwind5.dbo.Customers
WHERE len(PostalCode) != 5;

SELECT * FROM DQLOG

SELECT * 
FROM northwind5.dbo.Customers c
WHERE c.%%physloc%% = 0x5801000001000000
OR c.%%physloc%% = 0x5801000001000100
OR c.%%physloc%% = 0x5801000001000200


print '=============== END RULE 5 CHECKING ======================'


print '================ BEGIN RULE 6 CHECKING ===================='
print 'DQ Rule 6: 	CategoryID checking in Products (if exists or null)'
print 'Action: 		Allow'
print 'Database: 	Northwind5 and northwind6'
print '------------------------'
print 'Table: 		Products'
print '------------------------'
-- From Week 8 Worksheet - Step I. 
-- Write your SQL statement below... 

INSERT INTO DQLog(RowID, DBName, TableName, RuleNo, Action)
SELECT %%physloc%%, 'northwind5','Products',6,'allow'
FROM northwind5.dbo.Products
WHERE northwind5.dbo.Products.CategoryID NOT IN 
(
SELECT northwind5.dbo.Categories.CategoryID
FROM northwind5.dbo.Categories
)
OR northwind5.dbo.Products.CategoryID is null


SELECT * FROM DQLOG


SELECT * 
FROM northwind5.dbo.Products p
WHERE p.%%physloc%% =  0xD801000001000000

--NW 6


INSERT INTO DQLog(RowID, DBName, TableName, RuleNo, Action)
SELECT %%physloc%%, 'northwind6','Products',6,'allow'
FROM northwind6.dbo.Products
WHERE northwind6.dbo.Products.CategoryID NOT IN 
(
SELECT northwind6.dbo.Categories.CategoryID
FROM northwind6.dbo.Categories
)
OR northwind6.dbo.Products.CategoryID is null

SELECT * FROM DQLOG

SELECT * 
FROM northwind6.dbo.Products p
WHERE p.%%physloc%% = 0xB001000001000100


print '=============== END RULE 6 CHECKING ======================'

-- **************************************************************
-- PLEASE FILL IN NUMBERS IN THE ##### BELOW
-- **************************************************************
-- Rule no	| 	Total Logged Rows
-- **************************************************************
-- 1			4
-- 2			1
-- 3			2
-- 4			8
-- 5			3
-- 6			2
-- **************************************************************
-- Total Allow 	7
-- Total Fix 	8
-- Total Reject	5
-- **************************************************************

SELECT count(*)
FROM DQLOG
WHERE action = 'reject'