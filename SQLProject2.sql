--Cleaning Data in SQL 

SELECT * FROM Data_Clean..Sheet1$ ;

SELECT SaleDateConverted, CONVERT(Date,SaleDate)
FROM Sheet1$;

UPDATE Sheet1$ 
SET SaleDateConverted = CONVERT(Date,SaleDate);

ALTER TABLE Sheet1$ 
ADD SaleDateConverted Date;

-- Populate property adress data

SELECT *
FROM Sheet1$ 
--WHERE PropertyAddress IS NULL 
ORDER BY ParcelID;

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM Sheet1$ a
JOIN Sheet1$ b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL 

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM Sheet1$ a
JOIN Sheet1$ b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL 

-- Breaking out an adress by indivdual columns (Adress,City, State)

SELECT PropertyAddress
FROM Sheet1$;

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1) AS Address
,SUBSTRING(PropertyAddress,  CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress)) AS Address
FROM Sheet1$

UPDATE Sheet1$ 
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1);

ALTER TABLE Sheet1$ 
ADD PropertySplitAddress NVARCHAR(255);

UPDATE Sheet1$ 
SET PropertySplitCity= SUBSTRING(PropertyAddress,  CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress))

ALTER TABLE Sheet1$ 
ADD PropertySplitCity NVARCHAR(255);

SELECT* FROM Sheet1$;


SELECT OwnerAddress FROM Sheet1$;

SELECT 
PARSENAME(REPLACE(OwnerAddress,',','.'),3)
,PARSENAME(REPLACE(OwnerAddress,',','.'),2)
,PARSENAME(REPLACE(OwnerAddress,',','.'),1)
FROM Sheet1$


UPDATE Sheet1$ 
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

ALTER TABLE Sheet1$ 
ADD OwnerSplitAddress NVARCHAR(255);

UPDATE Sheet1$ 
SET OwnerSplitCity= PARSENAME(REPLACE(OwnerAddress,',','.'),2)

ALTER TABLE Sheet1$ 
ADD OwnerSplitCity NVARCHAR(255);

UPDATE Sheet1$ 
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)

ALTER TABLE Sheet1$ 
ADD OwnerSplitState NVARCHAR(255);

C


--Change Y and N In Sold field 

SELECT DISTINCT(SoldAsVacant),COUNT(SoldAsVacant)
FROM Sheet1$
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant
, CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'NO'
	ELSE SoldAsVacant
	END
FROM Sheet1$

UPDATE Sheet1$
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'NO'
	ELSE SoldAsVacant
	END


	-- Remove Duplicates 
WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY 
					UniqueID
				
				) row_num

FROM Sheet1$
--ORDER BY ParcelID;
)
SELECT*  
FROM RowNumCTE
WHERE row_num >1 
ORDER BY PropertyAddress;

-- Delete Unused Columns 

SELECT * 
FROM Sheet1$

ALTER TABLE Sheet1$ 
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE Sheet1$ 
DROP COLUMN SaleDate
