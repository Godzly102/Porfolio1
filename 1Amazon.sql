--Clean the Data:



-- Step 1: BREAK DOWN PRODUCT NAME
-- Add computed columns to your table
ALTER TABLE amazon$
ADD CompanyName AS LEFT(product_name, CHARINDEX(' ', product_name + ' ') - 1),
    Description AS SUBSTRING(product_name, CHARINDEX(' ', product_name + ' ') + 1, LEN(product_name));


-- Update existing rows with computed values
UPDATE amazon$
SET CompanyName = LEFT(product_name, CHARINDEX(' ', product_name + ' ') - 1),
    Description = SUBSTRING(product_name, CHARINDEX(' ', product_name + ' ') + 1, LEN(product_name));

-- Assuming your existing table structure and using a variable for the category string

ALTER TABLE amazon$
ADD NewCategory VARCHAR(100),
    type_tech VARCHAR(100),
    prod_in VARCHAR(100);

ALTER TABLE amazon$
DROP COLUMN NewCategory,
            type_tech,
            prod_in;

UPDATE amazon$
SET 
    NewCategory = PARSENAME(REPLACE(category, '|', '.'), 4),
    type_tech = PARSENAME(REPLACE(category, '|', '.'), 3),
    prod_in = PARSENAME(REPLACE(category, '|', '.'), 2);

-- Step 2: INT,FLOATS AND NUMS SET
-- Update actual_price column
UPDATE amazon$
SET actual_price = REPLACE(REPLACE(actual_price, '₹', ''), ',', '');

-- Update discounted_price column
UPDATE amazon$
SET discounted_price = REPLACE(REPLACE(discounted_price, '₹', ''), ',', '');




--Analytics of Data 

--Top companie by number of products sold

SELECT TOP 50 CompanyName, COUNT(CompanyName) AS TopCompanySales 
FROM amazon$
GROUP BY CompanyName
ORDER BY TopCompanySales DESC;

SELECT *  FROM amazon$

-- TOP selling products from a catagorical perspective 
SELECT NewCategory, COUNT(*) AS CategoryCount
FROM amazon$
WHERE NewCategory IS NOT NULL
GROUP BY NewCategory
ORDER BY CategoryCount DESC

-- Most discounted Product and Catagory

SELECT TOP 50 discount_percentage, COUNT(NewCategory) AS counting, NewCategory
FROM amazon$
GROUP BY discount_percentage,NewCategory
ORDER BY counting DESC;

-- Top selling product 

SELECT TOP 50 COUNT(prod_in) AS Top_seller, prod_in
FROM amazon$
GROUP BY prod_in
ORDER BY Top_seller DESC;

--Relationship between ratings and prices
SELECT * FROM amazon$
SELECT TOP 50
    CompanyName,
	rating,
    AVG(CAST(discounted_price AS FLOAT)) AS average_discounted_price,
    MIN(CAST(discounted_price AS FLOAT)) AS minimum_discounted_price,
    MAX(CAST(discounted_price AS FLOAT)) AS maximum_discounted_price,
    AVG(CAST(actual_price AS FLOAT)) AS average_actual_price,
    MIN(CAST(actual_price AS FLOAT)) AS minimum_actual_price,
    MAX(CAST(actual_price AS FLOAT)) AS maximum_actual_price
FROM
    amazon$
GROUP BY
    rating, CompanyName
ORDER BY
    rating DESC;

--Discount Metrics 

SELECT
    rating,
    AVG(CAST(actual_price AS FLOAT) - CAST(discounted_price AS FLOAT)) AS average_discount,
    MIN(CAST(actual_price AS FLOAT) - CAST(discounted_price AS FLOAT)) AS minimum_discount,
    MAX(CAST(actual_price AS FLOAT) - CAST(discounted_price AS FLOAT)) AS maximum_discount
FROM
    amazon$
GROUP BY
    rating
ORDER BY
    rating DESC;



