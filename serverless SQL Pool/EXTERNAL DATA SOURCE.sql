/****** Object:  ExternalDataSource [ContosoLake]    Script Date: 5/17/2022 5:12:09 PM ******/
DROP EXTERNAL DATA SOURCE [ContosoLake]
GO

/****** Object:  ExternalDataSource [ContosoLake]    Script Date: 5/17/2022 5:12:09 PM ******/
CREATE EXTERNAL DATA SOURCE [ContosoLake] WITH (LOCATION = N'https://contosolakeaccount.dfs.core.windows.net/users/NYCTripSmall.parquet')
GO

