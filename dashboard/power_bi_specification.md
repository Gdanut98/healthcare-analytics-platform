# Power BI Semantic Model & Report Specification

## Semantic model
Use a star-oriented semantic model with `dim_date`, `dim_therapist`, `dim_service`, `dim_patient`, `dim_visit`, and `dim_payer` filtering the relevant facts/marts. Financial KPIs should originate from `fact_invoice` or `mart_billing_payer_monthly`; service utilization should originate from `fact_clinic_service` or the service mart. Do not sum invoice dollars from a service-grain table.

## Report pages
### 1. Executive Overview
KPI cards: Completed Visits, Completion Rate, No-Show Rate, Total Billed, Total Collected, Outstanding A/R, Avg Days to First Payment.
Visuals: monthly completed visits, monthly billed vs collected, payer A/R ranking, service-mix contribution.

### 2. Clinic Operations
Slicers: Date, Therapist, Specialty, Visit Type.
Visuals: completed appointments by therapist; cancellation/no-show rates; treatment minutes; unique patients; monthly utilization trend.

### 3. Revenue Cycle
Slicers: Date, Payer, Payer Class.
Visuals: billed vs collected, outstanding balance by payer, average days to first payment, percent paid within 30 days, monthly A/R trend.

### 4. Service Mix
Slicers: Date, Service Category, Billing Code.
Visuals: units, charges, appointments with service, average charge per appointment, service-category trend.

### 5. Data Quality
Cards: failed tests, orphan keys, duplicate keys, invalid statuses, reconciliation differences.
Purpose: make trust/validation visible rather than treating quality as hidden engineering work.

## Core DAX measures
```DAX
Total Billed = SUM(fact_invoice[billed_amount])
Total Collected = SUM(fact_invoice[collected_amount])
Outstanding AR = SUM(fact_invoice[outstanding_amount])
Collection Rate = DIVIDE([Total Collected], [Total Billed])
Avg Days to First Payment = AVERAGE(fact_invoice[days_to_first_payment])
Paid Within 30 Days % = AVERAGE(fact_invoice[paid_within_30_days_flag])
Service Charges = SUM(fact_clinic_service[extended_charge_amount])
Service Units = SUM(fact_clinic_service[units_provided])
```

## Portfolio presentation rule
The report should look like a healthcare operational product, not a classroom dashboard: restrained layout, clear KPI hierarchy, business-language titles, consistent filters, and a visible data-quality page.
