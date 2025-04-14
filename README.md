# Analysis-of-Public-Health-Facilities-in-Sub-Saharan-Africa
Exploring country-level and state-level distribution, facility ownership, and facility types across health facilities in sub-Saharan Africa.

This [dataset](https://data.humdata.org/dataset/health-facilities-in-sub-saharan-africa) was compiled by Maina, J., Ouma, P.O., Macharia, P.M., et al., as part of their research titled [A spatial database of health facilities managed by the public health sector in sub-Saharan Africa](https://www.researchgate.net/publication/334289719_A_spatial_database_of_health_facilities_managed_by_the_public_health_sector_in_sub_Saharan_Africa), published in 2019.

The objective of this analysis is to explore the dataset and extract insights related to the distribution of health facilities at both the country and state (admin division) levels. It also investigates the types and ownership structures of healthcare facilities across the region.
Subsequently, the analysis will narrow its focus to Nigeria to examine the state-level distribution of health facilities, as well as the ownership, facility type and healthcare service tiers within the country.

## Data Profiling
The dataset contains 8 columns and 98,745 rows. There are 6 categorical variables of the varchar datatype (Country, Admin1, Facility name, Facility type, Ownership, LL Source) and 2 numerical variables: Lat (Latitude) and Long (Longitude). Ownership, Lat, Long, and LL Source contain 30,448, 2,351, 2,351, and 2,350 null values, respectively. The dataset contains 123 duplicate rows. Removing the duplicate rows leaves the row count at 98,622.

### Number of columns
```
SELECT COUNT(*) AS column_count
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'data_table';
```
| column_count |
|--------------|
| 8            |

### Number of rows
```
--Number of rows
SELECT COUNT(*) AS row_count
FROM data_table;
```

| row_count |
|-----------|
| 98745     |

### columns and data types
```
SELECT 
    column_name,
    data_type
	FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'data_table';
```

| column_name     | data_type |
|------------------|-----------|
| Country          | varchar   |
| Admin1           | varchar   |
| Facility name    | varchar   |
| Facility type    | varchar   |
| Ownership        | varchar   |
| Lat              | float     |
| Long             | float     |
| LL source        | varchar   |

### checking for nulls
```
SELECT
  SUM(CASE WHEN Country IS NULL THEN 1 ELSE 0 END) AS null_Country,
  SUM(CASE WHEN Admin1 IS NULL THEN 1 ELSE 0 END) AS null_Admin1,
  SUM(CASE WHEN [Facility name] IS NULL THEN 1 ELSE 0 END) AS null_FacilityName,
  SUM(CASE WHEN [Facility type] IS NULL THEN 1 ELSE 0 END) AS null_FacilityType,
  SUM(CASE WHEN Ownership IS NULL THEN 1 ELSE 0 END) AS null_Ownership,
  SUM(CASE WHEN Lat IS NULL THEN 1 ELSE 0 END) AS null_Lat,
  SUM(CASE WHEN Long IS NULL THEN 1 ELSE 0 END) AS null_Long,
  SUM(CASE WHEN [LL source] IS NULL THEN 1 ELSE 0 END) AS null_LLSource
FROM data_table;
```
| null_Country | null_Admin1 | null_FacilityName | null_FacilityType | null_Ownership | null_Lat | null_Long | null_LLSource |
|--------------|-------------|-------------------|--------------------|----------------|----------|-----------|----------------|
| 0            | 0           | 0                 | 0                  | 30448          | 2351     | 2351      | 2350           |

### duplicate rows count
```
WITH dup AS (SELECT *, 
		ROW_NUMBER() OVER(PARTITION BY [Country]
      ,[Admin1]
      ,[Facility name]
      ,[Facility type]
      ,[Ownership]
      ,[Lat]
      ,[Long]
      ,[LL source] ORDER BY (SELECT NULL)) AS row_number
FROM data_table)

SELECT COUNT(*) AS duplicaterowcount
FROM dup
WHERE row_number > 1
```
| column_name       | value  |
|-------------------|--------|
| duplicaterowcount | 123    |

### create view(data_cleaned) to store dataset without duplicates
```
CREATE VIEW  data_cleaned AS
 WITH dup AS (SELECT *, 
		ROW_NUMBER() OVER(PARTITION BY [Country]
      ,[Admin1]
      ,[Facility name]
      ,[Facility type]
      ,[Ownership]
      ,[Lat]
      ,[Long]
      ,[LL source] ORDER BY (SELECT NULL)) AS row_number
FROM data_table)

SELECT [Country]
      ,[Admin1]
      ,[Facility name]
      ,[Facility type]
      ,[Ownership]
      ,[Lat]
      ,[Long]
      ,[LL source] 
FROM dup
WHERE row_number = 1
```
### Number of rows after duplicate removal
```
--Number of rows
SELECT COUNT(*) AS row_count
FROM data_cleaned;
```

| row_count |
|-----------|
| 98622     |














