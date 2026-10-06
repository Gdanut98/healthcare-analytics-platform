# Interview One-Pager — Healthcare Analytics Platform

## 30-second explanation
I took a healthcare dimensional-modeling project from graduate school and rebuilt it as a production-style analytics-engineering portfolio project. I generated synthetic outpatient-clinic data, designed BigQuery raw/staging/warehouse/mart layers, separated service and invoice facts to preserve grain, added reconciliation and data-quality tests, and designed a Power BI semantic layer for operations and revenue-cycle reporting.

## Why this matters
The project demonstrates that I can work across:
business requirements → source modeling → SQL transformations → dimensional design → validation → marts → BI.

## Strong technical story: grain
A service-level fact is appropriate for units, service charges, duration, and clinical activity. It is unsafe for invoice/payment totals when one appointment can contain multiple services. I separated revenue-cycle measures into an invoice-grain fact and validated totals through reconciliation tests.

## Strong business story
Operations managers need capacity, visit volume, cancellation/no-show and workload measures. Revenue-cycle managers need billed amounts, collections, outstanding balances and payment speed. Separate marts simplify each audience's analysis and reduce unnecessary exposure of sensitive detail.

## Connection to experience
- Graduate coursework provides formal data-modeling and warehousing evidence.
- Healthcare analytics experience provides domain context for operational KPIs and stakeholder needs.
- Prior BI/SQL warehouse work provides professional context for SQL transformation and reporting workflows.
- The portfolio extension demonstrates current BigQuery-oriented analytics-engineering initiative.

## Important boundary
The project is entirely synthetic and contains no employer data or PHI.
