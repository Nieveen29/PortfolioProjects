-- Cleaning Data in SQL queries 

Select * 
from nashvillehousing; 

-- Standardize Date Format 

SELECT 
  STR_TO_DATE(SaleDate, '%M %d, %Y') AS SaleDate,
  DATE(STR_TO_DATE(SaleDate, '%M %d, %Y')) AS ConvertedDate
FROM nashvillehousing;


ALTER TABLE nashvillehousing
ADD SaleDateConverted DATE;


UPDATE nashvillehousing
SET SaleDateConverted = CAST(SaleDate AS DATE)
WHERE SaleDate IS NOT NULL;

SELECT 
  DATE_FORMAT(SaleDateConverted, '%m/%d/%Y') AS SaleDateConverted,
  DATE_FORMAT(SaleDate, '%m/%d/%Y') AS SaleDate
FROM nashvillehousing;

-- populate property Address Data 

SELECT * 
FROM nashvillehousing 
WHERE TRIM(PropertyAddress) = '';

SET SQL_SAFE_UPDATES = 0;

UPDATE nashvillehousing a
JOIN nashvillehousing b 
  ON a.ParcelID = b.ParcelID 
  AND a.UniqueID <> b.UniqueID
SET a.PropertyAddress = b.PropertyAddress
WHERE TRIM(a.PropertyAddress) = ''
  AND b.PropertyAddress IS NOT NULL
  AND TRIM(b.PropertyAddress) <> '';


SET SQL_SAFE_UPDATES = 1;
UPDATE nashvillehousing
SET PropertyAddress = NULL
WHERE TRIM(PropertyAddress) = '';

-- Breaking out Address into individual columns (Address, City, State) 

Select propertyaddress 
from nashvillehousing;
-- where propertyaddress is null
-- order by ParcelID

SELECT 
  SUBSTRING_INDEX(PropertyAddress, ',', 1) AS Address,
  LENGTH(SUBSTRING_INDEX(PropertyAddress, ',', 1)) AS LengthBeforeComma
FROM nashvillehousing;

SELECT 
  SUBSTRING_INDEX(PropertyAddress, ',', 1) AS StreetAddress,
  TRIM(SUBSTRING_INDEX(PropertyAddress, ',', -1)) AS City
FROM nashvillehousing;




ALTER TABLE nashvillehousing
ADD COLUMN PropertySplitAddress VARCHAR(255);


SET SQL_SAFE_UPDATES = 0;


UPDATE nashvillehousing
SET PropertySplitAddress = SUBSTRING_INDEX(PropertyAddress, ',', 1)
WHERE TRIM(PropertyAddress) <> '';


ALTER TABLE nashvillehousing
ADD COLUMN PropertySplitCity VARCHAR(255);

SET SQL_SAFE_UPDATES = 0;


UPDATE nashvillehousing
SET PropertySplitCity = TRIM(SUBSTRING_INDEX(PropertyAddress, ',', -1))
WHERE TRIM(PropertyAddress) <> '';

UPDATE nashvillehousing
SET SaleDateConverted = STR_TO_DATE(SaleDate, '%M %d, %Y')
WHERE SaleDate IS NOT NULL;

Select * 
from nashvillehousing; 

Select OwnerAddress
From nashvillehousing; 


SELECT 
TRIM(SUBSTRING_INDEX(OwnerAddress, ',', 1)) AS Street,
  TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 2), ',', -1)) AS City,
   TRIM(SUBSTRING_INDEX(OwnerAddress, ',', -1)) AS state
FROM nashvillehousing;


ALTER TABLE nashvillehousing
ADD COLUMN OwnerSplitAddress VARCHAR(255);


SET SQL_SAFE_UPDATES = 0;


UPDATE nashvillehousing
SET OwnerSplitAddress = TRIM(SUBSTRING_INDEX(OwnerAddress, ',', 1))
WHERE TRIM(OwnerAddress) <> '';


ALTER TABLE nashvillehousing
ADD COLUMN OwnerSplitCity VARCHAR(255);

SET SQL_SAFE_UPDATES = 0;


UPDATE nashvillehousing
SET OwnerSplitCity = TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 2), ',', -1))
WHERE TRIM(OwnerAddress) <> '';

ALTER TABLE nashvillehousing
ADD COLUMN OwnerSplitState VARCHAR(255);

SET SQL_SAFE_UPDATES = 0;


UPDATE nashvillehousing
SET OwnerSplitState = TRIM(SUBSTRING_INDEX(OwnerAddress, ',', -1))
WHERE TRIM(OwnerAddress) <> '';



Select * 
from nashvillehousing; 

-- Change Y and N to Yes and No in "Sold as Vacant" Field 

Select distinct (SoldAsVacant), Count(SoldAsVacant) 
from nashvillehousing
Group by SoldAsVacant
order by 2;  



SELECT 
  SoldAsVacant,
  CASE
    WHEN UPPER(TRIM(SoldAsVacant)) IN ('Y', 'YES') THEN 'Yes'
    WHEN UPPER(TRIM(SoldAsVacant)) IN ('N', 'NO') THEN 'No'
    ELSE 'Unknown'
  END AS CleanedSoldAsVacant
FROM nashvillehousing
WHERE SoldAsVacant = 'Yes'
LIMIT 50;

SELECT SoldAsVacant,
 
  CASE
    WHEN SoldAsVacant = 'Y' Then 'YES' 
    WHEN SoldAsVacant= 'N' Then 'NO'
    ELSE SoldAsVacant
  END 
FROM nashvillehousing;

UPDATE nashvillehousing
SET SoldAsVacant = case  WHEN SoldAsVacant = 'Y' Then 'YES' 
    WHEN SoldAsVacant= 'N' Then 'NO'
    ELSE SoldAsVacant
  END ; 

Select * 
from nashvillehousing; 

-- Remove Duplicates 

SET SQL_SAFE_UPDATES = 0;

DELETE nh
FROM nashvillehousing nh
JOIN (
  SELECT 
    UniqueID
  FROM (
    SELECT 
      UniqueID,
      ROW_NUMBER() OVER (
        PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
        ORDER BY UniqueID
      ) AS row_num
    FROM nashvillehousing
  ) AS ranked
  WHERE row_num > 1
) AS duplicates
ON nh.UniqueID = duplicates.UniqueID;

WITH RowNumCTE AS (
Select * , 
Row_number () OVER (
Partition BY ParcelID, 
             PropertyAddress, 
             SalePrice, 
             SaleDate, 
             LegalReference
             ORDER BY 
                 UniqueID
                 ) Row_num
From nashvillehousing 
-- Order By ParcelID 
)
Delete
From RowNumCTE 
Where row_num > 1 
Order by PropertyAddress; 

-- Delete Unused Columns 


Select * 
from nashvillehousing ; 

Alter Table nashvillehousing 
Drop Column OwnerAddress, 
Drop Column TaxDistrict, 
Drop Column PropertyAddress; 

Alter Table nashvillehousing 
Drop Column SaleDate;  

Select * 
from nashvillehousing ; 




