/*

Cleaning data in SQL queries

*/

Select *
from portfolioprojects.dbo.[ NashvilleHousing]

---------------------------------------------------------------------------
--Standardize Date format

Alter Table [ NashvilleHousing]
Add SaleDateConverted Date;

update [ NashvilleHousing]
Set SaleDateConverted= convert(Date,SaleDate)

Select SaleDateConverted, convert(Date, SaleDate)
from portfolioprojects.dbo.[ NashvilleHousing]

----------------------------------------------------------------------------

--Populate Property Address data

Select *
from portfolioprojects.dbo.[ NashvilleHousing]
--Where PropertyAddress is null
order by ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from portfolioprojects.dbo.[ NashvilleHousing] a
JOIN portfolioprojects.dbo.[ NashvilleHousing] b
ON  a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from portfolioprojects.dbo.[ NashvilleHousing] a
JOIN portfolioprojects.dbo.[ NashvilleHousing] b
ON  a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


------------------------------------------------------------------------------
--Breaking out Address into individual columns (Addresss, City, State)

Select PropertyAddress
from portfolioprojects.dbo.[ NashvilleHousing]

Select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',' ,PropertyAddress) -1)as Address, 
SUBSTRING(PropertyAddress, CHARINDEX(',' ,PropertyAddress) +1, LEN(PropertyAddress)) as Address
from portfolioprojects.dbo.[ NashvilleHousing]

Alter Table [ NashvilleHousing]
Add PropertySplitAddress nvarchar(255);

update [ NashvilleHousing]
Set PropertySplitAddress= SUBSTRING(PropertyAddress, 1, CHARINDEX(',' ,PropertyAddress) -1)

Alter Table [ NashvilleHousing]
Add PropertyAddressCity nvarchar(255);

update [ NashvilleHousing]
Set PropertyAddressCity= SUBSTRING(PropertyAddress, CHARINDEX(',' ,PropertyAddress) +1, LEN(PropertyAddress))



Select 
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
from portfolioprojects.dbo.[ NashvilleHousing]


Alter Table [ NashvilleHousing]
Add OwnerSplitAddress nvarchar(255);

update [ NashvilleHousing]
Set OwnerSplitAddress= PARSENAME(REPLACE(OwnerAddress,',','.'),3)

Alter Table [ NashvilleHousing]
Add OwnerSplitCity nvarchar(255);

update [ NashvilleHousing]
Set OwnerSplitCity= PARSENAME(REPLACE(OwnerAddress,',','.'),2)


Alter Table [ NashvilleHousing]
Add OwnerSplitState nvarchar(255);

update [ NashvilleHousing]
Set OwnerSplitState= PARSENAME(REPLACE(OwnerAddress,',','.'),1)

-------------------------------------------------------------------------------------

--Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct (SoldAsVacant), count(SoldAsVacant)
From PortfolioProjects.dbo.[ NashvilleHousing]
Group by SoldAsVacant
Order by 2



select SoldAsVacant,
CASE when SoldAsVacant = 'Y' THEN 'Yes'
     wHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END 
From PortfolioProjects.dbo.[ NashvilleHousing] 



Update PortfolioProjects.dbo.[ NashvilleHousing]
SET SoldAsVacant =CASE when SoldAsVacant = 'Y' THEN 'Yes'
     wHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END

---------------------------------------------------------------------------------------
--Remove Duplicates

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

From PortfolioProjects.dbo.[ NashvilleHousing]
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From PortfolioProjects.dbo.[ NashvilleHousing]

--------------------------------------------------------------------------------
--Delete Unused Columns

Select *
From PortfolioProjects.dbo.[ NashvilleHousing]


ALTER TABLE PortfolioProjects.dbo.[ NashvilleHousing]
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate
