-- BigQuery Standard SQL
CREATE OR REPLACE TABLE `portfolio_healthcare.core.dim_date` AS
SELECT
  CAST(FORMAT_DATE('%Y%m%d', d) AS INT64) AS date_key,
  d AS full_date,
  EXTRACT(DAY FROM d) AS day_of_month,
  FORMAT_DATE('%A', d) AS day_name,
  EXTRACT(MONTH FROM d) AS month_number,
  FORMAT_DATE('%B', d) AS month_name,
  EXTRACT(QUARTER FROM d) AS quarter_number,
  EXTRACT(YEAR FROM d) AS year_number
FROM UNNEST(GENERATE_DATE_ARRAY('2021-01-01', '2030-12-31')) AS d;
