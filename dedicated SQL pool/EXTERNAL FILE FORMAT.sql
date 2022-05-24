CREATE EXTERNAL FILE FORMAT fmt_parquet  
WITH (  
    FORMAT_TYPE = PARQUET  
    
	--[ , DATA_COMPRESSION = {  
      --  'org.apache.hadoop.io.compress.SnappyCodec'  
      --| 'org.apache.hadoop.io.compress.GzipCodec'      }  
    --]
	
	
	);  