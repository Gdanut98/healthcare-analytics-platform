-- Representative BigQuery data-quality checks

-- 1. Appointment primary-key duplicates: expected 0 rows
SELECT appointment_id, COUNT(*) AS row_count
FROM `portfolio_healthcare.staging.stg_appointment`
GROUP BY appointment_id
HAVING COUNT(*) > 1;

-- 2. Orphan patient references: expected 0
SELECT a.appointment_id, a.patient_id
FROM `portfolio_healthcare.staging.stg_appointment` a
LEFT JOIN `portfolio_healthcare.staging.stg_patient` p USING (patient_id)
WHERE p.patient_id IS NULL;

-- 3. Invalid appointment status: expected 0
SELECT DISTINCT appointment_status
FROM `portfolio_healthcare.staging.stg_appointment`
WHERE appointment_status NOT IN ('Scheduled','Completed','Cancelled','No Show');

-- 4. Nonpositive service units: expected 0
SELECT *
FROM `portfolio_healthcare.staging.stg_appointment_service`
WHERE units_provided <= 0;

-- 5. Payment before invoice date: expected 0
SELECT p.payment_id, p.payment_date, i.invoice_date
FROM `portfolio_healthcare.staging.stg_payment` p
JOIN `portfolio_healthcare.staging.stg_invoice` i USING (invoice_id)
WHERE p.payment_date < i.invoice_date;
