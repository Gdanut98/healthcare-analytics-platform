-- Service-grain fact: one row per service performed during an appointment.
-- Invoice/payment measures intentionally live in fact_invoice to avoid double counting
-- when an appointment contains multiple services.
CREATE OR REPLACE TABLE `portfolio_healthcare.core.fact_clinic_service`
PARTITION BY appointment_date
CLUSTER BY therapist_key, service_key, payer_key AS
SELECT
  a.appointment_id,
  DATE(a.appointment_datetime) AS appointment_date,
  CAST(FORMAT_DATE('%Y%m%d', DATE(a.appointment_datetime)) AS INT64) AS date_key,
  dp.patient_key,
  dt.therapist_key,
  ds.service_key,
  dv.visit_key,
  dpay.payer_key,
  aps.units_provided,
  aps.unit_charge,
  ROUND(aps.units_provided * aps.unit_charge, 2) AS extended_charge_amount,
  a.duration_minutes,
  IF(a.appointment_status = 'Completed', 1, 0) AS completed_service_row,
  IF(a.appointment_status = 'Cancelled', 1, 0) AS cancelled_service_row,
  IF(a.appointment_status = 'No Show', 1, 0) AS no_show_service_row
FROM `portfolio_healthcare.staging.stg_appointment` a
JOIN `portfolio_healthcare.staging.stg_appointment_service` aps USING (appointment_id)
JOIN `portfolio_healthcare.core.dim_patient` dp ON a.patient_id = dp.patient_id_nk
JOIN `portfolio_healthcare.core.dim_therapist` dt ON a.therapist_id = dt.therapist_id_nk
JOIN `portfolio_healthcare.core.dim_service` ds ON aps.service_code = ds.service_code_nk
JOIN `portfolio_healthcare.core.dim_visit` dv USING (visit_type, appointment_status)
JOIN `portfolio_healthcare.staging.stg_patient` sp ON a.patient_id = sp.patient_id
JOIN `portfolio_healthcare.core.dim_payer` dpay ON sp.insurance_provider = dpay.insurance_provider;
