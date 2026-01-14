## Introduction

The purpose of this project is to document and present three Power BI dashboards, each built from different data sources and serving different analytical use cases.

This project consists of three Power BI dashboards:
1. A business sales performance dashboard
2. A survey-based analytics report
3. A financial stock analysis dashboard


## Beverages Dashboard

### Overview
The Beverages Dashboard provides stakeholders with a high-level and interactive view of Coca-Colas sales and financial performance across the United States. The dashboard allows users to quickly understand key business metrics, analyze operating profit, and explore sales trends geographically and over time.

### Use Case
This dashboard is intended for business managers and analysts who want to:
- View high-level sales and financial information
- Analyze operating profit across beverage brands
- Identify sales performance by U.S. state
- Interactively explore trends using filters and AI-driven questions

### Data
The dashboard uses the Coca-Cola Sales dataset provided in Excel format. The data includes:
- Retailer and region information
- Beverage brand details
- Sales metrics (total sales, units sold, price per unit)
- Financial metrics (operating profit and operating margin)
- Invoice dates for time-based filtering

All visuals are built from a single semantic model within Power BI.

### Key Features & Visuals
- AI Q&A visual for natural language exploration
- Key Influencers visual to identify drivers of operating profit
- Map visualization showing sales by U.S. state
- Matrix visual displaying financial metrics by beverage brand
- Date slicer to dynamically filter the dashboard

### Constraints & Limitations
- Analysis is limited to the provided dataset
- Data is static and does not refresh in real time
- Dashboard focuses on descriptive analytics only

### Future Improvements
- Add trend and growth analysis
- Improve layout and storytelling
- Introduce forecasting or predictive insights
- Integrate live or refreshed data sources


## Data Professionals Survey Report

### Overview
The Data Professionals Survey Report visualizes insights from a 2022 survey of data professionals. The report transforms raw survey responses into an interactive dashboard that highlights trends in careers, compensation, tools, and job satisfaction within the data industry.

### Use Case
This report is designed for:
- Aspiring and current data professionals
- Hiring managers and recruiters
- Analysts interested in workforce and survey-based insights

It helps answer questions related to salary trends, popular programming languages, job satisfaction, and difficulty breaking into the data field.

### Data
The dataset consists of over 600 survey responses and includes:
- Job titles and industries
- Salary ranges
- Favorite programming languages
- Job satisfaction metrics
- Demographic information such as age, gender, and country

Data was imported from Excel and cleaned and transformed using Power Query.

### Key Features & Visuals
- KPI cards showing total respondents and average age
- Salary analysis by job title
- Programming language popularity visualization
- Country distribution treemap
- Satisfaction gauges for salary and work-life balance
- Difficulty breaking into data visualization

### Constraints & Limitations
- Salary data is reported as ranges and estimated averages
- Limited sample size may not fully represent the industry
- Minimal standardization of free-text survey responses

### Future Improvements
- Further data cleaning and normalization
- Cost-of-living adjustments by country
- Drill-through analysis by role or region
- Additional DAX-driven metrics


## Stocks Dashboard

### Overview
The Stocks Dashboard provides a dynamic and interactive view of stock performance, combining historical price data, trading volume, company fundamentals, and analyst estimates. The dashboard is built in Power BI using data retrieved from the Alpha Vantage API.

### Use Case
This dashboard is intended for:
- Investors seeking a quick snapshot of stock performance
- Analysts comparing company metrics and estimates
- Users exploring historical price and volume trends

### Data
Data is sourced from Alpha Vantage API endpoints:
- Daily Time Series (open, high, low, close, volume)
- Company Overview (fundamental metrics and company description)
- Earnings Calendar (analyst earnings estimates)

Custom Power Query (M) scripts were written to retrieve and transform JSON responses, with parameters allowing dynamic ticker selection.

### Key Features & Visuals
- Stock name card and company description
- Combined line and column chart showing price and volume over time
- Dynamic time-period slicer (1 month to 5 years)
- Multi-row cards displaying key financial metrics such as:
  - Todays close
  - Analyst target price
  - 52-week high and low
  - Market capitalization
  - PE, forward PE, price-to-sales, and price-to-book ratios
- Earnings estimates comparison against major technology companies

### Constraints & Limitations
- API rate limits restrict refresh frequency
- Dependent on third-party data accuracy and availability
- No predictive analytics or trading signals included

### Future Improvements
- Add technical indicators such as moving averages or RSI
- Enable multi-stock comparison
- Improve handling of API errors and rate limits
- Add drill-through pages and bookmarks
