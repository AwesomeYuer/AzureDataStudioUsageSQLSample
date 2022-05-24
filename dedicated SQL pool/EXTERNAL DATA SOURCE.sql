

/****** Object:  ExternalDataSource [ContosoLake]    Script Date: 5/17/2022 5:12:09 PM ******/
CREATE EXTERNAL DATA SOURCE [zextds_ContosoLake] WITH (LOCATION = N'https://contosolakeaccount.dfs.core.windows.net/users/NYCTripSmall.parquet')
GO

-- select * from  [zextds_ContosoLake] 