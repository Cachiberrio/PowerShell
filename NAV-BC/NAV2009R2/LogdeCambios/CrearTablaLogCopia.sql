/*    ==Scripting Parameters==

    Source Server Version : SQL Server 2012 (11.0.7001)
    Source Database Engine Edition : Microsoft SQL Server Standard Edition
    Source Database Engine Type : Standalone SQL Server

    Target Server Version : SQL Server 2012
    Target Database Engine Edition : Microsoft SQL Server Standard Edition
    Target Database Engine Type : Standalone SQL Server
*/

USE [VOLCADO]
GO

/****** Object:  Table [dbo].[Emp1$Change Log Entry]    Script Date: 28/05/2021 13:52:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Emp1$Change Log Entry](
	[timestamp] [timestamp] NOT NULL,
	[Entry No_] [bigint] NOT NULL,
	[Date and Time] [datetime] NOT NULL,
	[Time] [datetime] NOT NULL,
	[User ID] [varchar](20) NOT NULL,
	[Table No_] [int] NOT NULL,
	[Field No_] [int] NOT NULL,
	[Type of Change] [int] NOT NULL,
	[Old Value] [varchar](250) NOT NULL,
	[New Value] [varchar](250) NOT NULL,
	[Primary Key] [varchar](250) NOT NULL,
	[Primary Key Field 1 No_] [int] NOT NULL,
	[Primary Key Field 1 Value] [varchar](50) NOT NULL,
	[Primary Key Field 2 No_] [int] NOT NULL,
	[Primary Key Field 2 Value] [varchar](50) NOT NULL,
	[Primary Key Field 3 No_] [int] NOT NULL,
	[Primary Key Field 3 Value] [varchar](50) NOT NULL,
 CONSTRAINT [Avialsa$Change Log Entry$0] PRIMARY KEY CLUSTERED 
(
	[Entry No_] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


