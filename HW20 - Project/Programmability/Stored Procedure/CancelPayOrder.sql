USE [TicketSystem]
GO

/****** Object:  StoredProcedure [dbo].[CancelPayOrder]    Script Date: 06.10.2023 7:25:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,Yuskina AA,Name>
-- Create date: <Create Date,,20230923>
-- Description:	<Description,,Отмена оплаченного заказа>
-- =============================================
CREATE PROCEDURE [dbo].[CancelPayOrder]
	@orderId INT,
	@transactionAmount DECIMAL(18,2),
    @transactionDate DATETIME,
    @terminalID NVARCHAR(50) = NULL,
    @rrn NCHAR(36) = NULL
AS
BEGIN
	SET NOCOUNT ON;
	SET XACT_ABORT ON;
		
	DECLARE @seqNum INT,
	        @statusId INT,
			@payStatusID INT,
			@id INT,
		    @ticketIds [Directory].[TicketIDList]
    
	BEGIN TRAN

		SET @seqNum = NEXT VALUE FOR dbo.orders

		EXEC [dbo].[getStatusId] '41' ,'Purchasing.Orders', @statusId = @statusId OUTPUT
		EXEC [dbo].[getStatusId] '30', 'Purchasing.Orders', @statusID = @payStatusID OUTPUT

		IF NOT EXISTS (SELECT 1 FROM Purchasing.Orders WHERE id = @orderID AND status_id = @payStatusID)
			THROW 51000, 'The order doesn''t have paid status.', 1
    
		--order
	    UPDATE Purchasing.Orders
		SET status_id = @statusId
		WHERE id = @orderId

		--order return
		INSERT INTO Purchasing.Orders_return
			(seq_number, order_id, point_id, amount, service_fee_price, return_date)
		SELECT 
			 @seqNum,    id,       point_id, amount, service_fee_price, @transactionDate
		FROM Purchasing.Orders
		WHERE id = @orderId

		SET @id = SCOPE_IDENTITY()
		
		--return lines
		INSERT INTO Purchasing.Order_return_lines
		(order_return_id, ticket_id, price, service_fee_price, order_line_id)
		SELECT 
		 @id,             ticket_id, price, service_fee_price, id
		FROM Purchasing.Order_lines
		WHERE order_id = @orderId

		--update tickets status
		INSERT INTO @ticketIds
		SELECT ticket_id
		FROM Purchasing.Order_lines
		WHERE id = @orderId

		EXEC UpdateTicketsStatus @ticketIds, '10'

		--order transaction
		INSERT INTO Purchasing.Order_transactions
		(order_id, transaction_amount, transaction_date, terminal_id, rrn)
		VALUES
		(@orderId, (-1)*@transactionAmount, @transactionDate, @terminalID, @rrn)

	COMMIT TRAN
END
GO

