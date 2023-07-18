CREATE DATABASE TicketSystem
GO

USE TicketSystem
GO

/*схема для словаря*/
CREATE SCHEMA Dictionary
GO

/*статусы*/
CREATE TABLE [Dictionary].[Statuses](
	[id] INT IDENTITY(1,1) NOT NULL,
	[name] NVARCHAR(50) NOT NULL,
	[description] NVARCHAR(100) NULL,
	[table_id] INT NOT NULL,
	CONSTRAINT PK_Statuses PRIMARY KEY([id])
 ) ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'имя' , @level0type=N'SCHEMA',@level0name=N'Dictionary', @level1type=N'TABLE',@level1name=N'Statuses', @level2type=N'COLUMN',@level2name=N'name'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'описание' , @level0type=N'SCHEMA',@level0name=N'Dictionary', @level1type=N'TABLE',@level1name=N'Statuses', @level2type=N'COLUMN',@level2name=N'description'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'к какой таблице относятся' , @level0type=N'SCHEMA',@level0name=N'Dictionary', @level1type=N'TABLE',@level1name=N'Statuses', @level2type=N'COLUMN',@level2name=N'table_id'
GO

/*схема для каталогов*/
CREATE SCHEMA Directory
GO

/*дилеры*/
CREATE TABLE [Directory].[Dealers](
	[id] INT IDENTITY(1,1) NOT NULL,
	[name] NVARCHAR(100) NOT NULL,
	[seq_number] INT NOT NULL,
	[is_deleted] BIT DEFAULT(0) NOT NULL,
	CONSTRAINT PK_Dealers PRIMARY KEY(id)
) ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'имя дилера' , @level0type=N'SCHEMA',@level0name=N'Directory', @level1type=N'TABLE',@level1name=N'Dealers', @level2type=N'COLUMN',@level2name=N'name'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'номер' , @level0type=N'SCHEMA',@level0name=N'Directory', @level1type=N'TABLE',@level1name=N'Dealers', @level2type=N'COLUMN',@level2name=N'seq_number'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'удален' , @level0type=N'SCHEMA',@level0name=N'Directory', @level1type=N'TABLE',@level1name=N'Dealers', @level2type=N'COLUMN',@level2name=N'is_deleted'

/*владельцы*/
CREATE TABLE [Directory].[Owners](
	[id] INT IDENTITY(1,1) NOT NULL,
	[name] NVARCHAR(100) NOT NULL,
	[is_deleted] BIT DEFAULT(0) NOT NULL,
	[seq_number] INT NOT NULL,
	CONSTRAINT PK_Owners PRIMARY KEY(id)
) ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Наименование владельца билетов' , @level0type=N'SCHEMA',@level0name=N'Directory', @level1type=N'TABLE',@level1name=N'Owners', @level2type=N'COLUMN',@level2name=N'name'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Удален' , @level0type=N'SCHEMA',@level0name=N'Directory', @level1type=N'TABLE',@level1name=N'Owners', @level2type=N'COLUMN',@level2name=N'is_deleted'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Порядковый номер' , @level0type=N'SCHEMA',@level0name=N'Directory', @level1type=N'TABLE',@level1name=N'Owners', @level2type=N'COLUMN',@level2name=N'seq_number'
GO

/*договора между владельцами и дилерами*/
CREATE TABLE [Directory].[Contracts](
	[id] INT IDENTITY(1,1) NOT NULL,
	[owner_id] INT NOT NULL,
	[dealer_id] INT NOT NULL,
	[is_closed] BIT DEFAULT(0) NOT NULL,
	CONSTRAINT PK_Contracts PRIMARY KEY(id),
	CONSTRAINT FK_Contracts_Dealers FOREIGN KEY([dealer_id]) REFERENCES [Directory].[Dealers]([id]),
	CONSTRAINT FK_Contracts_Owners FOREIGN KEY([owner_id]) REFERENCES [Directory].[Owners]([id]),
) ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id владельца' , @level0type=N'SCHEMA',@level0name=N'Directory', @level1type=N'TABLE',@level1name=N'Contracts', @level2type=N'COLUMN',@level2name=N'owner_id'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id дилера' , @level0type=N'SCHEMA',@level0name=N'Directory', @level1type=N'TABLE',@level1name=N'Contracts', @level2type=N'COLUMN',@level2name=N'dealer_id'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'закрыт' , @level0type=N'SCHEMA',@level0name=N'Directory', @level1type=N'TABLE',@level1name=N'Contracts', @level2type=N'COLUMN',@level2name=N'is_closed'
GO

/*площадка*/
CREATE TABLE [Directory].[Venues](
	[id] INT IDENTITY(1,1) NOT NULL,
	[name] NVARCHAR(50) NOT NULL,
	[description] NVARCHAR(1000) NULL,
	[is_deleted] BIT DEFAULT(0) NULL,
	CONSTRAINT [PK_Venues] PRIMARY KEY([id])
) ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'имя площадки' , @level0type=N'SCHEMA',@level0name=N'Directory', @level1type=N'TABLE',@level1name=N'Venues', @level2type=N'COLUMN',@level2name=N'name'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'описание' , @level0type=N'SCHEMA',@level0name=N'Directory', @level1type=N'TABLE',@level1name=N'Venues', @level2type=N'COLUMN',@level2name=N'description'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'удален' , @level0type=N'SCHEMA',@level0name=N'Directory', @level1type=N'TABLE',@level1name=N'Venues', @level2type=N'COLUMN',@level2name=N'is_deleted'
GO

/*зал*/
CREATE TABLE [Directory].[Halls](
	[id] INT IDENTITY(1,1) NOT NULL,
	[name] NVARCHAR(50) NULL,
	[venue_id] INT NOT NULL,
	[is_deleted] BIT NOT NULL,
	CONSTRAINT [PK_Halls] PRIMARY KEY([id]),
	CONSTRAINT [FK_Halls_Venues] FOREIGN KEY([venue_id]) REFERENCES [Directory].[Venues] ([id])
) ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'имя зала' , @level0type=N'SCHEMA',@level0name=N'Directory', @level1type=N'TABLE',@level1name=N'Halls', @level2type=N'COLUMN',@level2name=N'name'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id площадки' , @level0type=N'SCHEMA',@level0name=N'Directory', @level1type=N'TABLE',@level1name=N'Halls', @level2type=N'COLUMN',@level2name=N'venue_id'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'удален' , @level0type=N'SCHEMA',@level0name=N'Directory', @level1type=N'TABLE',@level1name=N'Halls', @level2type=N'COLUMN',@level2name=N'is_deleted'
GO

/*места*/
CREATE TABLE [Directory].[Places](
	[id] INT IDENTITY(1,1) NOT NULL,
	[sector] SMALLINT NOT NULL,
	[row_number] NVARCHAR(50) NULL,
	[place_number] NVARCHAR(50) NULL,
	[hall_id] INT NOT NULL,
	CONSTRAINT [PK_Places] PRIMARY KEY([id]),
	CONSTRAINT [FK_Places_Halls] FOREIGN KEY([hall_id]) REFERENCES [Directory].[Halls] ([id])
) ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'номер сектора' , @level0type=N'SCHEMA',@level0name=N'Directory', @level1type=N'TABLE',@level1name=N'Places', @level2type=N'COLUMN',@level2name=N'sector'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'номер ряда' , @level0type=N'SCHEMA',@level0name=N'Directory', @level1type=N'TABLE',@level1name=N'Places', @level2type=N'COLUMN',@level2name=N'row_number'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'номер места' , @level0type=N'SCHEMA',@level0name=N'Directory', @level1type=N'TABLE',@level1name=N'Places', @level2type=N'COLUMN',@level2name=N'place_number'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id зала' , @level0type=N'SCHEMA',@level0name=N'Directory', @level1type=N'TABLE',@level1name=N'Places', @level2type=N'COLUMN',@level2name=N'hall_id'
GO

/*мероприятия*/
CREATE TABLE [Directory].[Events](
	[id] INT IDENTITY(1,1) NOT NULL,
	[seq_number] INT NOT NULL,
	[name] NVARCHAR(100) NOT NULL,
	[owner_id] INT NOT NULL,
	[is_deleted] INT DEFAULT(0) NOT NULL,
	[description] NVARCHAR(200) NULL,
	CONSTRAINT [PK_Events] PRIMARY KEY([id]),
	CONSTRAINT [FK_Events_Owners] FOREIGN KEY([owner_id]) REFERENCES [Directory].[Owners]([id])
) ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Порядковый номер события' , @level0type=N'SCHEMA',@level0name=N'Directory', @level1type=N'TABLE',@level1name=N'Events', @level2type=N'COLUMN',@level2name=N'seq_number'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Наименование события' , @level0type=N'SCHEMA',@level0name=N'Directory', @level1type=N'TABLE',@level1name=N'Events', @level2type=N'COLUMN',@level2name=N'name'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Владелец' , @level0type=N'SCHEMA',@level0name=N'Directory', @level1type=N'TABLE',@level1name=N'Events', @level2type=N'COLUMN',@level2name=N'owner_id'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Удален' , @level0type=N'SCHEMA',@level0name=N'Directory', @level1type=N'TABLE',@level1name=N'Events', @level2type=N'COLUMN',@level2name=N'is_deleted'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Описание' , @level0type=N'SCHEMA',@level0name=N'Directory', @level1type=N'TABLE',@level1name=N'Events', @level2type=N'COLUMN',@level2name=N'description'
GO

/*события*/
CREATE TABLE [Directory].[Events_time](
	[id] INT IDENTITY(1,1) NOT NULL,
	[event_id] INT NOT NULL,
	[hall_id] INT NOT NULL,
	[start_date] DATETIME NOT NULL,
	[end_date] DATETIME NOT NULL,
	[is_closed] BIT DEFAULT(0) NOT NULL,
	[is_deleted] BIT DEFAULT(0) NOT NULL,
	CONSTRAINT [PK_Events_time] PRIMARY KEY([id]),
	CONSTRAINT [FK_Events_time_Events] FOREIGN KEY([event_id]) REFERENCES [Directory].[Events] ([id]),
	CONSTRAINT [FK_Events_time_Halls] FOREIGN KEY([hall_id]) REFERENCES [Directory].[Halls] ([id])
) ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id события' , @level0type=N'SCHEMA',@level0name=N'Directory', @level1type=N'TABLE',@level1name=N'Events_time', @level2type=N'COLUMN',@level2name=N'event_id'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id зала' , @level0type=N'SCHEMA',@level0name=N'Directory', @level1type=N'TABLE',@level1name=N'Events_time', @level2type=N'COLUMN',@level2name=N'hall_id'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'дата начала' , @level0type=N'SCHEMA',@level0name=N'Directory', @level1type=N'TABLE',@level1name=N'Events_time', @level2type=N'COLUMN',@level2name=N'start_date'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'дата окончания' , @level0type=N'SCHEMA',@level0name=N'Directory', @level1type=N'TABLE',@level1name=N'Events_time', @level2type=N'COLUMN',@level2name=N'end_date'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'продажи открыты/закрыты' , @level0type=N'SCHEMA',@level0name=N'Directory', @level1type=N'TABLE',@level1name=N'Events_time', @level2type=N'COLUMN',@level2name=N'is_closed'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Удален' , @level0type=N'SCHEMA',@level0name=N'Directory', @level1type=N'TABLE',@level1name=N'Events_time', @level2type=N'COLUMN',@level2name=N'is_deleted'
GO

/*точки продаж*/
CREATE TABLE [Directory].[Points](
	[id] INT IDENTITY(1,1) NOT NULL,
	[name] NVARCHAR(50) NOT NULL,
	[dealer_id] INT NOT NULL,
	CONSTRAINT [PK_Points] PRIMARY KEY([id]),
	CONSTRAINT [FK_Points_Dealers] FOREIGN KEY([dealer_id]) REFERENCES [Directory].[Dealers] ([id])
) ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'имя' , @level0type=N'SCHEMA',@level0name=N'Directory', @level1type=N'TABLE',@level1name=N'Points', @level2type=N'COLUMN',@level2name=N'name'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id дилера' , @level0type=N'SCHEMA',@level0name=N'Directory', @level1type=N'TABLE',@level1name=N'Points', @level2type=N'COLUMN',@level2name=N'dealer_id'
GO

/*настройка сервисного сбора*/
CREATE TABLE [Directory].[Service_fee](
	[id] INT IDENTITY(1,1) NOT NULL,
	[name] NVARCHAR(50) NOT NULL,
	[per_cent] DECIMAL(18, 2) NOT NULL,
	[round] BIT DEFAULT(0) NOT NULL,
	CONSTRAINT [PK_Service_fee] PRIMARY KEY([id])
) ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'имя' , @level0type=N'SCHEMA',@level0name=N'Directory', @level1type=N'TABLE',@level1name=N'Service_fee', @level2type=N'COLUMN',@level2name=N'name'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'процент' , @level0type=N'SCHEMA',@level0name=N'Directory', @level1type=N'TABLE',@level1name=N'Service_fee', @level2type=N'COLUMN',@level2name=N'per_cent'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'округлять' , @level0type=N'SCHEMA',@level0name=N'Directory', @level1type=N'TABLE',@level1name=N'Service_fee', @level2type=N'COLUMN',@level2name=N'round'
GO

/*сервисный сбор на событие и точку продаж*/
CREATE TABLE [Directory].[Service_4_events_time](
	[id] INT IDENTITY(1,1) NOT NULL,
	[event_time_id] INT NOT NULL,
	[point_id] INT NOT NULL,
	[service_fee_id] INT NOT NULL,
	CONSTRAINT [PK_Service_4_events_time] PRIMARY KEY([id]),
	CONSTRAINT [FK_Service_4_events_time_Event_time] FOREIGN KEY([event_time_id]) REFERENCES [Directory].[Events_time] ([id]),
	CONSTRAINT [FK_Service_4_events_time_Points] FOREIGN KEY([point_id]) REFERENCES [Directory].[Points] ([id]),
	CONSTRAINT [FK_Service_4_events_time_Service_fee] FOREIGN KEY([service_fee_id]) REFERENCES [Directory].[Service_fee] ([id])
) ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id события' , @level0type=N'SCHEMA',@level0name=N'Directory', @level1type=N'TABLE',@level1name=N'Service_4_events_time', @level2type=N'COLUMN',@level2name=N'event_time_id'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id точки продаж' , @level0type=N'SCHEMA',@level0name=N'Directory', @level1type=N'TABLE',@level1name=N'Service_4_events_time', @level2type=N'COLUMN',@level2name=N'point_id'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id сервисного сбора' , @level0type=N'SCHEMA',@level0name=N'Directory', @level1type=N'TABLE',@level1name=N'Service_4_events_time', @level2type=N'COLUMN',@level2name=N'service_fee_id'
GO

/*склад билетов*/
CREATE TABLE [Directory].[Tickets](
	[id] INT IDENTITY(1,1) NOT NULL,
	[event_time_id] INT NOT NULL,
	[place_id] INT NOT NULL,
	[price] DECIMAL(18, 3) NOT NULL,
	[input_date] DATETIME DEFAULT (GETDATE()) NOT NULL,
	[status_id] INT NOT NULL,
	CONSTRAINT [PK_Tickets] PRIMARY KEY([id]),
	CONSTRAINT [FK_Tickets_Events_time] FOREIGN KEY([event_time_id]) REFERENCES [Directory].[Events_time] ([id]),
	CONSTRAINT [FK_Tickets_Statuses] FOREIGN KEY([status_id]) REFERENCES [Dictionary].[Statuses] ([id])
) ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id события' , @level0type=N'SCHEMA',@level0name=N'Directory', @level1type=N'TABLE',@level1name=N'Tickets', @level2type=N'COLUMN',@level2name=N'event_time_id'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id места' , @level0type=N'SCHEMA',@level0name=N'Directory', @level1type=N'TABLE',@level1name=N'Tickets', @level2type=N'COLUMN',@level2name=N'place_id'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'цена' , @level0type=N'SCHEMA',@level0name=N'Directory', @level1type=N'TABLE',@level1name=N'Tickets', @level2type=N'COLUMN',@level2name=N'price'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'дата ввода' , @level0type=N'SCHEMA',@level0name=N'Directory', @level1type=N'TABLE',@level1name=N'Tickets', @level2type=N'COLUMN',@level2name=N'input_date'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id статуса' , @level0type=N'SCHEMA',@level0name=N'Directory', @level1type=N'TABLE',@level1name=N'Tickets', @level2type=N'COLUMN',@level2name=N'status_id'
GO

CREATE SCHEMA People
GO

/*данные о клиентах*/
CREATE TABLE [People].[Clients](
	[id] INT IDENTITY(1,1) NOT NULL,
	[info] NVARCHAR(MAX) NOT NULL,
	CONSTRAINT [PK_Clients] PRIMARY KEY([id])
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'инфо о клиента' , @level0type=N'SCHEMA',@level0name=N'People', @level1type=N'TABLE',@level1name=N'Clients', @level2type=N'COLUMN',@level2name=N'info'
GO

CREATE SCHEMA Purchasing
GO

/*корзина*/
CREATE TABLE [Purchasing].[Cart](
	[id] INT IDENTITY(1,1) NOT NULL,
	[client_session] UNIQUEIDENTIFIER NOT NULL,
	[ticket_id] INT NOT NULL,
	[input_date] DATETIME DEFAULT(GETDATE()) NOT NULL,
	[price] DECIMAL(18, 3) NOT NULL,
	[service_fee_price] DECIMAL(18, 3) NOT NULL,
	[point_id] INT NOT NULL,
	[event_time_id] INT NOT NULL,
	CONSTRAINT [PK_Cart] PRIMARY KEY([id]),
	CONSTRAINT [FK_Cart_Events_time] FOREIGN KEY([event_time_id]) REFERENCES [Directory].[Events_time] ([id]),
	CONSTRAINT [FK_Cart_Points] FOREIGN KEY([point_id]) REFERENCES [Directory].[Points] ([id]),
	CONSTRAINT [FK_Cart_Tickets] FOREIGN KEY([ticket_id]) REFERENCES [Directory].[Tickets] ([id])
) ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'guid клиента' , @level0type=N'SCHEMA',@level0name=N'Purchasing', @level1type=N'TABLE',@level1name=N'Cart', @level2type=N'COLUMN',@level2name=N'client_session'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id билета' , @level0type=N'SCHEMA',@level0name=N'Purchasing', @level1type=N'TABLE',@level1name=N'Cart', @level2type=N'COLUMN',@level2name=N'ticket_id'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'время создания' , @level0type=N'SCHEMA',@level0name=N'Purchasing', @level1type=N'TABLE',@level1name=N'Cart', @level2type=N'COLUMN',@level2name=N'input_date'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'цена' , @level0type=N'SCHEMA',@level0name=N'Purchasing', @level1type=N'TABLE',@level1name=N'Cart', @level2type=N'COLUMN',@level2name=N'price'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'цена сервисного сбора' , @level0type=N'SCHEMA',@level0name=N'Purchasing', @level1type=N'TABLE',@level1name=N'Cart', @level2type=N'COLUMN',@level2name=N'service_fee_price'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'точка продажи' , @level0type=N'SCHEMA',@level0name=N'Purchasing', @level1type=N'TABLE',@level1name=N'Cart', @level2type=N'COLUMN',@level2name=N'point_id'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id события' , @level0type=N'SCHEMA',@level0name=N'Purchasing', @level1type=N'TABLE',@level1name=N'Cart', @level2type=N'COLUMN',@level2name=N'event_time_id'
GO

/*заказ*/
CREATE TABLE [Purchasing].[Orders](
	[id] INT IDENTITY(1,1) NOT NULL,
	[seq_number] INT NOT NULL,
	[point_id] INT NOT NULL,
	[amount] DECIMAL(18, 2) NOT NULL,
	[service_fee_price] DECIMAL(18, 3) NULL,
	[status_id] INT NOT NULL,
	[order_date] DATETIME NOT NULL,
	[pay_time] DATETIME NULL,
	[event_time_id] INT NOT NULL,
	[client_id] INT NOT NULL,
	[is_pushkin] BIT DEFAULT(0) NOT NULL,
	CONSTRAINT [PK_Orders] PRIMARY KEY([id]),
	CONSTRAINT [FK_Orders_Clients] FOREIGN KEY([client_id]) REFERENCES [People].[Clients] ([id]),
	CONSTRAINT [FK_Orders_Event_time] FOREIGN KEY([event_time_id]) REFERENCES [Directory].[Events_time] ([id]),
	CONSTRAINT [FK_Orders_Points] FOREIGN KEY([point_id]) REFERENCES [Directory].[Points] ([id]),
	CONSTRAINT [FK_Orders_Statuses] FOREIGN KEY([status_id]) REFERENCES [Dictionary].[Statuses] ([id])
) ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'номер заказа' , @level0type=N'SCHEMA',@level0name=N'Purchasing', @level1type=N'TABLE',@level1name=N'Orders', @level2type=N'COLUMN',@level2name=N'seq_number'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'точка продаж' , @level0type=N'SCHEMA',@level0name=N'Purchasing', @level1type=N'TABLE',@level1name=N'Orders', @level2type=N'COLUMN',@level2name=N'point_id'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'сумма заказа' , @level0type=N'SCHEMA',@level0name=N'Purchasing', @level1type=N'TABLE',@level1name=N'Orders', @level2type=N'COLUMN',@level2name=N'amount'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'сумма сервисного сбора' , @level0type=N'SCHEMA',@level0name=N'Purchasing', @level1type=N'TABLE',@level1name=N'Orders', @level2type=N'COLUMN',@level2name=N'service_fee_price'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id статуса' , @level0type=N'SCHEMA',@level0name=N'Purchasing', @level1type=N'TABLE',@level1name=N'Orders', @level2type=N'COLUMN',@level2name=N'status_id'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'дата заказа' , @level0type=N'SCHEMA',@level0name=N'Purchasing', @level1type=N'TABLE',@level1name=N'Orders', @level2type=N'COLUMN',@level2name=N'order_date'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'дата оплаты заказа' , @level0type=N'SCHEMA',@level0name=N'Purchasing', @level1type=N'TABLE',@level1name=N'Orders', @level2type=N'COLUMN',@level2name=N'pay_time'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id события' , @level0type=N'SCHEMA',@level0name=N'Purchasing', @level1type=N'TABLE',@level1name=N'Orders', @level2type=N'COLUMN',@level2name=N'event_time_id'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id клиента' , @level0type=N'SCHEMA',@level0name=N'Purchasing', @level1type=N'TABLE',@level1name=N'Orders', @level2type=N'COLUMN',@level2name=N'client_id'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'по пушкинской карте' , @level0type=N'SCHEMA',@level0name=N'Purchasing', @level1type=N'TABLE',@level1name=N'Orders', @level2type=N'COLUMN',@level2name=N'is_pushkin'
GO

/*детализация заказа*/
CREATE TABLE [Purchasing].[Order_lines](
	[id] INT IDENTITY(1,1) NOT NULL,
	[order_id] INT NOT NULL,
	[ticket_id] INT NOT NULL,
	[price] DECIMAL(18, 3) NOT NULL,
	[service_free_price] DECIMAL(18, 3) NOT NULL,
	[status_id] INT NOT NULL,
	[point_id] INT NOT NULL,
	[event_time_id] INT NOT NULL,
	[seq_number] INT NOT NULL,
	CONSTRAINT [PK_Order_lines] PRIMARY KEY([id]),
	CONSTRAINT [FK_Order_lines_Events_time] FOREIGN KEY([event_time_id]) REFERENCES [Directory].[Events_time] ([id]),
	CONSTRAINT [FK_Order_lines_Orders] FOREIGN KEY([order_id]) REFERENCES [Purchasing].[Orders] ([id]),
	CONSTRAINT [FK_Order_lines_Points] FOREIGN KEY([point_id]) REFERENCES [Directory].[Points] ([id]),
	CONSTRAINT [FK_Order_lines_Statuses] FOREIGN KEY([status_id]) REFERENCES [Dictionary].[Statuses] ([id]),
	CONSTRAINT [FK_Order_lines_Tickets] FOREIGN KEY([ticket_id]) REFERENCES [Directory].[Tickets] ([id])
) ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id заказа' , @level0type=N'SCHEMA',@level0name=N'Purchasing', @level1type=N'TABLE',@level1name=N'Order_lines', @level2type=N'COLUMN',@level2name=N'order_id'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id билета' , @level0type=N'SCHEMA',@level0name=N'Purchasing', @level1type=N'TABLE',@level1name=N'Order_lines', @level2type=N'COLUMN',@level2name=N'ticket_id'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'цена' , @level0type=N'SCHEMA',@level0name=N'Purchasing', @level1type=N'TABLE',@level1name=N'Order_lines', @level2type=N'COLUMN',@level2name=N'price'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'цена сервисного сбора' , @level0type=N'SCHEMA',@level0name=N'Purchasing', @level1type=N'TABLE',@level1name=N'Order_lines', @level2type=N'COLUMN',@level2name=N'service_free_price'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id статуса' , @level0type=N'SCHEMA',@level0name=N'Purchasing', @level1type=N'TABLE',@level1name=N'Order_lines', @level2type=N'COLUMN',@level2name=N'status_id'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id точки продаж' , @level0type=N'SCHEMA',@level0name=N'Purchasing', @level1type=N'TABLE',@level1name=N'Order_lines', @level2type=N'COLUMN',@level2name=N'point_id'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id события' , @level0type=N'SCHEMA',@level0name=N'Purchasing', @level1type=N'TABLE',@level1name=N'Order_lines', @level2type=N'COLUMN',@level2name=N'event_time_id'
GO

/*оплата/возвраты заказов*/
CREATE TABLE [Purchasing].[Order_transactions](
	[id] INT IDENTITY(1,1) NOT NULL,
	[order_id] INT NOT NULL,
	[transaction_amount] DECIMAL(18, 2) NOT NULL,
	[transaction_date] DATETIME NOT NULL,
	[terminal_id] NVARCHAR(50) NULL,
	[rrn] NCHAR(36) NULL,
	CONSTRAINT [PK_Order_transactions] PRIMARY KEY([id]),
	CONSTRAINT [FK_Order_transactions_Orders] FOREIGN KEY([order_id]) REFERENCES [Purchasing].[Orders] ([id])
) ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id заказ' , @level0type=N'SCHEMA',@level0name=N'Purchasing', @level1type=N'TABLE',@level1name=N'Order_transactions', @level2type=N'COLUMN',@level2name=N'order_id'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'сумма' , @level0type=N'SCHEMA',@level0name=N'Purchasing', @level1type=N'TABLE',@level1name=N'Order_transactions', @level2type=N'COLUMN',@level2name=N'transaction_amount'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'дата транзакции' , @level0type=N'SCHEMA',@level0name=N'Purchasing', @level1type=N'TABLE',@level1name=N'Order_transactions', @level2type=N'COLUMN',@level2name=N'transaction_date'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id терминала' , @level0type=N'SCHEMA',@level0name=N'Purchasing', @level1type=N'TABLE',@level1name=N'Order_transactions', @level2type=N'COLUMN',@level2name=N'terminal_id'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'rrn платежа' , @level0type=N'SCHEMA',@level0name=N'Purchasing', @level1type=N'TABLE',@level1name=N'Order_transactions', @level2type=N'COLUMN',@level2name=N'rrn'
GO
