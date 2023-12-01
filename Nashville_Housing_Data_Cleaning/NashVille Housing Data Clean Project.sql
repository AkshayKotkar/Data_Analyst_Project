--Read Data of Nashville Housing 

Select * 
From NashvilleHousing

-- Null Property Addresses Fill with Same Parcel ID But Different Parcel ID.

Select a.ParcelID , a.PropertyAddress, a.UniqueID ,b.ParcelID, b.PropertyAddress, b.UniqueID 
From NashvilleHousing a
Join NashvilleHousing b
on a.ParcelID = b.ParcelID AND a.UniqueID != b.UniqueID
Where a.PropertyAddress is null

-- Update Null Column With Property Address

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From NashvilleHousing a
Join NashvilleHousing b
on a.ParcelID = b.ParcelID AND a.UniqueID != b.UniqueID
Where a.PropertyAddress is null

-- Check Any Null Property Address

Select PropertyAddress
From NashvilleHousing
Where PropertyAddress is null

-- Spliting the Property Address into Individual Columns (Address, City)
-- Retrive this Query and After Right Add Columns

Select PropertyAddress,
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) As PropertyAddress,
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, Len(PropertyAddress)) As PropertyCity
From NashvilleHousing

-- Add Address Column

ALTER TABLE NashvilleHousing
ADD Property_Address nvarchar(255);

-- Update Address Column

UPDATE NashvilleHousing
Set Property_Address = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)

--Add City Column

ALTER TABLE NashvilleHousing
ADD Property_City nvarchar(255);

--Update City Column

UPDATE NashvilleHousing
Set Property_City = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, Len(PropertyAddress))

-- Delete Old Property Address Column

ALTER TABLE NashvilleHousing
DROP COLUMN PropertyAddress

Select * From NashvilleHousing

-- Spliting the Owner Address into Individual Columns (Address, City) Using PARSENAME

Select OwnerAddress 
From NashvilleHousing

-- Retrive Query

SELECT 
PARSENAME(Replace(OwnerAddress, ',' ,'.'),3) As Address,
PARSENAME(Replace(OwnerAddress, ',' ,'.'),2) As City,
PARSENAME(Replace(OwnerAddress, ',' ,'.'),1) As Satte
From NashvilleHousing

-- Add All Columns

ALTER TABLE NashvilleHousing
ADD Owner_Address Nvarchar(255),
Owner_City Nvarchar(255),
Owner_State Nvarchar(255)

-- Update All Columns

Update NashvilleHousing
SET Owner_Address = PARSENAME(Replace(OwnerAddress, ',' ,'.'),3),
Owner_City = PARSENAME(Replace(OwnerAddress, ',' ,'.'),2),
Owner_State = PARSENAME(Replace(OwnerAddress, ',' ,'.'),1) 

Select * From NashvilleHousing

-- In Sold As Vacant Column Data in 0 and 1 Form Its Change To Yes Or No

Select DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
From NashvilleHousing
Group By SoldAsVacant

-- 0 Changes To No and 1 Changes To Yes

Select SoldAsVacant,
CASE 
WHEN SoldAsVacant = 0 Then 'NO'
WHEN SoldAsVacant = 1 Then 'Yes'
ELSE NULL
END as SoldAsVacant
From NashvilleHousing

-- Add SoldAsVacant Column 

ALTER TABLE NashvilleHousing
Add Sold_Vacant nvarchar(10)

-- Update New Column Data

UPDATE NashvilleHousing
SET Sold_Vacant = CASE 
WHEN SoldAsVacant = 0 Then 'NO'
WHEN SoldAsVacant = 1 Then 'Yes'
ELSE NULL
END

-- Delete Old Sold As Vacant Data

ALTER TABLE NashvilleHousing
DROP COLUMN SoldAsVacant

--Remove Duplicates
-- Create CTE For Delete With Where Condition

With ROW_NUM_CTE as
(
Select *, 
ROW_NUMBER() OVER (PARTITION BY ParcelID,
								Property_Address,
								Property_City,
								SalePrice,
								SaleDate,
								LegalReference
								Order By UniqueID ) As Row_Number
from NashvilleHousing
)

-- Delete Duplicate Rows

DELETE
From ROW_NUM_CTE
Where Row_Number > 1

-- DELETE Unused Columns

ALTER TABLE NashvilleHousing
DROP COLUMN LandUse, TaxDistrict

Select *
From NashvilleHousing