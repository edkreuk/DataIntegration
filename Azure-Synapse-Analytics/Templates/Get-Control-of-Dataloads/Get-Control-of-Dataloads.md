# Get control of your dataloads with Metadata

Use this template to get control of your dataloads in Azure Synapse Analytics or in Azure Data Factory. 



# How to use this solution template

Create a control table in Azure SQL Database to store the Metadata. 
>[!NOTE]
    > The table and view can be stored in any database, but preferred in a database where you store all your configuration in.

```sql

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

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE view [execution_demo].[Load_DataLake_Files]
AS 
/**********************************************************************************************************
* View Name:  [execution_demo].[Load_DataLake_Files]
*   
* Purpose:    View to show the records which should be processed
*               
*               
* Revision Date/Time: 

**********************************************************************************************************/


SELECT	 SP.Id as [PipelineParameterId]
		
		,SP.[SourceName] 
		,isnull(CASE WHEN SP.[SourceSchema] != '' THEN SP.[SourceSchema] END, 'Unknown')  as SourceSchema 
		,case when Worker not in (1,2,3,4,5,6)  then 1 else Worker end Worker 
		,WorkerOrder 
		,case	when	SourceQueryCustom is null  
			then	'SELECT * FROM [' +isnull(CASE WHEN SP.[SourceSchema] != '' THEN SP.[SourceSchema] END, 'Unknown') + '].[' + SP.[SourceName] + '] where 0 = ' + convert(nvarchar(1),[IsIncremental]) + ' OR 1 = ' + convert(nvarchar(1),[IsIncremental]) + ' AND ' + isnull(SP.[IsIncrementalColumn],'1') +' >='''+convert(varchar(20),ISNULL([LastLoadtime], '1900.01.01'))+''''
			else	[SourceQueryCustom] 
		end As SelectQuery 
		,'SELECT CASE WHEN ' + convert(nvarchar(1),[IsIncremental]) + ' = 1 THEN CONVERT(VARCHAR, MAX(' + isnull(SP.[IsIncrementalColumn],'1') +'), 120) ELSE CONVERT(VARCHAR, GETDATE(), 120) END AS [LastLoadDate] FROM [' +isnull(CASE WHEN SP.[SourceSchema] != '' THEN SP.[SourceSchema] END, 'Unknown') + '].[' + SP.[SourceName] + ']' AS [SelectLastLoaddate] 
		,	isnull(CASE WHEN SP.DataLakeCatalog != '' THEN SP.DataLakeCatalog END, 'Unknown') + '/' + 
					isnull(CASE WHEN SP.[SourceSchema] != '' THEN SP.[SourceSchema] END, 'Unknown') + '_' + 
					SP.TableDestinationName + '/' + 
					FORMAT(GETUTCDATE(), 'yyyy') +'/'+ 
					FORMAT(GETUTCDATE(), 'MM') +'/'+ 
					FORMAT(GETUTCDATE(), 'dd') 
           as  FilePath 
		,	isnull(CASE WHEN SP.DataLakeCatalog != '' THEN SP.DataLakeCatalog END, 'Unknown')  + '_' + 
					isnull(CASE WHEN SP.[SourceSchema] != '' THEN SP.[SourceSchema] END, 'Unknown') + '_' + 
					SP.TableDestinationName + '_' + 
					FORMAT(GETUTCDATE(), 'yyyy') + 
					FORMAT(GETUTCDATE(), 'MM') + 
					FORMAT(GETUTCDATE(), 'dd') + 
					FORMAT(GETUTCDATE(), 'HH') + 
					FORMAT(GETUTCDATE(), 'mm') +'.parquet' 
                --Equal to Filename 
			 as [FileName] 
		,SP.[TableDestinationName] 
		,cast(SP.[IsActive] 			   as BIT) AS [IsActive] 			  
		,cast(SP.[IsIncremental] 	   as BIT) AS [IsIncremental] 	  
	
		,isnull(SP.[IsIncrementalColumn],1) as [IsIncrementalColumn] 
		,case when [LastLoadtime] is null then '1900.01.01' else LastLoadtime end  as LastLoadtime
		

FROM [configuration_demo].[Source_Parameter]  as SP     


GO



```
Please visit my blog https://erwindekreuk.com/2021/07/get-control-of-data-loads-in-azure-synapse  for more details on how to use these pipelines
