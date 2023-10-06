--вернуть 1 билет
--1. Получить список активных билетов --3548.000
SELECT s.description, t.* FROM Directory.Tickets t
INNER JOIN Dictionary.Statuses s ON s.id = t.status_id
INNER JOIN Directory.Events_time et ON et.id = t.event_time_id
WHERE status_id = 36 AND et.start_date >= '20230930'

--2. Положить 2 билета в корзину
DECLARE @client_session uniqueidentifier
--генерируем сессию клиента/корзина
SET @client_session = NEWID()

EXECUTE [dbo].[PutTicketToCart] 
   @clientSession = @client_session
  ,@ticketID = 325	
  ,@pointID = 1179

EXECUTE [dbo].[PutTicketToCart] 
   @clientSession = @client_session
  ,@ticketID = 326	
  ,@pointID = 1179

--проверяем
SELECT * FROM Purchasing.Cart

--Создаем заказ, оплачиваем и подтверждаем
DECLARE @client_session uniqueidentifier = 'D54DB740-38A1-4327-9F48-2959D4C399EC'

DECLARE @id int
EXECUTE [dbo].[createOrder] 
   @clientSession = @client_session
  ,@id = @id OUTPUT
select @id

--3003

--проверяем что создан заказ
SELECT s.description, o.* FROM Purchasing.Orders o
INNER JOIN Dictionary.Statuses s ON s.id = o.status_id
WHERE o.id = 3004
SELECT * FROM Purchasing.Order_lines WHERE order_id = 3004

--подтверждаем заказ
EXECUTE [dbo].[ConfirmOrder] 3004

--оплачиваем заказ
EXECUTE [dbo].[PaymentOrder] 
   @orderId = 3004
  ,@transactionAmount = 7096.00
  ,@transactionDate = '20230930 17:00:00'
  ,@terminalID = N'A12345678958'
  ,@rrn = N'AA0123456789'

--возвращаем 1 из билетов
EXECUTE [dbo].[ReturnPaidTicket] 
   @orderID = 3004
  ,@ticketID = 326
  ,@transactionAmount = 3548.000
  ,@transactionDate = '20230930 17:00:00'
  ,@terminalID = N'123456789585'
  ,@rrn = N'0123456789СС'

SELECT s.description, o.* FROM Purchasing.Orders o
INNER JOIN Dictionary.Statuses s ON s.id = o.status_id
WHERE o.id = 3004

SELECT ol.* FROM Purchasing.Order_lines ol
WHERE ol.order_id = 3004

--записи о платежах и возврат
SELECT * FROM Purchasing.Orders_return WHERE order_id = 3004
SELECT * FROM Purchasing.Order_return_lines WHERE order_return_id IN (2005, 2006)

SELECT * FROM Purchasing.Order_transactions WHERE order_id = 3004

