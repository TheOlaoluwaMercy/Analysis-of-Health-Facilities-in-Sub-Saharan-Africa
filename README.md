# Analysis-of-Health-Facilities-in-Sub-Saharan-Africa
Exploring country-level and state-level distribution, facility ownership, and facility types across health facilities in sub-Saharan Africa.

## Tools & Concepts Used
- SQL
- SQL Server
- Data Exploration
- Data Cleaning
- Aggregation
- CTE

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

## Univariate Analysis
The dataset contains data from 50 unique countries, 582 states, 93,460 facilities, 167 facility types, and 11 ownership types.

### Highlight Unique Countries
```
SELECT DISTINCT(Country)
FROM data_cleaned
ORDER BY Country;
```              
> Angola, Benin, Botswana, Burkina Faso, Burundi, Cameroon, Cape Verde, Central African Republic, Chad, Comoros, Congo, Cote d'Ivoire, Democratic Republic of the Congo, Djibouti, Equatorial Guinea, Eritrea, eSwatini, Ethiopia, Gabon, Gambia, Ghana, Guinea, Guinea Bissau, Kenya, Lesotho, Liberia, Madagascar, Malawi, Mali, Mauritania, Mauritius, Mozambique, Namibia, Niger, Nigeria, Rwanda, Sao Tome and Principe, Senegal, Seychelles, Sierra Leone, Somalia, South Africa, South Sudan, Sudan, Tanzania, Togo, Uganda, Zambia, Zanzibar, Zimbabwe

### Count of Unique Countries
```
SELECT COUNT(DISTINCT(Country)) AS country_count
FROM data_cleaned;
```

|country_count|
|-------------|
|50           |

### Number of facilities by country
Nigeria, the Democratic Republic of the Congo, and Tanzania have the highest number of healthcare facilities, while Equatorial Guinea, Seychelles, and Guinea-Bissau have the fewest.
```
SELECT Country, COUNT([Facility name]) as facility_count
FROM data_cleaned
GROUP BY Country 
ORDER BY COUNT([Facility name]) DESC;
```
| Country                         | facility_count |
|----------------------------------|----------------|
| Nigeria                         | 20733          |
| Democratic Republic of the Congo| 14573          |
| Tanzania                        | 6304           |
| Kenya                           | 6144           |
| Ethiopia                        | 5214           |
| South Africa                    | 4303           |
| Uganda                          | 3789           |
| Cameroon                        | 3061           |
| Niger                           | 2881           |
| Madagascar                      | 2677           |
| Ghana                           | 1960           |
| Cote d'Ivoire                   | 1792           |
| Guinea                          | 1742           |
| South Sudan                     | 1739           |
| Burkina Faso                    | 1721           |
| Mozambique                      | 1579           |
| Angola                          | 1574           |
| Mali                            | 1478           |
| Senegal                         | 1345           |
| Chad                            | 1275           |
| Zambia                          | 1263           |
| Zimbabwe                        | 1236           |
| Sierra Leone                    | 1120           |
| Somalia                         | 879            |
| Benin                           | 819            |
| Liberia                         | 740            |
| Burundi                         | 664            |
| Malawi                          | 648            |
| Mauritania                      | 645            |
| Botswana                        | 623            |
| Rwanda                          | 572            |
| Central African Republic        | 555            |
| Gabon                           | 542            |
| Namibia                         | 369            |
| Congo                           | 328            |
| Sudan                           | 272            |
| Eritrea                         | 269            |
| Togo                            | 207            |
| Mauritius                       | 166            |
| Zanzibar                        | 145            |
| eSwatini                        | 135            |
| Lesotho                         | 117            |
| Gambia                          | 103            |
| Cape Verde                      | 66             |
| Djibouti                        | 66             |
| Comoros                         | 66             |
| Sao Tome and Principe           | 50             |
| Equatorial Guinea               | 47             |
| Seychelles                      | 18             |
| Guinea Bissau                   | 8              |

### Highlight Unique Administrative divisions/state 
```
SELECT DISTINCT(Admin1) AS Admin_Division_or_States
FROM data_cleaned
ORDER BY Admin1;
```
### Count of Unique Administrative divisions/state
```
SELECT COUNT(DISTINCT(Admin1)) AS AdminDivision_Count
FROM data_cleaned;
```

|AdminDivision_Count|
|-------------------|
|582                |

## Number of facilities by Admin Divisions/State
```
SELECT Admin1, Country, COUNT([Facility name]) as facility_count
FROM data_cleaned
GROUP BY Admin1 , Country
ORDER BY COUNT([Facility name]) DESC;
```

### Highlight Unique Facilities 
```
SELECT DISTINCT([Facility name])
FROM data_cleaned
ORDER BY [Facility name];
```

### Count of Unique Facilities
The number of unique facilities is lower than the total row count in the dataset because some facilities appear in multiple locations, such as satellite branches
```
SELECT COUNT(DISTINCT([Facility name])) AS Facility_Count
FROM data_cleaned;
```

|Facility_Count|
|--------------|
|93460         |

### Highlight Facility type
```
SELECT DISTINCT([Facility type])
FROM data_cleaned
ORDER BY [Facility type];
```
### Count Unique Facility type
```
SELECT COUNT(DISTINCT([Facility type])) AS FacilityType_Count
FROM data_cleaned;
```

|FacilityTpe_Count|
|-----------------|
|167              |

### Highlight Unique Ownership Types
This returned 20 different ownership types, most of which required data cleaning and transformation to ensure uniformity.
```
SELECT DISTINCT(Ownership)
FROM data_cleaned
ORDER BY Ownership;
```

### Transform & Highlight  the Unique Ownership Types 
```
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
```
> Community Based Organization, Confessionnel, Faith Based Organization, Faith Based Organization/Community Based Organization, Government, Local authority, Ministry of Health & Partners, Non Governmental Organization, Parastatal, Private, Public

### Count Unique Ownership types 
```
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
SELECT COUNT(DISTINCT(Ownership_transformed)) AS Ownership_count
FROM Ownership_new;
```

|Ownership_Count|
|---------------|
|11             |

### Number of facilities by Ownership type
The Ministry of Health & Partners owned the largest share of healthcare facilities.
```
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
```

| Ownership_transformed                                 | facility_count |
|--------------------------------------------------------|----------------|
| Ministry of Health & Partners                          | 31,704         |
| NULL                                                   | 30,365         |
| Public                                                 | 23,957         |
| Local authority                                        | 6,196          |
| Faith Based Organization                               | 2,945          |
| Private                                                | 962            |
| Non Governmental Organization                          | 859            |
| Government                                             | 806            |
| Community Based Organization                           | 369            |
| Confessionnel                                          | 365            |
| Faith Based Organization/Community Based Organization  | 89             |
| Parastatal                                             | 5              |

## Drilling down to Nigeria
The dataset reports 20,733 healthcare facilities in Nigeria.

### Number of health facilities in Nigeria
```
SELECT COUNT(*) AS facility_count_Nigeria
FROM data_cleaned
WHERE Country = 'Nigeria';
```

| Country  | facility_count |
|----------|----------------|
| Nigeria  | 20,733         |

### Number of health facilities in each state in Nigeria
Katsina, Niger, Kano, Kaduna, and Adamawa recorded the highest volumes, while Gombe, Lagos, Bayelsa, Abia, and the FCT recorded the fewest.
```
SELECT Admin1,  COUNT(*) AS facility_count_Nigeria
FROM data_cleaned
WHERE Country = 'Nigeria'
GROUP BY Admin1
ORDER BY COUNT(*) DESC;
```

| Admin1                  | facility_count_Nigeria |
|-------------------------|------------------------|
| Katsina                 | 1270                   |
| Niger                   | 1230                   |
| Kano                    | 1029                   |
| Kaduna                  | 926                    |
| Adamawa                 | 809                    |
| Kogi                    | 786                    |
| Bauchi                  | 773                    |
| Benue                   | 752                    |
| Taraba                  | 741                    |
| Plateau                 | 722                    |
| Osun                    | 681                    |
| Sokoto                  | 670                    |
| Zamfara                 | 654                    |
| Nasarawa                | 608                    |
| Oyo                     | 603                    |
| Jigawa                 | 598                    |
| Cross River             | 576                    |
| Kwara                   | 487                    |
| Delta                   | 485                    |
| Ogun                    | 481                    |
| Enugu                   | 474                    |
| Ondo                    | 455                    |
| Yobe                    | 448                    |
| Borno                   | 396                    |
| Imo                     | 389                    |
| River                   | 388                    |
| Akwa Ibom               | 386                    |
| Ebonyi                  | 376                    |
| Kebbi                   | 373                    |
| Anambra                 | 354                    |
| Edo                     | 346                    |
| Ekiti                   | 316                    |
| Gombe                   | 315                    |
| Lagos                   | 252                    |
| Bayelsa                 | 206                    |
| Abia                    | 198                    |
| Federal Capital Territory | 180                  |

### Top 5 states
```
SELECT TOP 5 Admin1,  COUNT(*) AS facility_count_Nigeria
FROM data_cleaned
WHERE Country = 'Nigeria'
GROUP BY Admin1
ORDER BY COUNT(*) DESC;
```

| Admin1   | facility_count_Nigeria |
|----------|------------------------|
| Katsina  | 1270                   |
| Niger    | 1230                   |
| Kano     | 1029                   |
| Kaduna   | 926                    |
| Adamawa  | 809                    |

### Bottom 5 states
```
SELECT TOP 5 Admin1,  COUNT(*) AS facility_count_Nigeria
FROM data_cleaned
WHERE Country = 'Nigeria'
GROUP BY Admin1
ORDER BY COUNT(*) ASC;
```
| Admin1                   | facility_count_Nigeria |
|--------------------------|------------------------|
| Federal Capital Territory| 180                    |
| Abia                     | 198                    |
| Bayelsa                  | 206                    |
| Lagos                    | 252                    |
| Gombe                    | 315                    |


### Number of facilities by Ownership in Nigeria
 Ownership was unspecified for the majority of healthcare facilities in Nigeria; however, for those with specified ownership, Community Based Organizations took the lead.
```
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
```

| Ownership_transformed        | facility_count |
|------------------------------|----------------|
| NULL                         | 20,552         |
| Community Based Organization | 126            |
| Ministry of Health & Partners| 39             |
| Faith Based Organization     | 16             |

### Highlight Unique Facility types in Nigeria
```
SELECT  DISTINCT([Facility type])
FROM data_cleaned
WHERE Country = 'Nigeria';
```

> Basic Health Centre, Clinic, Comprehensive Health Centre, Cottage Hospital, Dispensary, District Hospital, Federal Medical Centre, General Hospital, Health Centre, Health Post, Hospital, Medical Centre, Model Health Centre, Model Primary Health Centre, Natonal Hospital, Polyclinic, Primary Health Centre, Rural Hospital, State Hospital, University Teaching Hospital

### Number of facilities by Facility type in Nigeria
```
SELECT [Facility type], COUNT(*) as facility_count
FROM data_cleaned
WHERE Country = 'Nigeria'
GROUP BY [Facility type]
ORDER BY COUNT(*) DESC;
```

| Facility type                  | facility_count |
|--------------------------------|----------------|
| Primary Health Centre          | 4610           |
| Clinic                         | 4338           |
| Health Centre                  | 3394           |
| Dispensary                     | 3226           |
| Health Post                    | 3055           |
| Basic Health Centre            | 564            |
| General Hospital               | 529            |
| Comprehensive Health Centre    | 434            |
| Cottage Hospital               | 149            |
| Hospital                       | 148            |
| Model Health Centre            | 107            |
| Model Primary Health Centre    | 58             |
| University Teaching Hospital   | 25             |
| Federal Medical Centre         | 19             |
| Rural Hospital                 | 19             |
| Medical Centre                 | 19             |
| District Hospital              | 16             |
| State Hospital                 | 12             |
| Polyclinic                     | 10             |
| Natonal Hospital               | 1              |

### Group Facility type based on healthcare tier and return number of facilities by healthcare tier
Based on healthcare tier, the majority of health facilities are primary healthcare institutions.
```
With HealthCareTier AS (SELECT [Facility type],
	CASE WHEN [Facility type] = 'Natonal Hospital' THEN 'Tertairy'
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
		 WHEN [Facility type] = 'University Teaching Hospital' THEN 'Tertairy'
	END AS HealthCare_tier
FROM data_cleaned
WHERE Country = 'Nigeria')

SELECT HealthCare_tier, COUNT(*) AS facility_count
FROM HealthCareTier
GROUP BY HealthCare_tier;
```

| HealthCare_tier | facility_count |
|-----------------|----------------|
| Tertairy        | 26             |
| NULL            | 12             |
| Secondary       | 731            |
| Primary         | 19,964         |

## Bivariate Analysis
### Number of facilities by ownership and healthcare tier
```
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
```
| Ownership_transformed        | Primary | Secondary | Tertiary |
|------------------------------|---------|-----------|----------|
| Faith-Based Organization     | 16      | 0         | 0        |
| Ministry of Health & Partners| 15      | 24        | 0        |
| NULL                         | 19807   | 707       | 25       |
| Community Based Organization | 126     | 0         | 0        |
























