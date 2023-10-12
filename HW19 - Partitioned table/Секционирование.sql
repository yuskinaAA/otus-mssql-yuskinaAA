/*������� ��� ��������������� Events_time*/

--1. �������� �������� ������
ALTER DATABASE [TicketSystem] ADD FILEGROUP [YearData]
GO
--2. ��������� ����
ALTER DATABASE [TicketSystem] ADD FILE 
( NAME = N'Years', FILENAME = N'C:\mssql\Yeardata.ndf' , 
SIZE = 1097152KB , FILEGROWTH = 65536KB ) TO FILEGROUP [YearData]
GO
--3. ������� ������� ��������������
CREATE PARTITION FUNCTION [fnYearPartition](DATETIME) AS RANGE RIGHT FOR VALUES
('20200101','20210101','20220101','20230101');																																																									
GO
--4. ������� �����
CREATE PARTITION SCHEME [schmYearPartition] AS PARTITION [fnYearPartition] 
ALL TO ([YearData])
GO
--5. ������ ����� ���������� ������ � ������ ���������������
ALTER TABLE [Directory].[Events_time] ADD CONSTRAINT PK_Events_time 
PRIMARY KEY CLUSTERED  (start_date, id)
ON [schmYearPartition]([start_date]);

