-- BigQuery Standard SQL. Raw tables are loaded from generated CSV files.
CREATE OR REPLACE VIEW `portfolio_healthcare.staging.stg_patient` AS
SELECT CAST(patient_id AS INT64) patient_id, TRIM(first_name) first_name, TRIM(last_name) last_name,
  SAFE_CAST(date_of_birth AS DATE) date_of_birth, city, state, zip_code, insurance_provider
FROM `portfolio_healthcare.raw.patient`;

CREATE OR REPLACE VIEW `portfolio_healthcare.staging.stg_therapist` AS
SELECT CAST(therapist_id AS INT64) therapist_id, TRIM(first_name) first_name, TRIM(last_name) last_name,
  specialty, employment_status, SAFE_CAST(hire_date AS DATE) hire_date
FROM `portfolio_healthcare.raw.therapist`;

CREATE OR REPLACE VIEW `portfolio_healthcare.staging.stg_service` AS
SELECT service_code, service_name, service_category, billing_code,
  SAFE_CAST(standard_fee AS NUMERIC) standard_fee, CAST(default_duration_minutes AS INT64) default_duration_minutes
FROM `portfolio_healthcare.raw.service`;

CREATE OR REPLACE VIEW `portfolio_healthcare.staging.stg_appointment` AS
SELECT CAST(appointment_id AS INT64) appointment_id, CAST(patient_id AS INT64) patient_id,
 CAST(therapist_id AS INT64) therapist_id, SAFE_CAST(appointment_datetime AS TIMESTAMP) appointment_datetime,
 CAST(duration_minutes AS INT64) duration_minutes, appointment_status, visit_type, CAST(room_number AS INT64) room_number
FROM `portfolio_healthcare.raw.appointment`;

CREATE OR REPLACE VIEW `portfolio_healthcare.staging.stg_appointment_service` AS
SELECT CAST(appointment_id AS INT64) appointment_id, service_code, CAST(units_provided AS INT64) units_provided,
 SAFE_CAST(unit_charge AS NUMERIC) unit_charge
FROM `portfolio_healthcare.raw.appointment_service`;

CREATE OR REPLACE VIEW `portfolio_healthcare.staging.stg_invoice` AS
SELECT CAST(invoice_id AS INT64) invoice_id, CAST(appointment_id AS INT64) appointment_id, SAFE_CAST(invoice_date AS DATE) invoice_date,
 SAFE_CAST(total_amount AS NUMERIC) total_amount, SAFE_CAST(insurance_amount AS NUMERIC) insurance_amount,
 SAFE_CAST(patient_amount AS NUMERIC) patient_amount, SAFE_CAST(due_date AS DATE) due_date,
 insurance_provider, invoice_status
FROM `portfolio_healthcare.raw.invoice`;

CREATE OR REPLACE VIEW `portfolio_healthcare.staging.stg_payment` AS
SELECT CAST(payment_id AS INT64) payment_id, CAST(invoice_id AS INT64) invoice_id, SAFE_CAST(payment_date AS DATE) payment_date,
 SAFE_CAST(payment_amount AS NUMERIC) payment_amount, payment_method, payment_source
FROM `portfolio_healthcare.raw.payment`;
