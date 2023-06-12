/*
Домашнее задание по курсу MS SQL Server Developer в OTUS.

Занятие "10 - Операторы изменения данных".

Задания выполняются с использованием базы данных WideWorldImporters.

Бэкап БД можно скачать отсюда:
https://github.com/Microsoft/sql-server-samples/releases/tag/wide-world-importers-v1.0
Нужен WideWorldImporters-Full.bak

Описание WideWorldImporters от Microsoft:
* https://docs.microsoft.com/ru-ru/sql/samples/wide-world-importers-what-is
* https://docs.microsoft.com/ru-ru/sql/samples/wide-world-importers-oltp-database-catalog
*/

-- ---------------------------------------------------------------------------
-- Задание - написать выборки для получения указанных ниже данных.
-- ---------------------------------------------------------------------------

USE WideWorldImporters

/*
1. Довставлять в базу пять записей используя insert в таблицу Customers или Suppliers 
*/

INSERT INTO Sales.Customers
(CustomerName, BillToCustomerID, CustomerCategoryID, PrimaryContactPersonID, 
 DeliveryMethodID, DeliveryCityID, PostalCityID, AccountOpenedDate,
 StandardDiscountPercentage, IsStatementSent, IsOnCreditHold, PaymentDays, 
 PhoneNumber, FaxNumber, WebsiteURL, DeliveryAddressLine1,
 DeliveryPostalCode, PostalAddressLine1, PostalPostalCode, LastEditedBy
 )
 VALUES
 ('Customer 1', 1, 3, 1001, 
   3, 19586, 19586, '20230101',
   0, 0, 0, 7, 
   '(308) 111-1111', '(308) 111-1111', 'http://customer1.com',  'C 1',
   '11111', 'PO Box 1111', '11111', 1
   ),
   ('Customer 2', 1, 3, 1002, 
   3, 19586, 19586, '20230101',
   0, 0, 0, 7, 
   '(308) 222-2222', '(308) 222-2222', 'http://customer2.com',  'C 2',
   '22222', 'PO Box 2222', '22222', 1
   ),
   ('Customer 3', 1, 3, 1003, 
   3, 19586, 19586, '20230101',
   0, 0, 0, 7, 
   '(308) 333-3333', '(308) 333-3333', 'http://customer3.com',  'C 3',
   '33333', 'PO Box 3333', '33333', 1
   ),
   ('Customer 4', 1, 3, 1004, 
   3, 19586, 19586, '20230101',
   0, 0, 0, 7, 
   '(308) 444-4444', '(308) 444-4444', 'http://customer4.com',  'C 4',
   '44444', 'PO Box 4444', '44444', 1
   ),
   ('Customer 5', 1, 3, 1005, 
   3, 19586, 19586, '20230101',
   0, 0, 0, 7, 
   '(308) 555-5555', '(308) 555-5555', 'http://customer5.com',  'C 5',
   '55555', 'PO Box 5555', '55555', 1
   )

INSERT INTO Sales.Customers
(CustomerName, 
 BillToCustomerID, CustomerCategoryID, PrimaryContactPersonID, 
 DeliveryMethodID, DeliveryCityID, PostalCityID, AccountOpenedDate,
 StandardDiscountPercentage, IsStatementSent, IsOnCreditHold, PaymentDays, 
 PhoneNumber, FaxNumber, WebsiteURL, DeliveryAddressLine1,
 DeliveryPostalCode, PostalAddressLine1, PostalPostalCode, LastEditedBy
 )
 SELECT TOP 5
 'Customer ' + CAST(RANK()OVER(ORDER BY CustomerID DESC) AS VARCHAR),
 BillToCustomerID, CustomerCategoryID, PrimaryContactPersonID, 
 DeliveryMethodID, DeliveryCityID, PostalCityID, AccountOpenedDate,
 StandardDiscountPercentage, IsStatementSent, IsOnCreditHold, PaymentDays, 
 PhoneNumber, FaxNumber, WebsiteURL, DeliveryAddressLine1,
 DeliveryPostalCode, PostalAddressLine1, PostalPostalCode, LastEditedBy
 FROM Sales.Customers
 ORDER BY CustomerID DESC

/*
2. Удалите одну запись из Customers, которая была вами добавлена
*/

DELETE FROM Sales.Customers WHERE CustomerName = 'Customer 1'


/*
3. Изменить одну запись, из добавленных через UPDATE
*/

UPDATE Sales.Customers 
SET CustomerName = CustomerName + ' old'
WHERE CustomerName = 'Customer 1'

/*
4. Написать MERGE, который вставит вставит запись в клиенты, если ее там нет, и изменит если она уже есть
*/

;WITH CustomCTE AS ( 
   SELECT TOP 20 
    CASE WHEN CustomerId % 2 = 0 THEN CustomerName
	ELSE 'Customer new' + CAST(RANK()OVER(ORDER BY CustomerID DESC) AS VARCHAR)
	END AS CustomerName,
 BillToCustomerID, CustomerCategoryID, PrimaryContactPersonID, 
 DeliveryMethodID, DeliveryCityID, PostalCityID, AccountOpenedDate,
 StandardDiscountPercentage, IsStatementSent, IsOnCreditHold, PaymentDays, 
 PhoneNumber, FaxNumber, WebsiteURL, DeliveryAddressLine1,
 DeliveryPostalCode, PostalAddressLine1, PostalPostalCode, LastEditedBy
 FROM Sales.Customers
 ORDER BY CustomerID
)
MERGE Sales.Customers AS c_old
  USING(
		SELECT * FROM CustomCTE
       ) AS c_new
	   (CustomerName,
		BillToCustomerID, CustomerCategoryID, PrimaryContactPersonID, 
		DeliveryMethodID, DeliveryCityID, PostalCityID, AccountOpenedDate,
		StandardDiscountPercentage, IsStatementSent, IsOnCreditHold, PaymentDays, 
		PhoneNumber, FaxNumber, WebsiteURL, DeliveryAddressLine1,
		DeliveryPostalCode, PostalAddressLine1, PostalPostalCode, LastEditedBy
	   ) ON c_old.CustomerName = c_new.CustomerName
	   WHEN MATCHED THEN
        UPDATE SET 
		c_old.BillToCustomerID = c_new.BillToCustomerID, 
		c_old.CustomerCategoryID = c_new.CustomerCategoryID, 
		c_old.PrimaryContactPersonID = c_new.PrimaryContactPersonID, 
		c_old.DeliveryMethodID = c_new.DeliveryMethodID, 
		c_old.DeliveryCityID = c_new.DeliveryCityID, 
		c_old.PostalCityID = c_new.PostalCityID, 
		c_old.AccountOpenedDate = c_new.AccountOpenedDate,
		c_old.StandardDiscountPercentage = c_new.StandardDiscountPercentage, 
		c_old.IsStatementSent = c_new.IsStatementSent, 
		c_old.IsOnCreditHold = c_new.IsOnCreditHold, 
		c_old.PaymentDays = c_new.PaymentDays, 
		c_old.PhoneNumber = c_new.PhoneNumber, 
		c_old.FaxNumber = c_new.FaxNumber, 
		c_old.WebsiteURL = c_new.WebsiteURL, 
		c_old.DeliveryAddressLine1 = c_new.DeliveryAddressLine1,
		c_old.DeliveryPostalCode = c_new.DeliveryPostalCode, 
		c_old.PostalAddressLine1 = c_new.PostalAddressLine1, 
		c_old.PostalPostalCode = c_new.PostalPostalCode, 
		c_old.LastEditedBy = c_new.LastEditedBy
	  WHEN NOT MATCHED THEN  
	  INSERT
		(CustomerName, 
		 BillToCustomerID, CustomerCategoryID, PrimaryContactPersonID, 
		 DeliveryMethodID, DeliveryCityID, PostalCityID, AccountOpenedDate,
		 StandardDiscountPercentage, IsStatementSent, IsOnCreditHold, PaymentDays, 
		 PhoneNumber, FaxNumber, WebsiteURL, DeliveryAddressLine1,
		 DeliveryPostalCode, PostalAddressLine1, PostalPostalCode, LastEditedBy
		 )
	  VALUES
	     (c_new.CustomerName, 
		 c_new.BillToCustomerID, c_new.CustomerCategoryID, c_new.PrimaryContactPersonID, 
		 c_new.DeliveryMethodID, c_new.DeliveryCityID, c_new.PostalCityID, c_new.AccountOpenedDate,
		 c_new.StandardDiscountPercentage, c_new.IsStatementSent, c_new.IsOnCreditHold, c_new.PaymentDays, 
		 c_new.PhoneNumber, c_new.FaxNumber, c_new.WebsiteURL, c_new.DeliveryAddressLine1,
		 c_new.DeliveryPostalCode, c_new.PostalAddressLine1, c_new.PostalPostalCode, c_new.LastEditedBy
		 )
       Output deleted.*, $action, inserted.*;

/*
5. Напишите запрос, который выгрузит данные через bcp out и загрузить через bulk insert
*/

EXEC sp_configure 'show advanced options', 1;  
GO  
-- To update the currently configured value for advanced options.  
RECONFIGURE;  
GO  
-- To enable the feature.  
EXEC sp_configure 'xp_cmdshell', 1;  
GO  
-- To update the currently configured value for this feature.  
RECONFIGURE;  
GO

DECLARE @queryText VARCHAR(1000)
DECLARE @cmd VARCHAR(8000)
DECLARE @serverName VARCHAR(50)

SET @serverName = ' -S "' + CAST(SERVERPROPERTY('ServerName') AS VARCHAR) + '"'
SET @queryText = 'WideWorldImporters.Application.Cities'
SET @cmd = ' bcp "' + @queryText + '" out C:\Users\yaa\Documents\Cities.txt -w -t"@eu&$1&" -T' + @serverName

EXEC master..xp_cmdshell @cmd

DROP TABLE IF EXISTS [WideWorldImporters].[Application].[Cities_BulkInsert]
SELECT * INTO Application.Cities_BulkInsert 
FROM Application.Cities
WHERE 1 = 0

BULK INSERT [WideWorldImporters].[Application].[Cities_BulkInsert]
FROM "C:\Users\yaa\Documents\Cities.txt"
WITH 
	(
	BATCHSIZE = 1000, 
	DATAFILETYPE = 'widechar',
	FIELDTERMINATOR = '@eu&$1&',
	ROWTERMINATOR ='\n',
	KEEPNULLS,
	TABLOCK        
	);

--Выключаем
EXEC sp_configure 'show advanced options', 1;  
GO  
-- To update the currently configured value for advanced options.  
RECONFIGURE;  
GO  
-- To enable the feature.  
EXEC sp_configure 'xp_cmdshell', 0;  
GO  
-- To update the currently configured value for this feature.  
RECONFIGURE;  
GO


