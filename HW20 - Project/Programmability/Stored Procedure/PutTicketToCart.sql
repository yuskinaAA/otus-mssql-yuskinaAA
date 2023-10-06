USE [TicketSystem]
GO

/****** Object:  StoredProcedure [dbo].[PutTicketToCart]    Script Date: 06.10.2023 7:27:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,Yuskina AA,Name>
-- Create date: <Create Date,20230909,>
-- Description:	<Description,,Положить билет в корзину>
-- =============================================
CREATE   PROCEDURE [dbo].[PutTicketToCart] 
	@clientSession UNIQUEIDENTIFIER, 
	@ticketId INT,
	@pointId INT
AS
BEGIN
	SET NOCOUNT ON;
	SET XACT_ABORT ON;

	DECLARE @statusFree INT = 0 

    EXEC GetStatusId '10' ,'Directory.Tickets', @statusID = @statusFree OUTPUT
	
	IF NOT EXISTS(SELECT 1 FROM Directory.Tickets WHERE id = @ticketID AND status_id = @statusFree)
		THROW 51000, 'The ticket isn''t free.', 1

	BEGIN TRAN
		INSERT INTO Purchasing.Cart
			(client_session, ticket_id, price, input_date, 
			 service_fee_price, 
			 point_id, event_time_id)
		SELECT 
			@clientSession, @ticketID, t.price, GETUTCDATE(), 
			ROUND(t.price * ISNULL(sf.per_cent, 0)/100, CAST(ISNULL(sf.round, 0) AS INT)),
			@pointID, t.event_time_id
		FROM Directory.Tickets t
		LEFT JOIN Directory.Service_4_events_time s4et ON s4et.event_time_id = t.event_time_id AND s4et.point_id = @pointID
		LEFT JOIN Directory.Service_fee sf ON sf.id = s4et.service_fee_id
		WHERE t.id = @ticketID


		--помечаем билет на бронирование
		EXECUTE UpdateTicketStatus @ticketID, '20'

	COMMIT TRAN
    
END
GO

