# Technical Specification — Healthcare Analytics Platform

## 1. Objective
Build a reproducible cloud analytics platform for a synthetic outpatient physical-therapy organization. The system supports operational capacity analysis and revenue-cycle analytics while demonstrating dimensional modeling, SQL ELT, BigQuery, data quality, and BI.

## 2. Source-system entities
- Patient
- Therapist
- Appointment
- TreatmentPlan
- Service
- AppointmentService
- Invoice
- Payment

## 3. Core warehouse grain
`fact_clinic_service`: one row per service performed during a specific appointment.

## 4. Dimensions
- `dim_date`
- `dim_patient`
- `dim_therapist`
- `dim_service`
- `dim_visit`
- `dim_payer`

## 5. Measures
- units_provided
- unit_charge
- extended_charge_amount
- duration_minutes
- appointment_count
- completed_appointment_count
- cancelled_appointment_count
- no_show_appointment_count
- invoice_total_amount
- insurance_amount
- patient_amount
- payment_amount
- days_to_payment

## 6. Analytical marts
### mart_ops_therapist_monthly
Grain: therapist + month + visit type.
Metrics: scheduled/completed/cancelled/no-show appointments, unique patients, treatment minutes, completion/cancellation/no-show rates.

### mart_billing_payer_monthly
Grain: payer + invoice month.
Metrics: invoices, billed amount, collected amount, outstanding balance, payment count, average days to payment, percent paid within 30 days.

### mart_billing_service_monthly
Grain: month + service category + billing code + service.
Metrics: appointments with service, units, charges, average charge per appointment, average units per appointment.

## 7. Data quality framework
Tests will include:
- primary-key uniqueness
- required-field null checks
- orphan foreign keys
- valid appointment status values
- nonnegative monetary values
- payment <= reasonable invoice relationship checks
- service units > 0
- invoice/payment date chronology
- duplicate appointment-service detection
- row-count reconciliation between stages

## 8. Privacy design
All portfolio data is synthetic. The BI marts minimize unnecessary patient-level fields and demonstrate role-oriented information compartmentalization.

## 9. Employer-facing evidence
The case study will show requirements → source model → warehouse architecture → SQL ELT → validation → marts → Power BI → business recommendations.
