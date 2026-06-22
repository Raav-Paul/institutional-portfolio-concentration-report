-- Total Funds
CREATE TABLE fund_totals AS SELECT fund_name, SUM(position_value) AS portfolio_value FROM
    infotable_clean
GROUP BY fund_name
HAVING SUM(position_value) >= 1000000000;

---------------------------------------------------------------------------------

-- Position weights
-- Creating Table 
CREATE TABLE position_weights (
    fund_name VARCHAR(500),
    company VARCHAR(500),
    position_value BIGINT,
    portfolio_value BIGINT,
    position_weight DECIMAL(30 , 10 )
);                                                                                                        -- This method is used to bypass data turnicate and preserve full integrity 
INSERT INTO position_weights
SELECT infotable_clean.fund_name, 
infotable_clean.company, 
infotable_clean.position_value, 
fund_totals.portfolio_value,
(infotable_clean.position_value * 1.0) / fund_totals.portfolio_value AS position_weight
FROM infotable_clean 
JOIN fund_totals  ON infotable_clean.fund_name = fund_totals.fund_name;                                      

-- Validation
SELECT 
    fund_name, SUM(position_weight) AS total_weight
FROM
    position_weights
GROUP BY fund_name
ORDER BY total_weight asc; 
-- Every fund is ~100%
-- Every fund is within the margin of error
-- Biggest deviation is 'Russell Investments Group, Ltd.', '0.9999968750'

---------------------------------------------------------------------------------

-- Ranked positions
CREATE TABLE ranked_positions AS
SELECT
fund_name, company, position_value, portfolio_value, position_weight,
ROW_NUMBER() OVER 
(PARTITION BY fund_name
ORDER BY position_weight DESC) AS position_rank
FROM position_weights;

-- Top 5 Weight
CREATE TABLE top5_concentration AS SELECT fund_name, SUM(position_weight) AS top5_weight FROM
    ranked_positions
WHERE
    position_rank <= 5
GROUP BY fund_name;

-- Top 10 weight
CREATE TABLE top10_concentration AS SELECT fund_name, SUM(position_weight) AS top10_weight FROM
    ranked_positions
WHERE
    position_rank <= 10
GROUP BY fund_name;


-- Validation
SELECT 
    *
FROM
    top5_concentration
ORDER BY top5_weight ASC;
-- Top 5 weights are under 100%
-- Only 7 funds are extremely diversified(under 5%)
-- Lowest being 3.22%

---------------------------------------------------------------------------------

-- Holdings Breakdown
CREATE TABLE bucketed_positions AS SELECT fund_name,
    company,
    position_weight,
    CASE
        WHEN position_weight > 0.10 THEN 'Core (>10%)'
        WHEN position_weight > 0.05 THEN 'High Conviction (5–10%)'
        WHEN position_weight > 0.01 THEN 'Medium Conviction (1–5%)'
        ELSE 'Tail(<1%)'
    END AS position_bucket FROM
    position_weights;

-- Validation
SELECT position_bucket, COUNT(*) 
FROM bucketed_positions
GROUP BY position_bucket;
-- Tail has the largest count
-- Core has the smallest count
-- Distribution looks reasonable


-- Portfolio Allocation(Bucket Summary)
CREATE TABLE bucket_summary AS
SELECT
fund_name,
position_bucket,
SUM(position_weight) AS capital_percentage,
COUNT(*) AS positions_count
FROM bucketed_positions
GROUP BY fund_name, position_bucket;
-- Position Counts are above 0
-- Capital Percentages are under 100%


-- Bucket Summary Clean
CREATE TABLE bucket_summary_clean AS
SELECT
fund_totals.fund_name,
buckets.position_bucket,
IFNULL(bucket_summary.capital_percentage, 0) AS capital_percentage,
IFNULL(bucket_summary.positions_count, 0) AS positions_count
FROM fund_totals
JOIN
(
SELECT 'Core (>10%)' AS position_bucket
UNION
SELECT 'High Conviction (5–10%)'
UNION
SELECT 'Medium Conviction (1–5%)'
UNION
SELECT 'Tail(<1%)'
) AS buckets
LEFT JOIN bucket_summary
ON fund_totals.fund_name = bucket_summary.fund_name
AND buckets.position_bucket = bucket_summary.position_bucket;
-- Some funds do not contain positions in every concentration bucket.
-- This table creates a complete bucket structure and fills missing values with zeros to support consistent portfolio allocation analysis.

-----------------------------------------------------------------------------------

-- Herfindahl-Hirschman Index 
CREATE TABLE herfindahl_hirschman_index AS
SELECT
    fund_name,
    CAST(SUM(POWER(position_weight, 2)) AS DECIMAL(30, 10)) AS 	hhi_ratio
FROM position_weights
GROUP BY fund_name;

-- Validation
SELECT *
FROM herfindahl_hirschman_index
ORDER BY hhi_ratio asc
LIMIT 10;                                                  
-- There are no values more than 1
-- There are no zeros

-- Effective Holdings
CREATE TABLE effective_holdings AS
SELECT 
    fund_name, ROUND(1 / Nullif(hhi_ratio,0), 2) as effective_holdings
FROM
    herfindahl_hirschman_index;
-- Matches public records for large firms

---------------------------------------------------------------------------------

-- Fund Summary    
-- Creating Table
CREATE TABLE fund_summary (
    fund_name VARCHAR(500),
    portfolio_value BIGINT,
    total_positions INT,
    avg_position_value DECIMAL(60, 20),  
    top5_concentration DECIMAL(30, 10),
    top10_concentration DECIMAL(30, 10),
    herfindahl_hirschman_index DECIMAL(30, 10),
    effective_holdings DECIMAL(30,10)
);                                                                               -- This method is used to bypass data turncate, and to preserve data integrity
 
-- Data Insert
INSERT INTO fund_summary
SELECT
    fund_totals.fund_name,
    fund_totals.portfolio_value,
    COUNT(position_weights.company) AS total_positions,
    CAST(fund_totals.portfolio_value AS DECIMAL(30, 10)) / COUNT(DISTINCT position_weights.company) AS avg_position_value,
    top5_concentration.top5_weight AS top5_concentration,
    top10_concentration.top10_weight AS top10_concentration,
    herfindahl_hirschman_index.hhi_ratio,
    effective_holdings.effective_holdings
FROM fund_totals
LEFT JOIN position_weights ON fund_totals.fund_name = position_weights.fund_name
LEFT JOIN top5_concentration ON fund_totals.fund_name = top5_concentration.fund_name
LEFT JOIN top10_concentration ON fund_totals.fund_name = top10_concentration.fund_name
LEFT JOIN herfindahl_hirschman_index ON fund_totals.fund_name = herfindahl_hirschman_index.fund_name
LEFT JOIN effective_holdings ON fund_totals.fund_name = effective_holdings.fund_name
GROUP BY 1, 2, 3, 4, 5, 6, 7, 8;

-- Validation
SELECT *
FROM fund_summary
ORDER BY portfolio_value desc
LIMIT 25;
-- Portfolio_value looks reasonable
-- Total Positions are not zero
-- Top 5 & 10 Concentrations are within 1 and 0
-- Effective Holdings match with the reported data online
