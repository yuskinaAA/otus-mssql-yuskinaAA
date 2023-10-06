USE [TicketSystem]
GO

/****** Object:  StoredProcedure [dbo].[CancelConfirmedOrder]    Script Date: 06.10.2023 7:25:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,Yuskina AA,Name>
-- Create date: <Create Date,,2023-09-23>
-- Description:	<Description,,Отменить неоплаченный заказ>
-- =============================================
CREATE PROCEDURE [dbo].[CancelConfirmedOrder] 
	@orderID INT
AS
BEGIN
	SET NOCOUNT ON;
	SET XACT_ABORT ON;

    DECLARE @confirmStatusID INT
		   ,@cancelStatusID INT
		   ,@ticketIds [Directory].[TicketIDList]

	EXEC GetStatusId '20', 'Purchasing.Orders', @statusID = @confirmStatusID OUTPUT
	EXEC GetStatusId '40', 'Purchasing.Orders', @statusID = @cancelStatusID OUTPUT

	IF NOT EXISTS (SELECT 1 FROM Purchasing.Orders WHERE id = @orderID AND status_id = @confirmStatusID)
		THROW 51000, 'The order doesn''t have confirmed status.', 1
    
	BEGIN TRAN
	    --update orders status 
	    UPDATE Purchasing.Orders
		SET status_id = @cancelStatusID
		WHERE id = @orderID

		--update tickets status
		INSERT INTO @ticketIds
		SELECT ticket_id
		FROM Purchasing.Order_lines
		WHERE order_id = @orderID

		EXEC UpdateTicketsStatus @ticketIds, '10'

	COMMIT TRAN

END
GO

