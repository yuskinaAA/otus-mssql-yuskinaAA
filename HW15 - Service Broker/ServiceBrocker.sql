/*
Реализация д/з по Service Broker

В качестве д/з берем по умолчанию:
	1. Создайте очередь для формирования отчетов для клиентов по таблице Invoices. При вызове процедуры для создания отчета в очередь должна отправляться заявка.
	2. При обработке очереди создавайте отчет по количеству заказов (Orders) по клиенту за заданный период времени и складывайте готовый отчет в новую таблицу.
	3. Проверьте, что вы корректно открываете и закрываете диалоги и у нас они не копятся.

В связи с тем что к заданию можно подходить двояко, я буду реализовывать следующее:
	По всем клиентам в Invoices вывести отчет вида(предполагаю вывести без всяких обращений к другим таблицам (возможна избыточность данных))
	IdКлиент  ИмяКлиента ДатаНачала ДатаОкончания ОбщееКоличествоЗаказов КоличествоОплаченныхЗаказов

*/

/*
    Шаг 1 
	Создадим таблицу
*/
USE WideWorldImporters

IF NOT EXISTS(SELECT 1 FROM sys.tables WHERE type = 'U' AND name = 'CustomerOrderQuantityReport')
BEGIN
   CREATE TABLE Sales.CustomerOrderQuantityReport
   (
      ReportId           INT IDENTITY(1,1),
	  CustomerId         INT NOT NULL,
	  CustomerName       NVARCHAR(100) NOT NULL,
	  DateFrom           DATE NOT NULL,
	  DateTo             DATE NOT NULL,
	  CountTotalOrders   INT NOT NULL,
	  CountInvoiceOrders INT NOT NULL,
	  DateCreated        DATETIME DEFAULT(GetUTCDate()) 
   )
END


/*
    Шаг 2
    Необходимо произвести настройки бд
*/

-- WITH ROLLBACK IMMEDIATE - откат всех незавершенных транзакций
-- NOWAIT - вернуть сообщение сразу после обнаружения блокировки таблицы.
USE master
GO

ALTER DATABASE WideWorldImporters
SET ENABLE_BROKER  WITH ROLLBACK IMMEDIATE;
GO
-- следует ли доверять экземпляру SQL Server базе данных и содержимому в ней
ALTER DATABASE WideWorldImporters SET TRUSTWORTHY ON;

-- авторизуемся под админом
ALTER AUTHORIZATION    
   ON DATABASE::WideWorldImporters TO [sa];

/*
    Шаг 3
	Создаем типы сообщений
*/
USE [WideWorldImporters]
GO

--тип сообщения для запроса
CREATE MESSAGE TYPE
    [//WWI/SB_HW/RequestMessage]
VALIDATION=WELL_FORMED_XML;
--тип сообщения для ответа
CREATE MESSAGE TYPE
    [//WWI/SB_HW/ReplyMessage]
VALIDATION=WELL_FORMED_XML;
GO

--создадим контракт
CREATE CONTRACT [//WWI/SB_HW/Contract]
     ([//WWI/SB_HW/RequestMessage]
      SENT BY INITIATOR,
      [//WWI/SB_HW/ReplyMessage]
      SENT BY TARGET
      );
GO

/*
    Шаг 4
	Создаем очереди и сервис
*/
USE [WideWorldImporters]
GO

CREATE QUEUE TargetHWQueueWWI; --тот кто принимает

CREATE SERVICE [//WWI/SB_HW/TargetService] ON QUEUE TargetHWQueueWWI ([//WWI/SB_HW/Contract]);
GO


CREATE QUEUE InitiatorHWQueueWWI; --инициатор сообщений

CREATE SERVICE [//WWI/SB_HW/InitiatorService] ON QUEUE InitiatorHWQueueWWI ([//WWI/SB_HW/Contract]);
GO

/*
    Шаг 5
	Создаем процедуры
*/
USE [WideWorldImporters]
GO

-- процедура на отправку сообщения
CREATE OR ALTER PROCEDURE Sales.SendRequestForCustomerReport
(
     @customerId INT 
	,@dateFrom DATE --дата начала
	,@dateTo DATE --дата окончания
)
AS
BEGIN
	SET NOCOUNT ON;
    
	DECLARE @DlgHandle UNIQUEIDENTIFIER
	       ,@RequestMessage   NVARCHAR(100)
    

	BEGIN TRAN 

	-- вновь лезем в таблицу Invoice, для уверенности существования записей по CustomerId
	SET @RequestMessage = (
							SELECT CustomerID customId, @dateFrom dateFrom, @dateTo dateTo
							FROM Sales.Invoices AS FromInv
							WHERE CustomerId = @customerId
							GROUP BY CustomerID
							FOR XML AUTO, root('RequestMessage')
						  )	
    SELECT @RequestMessage
	IF @RequestMessage IS NULL
	     RETURN -1;

	--открываем диалог
	BEGIN DIALOG @DlgHandle
	FROM SERVICE
	[//WWI/SB_HW/InitiatorService]
	TO SERVICE
	'//WWI/SB_HW/TargetService'
	ON CONTRACT
	[//WWI/SB_HW/Contract]
	WITH ENCRYPTION=OFF; 

	--отправляем сообщение
	SEND ON CONVERSATION @DlgHandle 
	MESSAGE TYPE
	[//WWI/SB_HW/RequestMessage]
	(@RequestMessage);
	
	COMMIT TRAN
END
GO

--процедура принимает сообщение и обрабатывает
CREATE OR ALTER PROCEDURE Sales.GetRequestForCustomerReport
AS
BEGIN
    
	SET NOCOUNT ON;

	DECLARE @targetDlgHandle UNIQUEIDENTIFIER
	       ,@messageBody NVARCHAR(1000)
		   ,@messageType Sysname
		   ,@replyMessage NVARCHAR(1000)
		   ,@xml XML
		   ,@customerId INT
		   ,@dateFrom DATE
		   ,@dateTo DATE

    BEGIN TRAN;

	RECEIVE TOP(1)
		@targetDlgHandle = Conversation_Handle,
		@messageBody = Message_Body,
		@messageType = Message_Type_Name
	FROM dbo.TargetHWQueueWWI; 

	SET @xml = CAST(@messageBody AS XML);

	SELECT @xml

	SELECT 
	    @customerId = Inv.Report.value('@customId','INT'),
		@dateFrom   = Inv.Report.value('@dateFrom','DATE'),
		@dateTo   = Inv.Report.value('@dateTo','DATE')
	FROM @xml.nodes('/RequestMessage/FromInv') as Inv(Report);

	MERGE Sales.CustomerOrderQuantityReport AS ordersReport
    USING ( 
	        SELECT
				o.CustomerId CustomerId,
				c.CustomerName CustomerName,
				COUNT(o.OrderId) CountTotalOrders,
				COUNT(i.InvoiceID) CountInvoiceOrders
			FROM Sales.Orders o
			INNER JOIN Sales.Customers c ON c.CustomerId = o.CustomerId
			LEFT JOIN Sales.Invoices i ON i.OrderID = o.OrderID
			WHERE o.CustomerID = @customerId
			AND o.OrderDate BETWEEN @dateFrom AND @dateTo
			GROUP BY o.CustomerID, CustomerName
		  ) AS newValuesForReport
	   ON (ordersReport.CustomerId = newValuesForReport.CustomerId AND
	       ordersReport.DateFrom = @dateFrom  AND
		   ordersReport.DateTo = @dateTo
          )
	   WHEN MATCHED THEN
        UPDATE SET 
		   [CountTotalOrders] = newValuesForReport.CountTotalOrders,
		   [CountInvoiceOrders] = newValuesForReport.CountInvoiceOrders,
		   [DateCreated] = GetUTCDate()
	   WHEN NOT MATCHED THEN  
        INSERT (CustomerId, CustomerName, DateFrom, DateTo, CountTotalOrders, CountInvoiceOrders)  
        VALUES (newValuesForReport.CustomerId, newValuesForReport.CustomerName, @dateFrom, @dateTo, newValuesForReport.CountTotalOrders, newValuesForReport.CountInvoiceOrders);

	
	
	-- Отправить ответ
	IF @messageType=N'//WWI/SB_HW/RequestMessage'
	BEGIN
		SET @replyMessage =N'<ReplyMessage>Message received</ReplyMessage>'; 
	
		SEND ON CONVERSATION @TargetDlgHandle
		MESSAGE TYPE
		[//WWI/SB_HW/ReplyMessage]
		(@replyMessage);
		END CONVERSATION @TargetDlgHandle;
	END 

	COMMIT TRAN;
END
GO

--обработка ответного сообщения о формировании отчета от target для инициатора
CREATE OR ALTER PROCEDURE Sales.ConfirmReportGeneration
AS
BEGIN
	--Receiving Reply Message from the Target.	
	DECLARE @initiatorReplyDlgHandle UNIQUEIDENTIFIER,
			@replyReceivedMessage NVARCHAR(1000) 
	
	BEGIN TRAN; 

		RECEIVE TOP(1)
			@initiatorReplyDlgHandle=Conversation_Handle
			,@replyReceivedMessage=Message_Body
		FROM dbo.InitiatorHWQueueWWI; 
		
		END CONVERSATION @initiatorReplyDlgHandle; 

	COMMIT TRAN; 
END
GO

/*
	Шаг 6
	Обновим наши очереди, привяжем процедуры
*/

USE [WideWorldImporters]
GO

ALTER QUEUE [dbo].[InitiatorHWQueueWWI] WITH STATUS = ON , RETENTION = OFF , POISON_MESSAGE_HANDLING (STATUS = OFF) 
	, ACTIVATION (   STATUS = ON ,
        PROCEDURE_NAME = Sales.ConfirmReportGeneration, MAX_QUEUE_READERS = 1, EXECUTE AS OWNER) ; 

GO
ALTER QUEUE [dbo].[TargetHWQueueWWI] WITH STATUS = ON , RETENTION = OFF , POISON_MESSAGE_HANDLING (STATUS = OFF)
	, ACTIVATION (  STATUS = ON ,
        PROCEDURE_NAME = Sales.GetRequestForCustomerReport, MAX_QUEUE_READERS = 1, EXECUTE AS OWNER) ; 

GO

/*
	Шаг 7
	Продемонстрируем использование
*/
DECLARE @dateFrom DATE = '20100101'
       ,@dateTo   DATE = '20160101' 
	   ,@cId      INT
    
DECLARE @customers TABLE (custId INT)

INSERT INTO @customers
SELECT TOP 10 CustomerId
FROM Sales.Invoices i
GROUP BY CustomerID

WHILE((SELECT COUNT(*) FROM @customers) > 0)
BEGIN
   SELECT @cId = custId FROM @customers

   EXECUTE Sales.SendRequestForCustomerReport @cId, @dateFrom, @dateTo

   DELETE FROM @customers WHERE custId = @cId
   
END

/*
    Шаг 8
	Проверяем все ли корректно

*/

SELECT conversation_handle, is_initiator, s.name as 'local service', 
far_service, sc.name 'contract', ce.state_desc
FROM sys.conversation_endpoints ce
LEFT JOIN sys.services s
ON ce.service_id = s.service_id
LEFT JOIN sys.service_contracts sc
ON ce.service_contract_id = sc.service_contract_id
ORDER BY conversation_handle;

SELECT * FROM Sales.CustomerOrderQuantityReport ORDER BY CustomerId

EXECUTE Sales.SendRequestForCustomerReport 100, null, null

--Если вдруг в отладке
--For target
EXEC Sales.GetRequestForCustomerReport;
--For Initiator
EXEC Sales.ConfirmReportGeneration;

/*
	Шаг 9
	Подчищаем
*/

DROP SERVICE [//WWI/SB_HW/TargetService]
GO
DROP SERVICE [//WWI/SB_HW/InitiatorService]
GO
DROP QUEUE [dbo].[TargetHWQueueWWI]
GO 
DROP QUEUE [dbo].[InitiatorHWQueueWWI]
GO
DROP CONTRACT [//WWI/SB_HW/Contract]
GO
DROP MESSAGE TYPE [//WWI/SB_HW/RequestMessage]
GO
DROP MESSAGE TYPE [//WWI/SB_HW/ReplyMessage]
GO
DROP PROCEDURE IF EXISTS  Sales.SendRequestForCustomerReport;
DROP PROCEDURE IF EXISTS  Sales.GetRequestForCustomerReport;
DROP PROCEDURE IF EXISTS  Sales.ConfirmReportGeneration;
DROP TABLE IF EXISTS Sales.CustomerOrderQuantityReport;