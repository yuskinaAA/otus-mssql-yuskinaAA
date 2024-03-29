USE [TicketSystem]
GO
/****** Object:  Schema [Dictionary]    Script Date: 06.10.2023 7:33:05 ******/
CREATE SCHEMA [Dictionary]
GO
/****** Object:  Schema [Directory]    Script Date: 06.10.2023 7:33:05 ******/
CREATE SCHEMA [Directory]
GO
/****** Object:  Schema [People]    Script Date: 06.10.2023 7:33:05 ******/
CREATE SCHEMA [People]
GO
/****** Object:  Schema [Purchasing]    Script Date: 06.10.2023 7:33:05 ******/
CREATE SCHEMA [Purchasing]
GO
/****** Object:  Table [Dictionary].[Statuses]    Script Date: 06.10.2023 7:33:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Dictionary].[Statuses](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](50) NOT NULL,
	[description] [nvarchar](100) NULL,
	[table_id] [int] NOT NULL,
 CONSTRAINT [PK_Statuses] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Directory].[Contracts]    Script Date: 06.10.2023 7:33:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Directory].[Contracts](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[owner_id] [int] NOT NULL,
	[dealer_id] [int] NOT NULL,
	[is_closed] [bit] NOT NULL,
 CONSTRAINT [PK_Contracts] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Directory].[Dealers]    Script Date: 06.10.2023 7:33:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Directory].[Dealers](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](100) NOT NULL,
	[seq_number] [int] NOT NULL,
	[is_deleted] [bit] NOT NULL,
 CONSTRAINT [PK_Dealers] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Directory].[Events]    Script Date: 06.10.2023 7:33:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Directory].[Events](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[seq_number] [int] NOT NULL,
	[name] [nvarchar](100) NOT NULL,
	[owner_id] [int] NOT NULL,
	[is_deleted] [int] NOT NULL,
	[description] [nvarchar](200) NULL,
 CONSTRAINT [PK_Events] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Directory].[Events_time]    Script Date: 06.10.2023 7:33:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Directory].[Events_time](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[event_id] [int] NOT NULL,
	[hall_id] [int] NOT NULL,
	[start_date] [datetime] NOT NULL,
	[end_date] [datetime] NOT NULL,
	[is_closed] [bit] NOT NULL,
	[is_deleted] [bit] NOT NULL,
 CONSTRAINT [PK_Events_time] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Directory].[Halls]    Script Date: 06.10.2023 7:33:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Directory].[Halls](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](100) NULL,
	[venue_id] [int] NOT NULL,
	[is_deleted] [bit] NOT NULL,
 CONSTRAINT [PK_Halls] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Directory].[Owners]    Script Date: 06.10.2023 7:33:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Directory].[Owners](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](100) NOT NULL,
	[is_deleted] [bit] NOT NULL,
	[seq_number] [int] NOT NULL,
 CONSTRAINT [PK_Owners] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Directory].[Places]    Script Date: 06.10.2023 7:33:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Directory].[Places](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[sector] [smallint] NOT NULL,
	[row_number] [nvarchar](50) NULL,
	[place_number] [nvarchar](50) NULL,
	[hall_id] [int] NOT NULL,
 CONSTRAINT [PK_Places] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Directory].[Points]    Script Date: 06.10.2023 7:33:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Directory].[Points](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](50) NOT NULL,
	[dealer_id] [int] NOT NULL,
 CONSTRAINT [PK_Points] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Directory].[Service_4_events_time]    Script Date: 06.10.2023 7:33:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Directory].[Service_4_events_time](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[event_time_id] [int] NOT NULL,
	[point_id] [int] NOT NULL,
	[service_fee_id] [int] NOT NULL,
 CONSTRAINT [PK_Service_4_events_time] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Directory].[Service_fee]    Script Date: 06.10.2023 7:33:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Directory].[Service_fee](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](50) NOT NULL,
	[per_cent] [decimal](18, 2) NOT NULL,
	[round] [bit] NOT NULL,
 CONSTRAINT [PK_Service_fee] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Directory].[Tickets]    Script Date: 06.10.2023 7:33:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Directory].[Tickets](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[event_time_id] [int] NOT NULL,
	[place_id] [int] NOT NULL,
	[price] [decimal](18, 3) NOT NULL,
	[input_date] [datetime] NOT NULL,
	[status_id] [int] NOT NULL,
 CONSTRAINT [PK_Tickets] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Directory].[Venues]    Script Date: 06.10.2023 7:33:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Directory].[Venues](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](100) NOT NULL,
	[description] [nvarchar](1000) NULL,
	[is_deleted] [bit] NULL,
 CONSTRAINT [PK_Venues] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [People].[Clients]    Script Date: 06.10.2023 7:33:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [People].[Clients](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[info] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_Clients] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Purchasing].[Cart]    Script Date: 06.10.2023 7:33:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Purchasing].[Cart](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[client_session] [uniqueidentifier] NOT NULL,
	[ticket_id] [int] NOT NULL,
	[input_date] [datetime] NOT NULL,
	[price] [decimal](18, 3) NOT NULL,
	[service_fee_price] [decimal](18, 3) NOT NULL,
	[point_id] [int] NOT NULL,
	[event_time_id] [int] NOT NULL,
 CONSTRAINT [PK_Cart] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Purchasing].[Order_lines]    Script Date: 06.10.2023 7:33:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Purchasing].[Order_lines](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[order_id] [int] NOT NULL,
	[ticket_id] [int] NOT NULL,
	[price] [decimal](18, 3) NOT NULL,
	[service_fee_price] [decimal](18, 3) NOT NULL,
	[point_id] [int] NOT NULL,
	[event_time_id] [int] NOT NULL,
 CONSTRAINT [PK_Order_lines] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Purchasing].[Order_return_lines]    Script Date: 06.10.2023 7:33:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Purchasing].[Order_return_lines](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[order_return_id] [int] NOT NULL,
	[ticket_id] [int] NOT NULL,
	[price] [decimal](18, 3) NOT NULL,
	[service_fee_price] [decimal](18, 3) NOT NULL,
	[order_line_id] [int] NULL,
 CONSTRAINT [PK_Order_return_lines] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Purchasing].[Order_transactions]    Script Date: 06.10.2023 7:33:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Purchasing].[Order_transactions](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[order_id] [int] NOT NULL,
	[transaction_amount] [decimal](18, 2) NOT NULL,
	[transaction_date] [datetime] NOT NULL,
	[terminal_id] [nvarchar](50) NULL,
	[rrn] [nchar](12) NULL,
 CONSTRAINT [PK_Order_transactions] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Purchasing].[Orders]    Script Date: 06.10.2023 7:33:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Purchasing].[Orders](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[seq_number] [int] NOT NULL,
	[point_id] [int] NOT NULL,
	[amount] [decimal](18, 2) NOT NULL,
	[service_fee_price] [decimal](18, 3) NULL,
	[status_id] [int] NOT NULL,
	[order_date] [datetime] NOT NULL,
	[pay_time] [datetime] NULL,
	[event_time_id] [int] NOT NULL,
	[client_id] [int] NULL,
	[is_pushkin] [bit] NULL,
 CONSTRAINT [PK_Orders] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Purchasing].[Orders_return]    Script Date: 06.10.2023 7:33:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Purchasing].[Orders_return](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[order_id] [int] NOT NULL,
	[point_id] [int] NOT NULL,
	[amount] [decimal](18, 2) NOT NULL,
	[service_fee_price] [decimal](18, 3) NULL,
	[return_date] [datetime] NOT NULL,
	[seq_number] [int] NOT NULL,
 CONSTRAINT [PK_Orders_return] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Directory].[Contracts] ADD  DEFAULT ((0)) FOR [is_closed]
GO
ALTER TABLE [Directory].[Dealers] ADD  DEFAULT ((0)) FOR [is_deleted]
GO
ALTER TABLE [Directory].[Events] ADD  DEFAULT ((0)) FOR [is_deleted]
GO
ALTER TABLE [Directory].[Events_time] ADD  DEFAULT ((0)) FOR [is_closed]
GO
ALTER TABLE [Directory].[Events_time] ADD  DEFAULT ((0)) FOR [is_deleted]
GO
ALTER TABLE [Directory].[Owners] ADD  DEFAULT ((0)) FOR [is_deleted]
GO
ALTER TABLE [Directory].[Service_fee] ADD  DEFAULT ((0)) FOR [round]
GO
ALTER TABLE [Directory].[Tickets] ADD  DEFAULT (getdate()) FOR [input_date]
GO
ALTER TABLE [Directory].[Venues] ADD  CONSTRAINT [DF__Venues__is_delet__440B1D61]  DEFAULT ((0)) FOR [is_deleted]
GO
ALTER TABLE [Purchasing].[Cart] ADD  DEFAULT (getdate()) FOR [input_date]
GO
ALTER TABLE [Purchasing].[Orders] ADD  CONSTRAINT [DF__Orders__is_pushk__6D0D32F4]  DEFAULT ((0)) FOR [is_pushkin]
GO
ALTER TABLE [dbo].[bb]  WITH CHECK ADD FOREIGN KEY([a], [b])
REFERENCES [dbo].[aa] ([a], [b])
ON DELETE CASCADE
GO
ALTER TABLE [Directory].[Contracts]  WITH CHECK ADD  CONSTRAINT [FK_Contracts_Dealers] FOREIGN KEY([dealer_id])
REFERENCES [Directory].[Dealers] ([id])
GO
ALTER TABLE [Directory].[Contracts] CHECK CONSTRAINT [FK_Contracts_Dealers]
GO
ALTER TABLE [Directory].[Contracts]  WITH CHECK ADD  CONSTRAINT [FK_Contracts_Owners] FOREIGN KEY([owner_id])
REFERENCES [Directory].[Owners] ([id])
GO
ALTER TABLE [Directory].[Contracts] CHECK CONSTRAINT [FK_Contracts_Owners]
GO
ALTER TABLE [Directory].[Events]  WITH CHECK ADD  CONSTRAINT [FK_Events_Owners] FOREIGN KEY([owner_id])
REFERENCES [Directory].[Owners] ([id])
GO
ALTER TABLE [Directory].[Events] CHECK CONSTRAINT [FK_Events_Owners]
GO
ALTER TABLE [Directory].[Events_time]  WITH CHECK ADD  CONSTRAINT [FK_Events_time_Events] FOREIGN KEY([event_id])
REFERENCES [Directory].[Events] ([id])
GO
ALTER TABLE [Directory].[Events_time] CHECK CONSTRAINT [FK_Events_time_Events]
GO
ALTER TABLE [Directory].[Events_time]  WITH CHECK ADD  CONSTRAINT [FK_Events_time_Halls] FOREIGN KEY([hall_id])
REFERENCES [Directory].[Halls] ([id])
GO
ALTER TABLE [Directory].[Events_time] CHECK CONSTRAINT [FK_Events_time_Halls]
GO
ALTER TABLE [Directory].[Halls]  WITH CHECK ADD  CONSTRAINT [FK_Halls_Venues] FOREIGN KEY([venue_id])
REFERENCES [Directory].[Venues] ([id])
GO
ALTER TABLE [Directory].[Halls] CHECK CONSTRAINT [FK_Halls_Venues]
GO
ALTER TABLE [Directory].[Places]  WITH CHECK ADD  CONSTRAINT [FK_Places_Halls] FOREIGN KEY([hall_id])
REFERENCES [Directory].[Halls] ([id])
GO
ALTER TABLE [Directory].[Places] CHECK CONSTRAINT [FK_Places_Halls]
GO
ALTER TABLE [Directory].[Points]  WITH CHECK ADD  CONSTRAINT [FK_Points_Dealers] FOREIGN KEY([dealer_id])
REFERENCES [Directory].[Dealers] ([id])
GO
ALTER TABLE [Directory].[Points] CHECK CONSTRAINT [FK_Points_Dealers]
GO
ALTER TABLE [Directory].[Service_4_events_time]  WITH CHECK ADD  CONSTRAINT [FK_Service_4_events_time_Event_time] FOREIGN KEY([event_time_id])
REFERENCES [Directory].[Events_time] ([id])
GO
ALTER TABLE [Directory].[Service_4_events_time] CHECK CONSTRAINT [FK_Service_4_events_time_Event_time]
GO
ALTER TABLE [Directory].[Service_4_events_time]  WITH CHECK ADD  CONSTRAINT [FK_Service_4_events_time_Points] FOREIGN KEY([point_id])
REFERENCES [Directory].[Points] ([id])
GO
ALTER TABLE [Directory].[Service_4_events_time] CHECK CONSTRAINT [FK_Service_4_events_time_Points]
GO
ALTER TABLE [Directory].[Service_4_events_time]  WITH CHECK ADD  CONSTRAINT [FK_Service_4_events_time_Service_fee] FOREIGN KEY([service_fee_id])
REFERENCES [Directory].[Service_fee] ([id])
GO
ALTER TABLE [Directory].[Service_4_events_time] CHECK CONSTRAINT [FK_Service_4_events_time_Service_fee]
GO
ALTER TABLE [Directory].[Tickets]  WITH CHECK ADD  CONSTRAINT [FK_Tickets_Events_time] FOREIGN KEY([event_time_id])
REFERENCES [Directory].[Events_time] ([id])
GO
ALTER TABLE [Directory].[Tickets] CHECK CONSTRAINT [FK_Tickets_Events_time]
GO
ALTER TABLE [Directory].[Tickets]  WITH CHECK ADD  CONSTRAINT [FK_Tickets_Statuses] FOREIGN KEY([status_id])
REFERENCES [Dictionary].[Statuses] ([id])
GO
ALTER TABLE [Directory].[Tickets] CHECK CONSTRAINT [FK_Tickets_Statuses]
GO
ALTER TABLE [Purchasing].[Cart]  WITH CHECK ADD  CONSTRAINT [FK_Cart_Events_time] FOREIGN KEY([event_time_id])
REFERENCES [Directory].[Events_time] ([id])
GO
ALTER TABLE [Purchasing].[Cart] CHECK CONSTRAINT [FK_Cart_Events_time]
GO
ALTER TABLE [Purchasing].[Cart]  WITH CHECK ADD  CONSTRAINT [FK_Cart_Points] FOREIGN KEY([point_id])
REFERENCES [Directory].[Points] ([id])
GO
ALTER TABLE [Purchasing].[Cart] CHECK CONSTRAINT [FK_Cart_Points]
GO
ALTER TABLE [Purchasing].[Cart]  WITH CHECK ADD  CONSTRAINT [FK_Cart_Tickets] FOREIGN KEY([ticket_id])
REFERENCES [Directory].[Tickets] ([id])
GO
ALTER TABLE [Purchasing].[Cart] CHECK CONSTRAINT [FK_Cart_Tickets]
GO
ALTER TABLE [Purchasing].[Order_lines]  WITH CHECK ADD  CONSTRAINT [FK_Order_lines_Events_time] FOREIGN KEY([event_time_id])
REFERENCES [Directory].[Events_time] ([id])
GO
ALTER TABLE [Purchasing].[Order_lines] CHECK CONSTRAINT [FK_Order_lines_Events_time]
GO
ALTER TABLE [Purchasing].[Order_lines]  WITH CHECK ADD  CONSTRAINT [FK_Order_lines_Orders] FOREIGN KEY([order_id])
REFERENCES [Purchasing].[Orders] ([id])
GO
ALTER TABLE [Purchasing].[Order_lines] CHECK CONSTRAINT [FK_Order_lines_Orders]
GO
ALTER TABLE [Purchasing].[Order_lines]  WITH CHECK ADD  CONSTRAINT [FK_Order_lines_Points] FOREIGN KEY([point_id])
REFERENCES [Directory].[Points] ([id])
GO
ALTER TABLE [Purchasing].[Order_lines] CHECK CONSTRAINT [FK_Order_lines_Points]
GO
ALTER TABLE [Purchasing].[Order_lines]  WITH CHECK ADD  CONSTRAINT [FK_Order_lines_Tickets] FOREIGN KEY([ticket_id])
REFERENCES [Directory].[Tickets] ([id])
GO
ALTER TABLE [Purchasing].[Order_lines] CHECK CONSTRAINT [FK_Order_lines_Tickets]
GO
ALTER TABLE [Purchasing].[Order_return_lines]  WITH CHECK ADD  CONSTRAINT [FK_Order_return_lines_Events_time] FOREIGN KEY([order_return_id])
REFERENCES [Purchasing].[Orders_return] ([id])
GO
ALTER TABLE [Purchasing].[Order_return_lines] CHECK CONSTRAINT [FK_Order_return_lines_Events_time]
GO
ALTER TABLE [Purchasing].[Order_return_lines]  WITH CHECK ADD  CONSTRAINT [FK_Order_return_lines_Order_lines] FOREIGN KEY([order_line_id])
REFERENCES [Purchasing].[Order_lines] ([id])
GO
ALTER TABLE [Purchasing].[Order_return_lines] CHECK CONSTRAINT [FK_Order_return_lines_Order_lines]
GO
ALTER TABLE [Purchasing].[Order_return_lines]  WITH CHECK ADD  CONSTRAINT [FK_Order_return_lines_Tickets] FOREIGN KEY([ticket_id])
REFERENCES [Directory].[Tickets] ([id])
GO
ALTER TABLE [Purchasing].[Order_return_lines] CHECK CONSTRAINT [FK_Order_return_lines_Tickets]
GO
ALTER TABLE [Purchasing].[Order_transactions]  WITH CHECK ADD  CONSTRAINT [FK_Order_transactions_Orders] FOREIGN KEY([order_id])
REFERENCES [Purchasing].[Orders] ([id])
GO
ALTER TABLE [Purchasing].[Order_transactions] CHECK CONSTRAINT [FK_Order_transactions_Orders]
GO
ALTER TABLE [Purchasing].[Orders]  WITH CHECK ADD  CONSTRAINT [FK_Orders_Clients] FOREIGN KEY([client_id])
REFERENCES [People].[Clients] ([id])
GO
ALTER TABLE [Purchasing].[Orders] CHECK CONSTRAINT [FK_Orders_Clients]
GO
ALTER TABLE [Purchasing].[Orders]  WITH CHECK ADD  CONSTRAINT [FK_Orders_Event_time] FOREIGN KEY([event_time_id])
REFERENCES [Directory].[Events_time] ([id])
GO
ALTER TABLE [Purchasing].[Orders] CHECK CONSTRAINT [FK_Orders_Event_time]
GO
ALTER TABLE [Purchasing].[Orders]  WITH CHECK ADD  CONSTRAINT [FK_Orders_Points] FOREIGN KEY([point_id])
REFERENCES [Directory].[Points] ([id])
GO
ALTER TABLE [Purchasing].[Orders] CHECK CONSTRAINT [FK_Orders_Points]
GO
ALTER TABLE [Purchasing].[Orders]  WITH CHECK ADD  CONSTRAINT [FK_Orders_Statuses] FOREIGN KEY([status_id])
REFERENCES [Dictionary].[Statuses] ([id])
GO
ALTER TABLE [Purchasing].[Orders] CHECK CONSTRAINT [FK_Orders_Statuses]
GO
ALTER TABLE [Purchasing].[Orders_return]  WITH CHECK ADD  CONSTRAINT [FK_Orders_return_Orders] FOREIGN KEY([order_id])
REFERENCES [Purchasing].[Orders] ([id])
GO
ALTER TABLE [Purchasing].[Orders_return] CHECK CONSTRAINT [FK_Orders_return_Orders]
GO
ALTER TABLE [Purchasing].[Orders_return]  WITH CHECK ADD  CONSTRAINT [FK_Orders_return_Points] FOREIGN KEY([point_id])
REFERENCES [Directory].[Points] ([id])
GO
ALTER TABLE [Purchasing].[Orders_return] CHECK CONSTRAINT [FK_Orders_return_Points]
GO
ALTER TABLE [dbo].[Tidentity]  WITH CHECK ADD CHECK  (([name] like '[a-z]'))
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'имя' , @level0type=N'SCHEMA',@level0name=N'Dictionary', @level1type=N'TABLE',@level1name=N'Statuses', @level2type=N'COLUMN',@level2name=N'name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'описание' , @level0type=N'SCHEMA',@level0name=N'Dictionary', @level1type=N'TABLE',@level1name=N'Statuses', @level2type=N'COLUMN',@level2name=N'description'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'к какой таблице относятся' , @level0type=N'SCHEMA',@level0name=N'Dictionary', @level1type=N'TABLE',@level1name=N'Statuses', @level2type=N'COLUMN',@level2name=N'table_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id владельца' , @level0type=N'SCHEMA',@level0name=N'Directory', @level1type=N'TABLE',@level1name=N'Contracts', @level2type=N'COLUMN',@level2name=N'owner_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id дилера' , @level0type=N'SCHEMA',@level0name=N'Directory', @level1type=N'TABLE',@level1name=N'Contracts', @level2type=N'COLUMN',@level2name=N'dealer_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'закрыт' , @level0type=N'SCHEMA',@level0name=N'Directory', @level1type=N'TABLE',@level1name=N'Contracts', @level2type=N'COLUMN',@level2name=N'is_closed'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'имя дилера' , @level0type=N'SCHEMA',@level0name=N'Directory', @level1type=N'TABLE',@level1name=N'Dealers', @level2type=N'COLUMN',@level2name=N'name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'номер' , @level0type=N'SCHEMA',@level0name=N'Directory', @level1type=N'TABLE',@level1name=N'Dealers', @level2type=N'COLUMN',@level2name=N'seq_number'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Порядковый номер события' , @level0type=N'SCHEMA',@level0name=N'Directory', @level1type=N'TABLE',@level1name=N'Events', @level2type=N'COLUMN',@level2name=N'seq_number'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Наименование события' , @level0type=N'SCHEMA',@level0name=N'Directory', @level1type=N'TABLE',@level1name=N'Events', @level2type=N'COLUMN',@level2name=N'name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Владелец' , @level0type=N'SCHEMA',@level0name=N'Directory', @level1type=N'TABLE',@level1name=N'Events', @level2type=N'COLUMN',@level2name=N'owner_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Удален' , @level0type=N'SCHEMA',@level0name=N'Directory', @level1type=N'TABLE',@level1name=N'Events', @level2type=N'COLUMN',@level2name=N'is_deleted'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Описание' , @level0type=N'SCHEMA',@level0name=N'Directory', @level1type=N'TABLE',@level1name=N'Events', @level2type=N'COLUMN',@level2name=N'description'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id события' , @level0type=N'SCHEMA',@level0name=N'Directory', @level1type=N'TABLE',@level1name=N'Events_time', @level2type=N'COLUMN',@level2name=N'event_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id зала' , @level0type=N'SCHEMA',@level0name=N'Directory', @level1type=N'TABLE',@level1name=N'Events_time', @level2type=N'COLUMN',@level2name=N'hall_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'дата начала' , @level0type=N'SCHEMA',@level0name=N'Directory', @level1type=N'TABLE',@level1name=N'Events_time', @level2type=N'COLUMN',@level2name=N'start_date'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'дата окончания' , @level0type=N'SCHEMA',@level0name=N'Directory', @level1type=N'TABLE',@level1name=N'Events_time', @level2type=N'COLUMN',@level2name=N'end_date'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'продажи открыты/закрыты' , @level0type=N'SCHEMA',@level0name=N'Directory', @level1type=N'TABLE',@level1name=N'Events_time', @level2type=N'COLUMN',@level2name=N'is_closed'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Удален' , @level0type=N'SCHEMA',@level0name=N'Directory', @level1type=N'TABLE',@level1name=N'Events_time', @level2type=N'COLUMN',@level2name=N'is_deleted'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'имя зала' , @level0type=N'SCHEMA',@level0name=N'Directory', @level1type=N'TABLE',@level1name=N'Halls', @level2type=N'COLUMN',@level2name=N'name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id площадки' , @level0type=N'SCHEMA',@level0name=N'Directory', @level1type=N'TABLE',@level1name=N'Halls', @level2type=N'COLUMN',@level2name=N'venue_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'удален' , @level0type=N'SCHEMA',@level0name=N'Directory', @level1type=N'TABLE',@level1name=N'Halls', @level2type=N'COLUMN',@level2name=N'is_deleted'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Наименование владельца билетов' , @level0type=N'SCHEMA',@level0name=N'Directory', @level1type=N'TABLE',@level1name=N'Owners', @level2type=N'COLUMN',@level2name=N'name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Удален' , @level0type=N'SCHEMA',@level0name=N'Directory', @level1type=N'TABLE',@level1name=N'Owners', @level2type=N'COLUMN',@level2name=N'is_deleted'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Порядковый номер' , @level0type=N'SCHEMA',@level0name=N'Directory', @level1type=N'TABLE',@level1name=N'Owners', @level2type=N'COLUMN',@level2name=N'seq_number'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'номер сектора' , @level0type=N'SCHEMA',@level0name=N'Directory', @level1type=N'TABLE',@level1name=N'Places', @level2type=N'COLUMN',@level2name=N'sector'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'номер ряда' , @level0type=N'SCHEMA',@level0name=N'Directory', @level1type=N'TABLE',@level1name=N'Places', @level2type=N'COLUMN',@level2name=N'row_number'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'номер места' , @level0type=N'SCHEMA',@level0name=N'Directory', @level1type=N'TABLE',@level1name=N'Places', @level2type=N'COLUMN',@level2name=N'place_number'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id зала' , @level0type=N'SCHEMA',@level0name=N'Directory', @level1type=N'TABLE',@level1name=N'Places', @level2type=N'COLUMN',@level2name=N'hall_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'имя' , @level0type=N'SCHEMA',@level0name=N'Directory', @level1type=N'TABLE',@level1name=N'Points', @level2type=N'COLUMN',@level2name=N'name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id дилера' , @level0type=N'SCHEMA',@level0name=N'Directory', @level1type=N'TABLE',@level1name=N'Points', @level2type=N'COLUMN',@level2name=N'dealer_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id события' , @level0type=N'SCHEMA',@level0name=N'Directory', @level1type=N'TABLE',@level1name=N'Service_4_events_time', @level2type=N'COLUMN',@level2name=N'event_time_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id точки продаж' , @level0type=N'SCHEMA',@level0name=N'Directory', @level1type=N'TABLE',@level1name=N'Service_4_events_time', @level2type=N'COLUMN',@level2name=N'point_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id сервисного сбора' , @level0type=N'SCHEMA',@level0name=N'Directory', @level1type=N'TABLE',@level1name=N'Service_4_events_time', @level2type=N'COLUMN',@level2name=N'service_fee_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'имя' , @level0type=N'SCHEMA',@level0name=N'Directory', @level1type=N'TABLE',@level1name=N'Service_fee', @level2type=N'COLUMN',@level2name=N'name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'процент' , @level0type=N'SCHEMA',@level0name=N'Directory', @level1type=N'TABLE',@level1name=N'Service_fee', @level2type=N'COLUMN',@level2name=N'per_cent'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'округлять' , @level0type=N'SCHEMA',@level0name=N'Directory', @level1type=N'TABLE',@level1name=N'Service_fee', @level2type=N'COLUMN',@level2name=N'round'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id события' , @level0type=N'SCHEMA',@level0name=N'Directory', @level1type=N'TABLE',@level1name=N'Tickets', @level2type=N'COLUMN',@level2name=N'event_time_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id места' , @level0type=N'SCHEMA',@level0name=N'Directory', @level1type=N'TABLE',@level1name=N'Tickets', @level2type=N'COLUMN',@level2name=N'place_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'цена' , @level0type=N'SCHEMA',@level0name=N'Directory', @level1type=N'TABLE',@level1name=N'Tickets', @level2type=N'COLUMN',@level2name=N'price'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'дата ввода' , @level0type=N'SCHEMA',@level0name=N'Directory', @level1type=N'TABLE',@level1name=N'Tickets', @level2type=N'COLUMN',@level2name=N'input_date'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id статуса' , @level0type=N'SCHEMA',@level0name=N'Directory', @level1type=N'TABLE',@level1name=N'Tickets', @level2type=N'COLUMN',@level2name=N'status_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'имя площадки' , @level0type=N'SCHEMA',@level0name=N'Directory', @level1type=N'TABLE',@level1name=N'Venues', @level2type=N'COLUMN',@level2name=N'name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'описание' , @level0type=N'SCHEMA',@level0name=N'Directory', @level1type=N'TABLE',@level1name=N'Venues', @level2type=N'COLUMN',@level2name=N'description'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'удален' , @level0type=N'SCHEMA',@level0name=N'Directory', @level1type=N'TABLE',@level1name=N'Venues', @level2type=N'COLUMN',@level2name=N'is_deleted'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'инфо о клиента' , @level0type=N'SCHEMA',@level0name=N'People', @level1type=N'TABLE',@level1name=N'Clients', @level2type=N'COLUMN',@level2name=N'info'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'guid клиента' , @level0type=N'SCHEMA',@level0name=N'Purchasing', @level1type=N'TABLE',@level1name=N'Cart', @level2type=N'COLUMN',@level2name=N'client_session'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id билета' , @level0type=N'SCHEMA',@level0name=N'Purchasing', @level1type=N'TABLE',@level1name=N'Cart', @level2type=N'COLUMN',@level2name=N'ticket_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'время создания' , @level0type=N'SCHEMA',@level0name=N'Purchasing', @level1type=N'TABLE',@level1name=N'Cart', @level2type=N'COLUMN',@level2name=N'input_date'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'цена' , @level0type=N'SCHEMA',@level0name=N'Purchasing', @level1type=N'TABLE',@level1name=N'Cart', @level2type=N'COLUMN',@level2name=N'price'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'цена сервисного сбора' , @level0type=N'SCHEMA',@level0name=N'Purchasing', @level1type=N'TABLE',@level1name=N'Cart', @level2type=N'COLUMN',@level2name=N'service_fee_price'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'точка продажи' , @level0type=N'SCHEMA',@level0name=N'Purchasing', @level1type=N'TABLE',@level1name=N'Cart', @level2type=N'COLUMN',@level2name=N'point_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id события' , @level0type=N'SCHEMA',@level0name=N'Purchasing', @level1type=N'TABLE',@level1name=N'Cart', @level2type=N'COLUMN',@level2name=N'event_time_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id заказа' , @level0type=N'SCHEMA',@level0name=N'Purchasing', @level1type=N'TABLE',@level1name=N'Order_lines', @level2type=N'COLUMN',@level2name=N'order_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id билета' , @level0type=N'SCHEMA',@level0name=N'Purchasing', @level1type=N'TABLE',@level1name=N'Order_lines', @level2type=N'COLUMN',@level2name=N'ticket_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'цена' , @level0type=N'SCHEMA',@level0name=N'Purchasing', @level1type=N'TABLE',@level1name=N'Order_lines', @level2type=N'COLUMN',@level2name=N'price'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'цена сервисного сбора' , @level0type=N'SCHEMA',@level0name=N'Purchasing', @level1type=N'TABLE',@level1name=N'Order_lines', @level2type=N'COLUMN',@level2name=N'service_fee_price'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id точки продаж' , @level0type=N'SCHEMA',@level0name=N'Purchasing', @level1type=N'TABLE',@level1name=N'Order_lines', @level2type=N'COLUMN',@level2name=N'point_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id события' , @level0type=N'SCHEMA',@level0name=N'Purchasing', @level1type=N'TABLE',@level1name=N'Order_lines', @level2type=N'COLUMN',@level2name=N'event_time_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id возврата' , @level0type=N'SCHEMA',@level0name=N'Purchasing', @level1type=N'TABLE',@level1name=N'Order_return_lines', @level2type=N'COLUMN',@level2name=N'order_return_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id билета' , @level0type=N'SCHEMA',@level0name=N'Purchasing', @level1type=N'TABLE',@level1name=N'Order_return_lines', @level2type=N'COLUMN',@level2name=N'ticket_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'цена билета' , @level0type=N'SCHEMA',@level0name=N'Purchasing', @level1type=N'TABLE',@level1name=N'Order_return_lines', @level2type=N'COLUMN',@level2name=N'price'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'цена сервисного сбора' , @level0type=N'SCHEMA',@level0name=N'Purchasing', @level1type=N'TABLE',@level1name=N'Order_return_lines', @level2type=N'COLUMN',@level2name=N'service_fee_price'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id заказ' , @level0type=N'SCHEMA',@level0name=N'Purchasing', @level1type=N'TABLE',@level1name=N'Order_transactions', @level2type=N'COLUMN',@level2name=N'order_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'сумма' , @level0type=N'SCHEMA',@level0name=N'Purchasing', @level1type=N'TABLE',@level1name=N'Order_transactions', @level2type=N'COLUMN',@level2name=N'transaction_amount'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'дата транзакции' , @level0type=N'SCHEMA',@level0name=N'Purchasing', @level1type=N'TABLE',@level1name=N'Order_transactions', @level2type=N'COLUMN',@level2name=N'transaction_date'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id терминала' , @level0type=N'SCHEMA',@level0name=N'Purchasing', @level1type=N'TABLE',@level1name=N'Order_transactions', @level2type=N'COLUMN',@level2name=N'terminal_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'rrn платежа' , @level0type=N'SCHEMA',@level0name=N'Purchasing', @level1type=N'TABLE',@level1name=N'Order_transactions', @level2type=N'COLUMN',@level2name=N'rrn'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'номер заказа' , @level0type=N'SCHEMA',@level0name=N'Purchasing', @level1type=N'TABLE',@level1name=N'Orders', @level2type=N'COLUMN',@level2name=N'seq_number'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'точка продаж' , @level0type=N'SCHEMA',@level0name=N'Purchasing', @level1type=N'TABLE',@level1name=N'Orders', @level2type=N'COLUMN',@level2name=N'point_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'сумма заказа' , @level0type=N'SCHEMA',@level0name=N'Purchasing', @level1type=N'TABLE',@level1name=N'Orders', @level2type=N'COLUMN',@level2name=N'amount'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'сумма сервисного сбора' , @level0type=N'SCHEMA',@level0name=N'Purchasing', @level1type=N'TABLE',@level1name=N'Orders', @level2type=N'COLUMN',@level2name=N'service_fee_price'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id статуса' , @level0type=N'SCHEMA',@level0name=N'Purchasing', @level1type=N'TABLE',@level1name=N'Orders', @level2type=N'COLUMN',@level2name=N'status_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'дата заказа' , @level0type=N'SCHEMA',@level0name=N'Purchasing', @level1type=N'TABLE',@level1name=N'Orders', @level2type=N'COLUMN',@level2name=N'order_date'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'дата оплаты заказа' , @level0type=N'SCHEMA',@level0name=N'Purchasing', @level1type=N'TABLE',@level1name=N'Orders', @level2type=N'COLUMN',@level2name=N'pay_time'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id события' , @level0type=N'SCHEMA',@level0name=N'Purchasing', @level1type=N'TABLE',@level1name=N'Orders', @level2type=N'COLUMN',@level2name=N'event_time_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id клиента' , @level0type=N'SCHEMA',@level0name=N'Purchasing', @level1type=N'TABLE',@level1name=N'Orders', @level2type=N'COLUMN',@level2name=N'client_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'по пушкинской карте' , @level0type=N'SCHEMA',@level0name=N'Purchasing', @level1type=N'TABLE',@level1name=N'Orders', @level2type=N'COLUMN',@level2name=N'is_pushkin'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id заказа' , @level0type=N'SCHEMA',@level0name=N'Purchasing', @level1type=N'TABLE',@level1name=N'Orders_return', @level2type=N'COLUMN',@level2name=N'order_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'точка продаж' , @level0type=N'SCHEMA',@level0name=N'Purchasing', @level1type=N'TABLE',@level1name=N'Orders_return', @level2type=N'COLUMN',@level2name=N'point_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'сумма возврата' , @level0type=N'SCHEMA',@level0name=N'Purchasing', @level1type=N'TABLE',@level1name=N'Orders_return', @level2type=N'COLUMN',@level2name=N'amount'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'сумма сервисного сбора' , @level0type=N'SCHEMA',@level0name=N'Purchasing', @level1type=N'TABLE',@level1name=N'Orders_return', @level2type=N'COLUMN',@level2name=N'service_fee_price'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'дата возврата' , @level0type=N'SCHEMA',@level0name=N'Purchasing', @level1type=N'TABLE',@level1name=N'Orders_return', @level2type=N'COLUMN',@level2name=N'return_date'
GO
