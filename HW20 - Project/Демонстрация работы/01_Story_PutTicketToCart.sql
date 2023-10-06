/*Основной сценарий*/
--1. Получить список активных билетов
SELECT s.description, t.* FROM Directory.Tickets t
INNER JOIN Dictionary.Statuses s ON s.id = t.status_id
INNER JOIN Directory.Events_time et ON et.id = t.event_time_id
WHERE status_id = 36 AND et.start_date >= '20230930'

--2. Положить билет в корзину
DECLARE @client_session uniqueidentifier
--генерируем сессию клиента/корзина
SET @client_session = NEWID()

EXECUTE [dbo].[PutTicketToCart] 
   @clientSession = @client_session
  ,@ticketID = 49	
  ,@pointID = 1179

--проверяем, что билет в корзине
SELECT * FROM Purchasing.Cart

--проверяем что у билета сменился статус 
SELECT s.description, t.* FROM Directory.Tickets t
INNER JOIN Dictionary.Statuses s ON s.id = t.status_id
WHERE t.id = 49

--попробовать снова положить билет в корзину




