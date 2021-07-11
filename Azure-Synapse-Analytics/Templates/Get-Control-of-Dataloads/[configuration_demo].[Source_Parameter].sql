
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [configuration_demo].[Source_Parameter](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[SourceName] [nvarchar](500) NULL,
	[SourceSchema] [nvarchar](500) NULL,
	[SourceQueryCustom] [nvarchar](max) NULL,
	[DataLakeCatalog] [nvarchar](500) NULL,
	[Worker] [int] NULL,
	[WorkerOrder] [int] NULL,
	[TableDestinationName] [nvarchar](500) NULL,
	[TableDestinationSchema] [nvarchar](500) NULL,
	[IsActive] [bit] NOT NULL,
	[IsIncremental] [bit] NULL,
	[IsIncrementalColumn] [nvarchar](50) NULL,
	[LastLoadtime] [datetime] NULL,
 CONSTRAINT [PK_Source_Parameter] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


