# Settings for a SQL Pool(Former SQL DW)



A SQL Pool(Former SQL DW) linked to a SQL (Logical) Server has a slightly different approach.


Use the settings below to create a Pipeline to Scale the SQL Pool.

| Parameter | Value | Deceription | 
|:--- |:--- |:--- |
|Action|   RESUME | Value needs to be **RESUME** to Scale
|WaitTime| 10| Wait time in seconds before the Pipeline will finish
|WaitTimeUntil| 30| Wait time in seconds for the retry process
|SQLServer_ResourceGroupName|xxxxxx | Name of the ResourceGroup of the used SQL Server
|SQLServer|xxxxxx| Logical Server|
|SQLServerDedicatedSQLPool|DWH| Name of the dedicated SQL Pool|
|SubsriptionId|XXXX| SubscriptionId of Synapse Workspace|
|PerformanceLevel|DW1000c|  The Database Performance level (DW100c, DW200c, DW300c, DW400c DW500c, DW1000c, DW1000c, DW1500c, DW2000c, DW2500c, DW3000c, DW5000c, DW6000c, DW7500c, DW10000c, DW15000c, DW30000c)|


Change the settings in we Web Activities

URL= https://management.azure.com/subscriptions/XXX/resourceGroups/XXX/providers/Microsoft.Sql/servers/XXX/databases/XXX/?api-version=2019-06-01-preview

Replace the **XXX** with Pipeline Parameters.

https://management.azure.com/subscriptions/@{pipeline().parameters.SubscriptionID}/resourceGroups/@{pipeline().parameters.SQLServer_ResourceGroupName}/providers/Microsoft.Synapse/SQLServer/@{pipeline().parameters.SQLServer}/databases/@{pipeline().parameters.SQLServerDedicatedSQLPool}/?api-version=2019-06-01-preview

**Only for Web Activitiy** = SCALE SQL POOL

Body: { “requestedServiceObjectiveName“: { “name”: ‘**@{pipeline().parameters.PerformanceLevel**}’ } }