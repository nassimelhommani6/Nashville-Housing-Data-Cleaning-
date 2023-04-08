USE nashville_database
CREATE TABLE nashville_housing (
  UniqueID INT,
  ParcelID VARCHAR(50),
  LandUse VARCHAR(50),
  PropertyAddress VARCHAR(255),
  SaleDate Date,
  SalePrice INT,
  LegalReference VARCHAR(50),
  SoldAsVacant VARCHAR(3),
  OwnerName VARCHAR(255),
  OwnerAddress VARCHAR(255),
  Acreage DECIMAL(10,2),
  TaxDistrict VARCHAR(50),
  LandValue INT,
  BuildingValue INT,
  TotalValue INT,
  YearBuilt INT,
  Bedrooms INT,
  FullBath INT,
  HalfBath INT
);
SET GLOBAL local_infile = 1;
LOAD DATA LOCAL INFILE 'C:/Users/Nassim/Desktop/Data_ Analytics_Certificate/Excel_SQL_for_Data_Analytics/SQL_project/SQL_Youtube_project/Nashville Housing Data for Data Cleaning csv.csv'
INTO TABLE nashville_housing 
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
SET 
UniqueID = NULLIF(UniqueID, ''),
ParcelID = NULLIF(ParcelID, ''),
LandUse = NULLIF(LandUse, ''),
PropertyAddress = NULLIF(PropertyAddress, ''),
SalePrice = NULLIF(SalePrice, ''),
LegalReference = NULLIF(LegalReference, ''),
SoldAsVacant = NULLIF(SoldAsVacant, ''),
OwnerName = NULLIF(OwnerName, ''),
OwnerAddress = NULLIF(OwnerAddress, ''),
Acreage = NULLIF(Acreage, ''),
TaxDistrict = NULLIF(TaxDistrict, ''),
LandValue = NULLIF(LandValue, ''),
BuildingValue = NULLIF(BuildingValue, ''),
TotalValue = NULLIF(TotalValue, ''),
YearBuilt = NULLIF(YearBuilt, ''),
Bedrooms = NULLIF(Bedrooms, ''),
FullBath = NULLIF(FullBath, ''),
HalfBath = NULLIF(HalfBath, '');

/*
Cleaning Data in SQL Queries
*/

Select *
From nashville_housing

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format


Select  SaleDate , CONVERT(SaleDate,Date) 
From nashville_housing ;


Update nashville_housing
SET SaleDate = CONVERT(SaleDate,Date);

-- If it doesn't Update properly

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)


 --------------------------------------------------------------------------------------------------------------------------
-- checking for nulls on each column
SELECT 
    SUM(CASE WHEN UniqueID IS NULL THEN 1 ELSE 0 END) AS UniqueID_null_count,
    SUM(CASE WHEN ParcelID IS NULL THEN 1 ELSE 0 END) AS ParcelID_null_count,
    SUM(CASE WHEN LandUse IS NULL THEN 1 ELSE 0 END) AS LandUse_null_count,
    SUM(CASE WHEN PropertyAddress IS NULL THEN 1 ELSE 0 END) AS PropertyAddress_null_count,
    SUM(CASE WHEN SaleDate IS NULL THEN 1 ELSE 0 END) AS SaleDate_null_count,
    SUM(CASE WHEN SalePrice IS NULL THEN 1 ELSE 0 END) AS SalePrice_null_count,
    SUM(CASE WHEN LegalReference IS NULL THEN 1 ELSE 0 END) AS LegalReference_null_count
FROM nashville_housing;

-- checking for duplicates on each column 
SELECT
  COUNT(*) - COUNT(DISTINCT UniqueID) AS UniqueID_duplicates,
  COUNT(*) - COUNT(DISTINCT ParcelID) AS ParcelID_duplicates,
  COUNT(*) - COUNT(DISTINCT LandUse) AS LandUse_duplicates,
  COUNT(*) - COUNT(DISTINCT PropertyAddress) AS PropertyAddress_duplicates,
  COUNT(*) - COUNT(DISTINCT SaleDate) AS SaleDate_duplicates,
  COUNT(*) - COUNT(DISTINCT SalePrice) AS SalePrice_duplicates,
  COUNT(*) - COUNT(DISTINCT LegalReference) AS LegalReference_duplicates,
  COUNT(*) - COUNT(DISTINCT SoldAsVacant) AS SoldAsVacant_duplicates,
  COUNT(*) - COUNT(DISTINCT OwnerName) AS OwnerName_duplicates,
  COUNT(*) - COUNT(DISTINCT OwnerAddress) AS OwnerAddress_duplicates,
  COUNT(*) - COUNT(DISTINCT Acreage) AS Acreage_duplicates,
  COUNT(*) - COUNT(DISTINCT TaxDistrict) AS TaxDistrict_duplicates,
  COUNT(*) - COUNT(DISTINCT LandValue) AS LandValue_duplicates,
  COUNT(*) - COUNT(DISTINCT BuildingValue) AS BuildingValue_duplicates,
  COUNT(*) - COUNT(DISTINCT TotalValue) AS TotalValue_duplicates,
  COUNT(*) - COUNT(DISTINCT YearBuilt) AS YearBuilt_duplicates,
  COUNT(*) - COUNT(DISTINCT Bedrooms) AS Bedrooms_duplicates,
  COUNT(*) - COUNT(DISTINCT FullBath) AS FullBath_duplicates,
  COUNT(*) - COUNT(DISTINCT HalfBath) AS HalfBath_duplicates
FROM nashville_housing;


-- Populate Property Address data

Select *
From nashville_housing
where PropertyAddress is null 
order by ParcelID 



Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, IFNULL(a.PropertyAddress,b.PropertyAddress)
From nashville_housing a
JOIN nashville_Housing b
	on a.ParcelID = b.ParcelID
	AND a.UniqueID  <> b.UniqueID 
Where a.PropertyAddress is null ;


Update a                                            -- we need to use the alias to avoid getting an error 
SET PropertyAddress = IFNULL(a.PropertyAddress,b.PropertyAddress)
From nashville_housing a
JOIN nashville_housing b
	on a.ParcelID = b.ParcelID
	AND a.UniqueID  <> b.UniqueID 
Where a.PropertyAddress is null

--------------------------------------------------------------------------------------------------------------------------
-- Breaking out Address into Individual Columns (Address, City, State)


Select PropertyAddress
From nashville_housing


SELECT PropertyAddress,
SUBSTRING_INDEX(PropertyAddress ,',', 1 ) as Address,
SUBSTRING_INDEX(PropertyAddress ,',', -1 ) as City
From nashville_housing 


ALTER TABLE nashville_housing
Add PropertySplitAddress Nvarchar(255);

Update nashville_housing
SET PropertySplitAddress = SUBSTRING_INDEX(PropertyAddress ,',', 1 ) ;


ALTER TABLE nashville_housing
Add PropertySplitCity Nvarchar(255);

Update nashville_housing
SET PropertySplitCity = SUBSTRING_INDEX(PropertyAddress ,',', -1 );

Select *
From nashville_housing


Select OwnerAddress
From nashville_housing


Select
SUBSTRING_INDEX(OwnerAddress ,',', 1 ) as Address,
SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress ,',', 2 ) ,',', -1 ) as City,
SUBSTRING_INDEX(OwnerAddress ,',', -1 ) as State
From nashville_housing



ALTER TABLE nashville_housing
Add OwnerSplitAddress Nvarchar(255);

Update nashville_housing
SET OwnerSplitAddress = SUBSTRING_INDEX(OwnerAddress ,',', 1 )


ALTER TABLE nashville_housing
Add OwnerSplitCity Nvarchar(255);

Update nashville_housing
SET OwnerSplitCity = SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress ,',', 2 ) ,',', -1 )



ALTER TABLE nashville_housing
Add OwnerSplitState Nvarchar(255);

Update nashville_housing
SET OwnerSplitState = SUBSTRING_INDEX(OwnerAddress ,',', -1 )

Select *
From nashville_housing

--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From nashville_housing
Group by SoldAsVacant
order by 2




Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From nashville_housing


Update nashville_housing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END ;

SELECT SoldAsVacant 
FROM nashville_housing 

----------------------------------------------------------------------------------------------------------------------------------------------------------
-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From nashville_housing
)
DELETE              -- the delete statement is not working with the CTE because CTE is not updatable , so we need to refer back to the original table using a join 
From nashville_housing
 USING nashville_housing JOIN RowNumCTE  
 ON nashville_housing.UniqueID=RowNumCTE.UniqueID
Where RowNumCTE.row_num > 1 ;

-- check for duplicates Rows : succeeded
WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From nashville_housing
)
Select *             -- the delete statement is not working with the CTE because CTE is not updatable , so we need to refer back to the original table using a join 
From RowNumCTE
Where row_num > 1 ;




Select *
From nashville_housing




