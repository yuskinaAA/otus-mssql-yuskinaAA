/*
Домашнее задание по курсу MS SQL Server Developer в OTUS.

Занятие "08 - Выборки из XML и JSON полей".

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
Примечания к заданиям 1, 2:
* Если с выгрузкой в файл будут проблемы, то можно сделать просто SELECT c результатом в виде XML. 
* Если у вас в проекте предусмотрен экспорт/импорт в XML, то можете взять свой XML и свои таблицы.
* Если с этим XML вам будет скучно, то можете взять любые открытые данные и импортировать их в таблицы (например, с https://data.gov.ru).
* Пример экспорта/импорта в файл https://docs.microsoft.com/en-us/sql/relational-databases/import-export/examples-of-bulk-import-and-export-of-xml-documents-sql-server
*/


/*
1. В личном кабинете есть файл StockItems.xml.
Это данные из таблицы Warehouse.StockItems.
Преобразовать эти данные в плоскую таблицу с полями, аналогичными Warehouse.StockItems.
Поля: StockItemName, SupplierID, UnitPackageID, OuterPackageID, QuantityPerOuter, TypicalWeightPerUnit, LeadTimeDays, IsChillerStock, TaxRate, UnitPrice 

Загрузить эти данные в таблицу Warehouse.StockItems: 
существующие записи в таблице обновить, отсутствующие добавить (сопоставлять записи по полю StockItemName). 

Сделать два варианта: с помощью OPENXML и через XQuery.
*/

--OPENXML
DECLARE @XmlDocument XML
DECLARE @docHandle INT

SELECT @xmlDocument = BulkColumn
FROM OPENROWSET
(BULK 'C:\Users\yaa\Documents\StockItems.xml', SINGLE_CLOB)
AS data;

EXEC sp_xml_preparedocument @docHandle OUTPUT, @xmlDocument

;WITH StockItemsCTE AS 
(
            SELECT 
			    *
			FROM OPENXML(@docHandle, N'/StockItems/Item')
			WITH ( 
				[StockItemName] NVARCHAR(100)  '@Name',
				[SupplierID] INT 'SupplierID',
				[UnitPackageID] INT 'Package/UnitPackageID',
				[OuterPackageID] INT 'Package/OuterPackageID',
				[QuantityPerOuter] INT 'Package/QuantityPerOuter',
				[TypicalWeightPerUnit] DECIMAL(18,3) 'Package/TypicalWeightPerUnit',
				[LeadTimeDays] INT 'LeadTimeDays',
				[IsChillerStock] INT 'IsChillerStock',
				[TaxRate] DECIMAL(18,3) 'TaxRate',
				[UnitPrice] DECIMAL(18,2) 'UnitPrice')
)
MERGE Warehouse.StockItems AS si
  USING ( SELECT * FROM StockItemsCTE) AS siXML 
	   (
	    [StockItemName], [SupplierID], [UnitPackageID], [OuterPackageID],
	    [QuantityPerOuter], [TypicalWeightPerUnit], [LeadTimeDays], 
		[IsChillerStock], [TaxRate], [UnitPrice] 
	   )  
	   ON (si.StockItemName = siXML.StockItemName)
	   WHEN MATCHED THEN
        UPDATE SET 
		   [SupplierID] = siXML.SupplierID,
		   [UnitPackageID] = siXML.UnitPackageID,
		   [OuterPackageID] = siXML.OuterPackageID,
		   [QuantityPerOuter] = siXML.QuantityPerOuter,
		   [TypicalWeightPerUnit] = siXML.TypicalWeightPerUnit,
		   [LeadTimeDays] = siXML.LeadTimeDays,
		   [IsChillerStock] = siXML.IsChillerStock,
		   [TaxRate] = siXML.TaxRate,
		   [UnitPrice] = siXML.UnitPrice
	   WHEN NOT MATCHED THEN  
        INSERT (StockItemName, SupplierID, UnitPackageID, OuterPackageID, QuantityPerOuter, TypicalWeightPerUnit, LeadTimeDays, IsChillerStock, TaxRate, UnitPrice)  
        VALUES (siXML.StockItemName, siXML.SupplierID, siXML.UnitPackageID, siXML.OuterPackageID, siXML.QuantityPerOuter, siXML.TypicalWeightPerUnit, siXML.LeadTimeDays, siXML.IsChillerStock, siXML.TaxRate, siXML.UnitPrice);

EXEC sp_xml_removedocument @docHandle;		


--XQuery
DECLARE @XmlDocument XML

SELECT @xmlDocument = BulkColumn
FROM OPENROWSET
(BULK 'C:\Users\yaa\Documents\StockItems.xml', SINGLE_CLOB)
AS data;

;WITH StockItemsCTE AS (
    SELECT
				t.Item.value('(@Name)[1]', 'NVARCHAR(100)') AS [StockItemName],
				t.Item.value('SupplierID[1]', 'INT') AS [SupplierID],
				t.Item.value('(Package/UnitPackageID)[1]', 'INT') AS [UnitPackageID],
				t.Item.value('(Package/OuterPackageID)[1]', 'INT') AS [OuterPackageID],
				t.Item.value('(Package/QuantityPerOuter)[1]', 'INT') AS [QuantityPerOuter],
				t.Item.value('(Package/TypicalWeightPerUnit)[1]', 'DECIMAL(18,3)') AS [TypicalWeightPerUnit],
				t.Item.value('(LeadTimeDays)[1]', 'INT') AS [LeadTimeDays],
				t.Item.value('(IsChillerStock)[1]', 'INT') AS [IsChillerStock],
				t.Item.value('(TaxRate)[1]', 'DECIMAL(18,3)') AS [TaxRate],
				t.Item.value('(UnitPrice)[1]', 'DECIMAL(18,2)') AS [UnitPrice]
   FROM @XmlDocument.nodes('/StockItems/Item') AS t(Item)
)

MERGE Warehouse.StockItems AS si
  USING ( SELECT * FROM StockItemsCTE) AS siXML 
        (
	      [StockItemName], [SupplierID], [UnitPackageID], [OuterPackageID],
	      [QuantityPerOuter], [TypicalWeightPerUnit], [LeadTimeDays], 
		  [IsChillerStock], [TaxRate], [UnitPrice] 
	    ) ON (si.StockItemName = siXML.StockItemName)
	   WHEN MATCHED THEN
        UPDATE SET 
		   [SupplierID] = siXML.SupplierID,
		   [UnitPackageID] = siXML.UnitPackageID,
		   [OuterPackageID] = siXML.OuterPackageID,
		   [QuantityPerOuter] = siXML.QuantityPerOuter,
		   [TypicalWeightPerUnit] = siXML.TypicalWeightPerUnit,
		   [LeadTimeDays] = siXML.LeadTimeDays,
		   [IsChillerStock] = siXML.IsChillerStock,
		   [TaxRate] = siXML.TaxRate,
		   [UnitPrice] = siXML.UnitPrice
	   WHEN NOT MATCHED THEN  
        INSERT (StockItemName, SupplierID, UnitPackageID, OuterPackageID, QuantityPerOuter, TypicalWeightPerUnit, LeadTimeDays, IsChillerStock, TaxRate, UnitPrice)  
        VALUES (siXML.StockItemName, siXML.SupplierID, siXML.UnitPackageID, siXML.OuterPackageID, siXML.QuantityPerOuter, siXML.TypicalWeightPerUnit, siXML.LeadTimeDays, siXML.IsChillerStock, siXML.TaxRate, siXML.UnitPrice)
       OUTPUT deleted.*, $action, inserted.*;
/*
2. Выгрузить данные из таблицы StockItems в такой же xml-файл, как StockItems.xml
*/

--Выгрузка в файле StockItems_OUT.xml
DECLARE @queryText VARCHAR(1000)
DECLARE @cmd VARCHAR(8000)
DECLARE @serverName VARCHAR(50)
DECLARE @res INT

SET @serverName = ' -S "' + CAST(SERVERPROPERTY('ServerName') AS VARCHAR) + '"'

SET @queryText = ''
SET @queryText +=' SELECT '
SET @queryText +='	StockItemName AS ''@Name'','
SET @queryText +='		SupplierID AS ''SupplierID'', '
SET @queryText +='		UnitPackageID AS ''Package/UnitPackageID'', '
SET @queryText +='		OuterPackageID AS ''Package/OuterPackageID'', '
SET @queryText +='		QuantityPerOuter AS ''Package/QuantityPerOuter'', '
SET @queryText +='		TypicalWeightPerUnit AS ''Package/TypicalWeightPerUnit'', '
SET @queryText +='		LeadTimeDays AS ''LeadTimeDays'', '
SET @queryText +='		IsChillerStock AS ''IsChillerStock'', '
SET @queryText +='		TaxRate AS ''TaxRate'', '
SET @queryText +='		UnitPrice AS ''UnitPrice'' '
SET @queryText +='	FROM WideWorldImporters.Warehouse.StockItems '
SET @queryText +='	ORDER BY StockItemName '
SET @queryText +='	FOR XML PATH(''Item''), ROOT(''StockItems'') '

SET @cmd = ' bcp "' + @queryText + '" queryout C:\Users\yaa\Documents\StockItems_OUT.xml -w -r -T' + @serverName
EXEC master..xp_cmdshell @cmd

/*
3. В таблице Warehouse.StockItems в колонке CustomFields есть данные в JSON.
Написать SELECT для вывода:
- StockItemID
- StockItemName
- CountryOfManufacture (из CustomFields)
- FirstTag (из поля CustomFields, первое значение из массива Tags)
*/

SELECT
  StockItemID,
  StockItemName,
  JSON_VALUE(CustomFields, '$.CountryOfManufacture') AS CountryOfManufacture,
  JSON_VALUE(CustomFields, '$.Tags[0]') AS FirstTag
FROM Warehouse.StockItems AS si

/*
4. Найти в StockItems строки, где есть тэг "Vintage".
Вывести: 
- StockItemID
- StockItemName
- (опционально) все теги (из CustomFields) через запятую в одном поле

Тэги искать в поле CustomFields, а не в Tags.
Запрос написать через функции работы с JSON.
Для поиска использовать равенство, использовать LIKE запрещено.

Должно быть в таком виде:
... where ... = 'Vintage'

Так принято не будет:
... where ... Tags like '%Vintage%'
... where ... CustomFields like '%Vintage%' 
*/

SELECT 
	StockItemID,
	StockItemName,
	(
		SELECT [key] + ','
		FROM OPENJSON (CustomFields, '$')
		FOR XML PATH('')
	) AS allTagsV1,
	(
		SELECT STRING_AGG([key], ',')
		FROM OPENJSON (CustomFields, '$')
	) AS allTagsV2
FROM Warehouse.StockItems 
CROSS APPLY OPENJSON(CustomFields, '$.Tags') customField
WHERE customField.[Value] = 'Vintage'

