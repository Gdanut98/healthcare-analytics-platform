CREATE OR REPLACE TABLE `portfolio_healthcare.core.dim_patient` AS
SELECT ROW_NUMBER() OVER(ORDER BY patient_id) patient_key, patient_id patient_id_nk,
 CONCAT(first_name,' ',last_name) patient_name, city,state,zip_code,insurance_provider,
 CASE WHEN DATE_DIFF(CURRENT_DATE(),date_of_birth,YEAR)<18 THEN '<18'
      WHEN DATE_DIFF(CURRENT_DATE(),date_of_birth,YEAR)<35 THEN '18-34'
      WHEN DATE_DIFF(CURRENT_DATE(),date_of_birth,YEAR)<50 THEN '35-49'
      WHEN DATE_DIFF(CURRENT_DATE(),date_of_birth,YEAR)<65 THEN '50-64' ELSE '65+' END age_band
FROM `portfolio_healthcare.staging.stg_patient`;

CREATE OR REPLACE TABLE `portfolio_healthcare.core.dim_therapist` AS
SELECT ROW_NUMBER() OVER(ORDER BY therapist_id) therapist_key, therapist_id therapist_id_nk,
 CONCAT(first_name,' ',last_name) therapist_name,specialty,employment_status,hire_date
FROM `portfolio_healthcare.staging.stg_therapist`;

CREATE OR REPLACE TABLE `portfolio_healthcare.core.dim_service` AS
SELECT ROW_NUMBER() OVER(ORDER BY service_code) service_key, service_code service_code_nk,
 service_name,service_category,billing_code,standard_fee,default_duration_minutes
FROM `portfolio_healthcare.staging.stg_service`;

CREATE OR REPLACE TABLE `portfolio_healthcare.core.dim_visit` AS
SELECT ROW_NUMBER() OVER(ORDER BY visit_type,appointment_status) visit_key, visit_type,appointment_status
FROM (SELECT DISTINCT visit_type,appointment_status FROM `portfolio_healthcare.staging.stg_appointment`);

CREATE OR REPLACE TABLE `portfolio_healthcare.core.dim_payer` AS
SELECT ROW_NUMBER() OVER(ORDER BY insurance_provider) payer_key, insurance_provider,
 CASE WHEN insurance_provider='Self Pay' THEN 'Patient' WHEN insurance_provider='Medicare' THEN 'Government' ELSE 'Commercial' END payer_class
FROM (SELECT DISTINCT insurance_provider FROM `portfolio_healthcare.staging.stg_patient`);
