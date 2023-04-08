# Nashville Housing Data Cleaning

This SQL project focuses on cleaning data for the Nashville Housing dataset. The data is loaded from a CSV file into a MySQL table named nashville_housing. The following SQL techniques were used to clean the data:

- Set the data type for each column in the table.
- Checked for null values in each column.
- Checked for duplicates in each column.
- Standardized the date format.
- Populated missing property address data using a subquery.

To check for null values and duplicates, CASE statements were used to count the number of null values and duplicates in each column. To standardize the date format, the CONVERT function was used to convert the SaleDate column to the Date data type. To populate the missing property address data, a subquery was used to match the ParcelID column with the missing PropertyAddress column and then used IFNULL to populate the missing data.

The full SQL code for this project is available in this link :  

https://github.com/nassimelhommani6/Nashville-Housing-Data-Cleaning-/blob/main/nashvillehousing_data_cleaning.sql
