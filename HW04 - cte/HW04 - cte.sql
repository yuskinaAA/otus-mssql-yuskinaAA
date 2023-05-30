/*
1. Выберите сотрудников (Application.People), которые являются продажниками (IsSalesPerson), и не сделали ни одной продажи 04 июля 2015 года. 
   Вывести ИД сотрудника и его полное имя. Продажи смотреть в таблице Sales.Invoices.
*/
--1.1 Вложенный запрос
SELECT
p.PersonID, p.FullName
FROM Application.People AS p
WHERE IsSalesperson = 1
AND NOT EXISTS(
               SELECT * 
			   FROM Sales.Invoices AS I
			   WHERE I.InvoiceDate = '20150704'
			   AND I.SalespersonPersonID = p.PersonID
			  )
--1.2 CTE
;WITH InvoiceCTE AS (
	SELECT I.SalespersonPersonID 
	FROM Sales.Invoices AS I
	WHERE I.InvoiceDate = '20150704'
)
SELECT
p.PersonID, p.FullName
FROM Application.People AS p
WHERE IsSalesperson = 1
AND p.PersonID NOT IN (Select SalespersonPersonID FROM InvoiceCTE)
/*
2. Выберите товары с минимальной ценой (подзапросом). Сделайте два варианта подзапроса. Вывести: ИД товара, наименование товара, цена.
*/
--2.1 Вложенный запрос
SELECT 
	si.StockItemID, 
	si.StockItemName, 
	si.UnitPrice
FROM Warehouse.StockItems AS si
WHERE si.UnitPrice = (
                       SELECT TOP 1 MIN(UnitPrice)
					   FROM Warehouse.StockItems
                     )
SELECT 
	si.StockItemID, 
	si.StockItemName, 
	si.UnitPrice
FROM Warehouse.StockItems AS si
WHERE si.UnitPrice IN (
                       SELECT MIN(UnitPrice)
					   FROM Warehouse.StockItems
                     )
--2.1 CTE (не уместно, но для практики)
;WITH MinPriceCTE AS (
					  SELECT MIN(UnitPrice) minPrice
					  FROM Warehouse.StockItems
)
SELECT 
	si.StockItemID, 
	si.StockItemName, 
	si.UnitPrice
FROM Warehouse.StockItems AS si
WHERE si.UnitPrice IN (SELECT minPrice FROM MinPriceCTE)

/*
3. Выберите информацию по клиентам, которые перевели компании пять максимальных платежей из Sales.CustomerTransactions. 
   Представьте несколько способов (в том числе с CTE).
*/
--3.1 Вложенный запрос
SELECT 
  c.CustomerID, 
  c.CustomerName
FROM Sales.Customers c
INNER JOIN (
SELECT 
    TOP 5 
	ct.CustomerID, 
	ct.TransactionAmount
FROM Sales.CustomerTransactions AS ct
ORDER BY ct.TransactionAmount DESC) AS ctTop5 ON ctTop5.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.CustomerName
ORDER BY c.CustomerName

SELECT 
  c.CustomerID, 
  c.CustomerName
FROM Sales.Customers c
WHERE c.CustomerID IN (
						SELECT 
							TOP 5 
							ct.CustomerID
						FROM Sales.CustomerTransactions AS ct
						ORDER BY ct.TransactionAmount DESC
					  )
ORDER BY c.CustomerName

--3.2 CTE
;WITH TranCTE AS (
				  SELECT 
					  TOP 5 ct.CustomerID CI
				  FROM Sales.CustomerTransactions AS ct
				  ORDER BY ct.TransactionAmount DESC
)
SELECT 
  c.CustomerID, 
  c.CustomerName
FROM Sales.Customers c
WHERE EXISTS (
               SELECT * 
			   FROM TranCTE cte
			   WHERE cte.CI = c.CustomerID
      )
ORDER BY c.CustomerName

/*
4. Выберите города (ид и название), в которые были доставлены товары, входящие в тройку самых дорогих товаров, 
   а также имя сотрудника, который осуществлял упаковку заказов (PackedByPersonID).
*/
--4.1 Вложенный запрос
SELECT 
   city.CityID,
   city.CityName,
   p.FullName
FROM Sales.Invoices AS i
INNER JOIN Sales.InvoiceLines AS il ON il.InvoiceID = i.InvoiceID
INNER JOIN Sales.Customers AS c ON c.CustomerID = i.CustomerID
INNER JOIN Application.Cities AS city ON city.CityID = c.DeliveryCityID
INNER JOIN Application.People AS p ON p.PersonID = i.PackedByPersonID
WHERE il.StockItemID IN (SELECT TOP 3 si.StockItemID FROM Warehouse.StockItems si ORDER BY si.UnitPrice DESC)
GROUP BY city.CityID, city.CityName, p.FullName
ORDER BY city.CityName

--4.2 CTE
;WITH StockItemsCTE AS (
	SELECT 
		TOP 3 si.StockItemID 
	FROM Warehouse.StockItems si 
	ORDER BY si.UnitPrice DESC
)
SELECT 
   city.CityID,
   city.CityName,
   p.FullName
FROM Sales.Invoices AS i
INNER JOIN Sales.InvoiceLines AS il ON il.InvoiceID = i.InvoiceID
INNER JOIN Sales.Customers AS c ON c.CustomerID = i.CustomerID
INNER JOIN Application.Cities AS city ON city.CityID = c.DeliveryCityID
INNER JOIN Application.People AS p ON p.PersonID = i.PackedByPersonID
WHERE il.StockItemID IN (SELECT StockItemID FROM StockItemsCTE)
GROUP BY city.CityID, city.CityName, p.FullName
ORDER BY city.CityName


/*
5. Опциональное

   Можно двигаться как в сторону улучшения читабельности запроса, так и в сторону упрощения плана\ускорения. 
   Сравнить производительность запросов можно через SET STATISTICS IO, TIME ON. 
   Если знакомы с планами запросов, то используйте их (тогда к решению также приложите планы). Напишите ваши рассуждения по поводу оптимизации.
   Объясните, что делает и оптимизируйте запрос:
*/
-- Запрос выводит все накладные покупателей, сумма продаж которых превышает 27 000 единиц
-- Выводит: ид накладной, дату накладной, имя продавца, общую сумму накладной, 
--          а также сумму собранного заказа (заказ должен быть уже укомплектован)


--5.1 ИСХОДНЫЙ
SET STATISTICS TIME, IO ON
/*
План выполнения - EP_original_01.sqlplan
CPU time = 109 ms,  elapsed time = 119 ms.

Table 'OrderLines'. Scan count 2, logical reads 0, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 163, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
Table 'OrderLines'. Segment reads 1, segment skipped 0.
Table 'InvoiceLines'. Scan count 2, logical reads 0, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 161, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
Table 'InvoiceLines'. Segment reads 1, segment skipped 0.
Table 'Worktable'. Scan count 0, logical reads 0, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
Table 'Orders'. Scan count 1, logical reads 692, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
Table 'Invoices'. Scan count 1, logical reads 11400, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
Table 'People'. Scan count 1, logical reads 11, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
*/

SELECT
	Invoices.InvoiceID,
	Invoices.InvoiceDate,
	(  
		SELECT People.FullName
		FROM Application.People
		WHERE People.PersonID = Invoices.SalespersonPersonID
	) AS SalesPersonName,
	SalesTotals.TotalSumm AS TotalSummByInvoice,
	(
		SELECT SUM(OrderLines.PickedQuantity * OrderLines.UnitPrice)
		FROM Sales.OrderLines
		WHERE OrderLines.OrderId = (SELECT Orders.OrderId
									FROM Sales.Orders
									WHERE Orders.PickingCompletedWhen IS NOT NULL
									AND Orders.OrderId = Invoices.OrderId
									)
	) AS TotalSummForPickedItems
FROM Sales.Invoices
JOIN (   
    SELECT InvoiceId, SUM(Quantity * UnitPrice) AS TotalSumm
	FROM Sales.InvoiceLines
	GROUP BY InvoiceId
	HAVING SUM(Quantity*UnitPrice) > 27000
	) AS SalesTotals ON Invoices.InvoiceID = SalesTotals.InvoiceID
ORDER BY TotalSumm DESC
OPTION(RECOMPILE, MAXDOP 1)

--5.2 исправленый
SET STATISTICS TIME, IO ON
/*
План выполнения - EP_correct_02
CPU time = 141 ms,  elapsed time = 201 ms.

Table 'OrderLines'. Scan count 2, logical reads 0, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 163, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
Table 'OrderLines'. Segment reads 1, segment skipped 0.
Table 'InvoiceLines'. Scan count 2, logical reads 0, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 161, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
Table 'InvoiceLines'. Segment reads 1, segment skipped 0.
Table 'Worktable'. Scan count 0, logical reads 0, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
Table 'Orders'. Scan count 1, logical reads 692, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
Table 'Invoices'. Scan count 1, logical reads 11400, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
Table 'People'. Scan count 1, logical reads 11, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
*/

;WITH OrdersCTE AS (
	SELECT 
	SUM(ol.PickedQuantity * ol.UnitPrice) AS TotalSummForPickedItems,
	o.OrderID
	FROM Sales.Orders AS o
	INNER JOIN Sales.OrderLines AS ol ON ol.OrderID = o.OrderID
	WHERE o.PickingCompletedWhen IS NOT NULL
	GROUP BY o.OrderID
)

SELECT
	i.InvoiceID,
	i.InvoiceDate,
	p.FullName AS SalesPersonName,
	SUM(il.Quantity * il.UnitPrice) AS TotalSummByInvoice,
	(
	 SELECT
	   TotalSummForPickedItems
     FROM  OrdersCTE octe
	 WHERE octe.OrderID = i.OrderID
	) AS TotalSummForPickedItems
FROM Sales.Invoices AS i
INNER JOIN Sales.InvoiceLines AS il ON il.InvoiceID = i.InvoiceID
INNER JOIN Application.People  AS p ON p.PersonID = i.SalespersonPersonID
GROUP BY i.InvoiceID, i.InvoiceDate, p.FullName, i.OrderID
HAVING SUM(il.Quantity*il.UnitPrice) > 27000
ORDER BY TotalSummByInvoice DESC
OPTION(RECOMPILE, MAXDOP 1)

1. Если сравнивать 2 верхних запроса, по операции ввода и вывода они идентичны. На время выполнения я обращаю внимание, но оно скачущее. 
2. Если сравнить планы выполнения - первый мне нравится больше, меня смущает, что во втором плане выполнения он таскает почти 5000 записей из таблицы Invoices, хотя в первом быстро их отфильтровывает до 8
   С чем это может быть связано?

--5.3 исправленый
--Этот вариант легче анализировать, план выполнения и IO не изменяются в сравнении с вариантом 5.2
   
;WITH 
InvoicesCTE AS (
   SELECT 
      i.InvoiceID,
	  i.InvoiceDate,
	  i.OrderId,
	  i.SalespersonPersonID,
	  SUM(il.Quantity * il.UnitPrice) AS TotalSummByInvoice
   FROM Sales.Invoices AS i
   INNER JOIN Sales.InvoiceLines AS il ON il.InvoiceID = i.InvoiceID
   GROUP BY i.InvoiceID, i.InvoiceDate, i.OrderId, i.SalespersonPersonID
   HAVING SUM(il.Quantity*il.UnitPrice) > 27000
)
,PickedItemsCTE AS (
	SELECT 
	SUM(ol.PickedQuantity * ol.UnitPrice) AS TotalSummForPickedItems,
	o.OrderID
	FROM Sales.Orders AS o
	INNER JOIN Sales.OrderLines AS ol ON ol.OrderID = o.OrderID
	WHERE o.PickingCompletedWhen IS NOT NULL
	GROUP BY o.OrderID
)

SELECT
	icte.InvoiceID,
	icte.InvoiceDate,
	p.FullName AS SalesPersonName,
	icte.TotalSummByInvoice,
	pickICTE.TotalSummForPickedItems
FROM InvoicesCTE AS icte
INNER JOIN Application.People  AS p ON p.PersonID = icte.SalespersonPersonID
LEFT JOIN PickedItemsCTE AS pickICTE ON pickICTE.OrderID = icte.OrderID
ORDER BY TotalSummByInvoice DESC
OPTION(RECOMPILE, MAXDOP 1)



