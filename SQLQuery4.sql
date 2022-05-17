
create VIEW zview_Top10CovidCases_parquet
AS
SELECT 
	TOP 10 
		* 
FROM
	OPENROWSET
		(
			BULK     'https://pandemicdatalake.blob.core.windows.net/public/curated/covid-19/ecdc_cases/latest/ecdc_cases.parquet',
			FORMAT = 'parquet'
		) AS [r] 
ORDER BY
	[date_rep] DESC
