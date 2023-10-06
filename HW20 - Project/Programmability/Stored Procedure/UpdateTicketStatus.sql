USE [TicketSystem]
GO

/****** Object:  StoredProcedure [dbo].[UpdateTicketStatus]    Script Date: 06.10.2023 7:28:12 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,YuskinaAA,Name>
-- Create date: <Create Date,,20230909>
-- Description:	<Description,,Обновить статус билета>
-- =============================================
CREATE PROCEDURE [dbo].[UpdateTicketStatus] 
	@ticketID INT, @statusName NVARCHAR(50)
AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @statusID INT

	EXEC [dbo].[GetStatusId] @statusName ,'Directory.Tickets', @statusID = @statusID OUTPUT
	
    UPDATE Directory.Tickets 
	SET status_id = @statusID
	WHERE id = @ticketID

END
GO

