#Nashville-housing-data-cleaning
____________________________________________________________________________________
- Standardized date format in SaleDate column using **date()** function.
- Populated Null values in PropertyAddress data by analyzing rows where ParcelID was the same    but null PropertyAddress.
- Used **UPDATE** and **SET** to populate the values in PropertyAddress.
- Used **substr()** and **instr()** to divide PropertyAddress and OwnerAddress data into Address, City, and State and updated the database by creating new columns for this data.
- Standardized SoldAsVacant Column by changing "Y" and "N" values into "Yes" and "No" respectively.
- Removed duplicate rows using **delete from**.
- Deleted unused columns such as **OwnerAddress**, **TaxDistrict**, and **PropertyAddress** using **alter table**.
