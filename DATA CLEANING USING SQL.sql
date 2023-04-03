/****** Cleaning data in SQL Querries  ******/

SELECT *
  FROM [Project].[dbo].[ HousingData]

  -- standardize Date format

  SELECT saleDate, convert(Date, saleDate)
  FROM [Project].[dbo].[ HousingData]

  update [Project].[dbo].[ HousingData]
  set SaleDate = convert(Date, saleDate)

  -- Fill in blanks for propert address data

  select *
  FROM [Project].[dbo].[ HousingData]
  where propertyaddress is null
  order by parcelID

 
 select a.ParcelID,a.PropertyAddress, b.parcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress) 
  FROM [Project].[dbo].[ HousingData] a
  JOIN [Project].[dbo].[ HousingData] b
  ON a.parcelID = b.parcelID
  AND a.[uniqueID] <> b.[uniqueID]
  --where a.PropertyAddress is null


  
  Update a -- When writing an update statementm we use the Alias
  SET propertyaddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
  FROM [Project].[dbo].[ HousingData] a
  JOIN [Project].[dbo].[ HousingData] b
  ON a.parcelID = b.parcelID
  AND a.[uniqueID] <> b.[uniqueID]
  where a.PropertyAddress is null

  -- breaking out address into individual columns (Address, city, state)

   select propertyaddress
  FROM [Project].[dbo].[ HousingData]

  -- using PARSENAME 
  -- seperating propert address

   select *
  FROM [Project].[dbo].[ HousingData]
  
  SELECT
  PARSENAME(REPLACE( propertyaddress, ',','.'),2)
  ,PARSENAME(REPLACE( propertyaddress, ',','.'),1)
  FROM [Project].[dbo].[ HousingData]
  

    ALTER TABLE [Project].[dbo].[ HousingData]
   Add propertysplitaddress nvarchar (255);

   update [Project].[dbo].[ HousingData]
   set propertysplitaddress = PARSENAME(REPLACE( PropertyAddress, ',','.'),2) 

   ALTER TABLE [Project].[dbo].[ HousingData]
   Add propertsplitcity nvarchar (255);

   update [Project].[dbo].[ HousingData]
   set propertsplitcity = PARSENAME(REPLACE( PropertyAddress, ',','.'),1) 

  -- Seperating owner address

   select 
   PARSENAME(REPLACE( OwnerAddress, ',','.'),3) 
  ,PARSENAME(REPLACE( OwnerAddress, ',','.'),2) 
  ,PARSENAME(REPLACE( OwnerAddress, ',','.'),1)
   FROM [Project].[dbo].[ HousingData]

   ALTER TABLE [Project].[dbo].[ HousingData]
   Add ownersplitaddress nvarchar (255);

   update [Project].[dbo].[ HousingData]
   set ownersplitaddress = PARSENAME(REPLACE( OwnerAddress, ',','.'),3) 

   ALTER TABLE [Project].[dbo].[ HousingData]
   Add ownersplitcity nvarchar (255);

   update [Project].[dbo].[ HousingData]
   set ownersplitcity = PARSENAME(REPLACE( OwnerAddress, ',','.'),2) 

   ALTER TABLE [Project].[dbo].[ HousingData]
   Add ownersplitstate nvarchar (255);

   update [Project].[dbo].[ HousingData]
   set ownersplitstate = PARSENAME(REPLACE( OwnerAddress, ',','.'),1) 

   
   -- change Y and N to YES and NO in "sold as vacant" feild 

    select SoldAsVacant
	,CASE when SoldAsVacant = 'Y' then 'Yes', varchar
	     when SoldAsVacant = 'N' then 'No', varchar
         Else SoldAsVacant
		 END
  FROM [Project].[dbo].[ HousingData]
 
 update [Project].[dbo].[ HousingData]
 set SoldAsVacant = CASE when SoldAsVacant = 'Y' then 'Yes'
	     when SoldAsVacant = 'N' then 'No'
         Else SoldAsVacant
		 END

 -- Remove dupilcates 

 With RownumCTE as (
 select *, 
 ROW_NUMBER() OVER (
 PARTITION BY ParcelID, 
              Propertyaddress, 
              saleprice, 
			  saledate,
			  legalreference
              ORDER BY UniqueId 
			  ) row_num
  FROM [Project].[dbo].[ HousingData]
  --order by parceliD
  )
  DELETE --  To delete duplicates 
  FROM RownumCTE
  WHERE row_num > 1
  --order by PropertyAddress

  -- deleting unwanted columns 

  
 ALTER TABLE [Project].[dbo].[ HousingData]
  DROP column owneraddress, taxdistrict, propertyaddress, saledate