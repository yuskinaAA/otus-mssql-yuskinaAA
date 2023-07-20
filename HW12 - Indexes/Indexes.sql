/*
�������� � ���� ���������� ������ �������� ����� ������� ��� ����� ��������������� ������
�� ������� ������ ���� ������������ � ������������� ��������� �������
*/

/*�������� ���� ������� �� ������ � �������� �������� 0/1*/
CREATE NONCLUSTERED INDEX [IX_dealers_seq_number_is_deleted_incl_name] ON [Directory].[Dealers]
(
	[seq_number] ASC,
	[is_deleted] ASC
) INCLUDE([name])

/*�������� ���� ������� (������/������ ��������) �� ���������*/
CREATE NONCLUSTERED INDEX [IX_contracts_owner_id_is_closed_incl_dealer_id] ON [Directory].[Contracts]
(
	[owner_id] ASC,
	[is_closed] ASC
)
INCLUDE([dealer_id])

/*�������� ���� ���������� �� ������ (������/������ ��������)*/
CREATE NONCLUSTERED INDEX [IX_contracts_dealer_id_is_closed_incl_owner_id] ON [Directory].[Contracts]
(
	[dealer_id] ASC,
	[is_closed] ASC
)
INCLUDE([owner_id])

/*�������� ��� ����������� �� ��������� (��� � �����)*/
CREATE NONCLUSTERED INDEX [IX_events_owner_id_incl_seq_number_name] ON [Directory].[Events]
(
	[owner_id] ASC
)
INCLUDE([seq_number],[name])

/*�������� ������������ ����������� � ��������� �� ������*/
CREATE NONCLUSTERED INDEX [IX_events_seq_number_incl_owner_id_name] ON [Directory].[Events]
(
	[seq_number] ASC
)
INCLUDE([name],[owner_id])

/*�������� ��� ������� �� ����������� � ����� ������*/
CREATE NONCLUSTERED INDEX [IX_event_id_hall_id_incl_start_date] ON [Directory].[Events_time]
(
	[event_id] ASC,
	[hall_id] ASC
)
INCLUDE([start_date])

/*�������� ��� �������� �����������, ������� ����� ��������� � ������������ ����*/
CREATE NONCLUSTERED INDEX [IX_hall_id_incl_event_id_start_date] ON [Directory].[Events_time]
(
	[hall_id] ASC
)
INCLUDE([event_id],[start_date]) 
WHERE ([is_closed]=(0))

/*�������� ������������ ���� ����� ������������ ��������*/
CREATE NONCLUSTERED INDEX [IX_halls_venue_id_incl_name] ON [Directory].[Halls]
(
	[venue_id] ASC
)
INCLUDE([name])

/*�������� ������������ ��������� �� ������*/
CREATE NONCLUSTERED INDEX [IX_owners_seq_number_incl_name] ON [Directory].[Owners]
(
	[seq_number] ASC
)
INCLUDE([name])

/*������� ��� ����� � ������������ ����*/
CREATE NONCLUSTERED INDEX [IX_places_hall_id_incl_sector_row_number_place_number] ON [Directory].[Places]
(
	[hall_id] ASC
)
INCLUDE([sector],[row_number],[place_number])

/*�������� ��� ����� ������ ������*/
CREATE NONCLUSTERED INDEX [IX_dealer_id_incl_name] ON [Directory].[Points]
(
	[dealer_id] ASC
)
INCLUDE([name]) 

/*�������� ��� ������ �� ������������� ������� (��� ������� ��������� ������) � �������*/
CREATE NONCLUSTERED INDEX [IX_tickets_event_time_id_status_id_place_id_price] ON [Directory].[Tickets]
(
	[event_time_id] ASC,
	[status_id] ASC
)
INCLUDE([place_id],[price])
--WHERE ([status_id]=(1000)) --1000 ������� ���������� ������, ���������� � �������. �� ��������� ��� ������ �����, �������� ����� ����� �� ���� �������.

/*�������� �� ������ ������ ��� ������, �����, ���� ������*/
CREATE UNIQUE NONCLUSTERED INDEX [IX_seq_number_incl_amount_status_id_order_date] ON [Purchasing].[Orders]
(
	[seq_number] ASC
)
INCLUDE([amount],[status_id],[order_date])

/*�������� �� ����������� � ������� ������ �������*/
CREATE NONCLUSTERED INDEX [IX_event_time_id_status_id_incl_seq_number] ON [Purchasing].[Orders]
(
	[status_id] ASC,
	[event_time_id] ASC
)
INCLUDE([seq_number])

/*�� ����� ������ � ������� �������� ��� ������ ������� � �� ����*/
CREATE NONCLUSTERED INDEX [IX_point_id_event_time_id_incl_seq_number] ON [Purchasing].[Orders]
(
	[point_id] ASC,
	[event_time_id] ASC
)
INCLUDE([seq_number],[order_date])

/*�� ������ �������� ��� ������ � �� ������ (������ ��� ��� ����� ����� ���� ���������)*/
CREATE NONCLUSTERED INDEX [IX_order_id_incl_ticket_id_status_id] ON [Purchasing].[Order_lines]
(
	[order_id] ASC
)
INCLUDE([ticket_id],[status_id])

/*�������� ��� ������ � �� ������ �� ����������� � ����� ������*/
CREATE NONCLUSTERED INDEX [IX_event_time_id_point_id_incl_ticket_id_status_id] ON [Purchasing].[Order_lines]
(
	[event_time_id] ASC,
	[point_id] ASC
)
INCLUDE([ticket_id],[status_id])

/*�������� ����� � ���� ���������� �� ������������� ������*/
CREATE NONCLUSTERED INDEX [IX_order_id_incl_transaction_amount_transaction_date] ON [Purchasing].[Order_transactions]
(
	[order_id] ASC
)
INCLUDE([transaction_amount],[transaction_date])
