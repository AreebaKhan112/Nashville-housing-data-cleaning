# Nashville Housing Data Cleaning (SQL)

A foundational data analytics project focused on the essential phase of data preprocessing: **Data Cleaning**. Using a raw dataset of property sales in Nashville, Tennessee, this project demonstrates how to use SQL Server queries to transform unstructured, messy raw data into a clean, normalized format optimized for downstream analysis.

### 🛠️ Tech Stack & Database Environment
* **Language:** SQL (T-SQL)
* **Dataset:** Nashville Housing Dataset (~56,000 rows)

---

### 🗂️ Clean-Up Objectives & Operations Implemented

The raw dataset contained multiple structural and formatting issues (missing records, packed string addresses, inconsistent terminology, and redundant entries). The following data cleaning techniques were applied:

1. **Standardizing Date Formats:** Converted the datetime format into a clean, standardized date format (`YYYY-MM-DD`) using `CONVERT` and `ALTER TABLE` modifications.
2. **Populating Missing Property Addresses:** Utilized a **Self-Join** on matching `ParcelID` rows to logically populate missing `PropertyAddress` null values.
3. **Breaking Out Monolithic Addresses (Parsing):** Used `SUBSTRING`, `CHARINDEX`, and `PARSENAME` functions to separate long string addresses into distinct, query-friendly columns (`Address`, `City`, and `State`).
4. **Unifying Inconsistent Fields:** Handled data disparity in boolean/categorical fields (standardizing mismatched values like `Y` and `N` into clean, explicit text strings `Yes` and `No` using a `CASE` statement).
5. **Removing Duplicate Records:** Flagged and eliminated redundant duplicate entries using a Common Table Expression (CTE) combined with the `ROW_NUMBER()` window function partitioned across key unique attributes.
6. **Dropping Unused/Redundant Columns:** Altered the final table schema to remove old, unparsed monolithic columns to optimize database storage and visual clarity.
