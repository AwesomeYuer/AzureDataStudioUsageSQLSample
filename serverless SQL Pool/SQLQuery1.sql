/****** Object:  StoredProcedure [dbo].[zsp_001]    Script Date: 5/17/2022 2:52:51 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

alter proc [dbo].[zsp_openrowset_parquet]
AS
select
	1
	,GETDATE()

declare @top int
set @top = 100
	 
SELECT
    TOP
		(@Top)
		 ROW_NUMBER() over (order by DateID desc) as row#
		, *
		
FROM
    OPENROWSET
		(
			BULK 
				--Cannot find the CREDENTIAL 'https://contosolakeaccount.dfs.core.windows.net/users/NYCTripSmall.parquet', because it does not exist or you do not have permission.*/
				--'https://contosolakeaccount.dfs.core.windows.net/users/NYCTripSmall.parquet',
		
				--?sv=2018-11-09&st=2022-05-17T05%3A28%3A42Z&se=2022-05-17T13%3A28%3A42Z&sr=c&sp=racwdl&sig=UORycNV7ndB%2F%2FFMWWMCtQNbapLo74k5SsJsyUToLyr4%3D',
				--'https://contosolake.dfs.core.windows.net/users/NYCTripSmall.parquet',
				--匿名的可以
				'https://azuresynapsestorage.blob.core.windows.net/sampledata/NYCTaxiSmall/NYCTripSmall.parquet',
			FORMAT='PARQUET'
    ) AS T1
order by
	--大小写敏感
	DateID

  --  GO
     --create proc zsp_001
     --AS
     --select 1,GETDATE()

    -- GO

     --exec zsp_001


--GO

--CREATE EXTERNAL DATA SOURCE ContosoLake
--WITH ( LOCATION = 'https://contosolakeaccount.dfs.core.windows.net/users/NYCTripSmall.parquet')


--go

--create table T1
--(F1 varchar(100))


--GO


