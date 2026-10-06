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

No proprietary employer data is used. All portfolio data is synthetic.

## Architecture
Synthetic Source Data → BigQuery Raw/Staging → SQL ELT → Dimensional Warehouse → Data Quality Tests → Operations & Revenue Cycle Marts → Power BI

## Key modeling decision: preserve fact grain
The portfolio implementation separates:
- `fact_clinic_service` — one row per appointment-service occurrence.
- `fact_invoice` — one row per invoice.

This prevents invoice/payment measures from being repeated across multiple service rows.

## Target stack
Google Cloud Platform • BigQuery • SQL • Python • Power BI • Git/GitHub

## Privacy
All data in this repository is synthetic. No HonorHealth, Quad, HAVI, patient, customer, or other proprietary employer data is included.
