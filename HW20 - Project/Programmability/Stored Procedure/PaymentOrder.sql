USE [TicketSystem]
GO

/****** Object:  StoredProcedure [dbo].[PaymentOrder]    Script Date: 06.10.2023 7:27:05 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,Yuskina AA,Name>
-- Create date: <Create Date,,20230919>
-- Description:	<Description,,Подтверждение заказа>
-- =============================================
CREATE PROCEDURE [dbo].[PaymentOrder]
	@orderID INT,
	@transactionAmount DECIMAL(18,2),
    @transactionDate DATETIME,
    @terminalID NVARCHAR(50) = NULL,
    @rrn NCHAR(12) = NULL
AS
BEGIN
	SET NOCOUNT ON;
	SET XACT_ABORT ON;

	DECLARE @statusID INT,
	        @statusConfirm INT = 0,
			@ticketIds [Directory].[TicketIDList]

    EXEC [dbo].[getStatusId] '20' ,'Purchasing.Orders', @statusID = @statusConfirm OUTPUT
	EXEC [dbo].[getStatusId] '30' ,'Purchasing.Orders', @statusID = @statusID OUTPUT

	IF NOT EXISTS(SELECT 1 FROM Purchasing.Orders WHERE id = @orderID AND status_id = @statusConfirm)
		THROW 51000, 'The order doesn''t have confirm status.', 1

	BEGIN TRAN
		--process the payment
		INSERT INTO [Purchasing].[Order_transactions]
        ([order_id], [transaction_amount], [transaction_date], [terminal_id], [rrn])
		VALUES
        (@orderId,   @transactionAmount,   @transactionDate,   @terminalID,   @rrn)
		
		--update order status
		UPDATE Purchasing.Orders
		SET status_id = @statusId
		WHERE id = @orderId

		--update tickets status
		INSERT INTO @ticketIds
		SELECT ticket_id
		FROM Purchasing.Order_lines
		WHERE order_id = @orderId

		EXEC UpdateTicketsStatus @ticketIds, '40'

	COMMIT TRAN	
END
GO

