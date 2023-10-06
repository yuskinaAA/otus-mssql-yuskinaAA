USE [TicketSystem]
GO

/****** Object:  StoredProcedure [dbo].[ReturnPaidTicket]    Script Date: 06.10.2023 7:27:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,YuskinaAA,Name>
-- Create date: <Create Date,,20230925>
-- Description:	<Description,,Вернуть оплаченный билет>
-- =============================================
CREATE PROCEDURE [dbo].[ReturnPaidTicket]
    @orderID INT, 
	@ticketID INT,
	@transactionAmount DECIMAL(18,2),
    @transactionDate DATETIME,
    @terminalID NVARCHAR(50) = NULL,
    @rrn NCHAR(36) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @seqNum INT,
	        @statusId INT,
			@payStatusID INT,
			@id INT,
			@cntTickets INT
    
	BEGIN TRAN

		SET @seqNum = NEXT VALUE FOR dbo.orders

		EXEC [dbo].[getStatusId] '41' ,'Purchasing.Orders', @statusId = @statusId OUTPUT
		EXEC [dbo].[getStatusId] '30', 'Purchasing.Orders', @statusID = @payStatusID OUTPUT

		IF NOT EXISTS (SELECT 1 FROM Purchasing.Orders WHERE id = @orderID AND status_id = @payStatusID)
			THROW 51000, 'The order doesn''t have paid status.', 1
        
		IF EXISTS (SELECT 1 
		           FROM Purchasing.Orders_return oret 
		           INNER JOIN Purchasing.Order_return_lines orl ON orl.order_return_id = oret.id
				   WHERE oret.order_id = @orderID AND orl.ticket_id = @ticketID
				   )
			THROW 51000, 'The ticket had already been returned.', 1
    
		--order return
		INSERT INTO Purchasing.Orders_return
			(seq_number, order_id, point_id,    amount,   service_fee_price, return_date)
		SELECT 
			 @seqNum,    o.id,     ol.point_id, ol.price, ol.service_fee_price, @transactionDate
		FROM Purchasing.Orders o
		INNER JOIN Purchasing.Order_lines ol ON ol.order_id = o.id
		WHERE o.id = @orderId
		AND ol.ticket_id = @ticketID

		SET @id = SCOPE_IDENTITY()
		
		--return lines
		INSERT INTO Purchasing.Order_return_lines
		(order_return_id, ticket_id, price, service_fee_price, order_line_id)
		SELECT 
		 @id,             ticket_id, price, service_fee_price, id
		FROM Purchasing.Order_lines
		WHERE order_id = @orderId
		AND ticket_id = @ticketID

		EXEC UpdateTicketStatus @ticketId, '10'

		--order transaction
		INSERT INTO Purchasing.Order_transactions
		(order_id, transaction_amount, transaction_date, terminal_id, rrn)
		VALUES
		(@orderId, (-1)*@transactionAmount, @transactionDate, @terminalID, @rrn)

		--если это последний билет, изменить статус заказа
		SET @cntTickets = (SELECT COUNT(*) 
		                   FROM Purchasing.Order_lines ol
                           LEFT JOIN Purchasing.Order_return_lines orl ON orl.order_line_id = ol.id
						   WHERE ol.order_id = @orderID AND orl.id IS NULL
						  )

        IF (@cntTickets = 0)
		BEGIN

			--order
			UPDATE Purchasing.Orders
			SET status_id = @statusId
			WHERE id = @orderId

        END

	COMMIT TRAN
END
GO

