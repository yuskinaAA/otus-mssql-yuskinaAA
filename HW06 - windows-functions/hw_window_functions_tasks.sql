/*
Домашнее задание по курсу MS SQL Server Developer в OTUS.

Занятие "06 - Оконные функции".

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
1. Сделать расчет суммы продаж нарастающим итогом по месяцам с 2015 года 
(в рамках одного месяца он будет одинаковый, нарастать будет в течение времени выборки).
Выведите: id продажи, название клиента, дату продажи, сумму продажи, сумму нарастающим итогом

Пример:
-------------+----------------------------
Дата продажи | Нарастающий итог по месяцу
-------------+----------------------------
 2015-01-29   | 4801725.31
 2015-01-30	 | 4801725.31
 2015-01-31	 | 4801725.31
 2015-02-01	 | 9626342.98
 2015-02-02	 | 9626342.98
 2015-02-03	 | 9626342.98
Продажи можно взять из таблицы Invoices.
Нарастающий итог должен быть без оконной функции.
*/

/*

CPU time = 406 ms,  elapsed time = 447 ms.
Table 'Worktable'. Scan count 1, logical reads 67, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
Table 'InvoiceLines'. Scan count 3, logical reads 10403, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
Table 'Invoices'. Scan count 3, logical reads 34200, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
Table 'Workfile'. Scan count 0, logical reads 0, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
Table 'Worktable'. Scan count 0, logical reads 0, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
Table 'Customers'. Scan count 1, logical reads 40, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
    

*/

;WITH InvoiceSumCTE AS(
	SELECT 
	  YEAR(i.InvoiceDate) AS y, MONTH(i.InvoiceDate) AS m, SUM(il.ExtendedPrice) AS s
	FROM Sales.Invoices AS i
	INNER JOIN Sales.InvoiceLines AS il ON il.InvoiceID = i.InvoiceID
	WHERE i.InvoiceDate >= '20150101'
	GROUP BY YEAR(i.InvoiceDate), MONTH(i.InvoiceDate)
),
InvoiceWithProgressiveTotalCTE AS (
  SELECT 
    t1.y, t1.m, SUM(t2.s) progressiveSum
  FROM InvoiceSumCTE t1
  INNER JOIN InvoiceSumCTE t2 ON t2.y <= t1.y AND t2.m <= t1.m
  GROUP BY t1.y, t1.m
)
SELECT 
  /*Выведите: id продажи, название клиента, дату продажи, сумму продажи, сумму нарастающим итогом*/   
  i.InvoiceID, 
  c.CustomerName, 
  i.InvoiceDate, 
  SUM(il.ExtendedPrice) InvoiceSum, 
  cte.progressiveSum
FROM Sales.Invoices AS i
INNER JOIN Sales.InvoiceLines AS il ON il.InvoiceID = i.InvoiceID
INNER JOIN Sales.Customers AS c ON c.CustomerID = i.CustomerID
INNER JOIN InvoiceWithProgressiveTotalCTE AS cte ON CTE.y =  YEAR(i.InvoiceDate) AND CTE.m = MONTH(i.InvoiceDate)
GROUP BY i.InvoiceID, c.CustomerName, i.InvoiceDate, cte.progressiveSum
ORDER BY i.InvoiceDate

/*
2. Сделайте расчет суммы нарастающим итогом в предыдущем запросе с помощью оконной функции.
   Сравните производительность запросов 1 и 2 с помощью set statistics time, io on
*/

/*

CPU time = 203 ms,  elapsed time = 198 ms.

Table 'Worktable'. Scan count 0, logical reads 0, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
Table 'Invoices'. Scan count 1, logical reads 11400, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
Table 'Worktable'. Scan count 0, logical reads 0, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
Table 'Customers'. Scan count 1, logical reads 40, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
Table 'InvoiceLines'. Scan count 1, logical reads 5003, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
*/

;WITH InvoiceSumCTE AS (
    SELECT 
	  /*Выведите: id продажи, название клиента, дату продажи, сумму продажи, сумму нарастающим итогом*/   
	  i.InvoiceID, 
	  c.CustomerName, 
	  i.InvoiceDate, 
	  SUM(il.ExtendedPrice) InvoiceSum
	FROM Sales.Invoices AS i
	INNER JOIN Sales.InvoiceLines AS il ON il.InvoiceID = i.InvoiceID
	INNER JOIN Sales.Customers AS c ON c.CustomerID = i.CustomerID
	WHERE i.InvoiceDate >= '20150101'
	GROUP BY i.InvoiceID, c.CustomerName, i.InvoiceDate
)

SELECT 
  /*Выведите: id продажи, название клиента, дату продажи, сумму продажи, сумму нарастающим итогом*/   
  InvoiceID, 
  CustomerName, 
  InvoiceDate, 
  InvoiceSum, 
  SUM(InvoiceSum) OVER(ORDER BY YEAR(InvoiceDate), MONTH(InvoiceDate)) ProgressiveSum
FROM InvoiceSumCTE
ORDER BY InvoiceDate, CustomerName

--Запрос с оконными функциями работает быстрее, а также меньше логических чтений.

/*
3. Вывести список 2х самых популярных продуктов (по количеству проданных) 
в каждом месяце за 2016 год (по 2 самых популярных продукта в каждом месяце).
*/

;WITH CTE1 AS (
		SELECT 
			si.StockItemName, 
			SUM(il.Quantity) AS Qt,
			MONTH(i.InvoiceDate) AS mon
		FROM Sales.Invoices AS i
		INNER JOIN Sales.InvoiceLines AS il ON il.InvoiceID = i.InvoiceID
		INNER JOIN Warehouse.StockItems AS si ON si.StockItemId = il.StockItemID
		WHERE i.InvoiceDate BETWEEN '20160101' AND '20161231'
		GROUP BY si.StockItemName, MONTH(i.InvoiceDate)
)
,CTE2 AS (
    SELECT 
    CTE1.*, 
	ROW_NUMBER() OVER(PARTITION BY mon ORDER BY Qt DESC) rn
	FROM CTE1
)
SELECT 
	CTE2.mon, CTE2.StockItemName, CTE2.Qt 
FROM CTE2 
WHERE CTE2.rn <= 2
ORDER BY CTE2.mon ASC, CTE2.Qt DESC


--!!!!!Опциональное БЕЗ оконных функций
;WITH CTE1 AS ( --количество по месяцам
		SELECT 
			si.StockItemName, 
			SUM(il.Quantity) AS Qt,
			MONTH(i.InvoiceDate) AS mon
		FROM Sales.Invoices AS i
		INNER JOIN Sales.InvoiceLines AS il ON il.InvoiceID = i.InvoiceID
		INNER JOIN Warehouse.StockItems AS si ON si.StockItemId = il.StockItemID
		WHERE i.InvoiceDate BETWEEN '20160101' AND '20161231'
		GROUP BY si.StockItemName, MONTH(i.InvoiceDate)
)
,MonthCTE AS ( --месяцы
    SELECT 
    CTE1.mon 
	FROM CTE1
	GROUP BY mon
)
, TopItemsCTE AS ( --первый и второй запрос соединяем вместе
	SELECT 
	    t2.mon, t2.Qt, t2.StockItemName
    FROM MonthCTE CTE2
	INNER JOIN CTE1 t2 ON t2.mon = CTE2.mon
	WHERE t2.StockItemName IN (SELECT TOP 2 CTE1.StockItemName
	              FROM CTE1 
				  WHERE CTE1.mon = CTE2.mon
				  ORDER BY CTE1.Qt DESC
				 )
)
SELECT 
    TopItemsCTE.mon, 
    TopItemsCTE.StockItemName,
    TopItemsCTE.Qt
FROM TopItemsCTE 
ORDER BY TopItemsCTE.mon ASC, TopItemsCTE.Qt DESC



/*
4. Функции одним запросом
Посчитайте по таблице товаров (в вывод также должен попасть ид товара, название, брэнд и цена):
* пронумеруйте записи по названию товара, так чтобы при изменении буквы алфавита нумерация начиналась заново
* посчитайте общее количество товаров и выведете полем в этом же запросе
* посчитайте общее количество товаров в зависимости от первой буквы названия товара
* отобразите следующий id товара исходя из того, что порядок отображения товаров по имени 
* предыдущий ид товара с тем же порядком отображения (по имени)
* названия товара 2 строки назад, в случае если предыдущей строки нет нужно вывести "No items"
* сформируйте 30 групп товаров по полю вес товара на 1 шт

Для этой задачи НЕ нужно писать аналог без аналитических функций.
*/

SELECT
   si.StockItemId
  ,si.StockItemName
  ,si.Brand
  ,si.UnitPrice
  ,ROW_NUMBER() OVER(PARTITION BY LEFT(si.StockItemName,1) ORDER BY si.StockItemName) RnStockItemName
  ,COUNT(*) OVER() TotalRows
  ,COUNT(*) OVER(PARTITION BY LEFT(si.StockItemName,1)) TotalRowsWithTheSameStartLetter
  ,LEAD(si.StockItemID) OVER(ORDER BY si.StockItemName) NextStockItemId
  ,LAG(si.StockItemID) OVER(ORDER BY si.StockItemName) PreviousStockItemId
  ,LAG(si.StockItemName,2,'No items') OVER(ORDER BY si.StockItemName) PreviousTwoStockItemName
  ,NTILE(30) OVER (ORDER BY TypicalWeightPerUnit) AS GroupWeight
  ,TypicalWeightPerUnit
FROM Warehouse.StockItems AS si
--ORDER BY TypicalWeightPerUnit, GroupWeight
ORDER BY si.StockItemName



/*
5. По каждому сотруднику выведите последнего клиента, которому сотрудник что-то продал.
   В результатах должны быть ид и фамилия сотрудника, ид и название клиента, дата продажи, сумму сделки.
*/
--БЕЗ ОКОННОЙ ФУНКЦИИ
;WITH InvoiceCTE AS (
   SELECT 
       i.InvoiceID,
       i.InvoiceDate,
	   SUM(il.ExtendedPrice) AmountOfSale,
	   i.SalespersonPersonID AS SalesPersonId,
	   i.CustomerID AS CustomerId
   FROM Sales.Invoices AS i
   INNER JOIN Sales.InvoiceLines AS il ON il.InvoiceID = i.InvoiceID
   GROUP BY i.InvoiceDate, i.SalespersonPersonID, i.CustomerID, i.InvoiceID
),
sellers AS (
	SELECT
	    SalesPersonId,
		(
		   SELECT TOP 1 cte.InvoiceID
		   FROM InvoiceCTE cte
		   WHERE cte.SalesPersonId = iCTE.SalesPersonId
		   ORDER BY cte.InvoiceDate  DESC, cte.InvoiceID DESC
		) lastInvoiceId
    FROM InvoiceCTE iCTE
	GROUP BY SalesPersonId
)

SELECT 
   icte.SalesPersonId SalesPersonId,
   p.FullName SalesPersonName,
   icte.CustomerId AS CustomerId,
   c.CustomerName AS CustomerName,
   icte.InvoiceDate AS InvoiceDate,
   icte.AmountOfSale AS AmountOfSale
FROM sellers AS s
INNER JOIN InvoiceCTE AS icte ON icte.InvoiceID = s.lastInvoiceId
INNER JOIN Application.People AS p ON p.PersonID = icte.SalesPersonId
INNER JOIN Sales.Customers AS c ON c.CustomerId = icte.CustomerId
ORDER BY SalesPersonId 

--С ОКОННОЙ ФУНКЦИЕЙ
;WITH InvoiceCTE AS (
   SELECT 
       i.InvoiceID,
       i.InvoiceDate,
	   SUM(il.ExtendedPrice) AmountOfSale,
	   i.SalespersonPersonID AS SalesPersonId,
	   i.CustomerID AS CustomerId,
	   FIRST_VALUE(i.InvoiceId) OVER (PARTITION BY i.SalespersonPersonId ORDER BY i.InvoiceId DESC) LastInvoiceId
   FROM Sales.Invoices AS i
   INNER JOIN Sales.InvoiceLines AS il ON il.InvoiceID = i.InvoiceID
   GROUP BY i.InvoiceDate, i.SalespersonPersonID, i.CustomerID, i.InvoiceID
)

SELECT 
   tCTE.SalesPersonId SalesPersonId,
   p.FullName SalesPersonName,
   tCTE.CustomerId AS CustomerId,
   c.CustomerName AS CustomerName,
   tCTE.InvoiceDate AS InvoiceDate,
   tCTE.AmountOfSale AS AmountOfSale
FROM InvoiceCTE tCTE
INNER JOIN Application.People AS p ON p.PersonID = tCTE.SalesPersonId
INNER JOIN Sales.Customers AS c ON c.CustomerId = tCTE.CustomerId
WHERE tCTE.InvoiceID = tCTE.LastInvoiceId
ORDER BY SalesPersonId 



/*
6. Выберите по каждому клиенту два самых дорогих товара, которые он покупал.
В результатах должно быть ид клиета, его название, ид товара, цена, дата покупки.
*/
;WITH CTE AS (
	SELECT 
	  i.CustomerID, 
	  il.StockItemId, 
	  il.UnitPrice, 
	  MAX(i.InvoiceDate) InvoiceDate,
	  ROW_NUMBER() OVER (PARTITION BY i.CustomerId ORDER BY il.UnitPrice DESC, StockItemId) rn
	FROM Sales.Invoices AS i
	INNER JOIN Sales.InvoiceLines AS il ON il.InvoiceID = i.InvoiceID
	GROUP BY i.CustomerID, il.StockItemId, il.UnitPrice
)

SELECT 
	c.CustomerID,
	c.CustomerName,
	CTE.StockItemID, 
	CTE.UnitPrice,
	CTE.InvoiceDate
FROM CTE
INNER JOIN Sales.Customers AS c ON c.CustomerID = CTE.CustomerID
WHERE rn <= 2
ORDER BY c.CustomerId, CTE.UnitPrice DESC

--Опционально НЕ ПОЛУЧИЛОСЬ, приведите пример!
--Опционально можете для каждого запроса без оконных функций сделать вариант запросов с оконными функциями и сравнить их производительность. 
