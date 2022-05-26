/****** Object:  Database [SQLPOOL1]    Script Date: 5/26/2022 3:42:16 PM ******/
CREATE DATABASE [SQLPOOL1]  (EDITION = 'DataWarehouse', SERVICE_OBJECTIVE = 'DW100c', MAXSIZE = 128 GB);
GO
/****** Object:  DatabaseScopedCredential [Synapse_Workspace_001_Identity]    Script Date: 5/26/2022 3:42:17 PM ******/
CREATE DATABASE SCOPED CREDENTIAL [Synapse_Workspace_001_Identity] WITH IDENTITY = N'Managed Identity'
GO
/****** Object:  DatabaseScopedCredential [Synapse_Workspace_001_MSI]    Script Date: 5/26/2022 3:42:17 PM ******/
CREATE DATABASE SCOPED CREDENTIAL [Synapse_Workspace_001_MSI] WITH IDENTITY = N'Managed Service Identity'
GO
/****** Object:  DatabaseRole [xlargerc]    Script Date: 5/26/2022 3:42:17 PM ******/
CREATE ROLE [xlargerc]
GO
/****** Object:  DatabaseRole [staticrc80]    Script Date: 5/26/2022 3:42:18 PM ******/
CREATE ROLE [staticrc80]
GO
/****** Object:  DatabaseRole [staticrc70]    Script Date: 5/26/2022 3:42:18 PM ******/
CREATE ROLE [staticrc70]
GO
/****** Object:  DatabaseRole [staticrc60]    Script Date: 5/26/2022 3:42:18 PM ******/
CREATE ROLE [staticrc60]
GO
/****** Object:  DatabaseRole [staticrc50]    Script Date: 5/26/2022 3:42:19 PM ******/
CREATE ROLE [staticrc50]
GO
/****** Object:  DatabaseRole [staticrc40]    Script Date: 5/26/2022 3:42:19 PM ******/
CREATE ROLE [staticrc40]
GO
/****** Object:  DatabaseRole [staticrc30]    Script Date: 5/26/2022 3:42:20 PM ******/
CREATE ROLE [staticrc30]
GO
/****** Object:  DatabaseRole [staticrc20]    Script Date: 5/26/2022 3:42:20 PM ******/
CREATE ROLE [staticrc20]
GO
/****** Object:  DatabaseRole [staticrc10]    Script Date: 5/26/2022 3:42:20 PM ******/
CREATE ROLE [staticrc10]
GO
/****** Object:  DatabaseRole [mediumrc]    Script Date: 5/26/2022 3:42:21 PM ******/
CREATE ROLE [mediumrc]
GO
/****** Object:  DatabaseRole [largerc]    Script Date: 5/26/2022 3:42:21 PM ******/
CREATE ROLE [largerc]
GO
/****** Object:  DatabaseRole [db_exporter]    Script Date: 5/26/2022 3:42:21 PM ******/
CREATE ROLE [db_exporter]
GO
/****** Object:  Schema [sysdiag]    Script Date: 5/26/2022 3:42:23 PM ******/
CREATE SCHEMA [sysdiag]
GO
/****** Object:  UserDefinedFunction [dbo].[udf_DayOfQuarter]    Script Date: 5/26/2022 3:42:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[udf_DayOfQuarter] (@Date [datetime]) RETURNS integer
AS
begin
/*
declare @date datetime
set @date = '2004-4-1'
--*/
return datediff(day
               ,dateadd(Quarter,datediff(Quarter,0,@Date),0)
               ,@Date
               ) + 1
end
GO
/****** Object:  UserDefinedFunction [dbo].[udf_DaysOfQuarterByDate]    Script Date: 5/26/2022 3:42:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[udf_DaysOfQuarterByDate] (@Date [datetime]) RETURNS integer
AS
begin
/*
declare @date datetime
set @date = '2004-4-1'
--*/
return datediff(day
               ,dateadd(Quarter,datediff(Quarter,0,@Date),0)
               ,dateadd(Quarter,datediff(Quarter,0,@Date) + 1,0)
               )
end
GO
/****** Object:  UserDefinedFunction [dbo].[udf_DaysOfYear]    Script Date: 5/26/2022 3:42:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[udf_DaysOfYear] (@Year [integer]) RETURNS integer
AS
begin
return datediff(day,dateadd(year,@year - year(0),0),dateadd(year,@year - year(0) + 1,0))
end
GO
/****** Object:  UserDefinedFunction [dbo].[udf_DaysOfYearByDate]    Script Date: 5/26/2022 3:42:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[udf_DaysOfYearByDate] (@Date [datetime]) RETURNS integer
AS
begin
return datediff(day,dateadd(year,datediff(year,0,@Date),0),dateadd(year,datediff(year,0,@Date) + 1,0))
end
GO
/****** Object:  UserDefinedFunction [dbo].[udf_GetAge]    Script Date: 5/26/2022 3:42:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[udf_GetAge] (@StartDate [datetime],@EndDate [datetime]) RETURNS integer
AS
begin
return datediff(year,@StartDate,@EndDate)
       - case when datediff(day,dateadd(year,datediff(year,@StartDate,@EndDate),@StartDate),@EndDate) >= 0
                   then 0
              else
                   1
         end
end
GO
/****** Object:  UserDefinedFunction [dbo].[udf_HalfDay]    Script Date: 5/26/2022 3:42:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[udf_HalfDay] (@Date [datetime]) RETURNS datetime
AS
begin
return case when datepart(hour,@Date) < 12
                 then dateadd(day,datediff(day,0,@Date),0) --上午归到 零点
            else
                 dateadd(hour,12,dateadd(day,datediff(day,0,@Date),0)) --下午归到 十二点
       end
end
GO
/****** Object:  ExternalDataSource [Synapse_Workspace_001_data_source]    Script Date: 5/26/2022 3:42:24 PM ******/
CREATE EXTERNAL DATA SOURCE [Synapse_Workspace_001_data_source] WITH (LOCATION = N'abfs://microshaoftcontosolake.dfs.core.windows.net/users', CREDENTIAL = [Synapse_Workspace_001_Identity])
GO
/****** Object:  ExternalDataSource [Synapse_Workspace_001_data_source_abfss]    Script Date: 5/26/2022 3:42:24 PM ******/
CREATE EXTERNAL DATA SOURCE [Synapse_Workspace_001_data_source_abfss] WITH (TYPE = HADOOP, LOCATION = N'abfss://users@microshaoftcontosolake.dfs.core.windows.net', CREDENTIAL = [Synapse_Workspace_001_MSI])
GO
/****** Object:  ExternalDataSource [zextds_ContosoLake]    Script Date: 5/26/2022 3:42:24 PM ******/
CREATE EXTERNAL DATA SOURCE [zextds_ContosoLake] WITH (LOCATION = N'https://contosolakeaccount.dfs.core.windows.net/users/NYCTripSmall.parquet')
GO
/****** Object:  ExternalDataSource [zextds_ContosoLake2]    Script Date: 5/26/2022 3:42:25 PM ******/
CREATE EXTERNAL DATA SOURCE [zextds_ContosoLake2] WITH (LOCATION = N'https://microshaoftcontosolake.dfs.core.windows.net/users/NYCTripSmall.parquet')
GO
/****** Object:  ExternalFileFormat [fmt_parquet]    Script Date: 5/26/2022 3:42:25 PM ******/
CREATE EXTERNAL FILE FORMAT [fmt_parquet] WITH (FORMAT_TYPE = PARQUET)
GO
/****** Object:  ExternalFileFormat [SynapseParquetFormat]    Script Date: 5/26/2022 3:42:26 PM ******/
CREATE EXTERNAL FILE FORMAT [SynapseParquetFormat] WITH (FORMAT_TYPE = PARQUET)
GO
/****** Object:  UserDefinedFunction [dbo].[lpad]    Script Date: 5/26/2022 3:42:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[lpad] (@expression [VARCHAR](MAX),@length [INT],@fill [VARCHAR](64) = ' ') RETURNS VARCHAR(MAX)
WITH SCHEMABINDING
AS
BEGIN

	RETURN
		CASE 
			WHEN (@length <= DATALENGTH(@expression)) THEN LEFT(@expression, @length)
			ELSE LEFT(REPLICATE(@fill, @length), ABS(@length - DATALENGTH(@expression))) + @expression
		END;

END
GO
/****** Object:  Table [dbo].[NYCTaxiTripSmall]    Script Date: 5/26/2022 3:42:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NYCTaxiTripSmall]
(
	[DateID] [int] NULL,
	[MedallionID] [int] NULL,
	[HackneyLicenseID] [int] NULL,
	[PickupTimeID] [int] NULL,
	[DropoffTimeID] [int] NULL,
	[PickupGeographyID] [int] NULL,
	[DropoffGeographyID] [int] NULL,
	[PickupLatitude] [float] NULL,
	[PickupLongitude] [float] NULL,
	[PickupLatLong] [nvarchar](4000) NULL,
	[DropoffLatitude] [float] NULL,
	[DropoffLongitude] [float] NULL,
	[DropoffLatLong] [nvarchar](4000) NULL,
	[PassengerCount] [int] NULL,
	[TripDurationSeconds] [int] NULL,
	[TripDistanceMiles] [float] NULL,
	[PaymentType] [nvarchar](4000) NULL,
	[FareAmount] [numeric](19, 4) NULL,
	[SurchargeAmount] [numeric](19, 4) NULL,
	[TaxAmount] [numeric](19, 4) NULL,
	[TipAmount] [numeric](19, 4) NULL,
	[TollsAmount] [numeric](19, 4) NULL,
	[TotalAmount] [numeric](19, 4) NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
)
GO
/****** Object:  Table [dbo].[NYCTaxiTripSmall_Table]    Script Date: 5/26/2022 3:42:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE EXTERNAL TABLE [dbo].[NYCTaxiTripSmall_Table]
(
	[DateID] [int] NULL,
	[MedallionID] [int] NULL,
	[HackneyLicenseID] [int] NULL,
	[PickupTimeID] [int] NULL,
	[DropoffTimeID] [int] NULL,
	[PickupGeographyID] [int] NULL,
	[DropoffGeographyID] [int] NULL,
	[PickupLatitude] [int] NULL,
	[PickupLongitude] [int] NULL,
	[PickupLatLong] [int] NULL,
	[DropoffLatitude] [int] NULL,
	[DropoffLongitude] [int] NULL,
	[DropoffLatLong] [int] NULL,
	[PassengerCount] [int] NULL,
	[TripDurationSeconds] [int] NULL,
	[TripDistanceMiles] [int] NULL,
	[PaymentType] [int] NULL,
	[FareAmount] [int] NULL,
	[SurchargeAmount] [int] NULL,
	[TaxAmount] [int] NULL,
	[TipAmount] [int] NULL,
	[TollsAmount] [int] NULL,
	[TotalAmount] [int] NULL
)
WITH (DATA_SOURCE = [Synapse_Workspace_001_data_source_abfss],LOCATION = N'NYCTripSmall.parquet',FILE_FORMAT = [SynapseParquetFormat],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO
/****** Object:  View [dbo].[vTableSizes]    Script Date: 5/26/2022 3:42:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vTableSizes]
AS WITH base
AS
(
SELECT
 GETDATE()                                                             AS  [execution_time]
, DB_NAME()                                                            AS  [database_name]
, s.name                                                               AS  [schema_name]
, t.name                                                               AS  [table_name]
, QUOTENAME(s.name)+'.'+QUOTENAME(t.name)                              AS  [two_part_name]
, nt.[name]                                                            AS  [node_table_name]
, ROW_NUMBER() OVER(PARTITION BY nt.[name] ORDER BY (SELECT NULL))     AS  [node_table_name_seq]
, tp.[distribution_policy_desc]                                        AS  [distribution_policy_name]
, c.[name]                                                             AS  [distribution_column]
, nt.[distribution_id]                                                 AS  [distribution_id]
, i.[type]                                                             AS  [index_type]
, i.[type_desc]                                                        AS  [index_type_desc]
, nt.[pdw_node_id]                                                     AS  [pdw_node_id]
, pn.[type]                                                            AS  [pdw_node_type]
, pn.[name]                                                            AS  [pdw_node_name]
, di.name                                                              AS  [dist_name]
, di.position                                                          AS  [dist_position]
, nps.[partition_number]                                               AS  [partition_nmbr]
, nps.[reserved_page_count]                                            AS  [reserved_space_page_count]
, nps.[reserved_page_count] - nps.[used_page_count]                    AS  [unused_space_page_count]
, nps.[in_row_data_page_count]
    + nps.[row_overflow_used_page_count]
    + nps.[lob_used_page_count]                                        AS  [data_space_page_count]
, nps.[reserved_page_count]
 - (nps.[reserved_page_count] - nps.[used_page_count])
 - ([in_row_data_page_count]
         + [row_overflow_used_page_count]+[lob_used_page_count])       AS  [index_space_page_count]
, nps.[row_count]                                                      AS  [row_count]
from
    sys.schemas s
INNER JOIN sys.tables t
    ON s.[schema_id] = t.[schema_id]
INNER JOIN sys.indexes i
    ON  t.[object_id] = i.[object_id]
    AND i.[index_id] <= 1
INNER JOIN sys.pdw_table_distribution_properties tp
    ON t.[object_id] = tp.[object_id]
INNER JOIN sys.pdw_table_mappings tm
    ON t.[object_id] = tm.[object_id]
INNER JOIN sys.pdw_nodes_tables nt
    ON tm.[physical_name] = nt.[name]
INNER JOIN sys.dm_pdw_nodes pn
    ON  nt.[pdw_node_id] = pn.[pdw_node_id]
INNER JOIN sys.pdw_distributions di
    ON  nt.[distribution_id] = di.[distribution_id]
INNER JOIN sys.dm_pdw_nodes_db_partition_stats nps
    ON nt.[object_id] = nps.[object_id]
    AND nt.[pdw_node_id] = nps.[pdw_node_id]
    AND nt.[distribution_id] = nps.[distribution_id]
LEFT OUTER JOIN (select * from sys.pdw_column_distribution_properties where distribution_ordinal = 1) cdp
    ON t.[object_id] = cdp.[object_id]
LEFT OUTER JOIN sys.columns c
    ON cdp.[object_id] = c.[object_id]
    AND cdp.[column_id] = c.[column_id]
WHERE pn.[type] = 'COMPUTE'
)
, size
AS
(
SELECT
   [execution_time]
,  [database_name]
,  [schema_name]
,  [table_name]
,  [two_part_name]
,  [node_table_name]
,  [node_table_name_seq]
,  [distribution_policy_name]
,  [distribution_column]
,  [distribution_id]
,  [index_type]
,  [index_type_desc]
,  [pdw_node_id]
,  [pdw_node_type]
,  [pdw_node_name]
,  [dist_name]
,  [dist_position]
,  [partition_nmbr]
,  [reserved_space_page_count]
,  [unused_space_page_count]
,  [data_space_page_count]
,  [index_space_page_count]
,  [row_count]
,  ([reserved_space_page_count] * 8.0)                                 AS [reserved_space_KB]
,  ([reserved_space_page_count] * 8.0)/1000                            AS [reserved_space_MB]
,  ([reserved_space_page_count] * 8.0)/1000000                         AS [reserved_space_GB]
,  ([reserved_space_page_count] * 8.0)/1000000000                      AS [reserved_space_TB]
,  ([unused_space_page_count]   * 8.0)                                 AS [unused_space_KB]
,  ([unused_space_page_count]   * 8.0)/1000                            AS [unused_space_MB]
,  ([unused_space_page_count]   * 8.0)/1000000                         AS [unused_space_GB]
,  ([unused_space_page_count]   * 8.0)/1000000000                      AS [unused_space_TB]
,  ([data_space_page_count]     * 8.0)                                 AS [data_space_KB]
,  ([data_space_page_count]     * 8.0)/1000                            AS [data_space_MB]
,  ([data_space_page_count]     * 8.0)/1000000                         AS [data_space_GB]
,  ([data_space_page_count]     * 8.0)/1000000000                      AS [data_space_TB]
,  ([index_space_page_count]  * 8.0)                                   AS [index_space_KB]
,  ([index_space_page_count]  * 8.0)/1000                              AS [index_space_MB]
,  ([index_space_page_count]  * 8.0)/1000000                           AS [index_space_GB]
,  ([index_space_page_count]  * 8.0)/1000000000                        AS [index_space_TB]
FROM base
)
SELECT *
FROM size;
GO
/****** Object:  StoredProcedure [dbo].[zsp_001]    Script Date: 5/26/2022 3:42:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[zsp_001] AS
select 1
GO
/****** Object:  StoredProcedure [dbo].[zsp_CopyIntoFromParquet]    Script Date: 5/26/2022 3:42:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[zsp_CopyIntoFromParquet] AS

COPY INTO dbo.NYCTaxiTripSmall
(DateID 1, MedallionID 2, HackneyLicenseID 3, PickupTimeID 4, DropoffTimeID 5,
PickupGeographyID 6, DropoffGeographyID 7, PickupLatitude 8, PickupLongitude 9, 
PickupLatLong 10, DropoffLatitude 11, DropoffLongitude 12, DropoffLatLong 13, 
PassengerCount 14, TripDurationSeconds 15, TripDistanceMiles 16, PaymentType 17, 
FareAmount 18, SurchargeAmount 19, TaxAmount 20, TipAmount 21, TollsAmount 22, 
TotalAmount 23)
FROM 'https://microshaoftcontosolake.dfs.core.windows.net/users/NYCTripSmall.parquet'
WITH
(
    FILE_TYPE = 'PARQUET'
    ,MAXERRORS = 0
    ,IDENTITY_INSERT = 'OFF'
	, CREDENTIAL = (IDENTITY = 'Managed Identity')
)
GO
/****** Object:  StoredProcedure [dbo].[zsp_openjson]    Script Date: 5/26/2022 3:42:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[zsp_openjson] AS

DECLARE @json NVARCHAR(2048) = N'{
   "String_value": "John",
   "DoublePrecisionFloatingPoint_value": 45,
   "DoublePrecisionFloatingPoint_value": 2.3456,
   "BooleanTrue_value": true,
   "BooleanFalse_value": false,
   "Null_value": null,
   "Array_value": ["a","r","r","a","y"],
   "Object_value": {"obj":"ect"}
}';

SELECT * FROM OpenJson(@json);
GO
/****** Object:  StoredProcedure [dbo].[zsp_skew_space_used]    Script Date: 5/26/2022 3:42:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[zsp_skew_space_used] AS
SELECT
   0 '表空间摘要'
,    database_name
,    schema_name
,    table_name
,    distribution_policy_name
,      distribution_column
,    index_type_desc
,    COUNT(distinct partition_nmbr) as nbr_partitions
,    SUM(row_count)                 as table_row_count
,    SUM(reserved_space_GB)         as table_reserved_space_GB
,    SUM(data_space_GB)             as table_data_space_GB
,    SUM(index_space_GB)            as table_index_space_GB
,    SUM(unused_space_GB)           as table_unused_space_GB
FROM
    dbo.vTableSizes
GROUP BY
     database_name
,    schema_name
,    table_name
,    distribution_policy_name
,      distribution_column
,    index_type_desc
ORDER BY
    table_reserved_space_GB desc


SELECT
0 [按分布类型划分的表空间]
,     distribution_policy_name
,    SUM(row_count)                as table_type_row_count
,    SUM(reserved_space_GB)        as table_type_reserved_space_GB
,    SUM(data_space_GB)            as table_type_data_space_GB
,    SUM(index_space_GB)           as table_type_index_space_GB
,    SUM(unused_space_GB)          as table_type_unused_space_GB
FROM dbo.vTableSizes
GROUP BY distribution_policy_name


SELECT
0 [按索引类型划分的表空间]
,     index_type_desc
,    SUM(row_count)                as table_type_row_count
,    SUM(reserved_space_GB)        as table_type_reserved_space_GB
,    SUM(data_space_GB)            as table_type_data_space_GB
,    SUM(index_space_GB)           as table_type_index_space_GB
,    SUM(unused_space_GB)          as table_type_unused_space_GB
FROM dbo.vTableSizes
GROUP BY index_type_desc

SELECT
 0 [分布空间摘要]
 , distribution_id
,    SUM(row_count)                as total_node_distribution_row_count
,    SUM(reserved_space_MB)        as total_node_distribution_reserved_space_MB
,    SUM(data_space_MB)            as total_node_distribution_data_space_MB
,    SUM(index_space_MB)           as total_node_distribution_index_space_MB
,    SUM(unused_space_MB)          as total_node_distribution_unused_space_MB
FROM dbo.vTableSizes
GROUP BY     distribution_id
ORDER BY    distribution_id



;with T
as
(
SELECT
 0 [分布空间摘要]
 , distribution_id
,    SUM(row_count)                as total_node_distribution_row_count
,    SUM(reserved_space_MB)        as total_node_distribution_reserved_space_MB
,    SUM(data_space_MB)            as total_node_distribution_data_space_MB
,    SUM(index_space_MB)           as total_node_distribution_index_space_MB
,    SUM(unused_space_MB)          as total_node_distribution_unused_space_MB
FROM dbo.vTableSizes
GROUP BY     distribution_id
)
select
	max(total_node_distribution_row_count) as 最大_total_node_distribution_row_count
	,min(total_node_distribution_row_count) as 最小_total_node_distribution_row_count
	,avg(total_node_distribution_row_count) as 平均_total_node_distribution_row_count
	,stdev(total_node_distribution_row_count) as 标准差_total_node_distribution_row_count
	,stdevp(total_node_distribution_row_count) as 总体标准差_total_node_distribution_row_count
	,VAR(total_node_distribution_row_count) as 方差_total_node_distribution_row_count
	,VAR(total_node_distribution_row_count) as 总体方差_total_node_distribution_row_count
from
	T a



;
GO
