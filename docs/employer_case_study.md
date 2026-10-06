# Healthcare Analytics Platform — Employer Case Study

## Executive summary
Built a production-style healthcare analytics platform for a synthetic outpatient physical-therapy organization. The project extends prior graduate work in healthcare dimensional modeling into a cloud-oriented implementation using Python-generated source data, BigQuery SQL, layered ELT, dimensional facts/dimensions, data-quality controls, analytical marts, and a Power BI reporting specification.

## Business problem
Clinic leaders need consistent answers to operational and revenue-cycle questions without repeatedly joining transactional scheduling, service, invoice, payment, patient, therapist, and payer tables. The analytical system must also minimize unnecessary exposure of patient-level attributes to self-service users.

## Solution
Designed a layered architecture from synthetic operational sources through raw/staging models into a dimensional warehouse. Created separate service-activity and invoice facts to preserve analytical grain, then produced operations, payer, and service marts for self-service BI.

## Technical highlights
- Reproducible Python synthetic-data generator with multi-year clinic activity.
- BigQuery-ready staging, dimensions, partitioned/clustered facts, and marts.
- Explicit fact-grain design to prevent financial double counting.
- Data-quality tests for keys, statuses, chronology, referential integrity, and financial reconciliation.
- Power BI semantic-model and KPI specification.
- Documentation of lineage, business definitions, and academic-to-professional evolution.

## Business questions answered
1. Which therapists and visit types have the highest cancellation and no-show rates?
2. Which therapists carry the greatest patient load and treatment minutes?
3. Which payers have the largest outstanding balances and slowest payment cycles?
4. Which services drive the most units and charges?
5. How do utilization and revenue-cycle performance change over time?

## Professional relevance
The project intentionally connects—but does not conflate—three forms of evidence:
- Graduate coursework: healthcare ER modeling, dimensional warehouse design, data marts, SQL, and BI.
- Professional experience: healthcare operational/financial analytics and Power BI reporting at HonorHealth; SQL/ETL-to-warehouse and Tableau experience at Quad; forecasting and supply-chain analytics at HAVI.
- New portfolio engineering: synthetic source generation, BigQuery-oriented ELT, stronger fact-grain design, automated reconciliation, and a cloud-ready reporting architecture.

No employer data, schema, code, or proprietary business logic is used.

## Interview talking points
- Why the service fact and invoice fact must have different grains.
- How marts simplify self-service BI while governed core models retain reusable logic.
- Why reconciliation tests are necessary in addition to schema/NULL tests.
- How partitioning and clustering support BigQuery performance/cost management.
- How PHI minimization influences mart design.
- How the project evolved an academic dimensional model into a more production-oriented architecture.
