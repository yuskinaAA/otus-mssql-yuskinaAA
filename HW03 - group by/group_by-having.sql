/*
Домашнее задание по курсу MS SQL Server Developer в OTUS.
Занятие "02 - Оператор SELECT и простые фильтры, GROUP BY, HAVING".

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
1. Посчитать среднюю цену товара, общую сумму продажи по месяцам.
Вывести:
* Год продажи (например, 2015)
* Месяц продажи (например, 4)
* Средняя цена за месяц по всем товарам
* Общая сумма продаж за месяц

Продажи смотреть в таблице Sales.Invoices и связанных таблицах.
*/

SELECT 
	YEAR(i.InvoiceDate) [Год продажи],
	MONTH(i.InvoiceDate) [Месяц продажи],
	AVG(il.ExtendedPrice/il.Quantity) AS [Средняя цена товара с налогом],
	SUM(il.ExtendedPrice) [Общая сумма продажи]
FROM Sales.Invoices i
INNER JOIN Sales.InvoiceLines il ON il.InvoiceID = i.InvoiceID
GROUP BY MONTH(i.InvoiceDate), YEAR(i.InvoiceDate)
ORDER BY [Год продажи], [Месяц продажи]


/*
2. Отобразить все месяцы, где общая сумма продаж превысила 4 600 000

Вывести:
* Год продажи (например, 2015)
* Месяц продажи (например, 4)
* Общая сумма продаж

Продажи смотреть в таблице Sales.Invoices и связанных таблицах.
*/

SELECT 
	YEAR(i.InvoiceDate) AS [Год продажи],
	MONTH(i.InvoiceDate) AS [Месяц продажи],
	SUM(il.ExtendedPrice) AS [Общая сумма продажи]
FROM Sales.Invoices i
INNER JOIN Sales.InvoiceLines il ON il.InvoiceID = i.InvoiceID
GROUP BY YEAR(i.InvoiceDate), MONTH(i.InvoiceDate)
HAVING SUM(il.ExtendedPrice) > 4600000
ORDER BY [Год продажи], [Месяц продажи]


/*
3. Вывести сумму продаж, дату первой продажи
и количество проданного по месяцам, по товарам,
продажи которых менее 50 ед в месяц.
Группировка должна быть по году,  месяцу, товару.

Вывести:
* Год продажи
* Месяц продажи
* Наименование товара
* Сумма продаж
* Дата первой продажи
* Количество проданного

Продажи смотреть в таблице Sales.Invoices и связанных таблицах.
*/

SELECT 
	YEAR(i.InvoiceDate) AS [Год продажи],
	MONTH(i.InvoiceDate) AS [Месяц продажи],
	si.StockItemName AS [Наименование товара],
	SUM(il.ExtendedPrice) AS [Общая сумма продажи], 
	MIN(i.InvoiceDate) AS [Дата первой продажи],
	SUM(il.Quantity) AS [Количество проданного]
FROM Sales.Invoices i
INNER JOIN Sales.InvoiceLines il ON il.InvoiceID = i.InvoiceID
INNER JOIN Warehouse.StockItems si ON si.StockItemID = il.StockItemID
GROUP BY YEAR(i.InvoiceDate), MONTH(i.InvoiceDate), si.StockItemName
HAVING SUM(il.Quantity) < 50
ORDER BY [Год продажи], [Месяц продажи], [Наименование товара]


-- ---------------------------------------------------------------------------
-- Опционально
-- ---------------------------------------------------------------------------
/*
Написать запросы 2-3 так, чтобы если в каком-то месяце не было продаж,
то этот месяц также отображался бы в результатах, но там были нули.
*/
/*
  Для 3-ьего
  Даты выбираю все что есть в таблице продаж, можно будет передавать параметрами
*/

DECLARE @maxdate DATE = (SELECT Max(dateadd(day, - datepart(day, ([InvoiceDate])) + 1, convert(date, ([InvoiceDate])))) FROM Sales.Invoices)

;WITH AllDate AS ( SELECT MIN(DATEADD(DAY, - DATEPART(DAY, ([InvoiceDate])) + 1, CONVERT(DATE, ([InvoiceDate])))) AS dt 
                  FROM Sales.Invoices

                  UNION ALL 

				  SELECT dateadd(mm, 1, dt) 
				  FROM AllDate 
				  WHERE dt < @maxdate) 

SELECT 
 COALESCE(t.[Год продажи], YEAR(c.dt)) [Год продажи],
 COALESCE(t.[Месяц продажи], MONTH(c.dt)) [Месяц продажи],
 COALESCE(t.[Наименование товара], '') [Наименование товара],
 COALESCE(t.[Общая сумма продажи], 0) [Общая сумма продажи],
 t.[Дата первой продажи] [Дата первой продажи],
 COALESCE(t.[Количество проданного], 0) [Количество проданного]
FROM AllDate c
LEFT JOIN (
		SELECT 
			YEAR(i.InvoiceDate) AS [Год продажи],
			MONTH(i.InvoiceDate) AS [Месяц продажи],
			si.StockItemName AS [Наименование товара],
			SUM(il.ExtendedPrice) AS [Общая сумма продажи], 
			MIN(i.InvoiceDate) AS [Дата первой продажи],
			SUM(il.Quantity) AS [Количество проданного]
		FROM Sales.Invoices i
		INNER JOIN Sales.InvoiceLines il ON il.InvoiceID = i.InvoiceID
		INNER JOIN Warehouse.StockItems si ON si.StockItemID = il.StockItemID
		GROUP BY YEAR(i.InvoiceDate), MONTH(i.InvoiceDate), si.StockItemName
		HAVING SUM(ISNULL(il.Quantity,0)) < 50
) t ON t.[Год продажи] = YEAR(c.dt) AND t.[Месяц продажи] = MONTH(c.dt)
ORDER BY YEAR(dt), MONTH(dt)

/*Для 2-го аналогично*/
DECLARE @maxdate DATE = (SELECT Max(dateadd(day, - datepart(day, ([InvoiceDate])) + 1, convert(date, ([InvoiceDate])))) FROM Sales.Invoices); 

WITH AllDate AS ( SELECT MIN(DATEADD(DAY, - DATEPART(DAY, ([InvoiceDate])) + 1, CONVERT(DATE, ([InvoiceDate])))) AS dt 
                  FROM Sales.Invoices

                  UNION ALL 

				  SELECT dateadd(mm, 1, dt) 
				  FROM AllDate 
				  WHERE dt < @maxdate) 

SELECT 
 COALESCE(t.[Год продажи], YEAR(c.dt)) [Год продажи],
 COALESCE(t.[Месяц продажи], MONTH(c.dt)) [Месяц продажи],
 COALESCE(t.[Общая сумма продажи], 0) [Общая сумма продажи]
FROM AllDate c
LEFT JOIN (
	SELECT 
		YEAR(i.InvoiceDate) AS [Год продажи],
		MONTH(i.InvoiceDate) AS [Месяц продажи],
		SUM(il.ExtendedPrice) AS [Общая сумма продажи]
	FROM Sales.Invoices i
	INNER JOIN Sales.InvoiceLines il ON il.InvoiceID = i.InvoiceID
	GROUP BY YEAR(i.InvoiceDate), MONTH(i.InvoiceDate)
	HAVING SUM(il.ExtendedPrice) > 4600000) t ON t.[Год продажи] = YEAR(c.dt) AND t.[Месяц продажи] = MONTH(c.dt)
ORDER BY YEAR(dt), MONTH(dt)