--отменить оплаченный заказ
EXECUTE [dbo].[CancelPayOrder] 
   @orderId = 2002
  ,@transactionAmount = 480
  ,@transactionDate = '20230930 17:00:00'
  ,@terminalID = N'123456789585'
  ,@rrn = N'0123456789AС'

--заказ отменен
SELECT s.description, o.* FROM Purchasing.Orders o
INNER JOIN Dictionary.Statuses s ON s.id = o.status_id
WHERE o.id = 2002

SELECT * FROM Purchasing.Orders_return WHERE order_id = 2002
SELECT * FROM Purchasing.Order_return_lines WHERE order_return_id = 1002

--записи о платежах
SELECT * FROM Purchasing.Order_transactions WHERE order_id = 2002
