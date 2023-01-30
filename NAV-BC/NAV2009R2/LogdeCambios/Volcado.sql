USE [VOLCADO]
GO

INSERT INTO [dbo].[Emp1$Change Log Entry]
           ([Entry No_],
		   [Date and Time]
           ,[Time]
           ,[User ID]
           ,[Table No_]
           ,[Field No_]
           ,[Type of Change]
           ,[Old Value]
           ,[New Value]
           ,[Primary Key]
           ,[Primary Key Field 1 No_]
           ,[Primary Key Field 1 Value]
           ,[Primary Key Field 2 No_]
           ,[Primary Key Field 2 Value]
           ,[Primary Key Field 3 No_]
           ,[Primary Key Field 3 Value])
SELECT [Entry No_]
           ,[Date and Time]
           ,[Time]
           ,[User ID]
           ,[Table No_]
           ,[Field No_]
           ,[Type of Change]
           ,[Old Value]
           ,[New Value]
           ,[Primary Key]
           ,[Primary Key Field 1 No_]
           ,[Primary Key Field 1 Value]
           ,[Primary Key Field 2 No_]
           ,[Primary Key Field 2 Value]
           ,[Primary Key Field 3 No_]
           ,[Primary Key Field 3 Value] From VNM2009R2.dbo.[Avialsa$Change Log Entry] AS ORIGEN
		where not exists(
		 select * from [dbo].[Emp1$Change Log Entry] AS DESTINO
		 where ORIGEN.[Entry No_] = DESTINO.[Entry No_])
GO


