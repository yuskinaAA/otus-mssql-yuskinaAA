--3. —оздаем заказ
DECLARE @client_session uniqueidentifier = 'D437CA65-4229-4904-8D56-3774FAF2769B'

DECLARE @id int
EXECUTE [dbo].[createOrder] 
   @clientSession = @client_session
  ,@id = @id OUTPUT
select @id

--2002
--ѕровер€ем: Ѕилет изменил статус, корзина пуста€, создан заказ
SELECT * FROM Purchasing.Cart

--провер€ем что у билета сменилс€ статус 
SELECT s.description, t.* FROM Directory.Tickets t
INNER JOIN Dictionary.Statuses s ON s.id = t.status_id
WHERE t.id = 49

--провер€ем что создан заказ
SELECT s.description, o.* FROM Purchasing.Orders o
INNER JOIN Dictionary.Statuses s ON s.id = o.status_id
WHERE o.id = 2003
SELECT * FROM Purchasing.Order_lines WHERE order_id = 2003

--подтверждаем заказ
EXECUTE [dbo].[ConfirmOrder] 2003

--заказ подтвержден
SELECT s.description, o.* FROM Purchasing.Orders o
INNER JOIN Dictionary.Statuses s ON s.id = o.status_id
WHERE o.id = 2003
SELECT * FROM Purchasing.Order_lines WHERE order_id = 2003
