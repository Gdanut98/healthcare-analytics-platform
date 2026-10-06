# Data Dictionary

## Source layer
- **patient** — synthetic patient demographics/geography and payer assignment.
- **therapist** — therapist specialty, employment status, and hire date.
- **appointment** — scheduled visit, therapist, patient, date/time, status, type, duration, room.
- **service** — billable service catalog and billing code.
- **appointment_service** — many-to-many bridge recording performed services, units, and historical unit charge.
- **invoice** — appointment-level billed, insurer, patient, due-date, and status fields.
- **payment** — payment transactions with date, amount, method, and source.
- **treatment_plan** — synthetic plan-of-care authorization and diagnosis context.

## Warehouse layer
- **dim_date** — calendar hierarchy.
- **dim_patient** — surrogate patient key plus geography, payer, and age band. No direct contact fields are propagated.
- **dim_therapist** — surrogate therapist key, specialty, status, hire date.
- **dim_service** — service catalog, category, billing code, standard fee.
- **dim_visit** — visit type/status combinations.
- **dim_payer** — payer and payer class.
- **fact_clinic_service** — one row per service performed during an appointment.

## Marts
- **mart_ops_therapist_monthly** — therapist + month + visit type.
- **mart_billing_payer_monthly** — payer + invoice month.
- **mart_billing_service_monthly** — month + service category + billing code + service.
