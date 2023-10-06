USE [TicketSystem]
GO

/****** Object:  StoredProcedure [dbo].[DeleteTicketFromCart]    Script Date: 06.10.2023 7:26:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,Yuskina AA,Name>
-- Create date: <Create Date,20230909,>
-- Description:	<Description,,Положить билет в корзину>
-- =============================================
CREATE PROCEDURE [dbo].[DeleteTicketFromCart] 
	@clientSession UNIQUEIDENTIFIER, 
	@ticketId INT
AS
BEGIN
	SET NOCOUNT ON;
	SET XACT_ABORT ON;

	BEGIN TRAN
		
		DELETE FROM Purchasing.Cart WHERE client_session = @clientSession AND ticket_id = @ticketId

		--помечаем билет свободным
		EXECUTE UpdateTicketStatus @ticketID, '10'

	COMMIT TRAN
    
END
GO

