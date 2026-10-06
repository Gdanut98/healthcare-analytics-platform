-- Invoice-grain revenue-cycle fact: one row per invoice.
-- Keeps financial measures additive and prevents service-level duplication.
CREATE OR REPLACE TABLE `portfolio_healthcare.core.fact_invoice`
PARTITION BY invoice_date
CLUSTER BY payer_key, patient_key AS
WITH payment_rollup AS (
  SELECT
    invoice_id,
    SUM(payment_amount) AS total_payment_amount,
    COUNT(*) AS payment_count,
    MIN(payment_date) AS first_payment_date,
    MAX(payment_date) AS last_payment_date
  FROM `portfolio_healthcare.staging.stg_payment`
  GROUP BY invoice_id
)
SELECT
  i.invoice_id,
  i.appointment_id,
  i.invoice_date,
  CAST(FORMAT_DATE('%Y%m%d', i.invoice_date) AS INT64) AS invoice_date_key,
  dp.patient_key,
  dt.therapist_key,
  dpay.payer_key,
  i.total_amount AS billed_amount,
  i.insurance_amount,
  i.patient_amount,
  COALESCE(pr.total_payment_amount, 0) AS collected_amount,
  GREATEST(i.total_amount - COALESCE(pr.total_payment_amount, 0), 0) AS outstanding_amount,
  COALESCE(pr.payment_count, 0) AS payment_count,
  pr.first_payment_date,
  pr.last_payment_date,
  DATE_DIFF(pr.first_payment_date, i.invoice_date, DAY) AS days_to_first_payment,
  IF(pr.first_payment_date IS NOT NULL AND DATE_DIFF(pr.first_payment_date, i.invoice_date, DAY) <= 30, 1, 0) AS paid_within_30_days_flag,
  i.invoice_status
FROM `portfolio_healthcare.staging.stg_invoice` i
JOIN `portfolio_healthcare.staging.stg_appointment` a USING (appointment_id)
JOIN `portfolio_healthcare.core.dim_patient` dp ON a.patient_id = dp.patient_id_nk
JOIN `portfolio_healthcare.core.dim_therapist` dt ON a.therapist_id = dt.therapist_id_nk
JOIN `portfolio_healthcare.core.dim_payer` dpay ON i.insurance_provider = dpay.insurance_provider
LEFT JOIN payment_rollup pr USING (invoice_id);
