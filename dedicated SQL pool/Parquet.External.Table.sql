
create proc [dbo].[zsp_credentials_Managed_Identity]
AS
select
	1
	,GETDATE()

declare @top int
set @top = 100

select
	DateID
	, MedallionID
from
	NYCTaxiTripSmall_Table


go
-- Create master key in databases with some password (one-off per database)
--CREATE MASTER KEY ENCRYPTION BY PASSWORD = '!@#123QWE_without'
GO

-- Create databases scoped credential that use Managed Identity, SAS token or Service Principal. User needs to create only database-scoped credentials that should be used to access data source:

CREATE DATABASE SCOPED CREDENTIAL Synapse_Workspace_001_MSI
WITH IDENTITY = 'Managed Service Identity'
go
CREATE EXTERNAL FILE FORMAT [SynapseParquetFormat] WITH ( FORMAT_TYPE = PARQUET)
GO

CREATE EXTERNAL DATA SOURCE Synapse_Workspace_001_data_source_abfss 
WITH 
  ( TYPE = HADOOP , 
	-- users is storage account <container>
    LOCATION = 'abfss://users@microshaoftcontosolake.dfs.core.windows.net' , 
    CREDENTIAL = Synapse_Workspace_001_MSI
  ) ;



--Create external data source with abfss:// scheme for connecting to your Azure Data Lake Store Gen2 account


go
create EXTERNAL TABLE dbo.NYCTaxiTripSmall_Table 
(
	DateID							int
	,MedallionID					int
	,HackneyLicenseID				int
	,PickupTimeID					int
	,DropoffTimeID					int
	,PickupGeographyID				int
	,DropoffGeographyID				int
	,PickupLatitude					int
	,PickupLongitude				int
	,PickupLatLong					int
	,DropoffLatitude				int
	,DropoffLongitude				int
	,DropoffLatLong					int
	,PassengerCount					int
	,TripDurationSeconds			int
	,TripDistanceMiles				int
	,PaymentType					int
	,FareAmount						int
	,SurchargeAmount				int
	,TaxAmount						int
	,TipAmount						int
	,TollsAmount					int
	,TotalAmount					int
)
WITH 
( 
		LOCATION = 'NYCTripSmall.parquet',
		DATA_SOURCE = [Synapse_Workspace_001_data_source_abfss],
		FILE_FORMAT = [SynapseParquetFormat] 
);
go


select
	DateID
	, MedallionID
from
	NYCTaxiTripSmall_Table



