USE [TicketSystem]
GO

/****** Object:  StoredProcedure [dbo].[UpdateTicketsStatus]    Script Date: 06.10.2023 7:27:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,YuskinaAA,Name>
-- Create date: <Create Date,,20230909>
-- Description:	<Description,,Обновить статус билетов>
-- =============================================
CREATE   PROCEDURE [dbo].[UpdateTicketsStatus] 
	@ticketIds [Directory].[TicketIDList] READONLY, @statusName NVARCHAR(50)
AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @statusId INT

	EXEC [dbo].[GetStatusId] @statusName ,'Directory.Tickets', @statusId = @statusId OUTPUT
	
    UPDATE Directory.Tickets 
	SET status_id = @statusId
	WHERE id IN 
	  (SELECT ticketID FROM @ticketIds)

END
GO

