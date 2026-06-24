-- Extracting Required Columns
CREATE TABLE coverpage_staging AS SELECT ACCESSION_NUMBER, FILINGMANAGER_NAME FROM
    coverpage;

-- Creating Staging Table
CREATE TABLE infotable_staging AS SELECT infotable.*, coverpage_staging.FILINGMANAGER_NAME FROM
    infotable
        LEFT JOIN
    coverpage_staging ON infotable.ACCESSION_NUMBER = coverpage_staging.ACCESSION_NUMBER;
    
-- Infotable_clean 
CREATE TABLE infotable_clean AS SELECT FILINGMANAGER_NAME AS fund_name,
    NAMEOFISSUER AS company,
    SUM(VALUE) AS position_value FROM
    infotable_staging
WHERE
    VALUE IS NOT NULL AND VALUE > 0
GROUP BY FILINGMANAGER_NAME , NAMEOFISSUER;

---------------------------------------------------------------------------------

-- Total Funds
CREATE TABLE fund_totals AS SELECT fund_name, SUM(position_value) AS portfolio_value FROM
    infotable_clean
GROUP BY fund_name
HAVING SUM(position_value) >= 1000000000;

