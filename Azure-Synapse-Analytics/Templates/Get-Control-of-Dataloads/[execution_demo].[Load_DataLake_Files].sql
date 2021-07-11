
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


