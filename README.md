# Institutional Portfolio Concentration Report

## Overview

This project reports portfolio concentration across U.S. institutional investors using [Q4 2025 SEC Form 13F investment holdings data](https://www.sec.gov/data-research/sec-markets-data/form-13f-data-sets).

The objective is to build a portfolio construction benchmarking framework that evaluates how institutional managers allocate capital and compares individual funds against the broader report.

The workflow follows a structured pipeline that moves from:
**Raw SEC Data > Data Staging > Position Weighting > Portfolio Analytics**

## Project Context:

Form 13F requires institutional investment managers with more than $100 million in qualifying assets to disclose their U.S. equity holdings to the SEC every quarter.

This project focuses on managers with more than **$1 billion in reported 13F holdings value** and uses concentration metrics such as **Effective Holdings, Top Concentration Ratios, Conviction Buckets, and HHI** to evaluate portfolio construction patterns across the institutional landscape.

Rather than evaluating performance or generating investment recommendations, the report focuses on how institutional fund managers structure portfolios, distribute capital, and compare against their peers.


---------------------------------------------------------------------------------

## Tools Used

- MySQL:

     [01_load.sql](https://github.com/Raav-Paul/institutional-portfolio-concentration-report/blob/18d3507c5be398fcc6151b784a0ee3b7d25c8330/sql/01_load.sql)
  
     [02_staging.sql](https://github.com/Raav-Paul/institutional-portfolio-concentration-/blob/18d3507c5be398fcc6151b784a0ee3b7d25c8330/sql/02_staging.sql)

     [03_position_weighting.sql](https://github.com/Raav-Paul/institutional-portfolio-concentration-/blob/18d3507c5be398fcc6151b784a0ee3b7d25c8330/sql/03_position_weighting.sql)

     [04_profiling.sql](https://github.com/Raav-Paul/institutional-portfolio-concentration-/blob/18d3507c5be398fcc6151b784a0ee3b7d25c8330/sql/04_profiling.sql)

  
- Tableau:

     [Institutional Portfolio Concentration.twb](https://github.com/Raav-Paul/institutional-portfolio-concentration-/blob/58d2141edd0c7de532a713cce69047a23b62ea87/dashboard/Institutional%20Portfolio%20Concentration.twb)
- GitHub
---------------------------------------------------------------------------------

## Dataset

- Source: [SEC Form 13F investment holdings data](https://www.sec.gov/data-research/sec-markets-data/form-13f-data-sets).
  
**Coverage:** Institutional managers with more than $1 billion in reported 13F holdings value
- ****Records:****
- INFOTABLE: 3,473,209 holdings records
- COVERPAGE: 11,372 filing manager records
- Coverage: U.S. institutional equity holdings
- Time period covered: Oct-Dec 2025

**Data Sources Include:**

* Manager information
* Security holdings
* Position values
* Reported share counts

---------------------------------------------------------------------------------

**Key Metrics Generated:**

* Position Weights
* Top 5 & Top 10 Concentration
* Herfindahl-Hirschman Index (HHI)
* Effective Holdings
* Conviction Bucket Allocation

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
* INFOTABLE - Security details and position values
* COVERPAGE - Fund name and manager information

---------------------------------------------------------------------------------

### Position Weighting (Script 03)

Holdings are weighted as a percentage of total portfolio value and classified by concentration level.

**Transformations:**
* Calculate position weight = (position value / total portfolio value)
* Rank positions from largest to smallest within each fund
* Classify positions into concentration buckets

**Position Buckets:**
* **Core (>10%)** - Largest positions, highest conviction
* **High Conviction (5–10%)** - Significant holdings
* **Medium Conviction (1–5%)** - Moderate exposure
* **Tail (<1%)** - Small/speculative positions


---------------------------------------------------------------------------------

### Portfolio Profiling (Script 04)

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

# Tableau Dashboard

## Dashboard Overview

The dashboard evaluates portfolio concentration across institutional investors with more than $1 billion in reported Q4 2025 13F holdings.

It combines market-level benchmarking with manager-level reporting using a Selected Fund vs Institutional Universe framework.

Key metrics include:

- Reported holdings value
- Effective holdings
- Top 5 concentration
- Conviction bucket allocation
- Portfolio concentration rankings

-----------------------------------------------------------------------------------------------------------------------------

## Dashboard Preview

### Market Overview

![Market Overview](https://github.com/Raav-Paul/institutional-portfolio-concentration-report/blob/acdd6cd9429b736957e236609c4ee0b44fedeb2b/dashboard/institutional%20portfolio%20concentration.png)

## Key Insights

- The report covers **2,280 institutional managers** with more than **$1 billion in reported 13F holdings value**.
- The average portfolio contains approximately **36 effective holdings**, indicating moderate diversification.
- The average Top 5 concentration is approximately **42%**, suggesting a meaningful portion of capital is concentrated within a fund's largest positions.
- Reported capital is concentrated among the largest institutions, with the Top 10 managers controlling a substantial **39.5%** share of disclosed 13F equity exposure for Q4 2025.
- Most reported capital is allocated to the **MEDIUM-CONVICTION(1%-5%)** & **TAIL(<1%)** buckets at 33% and 29% respectively.
- Compartively a smaller share of capital is committed to **HIGH(5%-10%)** & **CORE(>10%)** positions at 14% & 23% respectively.

-----------------------------------------------------------------------------------------------------------------------------

### Vanguard Group Inc.

![Vanguard](https://github.com/Raav-Paul/institutional-portfolio-concentration-report/blob/7d2e620b748d0efe0be60a33ea228f9e6049b875/dashboard/Vanguard.png)

## Key Insights

- Vanguard reports approximately **$6.9 trillion** in disclosed 13F holdings.
- Vanguard represents approximately **9.97%** of the total reported holdings value within the report.
- The portfolio exhibits a high level of diversification with approximately **66 effective holdings**.
- Top 5 concentration remains lower than the institutional average, indicating a relatively diversified portfolio structure.
- The majority of holdings fall within smaller position-size buckets, reflecting Vanguard's strategy of broad market exposure.
- Vanguard has **0%** allocated to **CORE (>10%)** positions compared to the market average of **23%**.
- Approximately **66%** of reported capital is allocated to **TAIL (<1%)** positions, reflecting diversification across a large number of smaller holdings.
- Their largest position is **Nvidia** valued at approximately **$422.74 Billion**.

-----------------------------------------------------------------------------------------------------------------------------

### Jane Street Group, LLC

![Jane Street](https://github.com/Raav-Paul/institutional-portfolio-concentration-report/blob/7d2e620b748d0efe0be60a33ea228f9e6049b875/dashboard/Jane%20Street.png)

## Key Insights

- Jane Street reports approximately **$662 billion** in disclosed 13F holdings.
- Jane Street represents approximately **0.96%** of the total reported holdings value within the report.
- The portfolio exhibits a low level of diversification with approximately **25 effective holdings**.
- Top 5 concentration remains relatively balanced compared to many active managers.
- The majority of reported capital is allocated across **TAIL (<1%)**, **MEDIUM-CONVICTION (1%-5%)**, and **HIGH-CONVICTION (5%-10%)** positions.
- Jane Street has **14%** in **CORE(>10%)** positions compared to the market average of **23%**
- Approximately **39%** of Jane Street's positions are in **TAIL(<1%)** positions, indicating a diversified tail.
- Their largest position is SPDR S&P 500 ETF TR at roughly **$95.86 Billion**

-----------------------------------------------------------------------------------------------------------------------------

### Top 10 Funds

![Top 10 Funds](https://github.com/Raav-Paul/institutional-portfolio-concentration-report/blob/b4370e1cc187a22a5f05154431141e99b8567ba9/dashboard/Top%2010%20Funds.png)

## Key Insights

- The Top 10 institutional managers collectively report approximately **$27.3 trillion** in disclosed 13F holdings.
- Together, these managers account for approximately **39.5%** of all reported holdings value within the report.
- The average portfolio contains approximately **58 effective holdings**, indicating a relatively diversified portfolio structure despite their size.
- Average **Top 5 Concentration** is approximately **24.93%**, suggesting that capital is generally distributed across a broad set of holdings rather than concentrated within a small number of dominant positions.
- Approximately **62%** of reported capital is allocated to **TAIL (<1%)** positions, highlighting the importance of smaller holdings in large institutional portfolios.
- Only **2%** of reported capital is allocated to **CORE (>10%)** positions, indicating that the largest managers rarely rely on oversized individual positions.
- Their combined largest position is **Nvidia** at roughly **$1.48 Trillion**

-----------------------------------------------------------------------------------------------------------------------------


## Overall Insights

- The report suggests that portfolio size alone does not explain concentration differences across institutional investors. While the largest managers control a substantial share of reported capital, they are often more diversified than the broader institutional universe.

- Several of the largest managers, including BlackRock, Vanguard, State Street, and Morgan Stanley, exhibit remarkably similar portfolio construction characteristics despite differences in reported holdings value. These managers maintain nearly identical effective holdings, concentration levels, and HHI values, suggesting convergence toward a common diversification profile.

This similarity extends beyond concentration metrics. BlackRock, Vanguard, and State Street also share many of the same top holdings in similar ranking order, indicating that comparable portfolio structures are often accompanied by comparable exposure to the largest U.S. equities.

The analysis also shows that diversification among the largest managers is primarily achieved through extensive allocation to smaller positions rather than oversized investments in a limited number of securities. Across the Top 10 managers, approximately 62% of reported capital is allocated to Tail (<1%) positions, while only 2% is allocated to Core (>10%) positions.

At the same time, alternative portfolio construction approaches remain visible within the institutional universe. Managers such as JPMorgan and Bank of America occupy significantly different positions on the concentration spectrum, demonstrating that large-scale portfolios can be constructed through materially different allocation strategies.

Together, these findings suggest that concentration metrics can be used to identify common portfolio construction patterns, distinguish outliers, and place individual managers within the broader institutional landscape.


-----------------------------------------------------------------------------------------------------------------------------

## Business Implications

Reviewing individual holdings across thousands of institutional portfolios is impractical and time-consuming. By reducing portfolio construction into a set of comparable concentration and diversification metrics, managers can be evaluated quickly and consistently.

This report enables analysts to identify whether a manager follows a broadly diversified approach, exhibits unusually concentrated positioning, or shares characteristics with other institutional investors. It also provides context for understanding how capital is distributed across conviction levels and where a portfolio sits relative to its peers.

The purpose of this report is not to evaluate performance, generate investment recommendations, predict the winners, or determine whether concentration is inherently good or bad. Instead, it provides a structured framework for comparing portfolio construction across institutional investors and rapidly assessing where a selected manager sits within the wider market.





