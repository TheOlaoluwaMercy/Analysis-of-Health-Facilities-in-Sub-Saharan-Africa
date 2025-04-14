--Number of columns
SELECT COUNT(*) AS column_count
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'data_table';

--Number of rows
SELECT COUNT(*) AS row_count
FROM data_table;

--Highlighting data columns and data types
SELECT 
    column_name,
    data_type
	FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'data_table';

--checking for nulls
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

--duplicate rows count
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

--data without duplicates stored as a view
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

--Number of rows
SELECT COUNT(*) AS row_count
FROM data_cleaned;

--Highlight Unique Countries
SELECT DISTINCT(Country)
FROM data_cleaned
ORDER BY Country;

--Count of Unique Countries
SELECT COUNT(DISTINCT(Country)) AS country_count
FROM data_cleaned;

--Number of facilities by country
SELECT Country, COUNT([Facility name]) as facility_count
FROM data_cleaned
GROUP BY Country 
ORDER BY COUNT([Facility name]) DESC;

--Highlight Unique Administrative divisions/state 
SELECT DISTINCT(Admin1) AS Admin_Division_or_States
FROM data_cleaned
ORDER BY Admin1;

--Count of Unique Administrative divisions/state
SELECT COUNT(DISTINCT(Admin1)) AS AdminDivision_Count
FROM data_cleaned;

--Number of facilities by Admin Divisions/State
SELECT Admin1, Country, COUNT([Facility name]) as facility_count
FROM data_cleaned
GROUP BY Admin1 , Country
ORDER BY COUNT([Facility name]) DESC;

--Highlight Unique Facilities 
SELECT DISTINCT([Facility name])
FROM data_cleaned
ORDER BY [Facility name];

--Count of Unique Facilities
SELECT COUNT(DISTINCT([Facility name])) AS Facility_Count
FROM data_cleaned;

--Highlight Facility type
SELECT DISTINCT([Facility type])
FROM data_cleaned
ORDER BY [Facility type];

--Count Unique Facility type
SELECT COUNT(DISTINCT([Facility type])) AS FacilityType_Count
FROM data_cleaned;

--Highlight Unique Ownership Types 
SELECT DISTINCT(Ownership)
FROM data_cleaned
ORDER BY Ownership;

--Count Unique Ownership Types 
SELECT COUNT(DISTINCT(Ownership)) AS Ownership_count
FROM data_cleaned;

--Highlight the different Ownership Types 
WITH Ownership_new AS (
    SELECT 
        CASE 
            WHEN Ownership LIKE 'MoH%' THEN 'Ministry of Health & Partners' 
            WHEN Ownership LIKE 'Priv%' THEN 'Private'
            WHEN Ownership LIKE 'Publi%' THEN 'Public'
            WHEN Ownership LIKE 'ONG%' THEN 'Non Governmental Organization'
            WHEN Ownership = 'Govt.' THEN 'Government'
            WHEN Ownership = 'CBO' THEN 'Community Based Organization'
            WHEN Ownership = 'FBO' THEN 'Faith Based Organization'
            WHEN Ownership = 'FBO/NGO' OR Ownership = 'NGO/FBO' THEN 'Faith Based Organization/Community Based Organization'
            WHEN Ownership = 'NGO' THEN 'Non Governmental Organization'
            ELSE Ownership
        END AS Ownership_transformed
    FROM data_cleaned
)
SELECT DISTINCT(Ownership_transformed)
FROM Ownership_new;

--Count Unique Ownership types 
WITH Ownership_new AS (
    SELECT 
        CASE 
            WHEN Ownership LIKE 'MoH%' THEN 'Ministry of Health & Partners' 
            WHEN Ownership LIKE 'Priv%' THEN 'Private'
            WHEN Ownership LIKE 'Publi%' THEN 'Public'
            WHEN Ownership LIKE 'ONG%' THEN 'Non Governmental Organization'
            WHEN Ownership = 'Govt.' THEN 'Government'
            WHEN Ownership = 'CBO' THEN 'Community Based Organization'
            WHEN Ownership = 'FBO' THEN 'Faith Based Organization'
            WHEN Ownership = 'FBO/NGO' OR Ownership = 'NGO/FBO' THEN 'Faith Based Organization/Community Based Organization'
            WHEN Ownership = 'NGO' THEN 'Non Governmental Organization'
            ELSE Ownership
        END AS Ownership_transformed
    FROM data_cleaned
)
SELECT COUNT(DISTINCT(Ownership_transformed)) Ownership_count
FROM Ownership_new;

--Number of facilities by Ownership type
WITH Ownership_new AS (
    SELECT 
        CASE 
            WHEN Ownership LIKE 'MoH%' THEN 'Ministry of Health & Partners' 
            WHEN Ownership LIKE 'Priv%' THEN 'Private'
            WHEN Ownership LIKE 'Publi%' THEN 'Public'
            WHEN Ownership LIKE 'ONG%' THEN 'Non Governmental Organization'
            WHEN Ownership = 'Govt.' THEN 'Government'
            WHEN Ownership = 'CBO' THEN 'Community Based Organization'
            WHEN Ownership = 'FBO' THEN 'Faith Based Organization'
            WHEN Ownership = 'FBO/NGO' OR Ownership = 'NGO/FBO' THEN 'Faith Based Organization/Community Based Organization'
            WHEN Ownership = 'NGO' THEN 'Non Governmental Organization'
            ELSE Ownership
        END AS Ownership_transformed
    FROM data_cleaned
)
SELECT Ownership_transformed,  COUNT(*) AS facility_count
FROM Ownership_new
GROUP BY Ownership_transformed
ORDER BY COUNT(*) DESC;

--Drilling down to Nigeria


--Number of health facilities in Nigeria
SELECT COUNT(*) AS facility_count_Nigeria
FROM data_cleaned
WHERE Country = 'Nigeria';

--Number of health facilities in each state in Nigeria
SELECT Admin1,  COUNT(*) AS facility_count_Nigeria
FROM data_cleaned
WHERE Country = 'Nigeria'
GROUP BY Admin1
ORDER BY COUNT(*) DESC;

--Top 5 states
SELECT TOP 5 Admin1,  COUNT(*) AS facility_count_Nigeria
FROM data_cleaned
WHERE Country = 'Nigeria'
GROUP BY Admin1
ORDER BY COUNT(*) DESC;

--Bottom 5 states
SELECT TOP 5 Admin1,  COUNT(*) AS facility_count_Nigeria
FROM data_cleaned
WHERE Country = 'Nigeria'
GROUP BY Admin1
ORDER BY COUNT(*) ASC;

--Number of facilities by Ownership in Nigeria
WITH Ownership_new AS (
  SELECT 
    CASE 
      WHEN Ownership LIKE 'MoH%' THEN 'Ministry of Health & Partners' 
      WHEN Ownership LIKE 'Priv%' THEN 'Private'
      WHEN Ownership LIKE 'Publi%' THEN 'Public'
      WHEN Ownership LIKE 'ONG%' THEN 'Non Governmental Organization'
      WHEN Ownership = 'Govt.' THEN 'Government'
      WHEN Ownership = 'CBO' THEN 'Community Based Organization'
      WHEN Ownership = 'FBO' THEN 'Faith Based Organization'
      WHEN Ownership = 'FBO/NGO' THEN 'Faith Based Organization/Community Based Organization'
      WHEN Ownership = 'NGO' THEN 'Non Governmental Organization'
      ELSE Ownership 
    END AS Ownership_transformed,
    [Facility name]
  FROM data_cleaned
  WHERE Country = 'Nigeria'
)

SELECT Ownership_transformed, COUNT([Facility name]) AS facility_count
FROM Ownership_new
GROUP BY Ownership_transformed
ORDER BY COUNT([Facility name]) DESC;

--Highlight Unique Facility types in Nigeria
SELECT  DISTINCT([Facility type])
FROM data_cleaned
WHERE Country = 'Nigeria';

--Number of facilities by Facility type in Nigeria
SELECT [Facility type], COUNT(*) as facility_count
FROM data_cleaned
WHERE Country = 'Nigeria'
GROUP BY [Facility type]
ORDER BY COUNT(*) DESC;

-- Number of facilities by ownership and healthcare tier
WITH pivotdata AS (
    SELECT [Facility type],
        CASE 
            WHEN [Facility type] = 'National Hospital' THEN 'Tertiary'
            WHEN [Facility type] LIKE '%Health Centre%' THEN 'Primary'
            WHEN [Facility type] LIKE '%Clinic%' THEN 'Primary'
            WHEN [Facility type] = 'Cottage Hospital' THEN 'Primary'
            WHEN [Facility type] = 'Dispensary' THEN 'Primary'
            WHEN [Facility type] = 'District Hospital' THEN 'Secondary'
            WHEN [Facility type] LIKE '%Medical Centre%' THEN 'Secondary'
            WHEN [Facility type] = 'Federal Medical Centre' THEN 'Secondary'
            WHEN [Facility type] = 'General Hospital' THEN 'Secondary'
            WHEN [Facility type] = 'Health Post' THEN 'Primary'
            WHEN [Facility type] = 'Hospital' THEN 'Secondary'
            WHEN [Facility type] = 'Rural Hospital' THEN 'Primary'
            WHEN [Facility type] = 'University Teaching Hospital' THEN 'Tertiary'
        END AS HealthCare_tier,
        CASE 
            WHEN Ownership LIKE 'MoH%' THEN 'Ministry of Health & Partners'
            WHEN Ownership LIKE 'Priv%' THEN 'Private'
            WHEN Ownership LIKE 'Publi%' THEN 'Public'
            WHEN Ownership LIKE 'ONG%' THEN 'Non-Governmental Organization'
            WHEN Ownership = 'Govt.' THEN 'Government'
            WHEN Ownership = 'CBO' THEN 'Community Based Organization'
            WHEN Ownership = 'FBO' THEN 'Faith-Based Organization'
            WHEN Ownership = 'FBO/NGO' THEN 'Faith-Based Organization/Community Based Organization'
            WHEN Ownership = 'NGO' THEN 'Non-Governmental Organization'
            ELSE Ownership 
        END AS Ownership_transformed
    FROM data_cleaned
    WHERE Country = 'Nigeria'
)

-- Pivot query to get the counts of facilities by ownership and healthcare tier
SELECT *
FROM (
    SELECT Ownership_transformed, HealthCare_tier
    FROM pivotdata
) AS SourceTable
PIVOT (
    COUNT(HealthCare_tier)
    FOR HealthCare_tier IN ([Primary], [Secondary], [Tertiary])
) AS PivotTable;
