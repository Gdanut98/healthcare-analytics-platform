# Healthcare Analytics Platform

## Portfolio Case Study
A production-style healthcare analytics platform that extends an academic dimensional-modeling design into a modern cloud analytics implementation using synthetic data, BigQuery SQL, dimensional modeling, data-quality controls, analytical marts, and Power BI.

## Why this project exists
The original CIS 505 project modeled an outpatient physical-therapy clinic and designed a historical warehouse plus operations and revenue-cycle data marts. This portfolio implementation rebuilds that design as an end-to-end analytics engineering project.

## Professional connection
This project intentionally connects three evidence streams without conflating them:
- **Graduate work:** healthcare relational modeling, star-schema design, data marts, SQL, and BI.
- **HonorHealth:** professional healthcare operational/financial analytics, Power BI hospital-waste reporting, spend analysis, benchmarking, and stakeholder collaboration.
- **Quad Graphics:** professional SQL extraction/transformation/loading into data warehouses and Tableau BI workflows.

No proprietary employer data is used. All portfolio data will be synthetic.

## Architecture
Synthetic Source Data → BigQuery Raw/Staging → SQL ELT → Dimensional Warehouse → Data Quality Tests → Operations & Revenue Cycle Marts → Power BI

## Business questions
1. Which therapists and visit types have the highest cancellation and no-show rates?
2. Which therapists carry the highest completed patient load and treatment minutes?
3. Which payers have the largest outstanding balances and slowest payment times?
4. Which services generate the most billed charges and units?
5. How are operational utilization and revenue-cycle performance changing over time?

## Target stack
- Google Cloud Platform
- BigQuery
- SQL
- Python
- Power BI
- Git/GitHub

## Repository structure
- `docs/` — requirements, architecture, data dictionary, case-study narrative
- `sql/00_setup/` — datasets and environment setup
- `sql/01_staging/` — typed/clean staging models
- `sql/02_dimensions/` — dimensional tables
- `sql/03_facts/` — fact tables
- `sql/04_marts/` — business-facing analytical marts
- `sql/05_quality/` — validation and data-quality queries
- `python/` — synthetic healthcare data generation
- `dashboard/` — Power BI documentation/screenshots
- `images/` — architecture and portfolio visuals

## Academic foundation vs portfolio extension
### Academic foundation demonstrated
- Healthcare ER modeling
- Fact/dimension design
- Grain definition
- Natural/surrogate-key concepts
- Operations and billing data marts
- SQL business queries
- Tableau visualization

### New portfolio extension
- Synthetic source-system generation
- BigQuery implementation
- Layered raw/staging/core/mart architecture
- ELT SQL
- Data-quality checks
- Reproducible repository structure
- Power BI semantic/reporting layer
- Cloud-focused technical documentation

## Key modeling decision: preserve fact grain
The portfolio implementation improves the original academic design by separating two analytical processes:
- `fact_clinic_service` — one row per appointment-service occurrence for utilization and service-mix analytics.
- `fact_invoice` — one row per invoice for billed, collected, outstanding, and payment-timing measures.

This prevents invoice/payment measures from being repeated across multiple service rows and demonstrates explicit dimensional-grain design.

## Data quality & reconciliation
The repository includes tests for duplicate business keys, invalid statuses, orphan relationships, invalid quantities, payment chronology, source-to-fact billed-dollar reconciliation, source-to-fact payment reconciliation, service-grain row reconciliation, negative A/R, and mart-to-fact reconciliation.

## Power BI design
See `dashboard/power_bi_specification.md` for the proposed semantic model, report pages, KPIs, and DAX measures. Financial measures originate from invoice grain; service utilization originates from service grain.

## Employer-facing documentation
- `docs/employer_case_study.md` — polished case-study narrative.
- `docs/interview_guide.md` — 30-second explanation and technical interview talking points.
- `docs/architecture.md` — architecture and modeling rationale.
- `docs/resume_connection.md` — explicit separation of graduate, professional, and new portfolio evidence.

## Privacy and provenance
All data in this repository is synthetic. No HonorHealth, Quad, HAVI, patient, customer, or other proprietary employer data is included.

## Deployment readiness

The repository now includes a BigQuery deployment runbook, Power BI semantic-model specification, DAX measure library, employer-facing case study, and deployment checklist. Local engineering is complete enough to move into a real GCP project when account access is available.

See:
- `deployment/BIGQUERY_DEPLOYMENT_RUNBOOK.md`
- `deployment/DEPLOYMENT_CHECKLIST.md`
- `powerbi/POWER_BI_BUILD_GUIDE.md`
- `powerbi/measures.dax`
- `portfolio/CASE_STUDY.md`
- `portfolio/INTERVIEW_ONE_PAGER.md`
