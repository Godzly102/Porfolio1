-- Data Cleaning 

--Rid of Outliers and Useless data
DELETE FROM austin
WHERE latestPrice > (SELECT AVG(latestPrice) + 3 * STDEV(latestPrice) FROM austin)
   OR latestPrice < (SELECT AVG(latestPrice) - 3 * STDEV(latestPrice) FROM austin);

SELECT * FROM austin

-- Normalize Numerical Features:
SELECT 
    zpid,
    city,
    streetAddress,
    zipcode,
    description,
    latitude,
    longitude,
    (livingAreaSqFt - (SELECT AVG(livingAreaSqFt) FROM austin)) / (SELECT STDEV(livingAreaSqFt) FROM austin) AS norm_livingAreaSqFt,
    (latestPrice - (SELECT AVG(latestPrice) FROM austin)) / (SELECT STDEV(latestPrice) FROM austin) AS norm_latestPrice
FROM austin
ORDER BY norm_latestPrice DESC

--Duplicated 
SELECT 
    SUM(CASE WHEN city IS NULL THEN 1 ELSE 0 END) AS city_missing,
    SUM(CASE WHEN latestPrice IS NULL THEN 1 ELSE 0 END) AS price_missing,
    SUM(CASE WHEN numOfBedrooms IS NULL THEN 1 ELSE 0 END) AS bedrooms_missing,
    SUM(CASE WHEN numOfBathrooms IS NULL THEN 1 ELSE 0 END) AS bathrooms_missing
FROM austin;

--Standard data 
UPDATE austin
SET city = UPPER(LEFT(city, 1)) + LOWER(SUBSTRING(city, 2, LEN(city) - 1)),
    streetAddress = UPPER(LEFT(streetAddress, 1)) + LOWER(SUBSTRING(streetAddress, 2, LEN(streetAddress) - 1));

--Norms
ALTER TABLE austin
ADD norm_livingAreaSqFt FLOAT, norm_latestPrice FLOAT, norm_numOfBedrooms FLOAT, norm_numOfBathrooms FLOAT;

WITH normalized_data AS (
    SELECT 
        zpid,
        (livingAreaSqFt - (SELECT AVG(livingAreaSqFt) FROM austin)) / (SELECT STDEV(livingAreaSqFt) FROM austin) AS norm_livingAreaSqFt,
        (latestPrice - (SELECT AVG(latestPrice) FROM austin)) / (SELECT STDEV(latestPrice) FROM austin) AS norm_latestPrice,
        (numOfBedrooms - (SELECT AVG(numOfBedrooms) FROM austin)) / (SELECT STDEV(numOfBedrooms) FROM austin) AS norm_numOfBedrooms,
        (numOfBathrooms - (SELECT AVG(numOfBathrooms) FROM austin)) / (SELECT STDEV(numOfBathrooms) FROM austin) AS norm_numOfBathrooms
    FROM austin
)
UPDATE austin
SET 
    norm_livingAreaSqFt = normalized_data.norm_livingAreaSqFt,
    norm_latestPrice = normalized_data.norm_latestPrice,
    norm_numOfBedrooms = normalized_data.norm_numOfBedrooms,
    norm_numOfBathrooms = normalized_data.norm_numOfBathrooms
FROM normalized_data
WHERE austin.zpid = normalized_data.zpid;


SELECT * FROM austin
-- Price per square feet

ALTER TABLE austin
ADD pricePerSqFt FLOAT;

UPDATE austin
SET pricePerSqFt = latestPrice / livingAreaSqFt;

--Age of Property
ALTER TABLE austin
ADD propertyAge INT;

UPDATE austin
SET propertyAge = YEAR(GETDATE()) - yearBuilt;

SELECT * FROM austin