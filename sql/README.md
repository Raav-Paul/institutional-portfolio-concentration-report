# SQL

This folder contains the SQL pipeline used to clean, transform, and analyze the
[Q4 2025 SEC Form 13Ffilings](https://www.sec.gov/data-research/sec-markets-data/form-13f-data-sets).

*The scripts implement a structured workflow that moves from:*

**Raw Data Intake > Data Standardization > Analytical Views**

--------------------------------------

# Main Script
[01_data_load.sql](https://github.com/Raav-Paul/institutional-portfolio-concentration-report/blob/9cbc0bd57e5fbbbf422f642107bd960d2b03539f/sql/01_data_load.sql)
[02_analysis.sql](https://github.com/Raav-Paul/institutional-portfolio-concentration-report/blob/9cbc0bd57e5fbbbf422f642107bd960d2b03539f/sql/02_analysis.sql)
Workflow Overview
Data Preparation

----------------------------------------

# Workflow Overview

##  Data Preparation
Raw 13F filing data is loaded, staged, and then standardized for further analysis.

### Steps
* Import filing and holdings data
* Stage the data
* Create reporting-ready tables
* Standardize manager and fund information
* Aggregate holdings at the filing manager level

The resulting tables provide a consistent foundation for concentration analysis across institutional investors.


