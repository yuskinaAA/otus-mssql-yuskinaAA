/*
Домашнее задание по курсу MS SQL Server Developer в OTUS.
Занятие "02 - Оператор SELECT и простые фильтры, JOIN".

Задания выполняются с использованием базы данных WideWorldImporters.

Бэкап БД WideWorldImporters можно скачать отсюда:
https://github.com/Microsoft/sql-server-samples/releases/download/wide-world-importers-v1.0/WideWorldImporters-Full.bak

Описание WideWorldImporters от Microsoft:
* https://docs.microsoft.com/ru-ru/sql/samples/wide-world-importers-what-is
* https://docs.microsoft.com/ru-ru/sql/samples/wide-world-importers-oltp-database-catalog
*/

-- ---------------------------------------------------------------------------
-- Задание - написать выборки для получения указанных ниже данных.
-- ---------------------------------------------------------------------------

USE WideWorldImporters

/*
1. Все товары, в названии которых есть "urgent" или название начинается с "Animal".
Вывести: ИД товара (StockItemID), наименование товара (StockItemName).
Таблицы: Warehouse.StockItems.
*/

SELECT 
    StockItemID AS [ИД товара],
	StockItemName AS [Наименование товара]
FROM Warehouse.StockItems
WHERE StockItemName LIKE '%urgent%' OR StockItemName LIKE 'Animal%'

/*
2. Поставщиков (Suppliers), у которых не было сделано ни одного заказа (PurchaseOrders).
Сделать через JOIN, с подзапросом задание принято не будет.
Вывести: ИД поставщика (SupplierID), наименование поставщика (SupplierName).
Таблицы: Purchasing.Suppliers, Purchasing.PurchaseOrders.
По каким колонкам делать JOIN подумайте самостоятельно.
*/

SELECT
    s.SupplierID AS [ИД поставщика],
	s.SupplierName AS [Наименование поставщика]
FROM Purchasing.Suppliers AS s
LEFT JOIN Purchasing.PurchaseOrders AS po ON po.SupplierID = s.SupplierID
WHERE po.PurchaseOrderID IS NULL
GROUP BY s.SupplierID, s.SupplierName

--OR

SELECT
    s.SupplierID AS [ИД поставщика],
	s.SupplierName AS [Наименование поставщика]
FROM Purchasing.Suppliers AS s
LEFT JOIN Purchasing.PurchaseOrders AS po ON po.SupplierID = s.SupplierID
GROUP BY s.SupplierID, s.SupplierName
HAVING count(po.PurchaseOrderID) = 0

/*
3. Заказы (Orders) с ценой товара (UnitPrice) более 100$ 
либо количеством единиц (Quantity) товара более 20 штук
и присутствующей датой комплектации всего заказа (PickingCompletedWhen).
Вывести:
* OrderID
* дату заказа (OrderDate) в формате ДД.ММ.ГГГГ
* название месяца, в котором был сделан заказ
* номер квартала, в котором был сделан заказ
* треть года, к которой относится дата заказа (каждая треть по 4 месяца)
* имя заказчика (Customer)
Добавьте вариант этого запроса с постраничной выборкой,
пропустив первую 1000 и отобразив следующие 100 записей.

Сортировка должна быть по номеру квартала, трети года, дате заказа (везде по возрастанию).

Таблицы: Sales.Orders, Sales.OrderLines, Sales.Customers.
*/

SELECT
o.OrderID AS [ИД заказа],
CONVERT(VARCHAR(10), o.OrderDate, 104) AS [Дата заказа],
DATENAME(m, o.OrderDate) [Месяц],
DATENAME(q, o.OrderDate) [Номер квартала],
CASE WHEN MONTH(o.OrderDate) IN (1,2,3,4) THEN 1
     WHEN MONTH(o.OrderDate) IN (5,6,7,8) THEN 2
	 ELSE 3
END AS [Треть года],
c.CustomerName AS [Имя заказчика]
FROM Sales.Orders AS o
INNER JOIN Sales.OrderLines AS ol ON ol.OrderID = o.OrderID
INNER JOIN Sales.Customers AS c ON o.CustomerID = c.CustomerID
WHERE (ol.UnitPrice > 100 OR ol.Quantity > 20) AND ol.PickingCompletedWhen IS NOT NULL
GROUP BY o.OrderID, o.OrderDate, c.CustomerName
ORDER BY [Номер квартала], [Треть года], [Дата заказа]

--пропустив первую 1000 и отобразив следующие 100 записей.

SELECT
o.OrderID AS [ИД заказа],
CONVERT(VARCHAR(10), o.OrderDate, 104) AS [Дата заказа],
DATENAME(m, o.OrderDate) [Месяц],
DATENAME(q, o.OrderDate) [Номер квартала],
CASE WHEN MONTH(o.OrderDate) IN (1,2,3,4) THEN 1
     WHEN MONTH(o.OrderDate) IN (5,6,7,8) THEN 2
	 ELSE 3
END AS [Треть года],
c.CustomerName AS [Имя заказчика]
FROM Sales.Orders AS o
INNER JOIN Sales.OrderLines AS ol ON ol.OrderID = o.OrderID
INNER JOIN Sales.Customers AS c ON o.CustomerID = c.CustomerID
WHERE (ol.UnitPrice > 100 OR ol.Quantity > 20) AND ol.PickingCompletedWhen IS NOT NULL
GROUP BY o.OrderID, o.OrderDate, c.CustomerName
ORDER BY [Номер квартала], [Треть года], [Дата заказа]
OFFSET 1000 ROWS FETCH FIRST 100 ROWS ONLY

/*
4. Заказы поставщикам (Purchasing.Suppliers),
которые должны быть исполнены (ExpectedDeliveryDate) в январе 2013 года
с доставкой "Air Freight" или "Refrigerated Air Freight" (DeliveryMethodName)
и которые исполнены (IsOrderFinalized).
Вывести:
* способ доставки (DeliveryMethodName)
* дата доставки (ExpectedDeliveryDate)
* имя поставщика
* имя контактного лица принимавшего заказ (ContactPerson)

Таблицы: Purchasing.Suppliers, Purchasing.PurchaseOrders, Application.DeliveryMethods, Application.People.
*/

SELECT 
	dm.DeliveryMethodName,
	po.ExpectedDeliveryDate,
	s.SupplierName,
	p.FullName
FROM Purchasing.PurchaseOrders po
INNER JOIN Application.DeliveryMethods dm ON dm.DeliveryMethodID = po.DeliveryMethodID
INNER JOIN Purchasing.Suppliers s ON s.SupplierID = po.SupplierID
LEFT JOIN Application.People p ON p.PersonID = po.ContactPersonID
WHERE 
(dm.DeliveryMethodName = 'Air Freight' OR dm.DeliveryMethodName = 'Refrigerated Air Freight')
AND po.IsOrderFinalized = 1
AND po.ExpectedDeliveryDate BETWEEN '20130101' AND '20130131'


/*
5. Десять последних продаж (по дате продажи) с именем клиента и именем сотрудника,
который оформил заказ (SalespersonPerson).
Сделать без подзапросов.
*/

SELECT 
    TOP 10
    sPerson.FullName [Заказ оформил],
    cPerson.FullName [Имя клиента],
    o.*
FROM Sales.Orders o
LEFT JOIN Application.People sPerson ON sPerson.PersonID = o.SalespersonPersonID
LEFT JOIN Application.People cPerson ON cPerson.PersonID = o.ContactPersonID
ORDER BY o.OrderDate DESC

/*
6. Все ид и имена клиентов и их контактные телефоны,
которые покупали товар "Chocolate frogs 250g".
Имя товара смотреть в таблице Warehouse.StockItems.
*/

SELECT 
	p.PersonID [ИД Клиента],
	p.FullName [Имя клиента],
	p.PhoneNumber [Телефон]
FROM Purchasing.PurchaseOrders AS po
INNER JOIN Purchasing.PurchaseOrderLines AS pol ON pol.PurchaseOrderID = po.PurchaseOrderID
INNER JOIN Warehouse.StockItems AS si ON si.StockItemID = pol.StockItemID
LEFT JOIN Application.People AS p ON p.PersonID = po.ContactPersonID
WHERE si.StockItemName = 'Chocolate frogs 250g'
GROUP BY p.PersonID, p.FullName, p.PhoneNumber
