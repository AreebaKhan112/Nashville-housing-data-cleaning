Select * 
from NashvilleHousing
-- ____________________________________________

-- standardize date format 
select SaleDate, date(SaleDate)
from NashvilleHousing

update NashvilleHousing
set SaleDate = date(SaleDate)

--_______________________________

-- populate property address data  
-- the problem is, property address is null.
-- solution is, find where parcel IDs are the same, and if one of the parcel ID has property address,
-- the other identical parcel ID should have the same property address, so if its null, populate it with same property address 

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, IFNULL(a.PropertyAddress, b.PropertyAddress)
from NashvilleHousing a
join NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.UniqueID != b.UniqueID
where a.PropertyAddress is null

		-- now update the a.PropertyAddress with the new column just created.
update NashvilleHousing
set PropertyAddress = (
		select b.PropertyAddress
		from NashvilleHousing b
		where b.ParcelID = NashvilleHousing.ParcelID
		and b.UniqueID != NashvilleHousing.UniqueID
		)
where PropertyAddress is null

--____________________________________________________
-- break the address into individual columns (address, city, sales)

select PropertyAddress
from NashvilleHousing

select 
substr(PropertyAddress, 1, instr( PropertyAddress, ',') -1 ) as Address, -- the -1 is to remove the comma
substr(PropertyAddress, instr(PropertyAddress, ',') + 2, length(PropertyAddress)) as City -- to get the city in another column
from NashvilleHousing
				--_________________________
				--# create new columns and update those values into our database
alter table NashvilleHousing
add propertysplitaddress text;

update NashvilleHousing
set propertysplitaddress = substr(PropertyAddress, 1, instr( PropertyAddress, ',') -1 )

alter table NashvilleHousing
add propertysplitcity text;

update NashvilleHousing
set propertysplitcity= substr(PropertyAddress, instr(PropertyAddress, ',') + 2, length(PropertyAddress))

				-- checking the updates made
select *
from NashvilleHousing

-- _________________________________________________________________-
-- fixing OwnerAddress COLUMN
		-- viewing owner address column
select OwnerAddress
from NashvilleHousing
		-- break it down into address, city and state
select 
substr(OwnerAddress, 1, instr( OwnerAddress, ',') -1 ) as Address, -- the -1 is to remove the comma
substr(
		OwnerAddress, 
		instr(OwnerAddress, ',') + 2, 
		instr(substr(OwnerAddress, instr(OwnerAddress, ',') + 2), ',') -1
		) as City,    -- city part
substr(
		OwnerAddress, 
		instr(OwnerAddress, ',') + 
		instr(substr(OwnerAddress, instr(OwnerAddress, ',') + 2), ',') +2, instr(substr(OwnerAddress, instr(OwnerAddress, ',') + 2), ',') +2
		) as State -- state part
from NashvilleHousing

	-- add these into our DATABASE
	
	-- add owner's address
alter table NashvilleHousing
add OwnerSplitAddress text;

update NashvilleHousing
set OwnerSplitAddress = substr(OwnerAddress, 1, instr( OwnerAddress, ',') -1 )
	
	-- add owner's city
alter table NashvilleHousing
add OwnerSplitCity text;

update NashvilleHousing
set OwnerSplitCity= substr(
		OwnerAddress, 
		instr(OwnerAddress, ',') + 2, 
		instr(substr(OwnerAddress, instr(OwnerAddress, ',') + 2), ',') -1
		)

		-- add owner's state
alter table NashvilleHousing
add OwnerSplitState text;

update NashvilleHousing
set OwnerSplitState = substr(
		OwnerAddress, 
		instr(OwnerAddress, ',') + 
		instr(substr(OwnerAddress, instr(OwnerAddress, ',') + 2), ',') +2, instr(substr(OwnerAddress, instr(OwnerAddress, ',') + 2), ',') +2
		)
--___________________________________________________________________________________________-

	-- analyzing the column SoldAsVacant
select distinct(SoldAsVacant), count(SoldAsVacant)
from NashvilleHousing
group by SoldAsVacant
order by 2;
	-- since "Yes" and "No" are most common, replace Y by Yes and N by No
	
select SoldAsVacant,
case when SoldAsVacant= "Y" then "Yes"
	when SoldAsVacant = "N" then "No"
	else SoldAsVacant
	END
from NashvilleHousing

		-- update this into our DATABASE
update NashvilleHousing
set SoldAsVacant = case when SoldAsVacant= "Y" then "Yes"
					when SoldAsVacant = "N" then "No"
					else SoldAsVacant
					END
					

--______________________________________________________________________________
-- removing duplicates


WITH RowNumCTE as (
select *,
	row_number() over (
	partition by ParcelID, 
				PropertyAddress,
				SalePrice, 
				SaleDate, 
				LegalReference
				order by UniqueID) row_num
from NashvilleHousing 
)
select *
from RowNumCTE
where row_num > 1

		-- now delete duplicates
delete from NashvilleHousing
where rowid in (
    select rowid
    from (
        select rowid,
               row_number() over (
                   partition by ParcelID,
                                PropertyAddress,
                                SalePrice,
                                SaleDate,
                                LegalReference
                   order by UniqueID
               ) as row_num
        from NashvilleHousing
    )
    where row_num > 1
);
--________________________________________________________________

-- now removing unused columns

alter table NashvilleHousing drop column OwnerAddress;
alter table NashvilleHousing drop column TaxDistrict;
alter table NashvilleHousing drop column PropertyAddress;
		-- check everything now
select * 
from NashvilleHousing




