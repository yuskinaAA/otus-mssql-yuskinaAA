/*
Домашнее задание по курсу MS SQL Server Developer в OTUS.

Занятие "12 - Хранимые процедуры, функции, триггеры, курсоры".

Задания выполняются с использованием базы данных WideWorldImporters.

Бэкап БД можно скачать отсюда:
https://github.com/Microsoft/sql-server-samples/releases/tag/wide-world-importers-v1.0
Нужен WideWorldImporters-Full.bak

Описание WideWorldImporters от Microsoft:
* https://docs.microsoft.com/ru-ru/sql/samples/wide-world-importers-what-is
* https://docs.microsoft.com/ru-ru/sql/samples/wide-world-importers-oltp-database-catalog
*/

USE WideWorldImporters

/*
Во всех заданиях написать хранимую процедуру / функцию и продемонстрировать ее использование.
*/

/*
1) Написать функцию возвращающую Клиента с наибольшей суммой покупки.
*/
--Реализация функции, возвращающей скалярное значение
CREATE FUNCTION Sales.GetCustomerIdWithMaxBuy() 
RETURNS INT
AS
BEGIN

	DECLARE @customer_id INT
	
	SELECT 
		TOP 1 @customer_id = i.CustomerID
	FROM Sales.Invoices i
	INNER JOIN Sales.InvoiceLines il ON i.InvoiceID = il.InvoiceID
	GROUP BY i.CustomerID
	ORDER BY SUM(il.ExtendedPrice) DESC

	RETURN @customer_id

END
GO

SELECT [Sales].[GetCustomerIdWithMaxBuy] ()

--Реализация функции, возвращающей табличное значение
CREATE FUNCTION Sales.GetCustomerWithMaxBuy()
RETURNS TABLE 
AS
RETURN 
(
	SELECT 
		TOP 1 c.CustomerID, c.CustomerName, c.PhoneNumber
	FROM Sales.Invoices i
	INNER JOIN Sales.InvoiceLines il ON i.InvoiceID = il.InvoiceID
	INNER JOIN Sales.Customers c ON c.CustomerID = i.CustomerID
	GROUP BY c.CustomerID, c.CustomerName, c.PhoneNumber
	ORDER BY SUM(il.ExtendedPrice) DESC
)
GO

SELECT * FROM [Sales].[GetCustomerWithMaxBuy] ()


/*
2) Написать хранимую процедуру с входящим параметром СustomerID, выводящую сумму покупки по этому клиенту.
Использовать таблицы :
Sales.Customers
Sales.Invoices
Sales.InvoiceLines
*/

CREATE OR ALTER PROCEDURE Sales.GetPurchaseAmountByCustomer(@CustomerId INT)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @TotalAmount INT = 0 --если у клиента не было покупок, тогда возвращать 0

	SELECT @TotalAmount = SUM(il.ExtendedPrice) 
	FROM Sales.Invoices i
	INNER JOIN Sales.InvoiceLines il ON il.InvoiceID = i.InvoiceID
	WHERE i.CustomerID = @CustomerId
	GROUP BY i.CustomerID

	SELECT @TotalAmount

END
GO

EXECUTE [Sales].[GetPurchaseAmountByCustomer] 149


/*
3) Создать одинаковую функцию и хранимую процедуру, посмотреть в чем разница в производительности и почему.
*/
--Возможно в реальной жизни такого запроса не будет, но хотела соединиться с большими таблицами
--Вывести списки заказов с наименованием товара, датой заказа, количеством: по тем товарам, по которым была максимальная продажа
--Создала функцию
CREATE FUNCTION [Sales].[fGetOrdersForMax](@topMax INT = 5)
RETURNS 
@tbl TABLE (StockItemName NVARCHAR(100), UnitPrice DECIMAL(18,2), OrderDate DATE, Quantity INT)
AS
BEGIN
	INSERT INTO @tbl
	(StockItemName, UnitPrice, OrderDate, Quantity)
	SELECT
		s.StockItemName, s.UnitPrice, o.OrderDate, ol.Quantity
	FROM Sales.Orders o
	INNER JOIN Sales.OrderLines ol ON o.OrderID = ol.OrderID
	INNER JOIN Warehouse.StockItems s ON s.StockItemID = ol.StockItemID
	WHERE ol.StockItemID IN (
        SELECT TOP (@topMax) il.StockItemID
		FROM Sales.Invoices i
		INNER JOIN Sales.InvoiceLines il ON i.InvoiceID = il.InvoiceID
		GROUP BY il.StockItemID
		ORDER BY SUM(il.ExtendedPrice) DESC
	 )
	ORDER BY s.StockItemID, o.OrderDate, ol.Quantity
	
	RETURN 
END

--Создала процедуру
CREATE PROCEDURE Sales.pGetOrdersForMax(@topMax INT = 5)
AS
BEGIN
	SET NOCOUNT ON;

    SELECT
		s.StockItemName, s.UnitPrice, o.OrderDate, ol.Quantity
	FROM Sales.Orders o
	INNER JOIN Sales.OrderLines ol ON o.OrderID = ol.OrderID
	INNER JOIN Warehouse.StockItems s ON s.StockItemID = ol.StockItemID
	WHERE ol.StockItemID IN (
        SELECT TOP (@topMax) il.StockItemID
		FROM Sales.Invoices i
		INNER JOIN Sales.InvoiceLines il ON i.InvoiceID = il.InvoiceID
		GROUP BY il.StockItemID
		ORDER BY SUM(il.ExtendedPrice) DESC
	 )
	ORDER BY s.StockItemID, o.OrderDate, ol.Quantity
END
GO

--Анализ
SET STATISTICS IO, TIME ON

PRINT 'Function **********************************************************************************'
SELECT * FROM [Sales].[fGetOrdersForMax] (1000)
/*
РЕЗУЛЬТАТ
   CPU time = 516 ms,  elapsed time = 2679 ms.
*/

PRINT 'Procedure **********************************************************************************'
EXECUTE [Sales].[pGetOrdersForMax] 1000
/*
РЕЗУЛЬТАТ
CPU time = 188 ms,  elapsed time = 1463 ms.
*/

--в моем случае процедура сработала лучше. (пробовала на разных значениях входного параметра)
--В планах запроса по функции видно, что оптимизатор неверно оценил предполагаемое количество строк к получению.
--Могу предположить, если добавить индексы/или оптимизировать запрос - план запроса процедуры будет лучше.
--Плюс на практике столкнулась с тем что выгоднее создать временную таблицу, сложить туда данные и оперировать ими (если они нужны далее по коду), чем вызывать табличную функцию со сложным запросом

/*
4) Создайте табличную функцию покажите как ее можно вызвать для каждой строки result set'а без использования цикла. 
*/

--табличная функция
--получить только те позиции, где количество превышает указанного
CREATE FUNCTION GetInvoiceines (@InvoiceId INT, @quantity INT )
RETURNS TABLE 
AS
RETURN 
(
	SELECT il.StockItemID, il.ExtendedPrice
	FROM Sales.InvoiceLines il
	WHERE il.Quantity > @quantity
	AND il.InvoiceID = @InvoiceId
)
GO

DECLARE @quantity INT
SET @quantity = 25

SELECT 
il.StockItemId, i.InvoiceDate, il.ExtendedPrice
FROM Sales.Invoices i
CROSS APPLY Sales.GetInvoiceLines(i.InvoiceID, @quantity) il
ORDER BY il.StockItemId, il.ExtendedPrice, i.InvoiceDate


/*
5) Опционально. Во всех процедурах укажите какой уровень изоляции транзакций вы бы использовали и почему. 
*/
--1. нужно использовать Read Committed . Нужен реальный покупатель, который совершил максимальную покупку (каждая копейка на счету, я хочу предоставить ему скидку).
--2. тут я бы использовала в зависимости от ситуации: Read Uncommitted - мне нужны объемы за год, неучтенные покупки за день не важны
--                                                    Read Committed  - если все таки мне нужны реальные цифры для бухгалтерии 
