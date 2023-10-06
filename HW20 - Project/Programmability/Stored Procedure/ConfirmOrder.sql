USE [TicketSystem]
GO

/****** Object:  StoredProcedure [dbo].[ConfirmOrder]    Script Date: 06.10.2023 7:26:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,Yuskina AA,Name>
-- Create date: <Create Date,,20230910>
-- Description:	<Description,, Подтвердить заказ>
-- =============================================
CREATE PROCEDURE [dbo].[ConfirmOrder]
	@orderID INT
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @confirmStatusID INT
		   ,@bookStatusID INT

	EXEC GetStatusId '20', 'Purchasing.Orders', @statusID = @confirmStatusID OUTPUT
	EXEC GetStatusId '10', 'Purchasing.Orders', @statusID = @bookStatusID OUTPUT

	IF NOT EXISTS (SELECT 1 FROM Purchasing.Orders WHERE id = @orderID AND status_id = @bookStatusID)
		THROW 51000, 'The order doesn''t have booked status.', 1
    
	UPDATE Purchasing.Orders
	SET status_id = @confirmStatusID
	WHERE id = @orderID
END
GO

