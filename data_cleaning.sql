USE Nashville_housing;
SELECT * FROM nashvillehousingdata 

----------------------------------------------------
--- Gérer les valeurs nulles des adresses

update nashvillehousingdata set PropertyAddress=NULL where PropertyAddress='';

Select a.ParcelID, b.ParcelID, a.PropertyAddress, b.PropertyAddress, ifnull(a.PropertyAddress, b.PropertyAddress)
from nashvillehousingdata as a
join nashvillehousingdata as b
	on a.ParcelID = b.parcelID
    And a.UniqueID != b.UniqueID
where a.PropertyAddress is null; 

Update nashvillehousingdata as a
join nashvillehousingdata as b 
	on a.ParcelID = b.parcelID
    And a.UniqueID != b.UniqueID
Set a.PropertyAddress = ifnull(a.PropertyAddress, b.PropertyAddress)
where a.PropertyAddress is null 

----------------------------------------------------
--- Séparer les adresses en trois colonnes (adresse, ville, état)

--- Adresses des propriétés

select 
substring(PropertyAddress, 1, locate(',', PropertyAddress)-1) as Adresse,
substring(PropertyAddress, locate(',', PropertyAddress)+1, LENGTH(PropertyAddress)) as Ville
from nashvillehousingdata;

ALTER TABLE nashvillehousingdata
ADD Adresse VARCHAR(255);

ALTER TABLE nashvillehousingdata
ADD Ville VARCHAR(255);

UPDATE nashvillehousingdata
SET Adresse = substring(PropertyAddress, 1, locate(',', PropertyAddress)-1);


UPDATE nashvillehousingdata
SET Ville = substring(PropertyAddress, locate(',', PropertyAddress)+1, LENGTH(PropertyAddress));

--- Adresses des propriétaires 

SELECT 
SUBSTRING_INDEX(OwnerAddress,',',1),
SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress,',',-2),',',1),
SUBSTRING_INDEX(OwnerAddress,',',-1)
from nashvillehousingdata;

ALTER TABLE nashvillehousingdata
ADD Adresse_propriétaire VARCHAR(255);

ALTER TABLE nashvillehousingdata
ADD Ville_propriétaire VARCHAR(255);

ALTER TABLE nashvillehousingdata
ADD Etat_propriétaire VARCHAR(255);

UPDATE nashvillehousingdata
SET Adresse_propriétaire = SUBSTRING_INDEX(OwnerAddress,',',1);

UPDATE nashvillehousingdata
SET Ville_propriétaire = SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress,',',-2),',',1);

UPDATE nashvillehousingdata
SET Etat_propriétaire = SUBSTRING_INDEX(OwnerAddress,',',-1);


--------------------------------------------------------------------
--- Uniformiser les reponses à 'SoldAsVacant' en remplacant les reponses Y et N en Yes et No 

Select Distinct(SoldAsVacant),count(SoldAsVacant)
from nashvillehousingdata
group by SoldAsVacant
order by 2;

UPDATE nashvillehousingdata SET SoldAsVacant ='Yes' where SoldAsVacant = 'Y';
UPDATE nashvillehousingdata SET SoldAsVacant ='No' where SoldAsVacant = 'N';

-----------------------------------------------------------------------------
--- Verification de lignes dupliquées 

SELECT 
    ParcelID, COUNT(ParcelID),
    SaleDate,  COUNT(SaleDate),
    SalePrice,  COUNT(SalePrice),
    LegalReference, COUNT(LegalReference)
FROM
    nashvillehousingdata
GROUP BY 
    ParcelID , 
    SaleDate ,
    SalePrice,
    LegalReference
HAVING  COUNT(ParcelID) > 1
    AND COUNT(SaleDate) > 1
    AND COUNT(SalePrice) > 1
    AND COUNT(LegalReference) > 1;

-----------------------------------------------------------------------------
--- Suppression des colonnes inutiles

Alter Table nashvillehousingdata
drop PropertyAddress;

Alter Table nashvillehousingdata
drop OwnerAddress;

Select * from  nashvillehousingdata








