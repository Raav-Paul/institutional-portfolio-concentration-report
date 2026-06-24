# 13F Portfolio Analysis

This folder contains the SQL pipeline used to process, standardize, and analyze
[SEC Form 13F investment holdings data](https://www.sec.gov/data-research/sec-markets-data/form-13f-data-sets).

The scripts implement a structured workflow that moves from:

**Raw SEC Data > Data Staging > Position Weighting > Portfolio Analytics**

---------------------------------------------------------------------------------

## Scripts
[01_load.sql](https://github.com/Raav-Paul/institutional-portfolio-concentration-report/blob/18d3507c5be398fcc6151b784a0ee3b7d25c8330/sql/01_load.sql)
[02_staging.sql](https://github.com/Raav-Paul/institutional-portfolio-concentration-report/blob/18d3507c5be398fcc6151b784a0ee3b7d25c8330/sql/02_staging.sql)
[03_position_weighting.sql](https://github.com/Raav-Paul/institutional-portfolio-concentration-report/blob/18d3507c5be398fcc6151b784a0ee3b7d25c8330/sql/03_position_weighting.sql)
[04_profiling.sql](https://github.com/Raav-Paul/institutional-portfolio-concentration-report/blob/18d3507c5be398fcc6151b784a0ee3b7d25c8330/sql/04_profiling.sql)

---------------------------------------------------------------------------------

## Workflow Overview

### Data Intake & Staging (Scripts 01–02)

Raw SEC 13F data is loaded from TSV files and joined.

**Steps:**
* Load INFOTABLE (investment portfolio) and COVERPAGE (fund data)
* Joined tables on ACCESSION_NUMBER
* Extracted fund name and position details into the staging layer
* Filter managers with >= $1 billion in reported 13F holdings value

**Data Sources:**
* INFOTABLE — Security details and position values
* COVERPAGE — Fund name and manager information

---------------------------------------------------------------------------------

### Position Weighting & Bucketing (Script 03)

Holdings are weighted as a percentage of total portfolio value and classified by concentration level.

**Transformations:**
* Calculate position weight = (position value / total portfolio value)
* Rank positions from largest to smallest within each fund
* Classify positions into concentration buckets

**Position Buckets:**
* **Core (>10%)** — Largest positions, highest conviction
* **High Conviction (5–10%)** — Significant holdings
* **Medium Conviction (1–5%)** — Moderate exposure
* **Tail (<1%)** — Small/speculative positions


**Portfolio Allocation Summary:**

For each fund, capital allocation and position count are summarized by bucket, with missing buckets filled with zero values to enable consistent analysis while visualizing the data.

---------------------------------------------------------------------------------

### Portfolio Profiling & Metrics (Script 04)

Portfolio-level concentration and diversification metrics are calculated.

**Herfindahl-Hirschman Index (HHI):**
* Calculated as the summation of squared position weights
* Ranges from 0 (perfectly diversified) to 1 (single position)
** Lower = more diversified

**Effective Holdings:**
* Calculated as 1 / HHI
* Represents the equivalent number of equally-weighted positions

**Fund Summary Table:**

Combines all derived metrics:
* Total portfolio value
* Number of positions
* Average position value
* Top concentration percentages
* HHI and effective holdings

---------------------------------------------------------------------------------
