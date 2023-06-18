/*
Домашнее задание по курсу MS SQL Server Developer в OTUS.

Занятие "07 - Динамический SQL".

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

Это задание из занятия "Операторы CROSS APPLY, PIVOT, UNPIVOT."
Нужно для него написать динамический PIVOT, отображающий результаты по всем клиентам.
Имя клиента указывать полностью из поля CustomerName.

Требуется написать запрос, который в результате своего выполнения 
формирует сводку по количеству покупок в разрезе клиентов и месяцев.
В строках должны быть месяцы (дата начала месяца), в столбцах - клиенты.

Дата должна иметь формат dd.mm.yyyy, например, 25.12.2019.

Пример, как должны выглядеть результаты:
-------------+--------------------+--------------------+----------------+----------------------
InvoiceMonth | Aakriti Byrraju    | Abel Spirlea       | Abel Tatarescu | ... (другие клиенты)
-------------+--------------------+--------------------+----------------+----------------------
01.01.2013   |      3             |        1           |      4         | ...
01.02.2013   |      7             |        3           |      4         | ...
-------------+--------------------+--------------------+----------------+----------------------
*/


DECLARE @dynSql NVARCHAR(MAX)
DECLARE @columns NVARCHAR(MAX)

SELECT @columns= ISNULL(@columns + ',','') 
       + QUOTENAME(CustomerName)
FROM Sales.Invoices AS i
INNER JOIN Sales.Customers AS c ON c.CustomerID = i.CustomerId
GROUP BY c.CustomerName

SET @dynSql = '
;WITH InvoicesCTE AS (
	SELECT 
	    i.InvoiceId,
		CONVERT(varchar,DATEFROMPARTS(YEAR(i.InvoiceDate),MONTH(i.InvoiceDate),1),104) InvoiceMonth,
        c.CustomerName		
	FROM Sales.Invoices AS i
	INNER JOIN Sales.Customers AS c ON c.CustomerID = i.CustomerId
)
SELECT 
	*
FROM InvoicesCTE
PIVOT (COUNT(InvoiceId) FOR CustomerName
       IN (' + @columns +')
) as PivotTable
ORDER BY InvoiceMonth; '

EXEC sp_executesql @dynSql
