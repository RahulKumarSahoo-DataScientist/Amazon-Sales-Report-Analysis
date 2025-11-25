show databases;
use rahul;
CREATE TABLE Amazon_Sale_Report (
    `index` INT AUTO_INCREMENT PRIMARY KEY,
    `Order_ID` VARCHAR(30),
    `Date` DATE,
    `Status` VARCHAR(100),
    `Fulfilment` VARCHAR(50),
    `Sales_Channel` VARCHAR(50),
    `ship_service_level` VARCHAR(50),
    `Category` VARCHAR(50),
    `Size` VARCHAR(10),
    `Courier_Status` VARCHAR(50),
    `Qty` INT,
    `currency` VARCHAR(10),
    `Amount` DECIMAL(10,2),
    `ship_city` VARCHAR(100),
    `ship_state` VARCHAR(100),
    `ship_postal_code` VARCHAR(20),
    `ship_country` VARCHAR(10),
    `B2B`VARCHAR(10),
    `fulfilled_by` VARCHAR(50),
    `New` VARCHAR(20),
    `PendingS` VARCHAR(20)
);


show variables like 'secure_file_priv';
show variables like '%local%';

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Amazon Sale Report.csv'
INTO TABLE Amazon_Sale_Report
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@index, @Order_ID, @Date, @Status, @Fulfilment, @Sales_Channel, @ship_service_level, 
 @Category, @Size, @Courier_Status, @Qty, @currency, @Amount, 
 @ship_city, @ship_state, @ship_postal_code, @ship_country, 
 @B2B, @fulfilled_by, @New, @PendingS)
SET
`Order_ID` = @Order_ID,
`Date` = STR_TO_DATE(@Date, '%m-%d-%Y'),
`Status` = @Status,
`Fulfilment` = @Fulfilment,
`Sales_Channel` = @Sales_Channel,
`ship_service_level` = @ship_service_level,
`Category` = @Category,
`Size` = @Size,
`Courier_Status` = @Courier_Status,
`Qty` = NULLIF(@Qty, ''),
`currency` = @currency,
`Amount` = NULLIF(@Amount, ''),   -- ✅ Fix: converts empty string to NULL
`ship_city` = @ship_city,
`ship_state` = @ship_state,
`ship_postal_code` = @ship_postal_code,
`ship_country` = @ship_country,
`B2B` = @B2B,
`fulfilled_by` = @fulfilled_by,
`New` = @New,
`PendingS` = @PendingS;



-- 1️⃣ Turn off safe updates
SET SQL_SAFE_UPDATES = 0;

-- 2️⃣ Remove AUTO_INCREMENT restriction
ALTER TABLE Amazon_Sale_Report MODIFY `index` INT;

-- 3️⃣ Drop the primary key temporarily
ALTER TABLE Amazon_Sale_Report DROP PRIMARY KEY;

-- 4️⃣ Renumber rows preserving original insertion order
SET @row_num = -1;
UPDATE Amazon_Sale_Report
SET `index` = (@row_num := @row_num + 1);   -- ⚡ Keeps physical order, not sorted by any column

-- 5️⃣ Re-add the primary key
ALTER TABLE Amazon_Sale_Report ADD PRIMARY KEY (`index`);

-- 6️⃣ Turn safe updates back on
SET SQL_SAFE_UPDATES = 1;


select * from Amazon_Sale_Report;

SELECT * FROM Amazon_Sale_Report LIMIT 1000000;

desc Amazon_Sale_Report;

SELECT 
    (SELECT COUNT(*) FROM Amazon_Sale_Report) AS rowws,
    (SELECT COUNT(*) 
     FROM INFORMATION_SCHEMA.COLUMNS 
     WHERE TABLE_SCHEMA = DATABASE() 
       AND TABLE_NAME = 'Amazon_Sale_Report') AS columns;
       
       
drop table Amazon_Sale_Report;