--3. ������� �����
DECLARE @client_session uniqueidentifier = 'D437CA65-4229-4904-8D56-3774FAF2769B'

DECLARE @id int
EXECUTE [dbo].[createOrder] 
   @clientSession = @client_session
  ,@id = @id OUTPUT
select @id

--2002
--���������: ����� ������� ������, ������� ������, ������ �����
SELECT * FROM Purchasing.Cart

--��������� ��� � ������ �������� ������ 
SELECT s.description, t.* FROM Directory.Tickets t
INNER JOIN Dictionary.Statuses s ON s.id = t.status_id
WHERE t.id = 49

--��������� ��� ������ �����
SELECT s.description, o.* FROM Purchasing.Orders o
INNER JOIN Dictionary.Statuses s ON s.id = o.status_id
WHERE o.id = 2003
SELECT * FROM Purchasing.Order_lines WHERE order_id = 2003

--������������ �����
EXECUTE [dbo].[ConfirmOrder] 2003

--����� �����������
SELECT s.description, o.* FROM Purchasing.Orders o
INNER JOIN Dictionary.Statuses s ON s.id = o.status_id
WHERE o.id = 2003
SELECT * FROM Purchasing.Order_lines WHERE order_id = 2003
