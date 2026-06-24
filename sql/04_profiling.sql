-- Total Funds
CREATE TABLE fund_totals AS SELECT fund_name, SUM(position_value) AS portfolio_value FROM
    infotable_clean
GROUP BY fund_name
HAVING SUM(position_value) >= 1000000000;

---------------------------------------------------------------------------------

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
-------------------------------------------------------------------------------------------------------------


