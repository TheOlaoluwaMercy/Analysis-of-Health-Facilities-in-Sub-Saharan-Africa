# Analysis-of-Public-Health-Facilities-in-Sub-Saharan-Africa
Exploring country-level and state-level distribution, facility ownership, and facility types across health facilities in sub-Saharan Africa.

This [dataset](https://data.humdata.org/dataset/health-facilities-in-sub-saharan-africa) was compiled by Maina, J., Ouma, P.O., Macharia, P.M., et al., as part of their research titled [A spatial database of health facilities managed by the public health sector in sub-Saharan Africa](https://www.researchgate.net/publication/334289719_A_spatial_database_of_health_facilities_managed_by_the_public_health_sector_in_sub_Saharan_Africa), published in 2019.

The objective of this analysis is to explore the dataset and extract insights related to the distribution of health facilities at both the country and state (admin division) levels. It also investigates the types and ownership structures of healthcare facilities across the region.
Subsequently, the analysis will narrow its focus to Nigeria to examine the state-level distribution of health facilities, as well as the ownership, facility type and healthcare service tiers within the country.

## Data Profiling

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



