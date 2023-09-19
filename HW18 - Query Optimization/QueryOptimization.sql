/*
Исходный запрос

Select ord.CustomerID, 
       det.StockItemID, 
	   SUM(det.UnitPrice), 
	   SUM(det.Quantity), 
	   COUNT(ord.OrderID)
FROM Sales.Orders AS ord 
JOIN Sales.OrderLines AS det ON det.OrderID = ord.OrderID
JOIN Sales.Invoices AS Inv ON Inv.OrderID = ord.OrderID
JOIN Sales.CustomerTransactions AS Trans ON Trans.InvoiceID = Inv.InvoiceID
JOIN Warehouse.StockItemTransactions AS ItemTrans ON ItemTrans.StockItemID = det.StockItemID
WHERE Inv.BillToCustomerID != ord.CustomerID
AND		(Select 
			SupplierId
		 FROM Warehouse.StockItems AS It
		 Where It.StockItemID = det.StockItemID) = 12
AND 
     (SELECT SUM(Total.UnitPrice*Total.Quantity)
	  FROM Sales.OrderLines AS Total
	  Join Sales.Orders AS ordTotal On ordTotal.OrderID = Total.OrderID
	  WHERE ordTotal.CustomerID = Inv.CustomerID) > 250000
AND DATEDIFF(dd, Inv.InvoiceDate, ord.OrderDate) = 0
GROUP BY ord.CustomerID, det.StockItemID
ORDER BY ord.CustomerID, det.StockItemID
*/

/*
   Статистика по исходному запросу

    Table 'StockItemTransactions'. Scan count 1, logical reads 0, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 29, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
	Table 'StockItemTransactions'. Segment reads 1, segment skipped 0.
	Table 'OrderLines'. Scan count 4, logical reads 0, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 331, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
	Table 'OrderLines'. Segment reads 2, segment skipped 0.
	Table 'Worktable'. Scan count 0, logical reads 0, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
	Table 'CustomerTransactions'. Scan count 5, logical reads 261, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
	Table 'Orders'. Scan count 2, logical reads 883, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
	Table 'Invoices'. Scan count 1, logical reads 44525, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
	Table 'StockItems'. Scan count 1, logical reads 2, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.

	1 ВАРИАНТ ОПТИМИЗАЦИИ
	Статистика после оптимизации

    Table 'OrderLines'. Scan count 4, logical reads 0, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 518, lob physical reads 4, lob page server reads 0, lob read-ahead reads 795, lob page server read-ahead reads 0.
    Table 'OrderLines'. Segment reads 2, segment skipped 0.
	Table 'Worktable'. Scan count 0, logical reads 0, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
    Table 'CustomerTransactions'. Scan count 5, logical reads 261, physical reads 4, page server reads 0, read-ahead reads 253, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
    Table 'Orders'. Scan count 2, logical reads 314, physical reads 1, page server reads 0, read-ahead reads 155, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
    Table 'Invoices'. Scan count 1, logical reads 223, physical reads 1, page server reads 0, read-ahead reads 221, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
    Table 'StockItemTransactions'. Scan count 1, logical reads 3, physical reads 2, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.

	2 ВАРИАНТ ОПТИМИЗАЦИИ
	Статистика после оптимизации
	Table 'Orders'. Scan count 3, logical reads 157, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 76, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
    Table 'Orders'. Segment reads 1, segment skipped 0.
	Table 'OrderLines'. Scan count 2, logical reads 0, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 168, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
    Table 'OrderLines'. Segment reads 1, segment skipped 0.
    Table 'Worktable'. Scan count 0, logical reads 0, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
    Table 'CustomerTransactions'. Scan count 5, logical reads 261, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
    Table 'Invoices'. Scan count 1, logical reads 223, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
    Table 'StockItemTransactions'. Scan count 1, logical reads 3, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.



Оптимизация 1 ВАРИАНТ:
1. Убрала подзапрос

         (SELECT 
			SupplierId
		 FROM Warehouse.StockItems AS It
		 Where It.StockItemID = det.StockItemID) = 12

Так как запрос 
		SELECT * FROM Warehouse.StockItems si
		INNER JOIN Warehouse.StockItemTransactions siTran ON si.StockItemID = siTran.StockItemID
		WHERE si.SupplierID <> siTran.SupplierID
показал, что SupplierID в таблицах Warehouse.StockItems и Warehouse.StockItemTransactions совпадают

Чтобы избавиться от keyLookup обновила индекс
CREATE NONCLUSTERED INDEX [FK_Warehouse_StockItemTransactions_SupplierID_StockItemId] ON [Warehouse].[StockItemTransactions]
(
	[SupplierID] ASC,
	[StockItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [USERDATA]
GO
РЕЗУЛЬТАТ: Index Seek(15 строк) вместо Columnstore Index Scan(15876 строк)

2. Подзапрос вынесла в cte, далее сджойнила с таблицей Invoices
РЕЗУЛЬТАТ: Количество логических чтений уменьшилось Invoices с 44525 до 223 (только появилось физическое чтение. Почему? Памяти не хватило?)
                                                    Orders   c 883 до 314 

РЕЗУЛЬТАТ ЗАПРОСА
*/
;WITH cteCustomers AS (
      SELECT Total.CustomerID
	  FROM Sales.Orders AS Total
	  JOIN Sales.OrderLines AS ordTotal On ordTotal.OrderID = Total.OrderID
	  GROUP BY Total.CustomerID 
	  HAVING SUM(ordTotal.UnitPrice*ordTotal.Quantity) > 250000
)
SELECT
    ord.CustomerID, 
    det.StockItemID, 
	SUM(det.UnitPrice), 
	SUM(det.Quantity), 
	COUNT(ord.OrderID)
FROM Sales.Orders AS ord 
JOIN Sales.OrderLines AS det ON det.OrderID = ord.OrderID
JOIN Sales.Invoices AS Inv ON Inv.OrderID = ord.OrderID
JOIN cteCustomers ct ON ct.CustomerID = Inv.CustomerID
JOIN Sales.CustomerTransactions AS Trans ON Trans.InvoiceID = Inv.InvoiceID
JOIN Warehouse.StockItemTransactions AS ItemTrans ON ItemTrans.StockItemID = det.StockItemID AND ItemTrans.SupplierID = 12
WHERE Inv.BillToCustomerID != ord.CustomerID
AND Inv.InvoiceDate = ord.OrderDate
GROUP BY ord.CustomerID, det.StockItemID
ORDER BY ord.CustomerID, det.StockItemID


/*
Оптимизация 2 ВАРИАНТ:
То же самое что и в 1 ВАРИАНТЕ

Избавиться от поиска по OrderLines можно если в Orders добавить колонку Total = UnitPrice*Quantity + колоночный индекс на CustomerId, Total
РЕЗУЛЬТАТ относительно первой оптимизации: Количество Orders   c 314  до 157 
*/
ALTER TABLE Sales.Orders ADD Total DECIMAL(18,2)

UPDATE o
SET Total = odet.Total
FROM Sales.Orders o
INNER JOIN 
(
   SELECT SUM(ordl.UnitPrice*ordl.Quantity) total, ord.OrderId
   FROM Sales.Orders ord
   INNER JOIN Sales.OrderLines ordl ON ordl.OrderID = ord.OrderID
   GROUP BY ord.OrderID
) odet ON odet.OrderID = o.OrderID

;with cteCustomers AS (
SELECT 
	Total.CustomerID
FROM Sales.Orders AS Total
GROUP BY Total.CustomerID 
HAVING SUM(Total.Total) > 250000

)
SELECT
    ord.CustomerID, 
    det.StockItemID, 
	SUM(det.UnitPrice), 
	SUM(det.Quantity), 
	COUNT(ord.OrderID)
FROM Sales.Orders AS ord 
JOIN Sales.OrderLines AS det ON det.OrderID = ord.OrderID
JOIN Sales.Invoices AS Inv ON Inv.OrderID = ord.OrderID
JOIN cteCustomers ct ON ct.CustomerID = Inv.CustomerID
JOIN Sales.CustomerTransactions AS Trans ON Trans.InvoiceID = Inv.InvoiceID
JOIN Warehouse.StockItemTransactions AS ItemTrans ON ItemTrans.StockItemID = det.StockItemID AND ItemTrans.SupplierID = 12
WHERE Inv.BillToCustomerID != ord.CustomerID
AND Inv.InvoiceDate = ord.OrderDate
GROUP BY ord.CustomerID, det.StockItemID
ORDER BY ord.CustomerID, det.StockItemID
