# Healthcare Analytics Platform
## From Operational Clinic Data to a Tested Dimensional Analytics Layer

### Business problem
Operational healthcare systems are designed to record appointments, services, invoices, and payments. They are not optimized for repeated management questions such as:

- Which therapists and visit types have the highest cancellation/no-show rates?
- Where is clinical capacity being consumed?
- Which payers carry the largest outstanding balances?
- Which services drive billed volume?
- How quickly are invoices converted to cash?

### Solution
I designed an analytics platform that separates source ingestion, staging, dimensional modeling, business marts, data quality, and BI consumption.

**Pipeline:** Synthetic operational data → BigQuery raw → staging → dimensional warehouse → tested marts → Power BI.

### Modeling decision that materially improved the design
The original academic model centered multiple operational and financial measures on a service-level fact. During implementation, I identified a grain problem: if an appointment contains multiple services, repeating invoice or payment totals on every service row can overstate revenue.

I therefore separated the analytical model into:
- a service-grain fact for clinical/service activity; and
- an invoice-grain fact for revenue-cycle measures.

This keeps each measure at its natural grain and makes financial reconciliation auditable.

### Data quality
The project includes tests for:
- duplicate keys,
- orphan relationships,
- invalid appointment statuses,
- invalid service quantities,
- impossible payment chronology,
- source-to-fact billed-dollar reconciliation,
- payment reconciliation,
- fact-to-mart reconciliation.

### BI layer
The Power BI design focuses on:
- executive operational KPIs,
- therapist capacity and utilization,
- cancellations/no-shows,
- payer A/R and payment speed,
- service mix and billed activity.

### Evidence lineage
This project is a new portfolio implementation built from three clearly separated evidence sources:

**Academic foundation:** CIS 505 healthcare relational modeling, star-schema design, data marts, SQL, and BI.

**Professional context:** healthcare analytics experience and prior SQL/data-warehouse work inform the business framing and implementation discipline.

**New portfolio engineering:** synthetic data generation, BigQuery-oriented ELT, separate fact grains, reconciliation testing, and cloud-deployment documentation.

No employer data, PHI, proprietary SQL, or proprietary schema is used.

### Skills demonstrated
BigQuery • SQL • Dimensional Modeling • Star Schemas • ETL/ELT • Data Quality • Reconciliation • Healthcare Analytics • Power BI • Analytics Engineering
