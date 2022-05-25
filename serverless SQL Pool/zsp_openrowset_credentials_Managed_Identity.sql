
alter proc [dbo].[zsp_openrowset_credentials_Managed_Identity]
AS
select
	1
	,GETDATE()

declare @top int
set @top = 100

select *
from NYCTaxiTripSmall_Table


go
-- Create master key in databases with some password (one-off per database)
--CREATE MASTER KEY ENCRYPTION BY PASSWORD = '!@#123QWE_without'
GO

-- Create databases scoped credential that use Managed Identity, SAS token or Service Principal. User needs to create only database-scoped credentials that should be used to access data source:

CREATE DATABASE SCOPED CREDENTIAL Synapse_Workspace_001_Identity
WITH IDENTITY = 'Managed Identity'
GO
--CREATE DATABASE SCOPED CREDENTIAL SasCredential
--WITH IDENTITY = 'SHARED ACCESS SIGNATURE', SECRET = 'sv=2019-10-1********ZVsTOL0ltEGhf54N8KhDCRfLRI%3D'
GO
--CREATE DATABASE SCOPED CREDENTIAL SPNCredential WITH
--IDENTITY = '**44e*****8f6-ag44-1890-34u4-22r23r771098@https://login.microsoftonline.com/**do99dd-87f3-33da-33gf-3d3rh133ee33/oauth2/token' 
--, SECRET = '.7OaaU_454azar9WWzLL.Ea9ePPZWzQee~'
GO
-- Create data source that one of the credentials above, external file format, and external tables that reference this data source and file format:

CREATE EXTERNAL FILE FORMAT [SynapseParquetFormat] WITH ( FORMAT_TYPE = PARQUET)
GO

create EXTERNAL DATA SOURCE Synapse_Workspace_001_data_source
WITH (    LOCATION   = 'https://microshaoftcontosolake.dfs.core.windows.net/users'
-- Uncomment one of these options depending on authentication method that you want to use to access data source:
,CREDENTIAL = Synapse_Workspace_001_Identity 
--,CREDENTIAL = SasCredential 
--,CREDENTIAL = SPNCredential
)


go
create EXTERNAL TABLE dbo.NYCTaxiTripSmall_Table (DateID int, MedallionID int)
WITH 
( 
		LOCATION = '*.parquet',
		DATA_SOURCE = [Synapse_Workspace_001_data_source],
		FILE_FORMAT = [SynapseParquetFormat] 
);
go


	 


O


