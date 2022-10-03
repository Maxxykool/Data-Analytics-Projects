--To view the data 
SELECT * FROM Nashville_housing

--We would start by adjusting the date column to standard date format
SELECT saledate, CONVERT(date, saledate)
FROM Nashville_housing

Alter TABLE Nashville_housing
ADD saldateconverted date

UPDATE Nashville_housing
SET saldateconverted = CONVERT(date, saledate)

---Populate propertyaddress data
-- Looking at the null values on propertyaddress and uniqueid with the same address
SELECT *
FROM Nashville_housing
WHERE propertyaddress is null
ORDER BY parcelid 

SELECT a.parcelid, a.propertyaddress, b.parcelid, b.propertyaddress, ISNULL(a.propertyaddress, b.propertyaddress)
FROM Nashville_housing a
JOIN Nashville_housing b
on a.parcelid = b.parcelid
AND a.(uniqueid) <> b.(uniqueid)
WHERE a.parcelid is null

UPDATE a
SET propertyaddress = ISNULL(a.propertyaddress, b.propertyaddress)
FROM Nashville_housing a
JOIN Nashville_housing b
on a.parcelid = b.parcelid
AND a.(uniqueid) <> b.(uniqueid)
WHERE a.parcelid is null

-- Breaking out address into individual column (Address, city)

SELECT 
SUBSTRING(property, 1, CHARINDEX(',', propertyaddress) -1 as Address)
SUBSTRING(property, 1, CHARINDEX(',', propertyaddress) +1 LEN(propertyaddress)) as Address
FROM Nashville_housing 


Alter TABLE Nashville_housing
ADD propertyslitaddress Varchar(255)

UPDATE Nashville_housing
SET propertyslitaddress  = SUBSTRING(property, 1, CHARINDEX(',', propertyaddress) -1

Alter TABLE Nashville_housing
ADD propertysliptcity VArchar(255)

UPDATE Nashville_housing
SET propertysliptcity = SUBSTRING(property, 1, CHARINDEX(',', propertyaddress) +1 LEN(propertyaddress))
									 
--Looking at the owneraddress to split into diffrent column (address, city, state)
									 
SELECT 
PARSENAME(REPLACE(owneraddress, ',', '.', 3)
PARSENAME(REPLACE(owneraddress, ',', '.', 2)
PARSENAME(REPLACE(owneraddress, ',', '.', 1)
		  FROM Nashvillehousing
		  
Alter TABLE Nashville_housing
ADD ownersliptaddress VArchar(255)

UPDATE Nashville_housing
SET ownersliptaddress = PARSENAME(REPLACE(owneraddress, ',', '.', 3)
								  
Alter TABLE Nashville_housing
ADD owwnersliptcity VArchar(255)

UPDATE Nashville_housing
SET owwnersliptcity = PARSENAME(REPLACE(owneraddress, ',', '.', 2)
								
Alter TABLE Nashville_housing
ADD ownersliptstate VArchar(255)

UPDATE Nashville_housing
SET ownersliptstate = PARSENAME(REPLACE(owneraddress, ',', '.', 1)
								
--Changing Y to Yes and N to No in the "soldasvacant" column 
SELECT soldasvacant,
CASE WHEN soldasvacant = 'Y' THEN 'YES'
WHEN soldasvacant = 'N' THEN 'NO'
ELSE soldasvacant
END
	FROM Nashville_housing
							
UPDATE Nashville_housing
SET soldasvacant =CASE WHEN soldasvacant = 'Y' THEN 'YES'
WHEN soldasvacant = 'N' THEN 'NO'
ELSE soldasvacant
END
	
--Removing Duplicate 
WITH NashCTE AS (							
SELECT *,
 ROW_NUMBER () OVER(
PARTITION BY parcelid, propertyaddress, saleprice, saledate, legalreference
								ORDER BY uniqueid) row_num
								FROM Nashville_housing)
								--ORDER BY parcelid 
								
		DELETE FROM NashCTE WHERE row_num > '1'
								--ORDER BY propertyaddress
								
--DELETE Unused column 
--Since we have splited some columns we would go ahead to delete unused
								
ALTER TABLE Nashville_housing
DROP COLUMN owneraddress, taxdistrict, propertyaddress, saledate

SELECT * 
	FROM Nashville_housing
		  
		  
		  


