
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
    LOCATION = 'abfss://users@microshaoftcontosolake.dfs.core.windows.net' , 
    CREDENTIAL = Synapse_Workspace_001_MSI
  ) ;



--Create external data source with abfss:// scheme for connecting to your Azure Data Lake Store Gen2 account


go
create EXTERNAL TABLE dbo.NYCTaxiTripSmall_Table 
(
	DateID							varchar(100)
	,MedallionID					varchar(100)
	,HackneyLicenseID				varchar(100)
	,PickupTimeID					varchar(100)
	,DropoffTimeID					varchar(100)
	,PickupGeographyID				varchar(100)
	,DropoffGeographyID				varchar(100)
	,PickupLatitude					varchar(100)
	,PickupLongitude				varchar(100)
	,PickupLatLong					varchar(100)
	,DropoffLatitude				varchar(100)
	,DropoffLongitude				varchar(100)
	,DropoffLatLong					varchar(100)
	,PassengerCount					varchar(100)
	,TripDurationSeconds			varchar(100)
	,TripDistanceMiles				varchar(100)
	,PaymentType					varchar(100)
	,FareAmount						varchar(100)
	,SurchargeAmount				varchar(100)
	,TaxAmount						varchar(100)
	,TipAmount						varchar(100)
	,TollsAmount					varchar(100)
	,TotalAmount					varchar(100)
)
WITH 
( 
		LOCATION = 'NYCTripSmall.parquet',
		DATA_SOURCE = [Synapse_Workspace_001_data_source_abfss],
		FILE_FORMAT = [SynapseParquetFormat] 
);
go


	 


O


