USE [TicketSystem]
GO

/****** Object:  StoredProcedure [dbo].[CreateOrder]    Script Date: 06.10.2023 7:26:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,YuskinaAA,Name>
-- Create date: <Create Date,,20230909>
-- Description:	<Description,,Создать заказ>
-- =============================================
CREATE   PROCEDURE [dbo].[CreateOrder]
	@clientSession UNIQUEIDENTIFIER,

	@id INT = 0 OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	SET XACT_ABORT ON;

	DECLARE @seqNum INT,
	        @statusId INT,
			@ticketIds [Directory].[TicketIDList]
    
	BEGIN TRAN
		SET @seqNum = NEXT VALUE FOR dbo.orders
		EXEC [dbo].[getStatusId] '10' ,'Purchasing.Orders', @statusId = @statusId OUTPUT
		--order
		INSERT INTO Purchasing.Orders
			(seq_number, point_id, amount,    service_fee_price,      status_id, 
			 order_date, event_time_id)
		SELECT 
			 @seqNum,   point_id, SUM(price), SUM(service_fee_price), @statusId,
			 GetUTCDate(), event_time_id
		FROM Purchasing.Cart
		WHERE client_session = @clientSession
		GROUP BY client_session, point_id, event_time_id

		SET @id = SCOPE_IDENTITY()
		
		--lines
		INSERT INTO Purchasing.Order_lines
		(order_id, ticket_id, price, service_fee_price,
         point_id, event_time_id		)
		SELECT 
		 @id,       ticket_id, price, service_fee_price,
		 point_id,  event_time_id
		FROM Purchasing.Cart
		WHERE cart.client_session = @clientSession

		--update tickets status
		INSERT INTO @ticketIds
		SELECT ticket_id
		FROM Purchasing.Cart
		WHERE client_session = @clientSession

		EXEC UpdateTicketsStatus @ticketIds, '30'

		--clear cart
		DELETE FROM Purchasing.Cart WHERE client_session = @clientSession

    COMMIT TRAN
END
GO

