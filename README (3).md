# 🧹 Sales Data Cleaning Project (MySQL)

## 📘 Project Overview
This project demonstrates a **data cleaning process** in **MySQL** for a sales dataset.  
The goal is to import, clean, and standardize raw sales data to ensure consistency, accuracy, and usability for reporting or analytics.

## 🗄️ Database Setup
```sql
CREATE DATABASE sales_db;
USE sales_db;
```

Import your dataset into the `sales` table using the **MySQL Import Wizard** or any preferred import method.

## 🧽 Data Cleaning Steps

### 1️⃣ Remove Duplicate Records
```sql
WITH sales_duplicates AS (
  SELECT *,
         ROW_NUMBER() OVER (PARTITION BY transaction_id ORDER BY transaction_id) AS rn
  FROM sales_db.sales
)
SELECT * FROM sales_duplicates WHERE rn > 1;

CREATE TABLE rm_dup_sales AS
SELECT DISTINCT * FROM sales_db.sales;

DROP TABLE sales_db.sales;
CREATE TABLE sales AS SELECT * FROM sales_db.rm_dup_sales;
DROP TABLE sales_db.rm_dup_sales;
```

### 2️⃣ Handle NULL and Missing Values

#### 🏷 Category
```sql
UPDATE sales_db.sales
SET category = 'Unknown'
WHERE category = '';
```

#### 🏠 Customer Address
```sql
UPDATE sales_db.sales
SET customer_address = 'Not Available'
WHERE customer_address IS NULL OR customer_address = '';
```

#### 💳 Payment Method
```sql
UPDATE sales_db.sales
SET payment_method = 'Cash'
WHERE payment_method = '';

UPDATE sales_db.sales
SET payment_method = 'Credit Card'
WHERE payment_method IN ('CC', 'credit', 'creditcard');
```

#### 🚚 Delivery Status
```sql
UPDATE sales_db.sales
SET delivery_status = 'Not Delivered'
WHERE delivery_status = '';
```

### 3️⃣ Fix Invalid Price Values by Category Average
```sql
SELECT category, ROUND(AVG(price), 2) FROM sales_db.sales GROUP BY category;
UPDATE sales_db.sales
SET price = 2591.65
WHERE price = '' AND category = 'Books';
```

### 4️⃣ Handle Negative Quantities
```sql
UPDATE sales_db.sales
SET quantity = ABS(quantity)
WHERE quantity < 0;
```

### 5️⃣ Fix Total Amount Calculation
```sql
UPDATE sales_db.sales
SET total_amount = ROUND((price * quantity), 2)
WHERE total_amount = '' OR total_amount <> price * quantity;
```

### 6️⃣ Handle Missing Customer Names
```sql
UPDATE sales_db.sales
SET customer_name = 'User'
WHERE customer_name = '';
```

### 7️⃣ Clean and Convert Purchase Dates
```sql
UPDATE sales_db.sales
SET purchase_date = CASE
    WHEN purchase_date = '2024-02-30' THEN DATE('2024-02-29')
    ELSE STR_TO_DATE(purchase_date, '%d/%m/%Y')
END;

ALTER TABLE sales_db.sales
MODIFY COLUMN purchase_date DATE;
```

### 8️⃣ Validate and Clean Email Addresses
```sql
UPDATE sales_db.sales
SET email = NULL
WHERE email NOT LIKE '%@%';
```

## ✅ Final Checks
```sql
SELECT * FROM sales_db.sales WHERE purchase_date IS NULL;
SELECT * FROM sales_db.sales WHERE email IS NULL;
SELECT COUNT(*) FROM sales_db.sales;
```

## 🧾 Summary of Cleaning Actions
| Step | Action | Description |
|------|---------|-------------|
| 1 | Remove Duplicates | Eliminated 3 duplicate records |
| 2 | Handle Nulls | Replaced blanks with meaningful defaults |
| 3 | Fix Prices | Used category averages to fill missing prices |
| 4 | Fix Quantities | Converted negative values to absolute |
| 5 | Update Totals | Recalculated total amounts |
| 6 | Fix Names | Added placeholder for missing names |
| 7 | Convert Dates | Unified formats and corrected invalid dates |
| 8 | Validate Emails | Nullified invalid email formats |

## 🧠 Key SQL Concepts Used
- `CTE (Common Table Expression)`
- `ROW_NUMBER()` for duplicate detection
- `CASE` and `STR_TO_DATE()` for conditional logic
- `ALTER TABLE` for datatype modification
- String and null handling with `UPDATE`

## 🧰 Tools
- **MySQL 8.0+**
- **MySQL Workbench / Command Line**
- **Import Wizard** for data loading

## 📊 Result
A clean and standardized sales dataset, ready for:
- Reporting and dashboards  
- Data analysis and business insights  
- Integration with BI tools (Power BI, Tableau, etc.)

**Author:** Your Name  
**Database:** `sales_db`  
**Language:** SQL (MySQL)  
**Purpose:** Data Cleaning and Preparation
