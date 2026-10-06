CREATE OR REPLACE TABLE `portfolio_healthcare.marts.mart_billing_payer_monthly` AS
SELECT
  EXTRACT(YEAR FROM f.invoice_date) AS invoice_year,
  EXTRACT(MONTH FROM f.invoice_date) AS invoice_month,
  DATE_TRUNC(f.invoice_date, MONTH) AS month_start_date,
  p.insurance_provider,
  COUNT(*) AS invoice_count,
  SUM(f.billed_amount) AS total_billed_amount,
  SUM(f.insurance_amount) AS total_insurance_billed_amount,
  SUM(f.patient_amount) AS total_patient_billed_amount,
  SUM(f.collected_amount) AS total_collected_amount,
  SUM(f.outstanding_amount) AS outstanding_amount,
  SUM(f.payment_count) AS payment_count,
  AVG(f.days_to_first_payment) AS avg_days_to_payment,
  SAFE_DIVIDE(SUM(f.paid_within_30_days_flag), COUNT(*)) AS percent_paid_within_30_days
FROM `portfolio_healthcare.core.fact_invoice` f
JOIN `portfolio_healthcare.core.dim_payer` p USING (payer_key)
GROUP BY 1,2,3,4;

CREATE OR REPLACE TABLE `portfolio_healthcare.marts.mart_billing_service_monthly` AS
SELECT
  EXTRACT(YEAR FROM f.appointment_date) AS service_year,
  EXTRACT(MONTH FROM f.appointment_date) AS service_month,
  DATE_TRUNC(f.appointment_date, MONTH) AS month_start_date,
  s.service_category,
  s.billing_code,
  s.service_name,
  COUNT(DISTINCT f.appointment_id) AS appointments_with_service,
  SUM(f.units_provided) AS total_units_provided,
  SUM(f.extended_charge_amount) AS total_charge_amount,
  SAFE_DIVIDE(SUM(f.extended_charge_amount), COUNT(DISTINCT f.appointment_id)) AS avg_charge_per_appointment,
  SAFE_DIVIDE(SUM(f.units_provided), COUNT(DISTINCT f.appointment_id)) AS avg_units_per_appointment
FROM `portfolio_healthcare.core.fact_clinic_service` f
JOIN `portfolio_healthcare.core.dim_service` s USING (service_key)
GROUP BY 1,2,3,4,5,6;
