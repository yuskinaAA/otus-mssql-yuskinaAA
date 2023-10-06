USE [TicketSystem]
GO

/****** Object:  StoredProcedure [dbo].[GetStatusId]    Script Date: 06.10.2023 7:26:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,Yuskina AA,Name>
-- Create date: <Create Date,,20230910>
-- Description:	<Description,,Получить идентификатор статуса>
-- =============================================
CREATE   PROCEDURE [dbo].[GetStatusId]
	@statusName NVARCHAR(50), @tableName NVARCHAR(100), @statusID INT OUTPUT
AS
BEGIN
	
	SET NOCOUNT ON;

	SELECT @statusID = id 
	FROM Dictionary.Statuses 
	WHERE name = @statusName AND table_id = OBJECT_ID(@tableName)
	
	IF (@statusID IS NULL)
		THROW 51000, 'The status does not exist.', 1
	
END
GO

