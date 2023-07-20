/*
Возможно в ходе дальнейшей работы появятся новые индексы или будут редактироваться старые
На текущий момент могу предположить к использованию следующие индексы
*/

/*Получить всех дилеров по номеру и признаку удаления 0/1*/
CREATE NONCLUSTERED INDEX [IX_dealers_seq_number_is_deleted_incl_name] ON [Directory].[Dealers]
(
	[seq_number] ASC,
	[is_deleted] ASC
) INCLUDE([name])

/*Получить всех дилеров (открыт/закрыт контракт) по владельцу*/
CREATE NONCLUSTERED INDEX [IX_contracts_owner_id_is_closed_incl_dealer_id] ON [Directory].[Contracts]
(
	[owner_id] ASC,
	[is_closed] ASC
)
INCLUDE([dealer_id])

/*Получить всех владельцев по дилеру (открыт/закрыт контракт)*/
CREATE NONCLUSTERED INDEX [IX_contracts_dealer_id_is_closed_incl_owner_id] ON [Directory].[Contracts]
(
	[dealer_id] ASC,
	[is_closed] ASC
)
INCLUDE([owner_id])

/*Получить все мероприятия по владельцу (имя и номер)*/
CREATE NONCLUSTERED INDEX [IX_events_owner_id_incl_seq_number_name] ON [Directory].[Events]
(
	[owner_id] ASC
)
INCLUDE([seq_number],[name])

/*Получить наименование мероприятия и владельца по номеру*/
CREATE NONCLUSTERED INDEX [IX_events_seq_number_incl_owner_id_name] ON [Directory].[Events]
(
	[seq_number] ASC
)
INCLUDE([name],[owner_id])

/*получить все события по мероприятию с датой начала*/
CREATE NONCLUSTERED INDEX [IX_event_id_hall_id_incl_start_date] ON [Directory].[Events_time]
(
	[event_id] ASC,
	[hall_id] ASC
)
INCLUDE([start_date])

/*Получить все открытые мероприятия, которые будут проходить в определенном зале*/
CREATE NONCLUSTERED INDEX [IX_hall_id_incl_event_id_start_date] ON [Directory].[Events_time]
(
	[hall_id] ASC
)
INCLUDE([event_id],[start_date]) 
WHERE ([is_closed]=(0))

/*получить наименования всех залов определенной площадки*/
CREATE NONCLUSTERED INDEX [IX_halls_venue_id_incl_name] ON [Directory].[Halls]
(
	[venue_id] ASC
)
INCLUDE([name])

/*получить наименование владельца по номеру*/
CREATE NONCLUSTERED INDEX [IX_owners_seq_number_incl_name] ON [Directory].[Owners]
(
	[seq_number] ASC
)
INCLUDE([name])

/*достать все места в определенном зале*/
CREATE NONCLUSTERED INDEX [IX_places_hall_id_incl_sector_row_number_place_number] ON [Directory].[Places]
(
	[hall_id] ASC
)
INCLUDE([sector],[row_number],[place_number])

/*получить все точки продаж дилера*/
CREATE NONCLUSTERED INDEX [IX_dealer_id_incl_name] ON [Directory].[Points]
(
	[dealer_id] ASC
)
INCLUDE([name]) 

/*получить все билеты по определенному статусу (как правило свободные билеты) и событию*/
CREATE NONCLUSTERED INDEX [IX_tickets_event_time_id_status_id_place_id_price] ON [Directory].[Tickets]
(
	[event_time_id] ASC,
	[status_id] ASC
)
INCLUDE([place_id],[price])
--WHERE ([status_id]=(1000)) --1000 признак свободного билета, доступного к продаже. Не уверенная что фильтр нужен, возможно будет поиск по всем билетам.

/*Получить по номеру заказа его статус, сумму, дату заказа*/
CREATE UNIQUE NONCLUSTERED INDEX [IX_seq_number_incl_amount_status_id_order_date] ON [Purchasing].[Orders]
(
	[seq_number] ASC
)
INCLUDE([amount],[status_id],[order_date])

/*Получить по мероприятию и статусу номера заказов*/
CREATE NONCLUSTERED INDEX [IX_event_time_id_status_id_incl_seq_number] ON [Purchasing].[Orders]
(
	[status_id] ASC,
	[event_time_id] ASC
)
INCLUDE([seq_number])

/*По точке продаж и событию получить все номера заказов и их дату*/
CREATE NONCLUSTERED INDEX [IX_point_id_event_time_id_incl_seq_number] ON [Purchasing].[Orders]
(
	[point_id] ASC,
	[event_time_id] ASC
)
INCLUDE([seq_number],[order_date])

/*По заказу получить все билеты и их статус (статус так как билет может быть возвращен)*/
CREATE NONCLUSTERED INDEX [IX_order_id_incl_ticket_id_status_id] ON [Purchasing].[Order_lines]
(
	[order_id] ASC
)
INCLUDE([ticket_id],[status_id])

/*Получить все билеты и их статус по мероприятию и точке продаж*/
CREATE NONCLUSTERED INDEX [IX_event_time_id_point_id_incl_ticket_id_status_id] ON [Purchasing].[Order_lines]
(
	[event_time_id] ASC,
	[point_id] ASC
)
INCLUDE([ticket_id],[status_id])

/*получить сумму и дату транзакций по определенному заказу*/
CREATE NONCLUSTERED INDEX [IX_order_id_incl_transaction_amount_transaction_date] ON [Purchasing].[Order_transactions]
(
	[order_id] ASC
)
INCLUDE([transaction_amount],[transaction_date])
