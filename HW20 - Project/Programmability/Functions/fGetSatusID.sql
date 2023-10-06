USE [TicketSystem]
GO

/****** Object:  UserDefinedFunction [dbo].[fGetSatusID]    Script Date: 06.10.2023 7:28:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,Yuskina AA,Name>
-- Create date: <Create Date, ,20230925>
-- Description:	<Description, ,Получить идентификатор билета>
-- =============================================
CREATE FUNCTION [dbo].[fGetSatusID]
(
	@statusName NVARCHAR(50), @tableName NVARCHAR(100)
)
RETURNS INT
AS
BEGIN
    
	DECLARE @statusID INT = NULL
    
	SET @statusID = (SELECT id 
					 FROM Dictionary.Statuses 
					 WHERE name = @statusName AND table_id = OBJECT_ID(@tableName)
                    )  

	RETURN @statusID

END
GO

