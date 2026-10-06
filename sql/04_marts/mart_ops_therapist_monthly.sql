-- BigQuery Standard SQL
CREATE OR REPLACE TABLE `portfolio_healthcare.marts.mart_ops_therapist_monthly` AS
SELECT
  EXTRACT(YEAR FROM a.appointment_datetime) AS calendar_year,
  EXTRACT(MONTH FROM a.appointment_datetime) AS calendar_month,
  DATE_TRUNC(DATE(a.appointment_datetime), MONTH) AS month_start_date,
  a.therapist_id,
  CONCAT(t.first_name, ' ', t.last_name) AS therapist_name,
  t.specialty,
  a.visit_type,
  COUNT(*) AS scheduled_appointments,
  COUNTIF(a.appointment_status = 'Completed') AS completed_appointments,
  COUNTIF(a.appointment_status = 'Cancelled') AS cancelled_appointments,
  COUNTIF(a.appointment_status = 'No Show') AS no_show_appointments,
  COUNT(DISTINCT IF(a.appointment_status = 'Completed', a.patient_id, NULL)) AS unique_patients_seen,
  SUM(IF(a.appointment_status = 'Completed', a.duration_minutes, 0)) AS total_completed_minutes,
  AVG(IF(a.appointment_status = 'Completed', a.duration_minutes, NULL)) AS avg_completed_minutes,
  SAFE_DIVIDE(COUNTIF(a.appointment_status = 'Completed'), COUNT(*)) AS completion_rate,
  SAFE_DIVIDE(COUNTIF(a.appointment_status = 'Cancelled'), COUNT(*)) AS cancellation_rate,
  SAFE_DIVIDE(COUNTIF(a.appointment_status = 'No Show'), COUNT(*)) AS no_show_rate
FROM `portfolio_healthcare.staging.stg_appointment` a
JOIN `portfolio_healthcare.staging.stg_therapist` t
  USING (therapist_id)
GROUP BY 1,2,3,4,5,6,7;
