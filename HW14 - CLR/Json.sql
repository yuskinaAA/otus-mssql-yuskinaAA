USE WideWorldImporters;
GO

-- Определение переменной с типом JSONClr
DECLARE @json JSONClr;
SET @json = '{"key":"value"}';
SELECT 
	@json AS [Binary], 
	@json.ToString() AS [ToString];
GO

-- NULL
DECLARE @json JsonClr;
SELECT 
	@json AS [Binary], 
	@json.ToString() AS [ToString];
GO

-- C# source

-- Валидация (вызывается Parse())
DECLARE @json JsonCLR;
SET @json = '{"key":1';
GO

--Значение через свойство
DECLARE @json JsonCLR;
SET @json = '{"key":2}';
SET @json.Json = '{"key":1}';
SELECT 
	@json AS [Binary], 
	@json.ToString() AS [ToString]
GO

-- Пример использования как типа колонки
DROP TABLE IF EXISTS TestTable;
GO

CREATE TABLE TestTable
(
	Info JsonCLR
);
GO

INSERT INTO TestTable VALUES('{"squadName": "Super hero squad", "homeTown": "Metro City", "formed": 2016, "secretBase": "Super tower",  "active": true}');
GO

SELECT Info.Json FROM TestTable;
GO

-- ошибка (значение не валидное)
INSERT INTO TestTable VALUES('{"squadName": "Super hero squad", "homeTown": "Metro City", "formed": 2016, "secretBase": "Super tower",  "active" true}');
GO

SELECT 
 tt.Info,
 tt.Info.ToString() AS Json_ToString
FROM TestTable tt;
GO

DROP TABLE TestTable;
GO