--������ ��������������� ������
EXECUTE [dbo].[CancelConfirmedOrder] 2003

--����� ��������
SELECT s.description, o.* FROM Purchasing.Orders o
INNER JOIN Dictionary.Statuses s ON s.id = o.status_id
WHERE o.id = 2003

--����� ����� ��������
SELECT s.description, t.* FROM Directory.Tickets t
INNER JOIN Dictionary.Statuses s ON s.id = t.status_id
WHERE t.id = 49
