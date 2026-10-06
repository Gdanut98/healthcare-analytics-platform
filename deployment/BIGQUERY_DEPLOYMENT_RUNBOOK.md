# BigQuery Deployment Runbook

## Purpose
This runbook turns the repository into a repeatable Google Cloud / BigQuery implementation.
The portfolio uses only synthetic outpatient physical-therapy data.

## Target datasets
Create four datasets in one BigQuery project:

- `clinic_raw` — landed source extracts
- `clinic_stg` — typed and standardized staging models
- `clinic_dw` — conformed dimensions and facts
- `clinic_mart` — business-facing analytical marts

Use the same region for all datasets.

## Recommended execution order

1. Generate synthetic source CSVs locally.
2. Upload source CSVs to `clinic_raw`.
3. Execute staging SQL.
4. Build dimensions.
5. Build facts.
6. Execute data-quality and reconciliation tests.
7. Build analytical marts.
8. Re-run reconciliation tests.
9. Connect Power BI to `clinic_mart` and selected `clinic_dw` dimensions.
10. Capture screenshots for the portfolio case study.

## BigQuery implementation notes

### Partitioning
Partition large facts on the primary business date:
- service activity: appointment/service date
- invoice fact: invoice date

### Clustering
Useful clustering candidates:
- therapist key
- service key
- payer key
- appointment status
- insurance provider

Choose clustering only where query patterns justify it.

### Cost discipline
- Avoid `SELECT *` in production queries.
- Filter partition columns whenever possible.
- Materialize reusable business logic into marts.
- Use dry-run/query estimates before large scans.
- Keep raw, staging, warehouse, and mart layers logically separate.

## Validation gate
Do not expose a mart to Power BI unless:
- expected primary keys are unique,
- required foreign keys resolve,
- source billed dollars reconcile to invoice facts,
- payments reconcile to invoice facts,
- mart totals reconcile to their parent fact,
- no negative or impossible financial amounts exist,
- service quantities and dates pass validity checks.

## Portfolio deployment evidence to capture
When deployed, capture:
1. BigQuery Explorer showing the four datasets.
2. One staging query.
3. One dimensional model.
4. One fact table schema.
5. One reconciliation query returning zero differences.
6. Query execution details showing partition pruning.
7. Power BI semantic model.
8. Final dashboard pages.

These screenshots become proof of hands-on GCP implementation.
