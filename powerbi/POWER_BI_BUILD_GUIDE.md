# Power BI Build Guide

## Semantic model
Prefer a star schema in Power BI rather than importing a single flattened export.

### Core tables
- Date dimension
- Therapist dimension
- Service dimension
- Payer dimension
- Visit dimension
- Service Activity Fact
- Invoice Fact
- Operations Monthly Mart
- Payer Monthly Mart
- Service Monthly Mart

## Relationship principles
- One-to-many from dimensions to facts.
- Single-direction filtering by default.
- Avoid fact-to-fact relationships.
- Use Date as the conformed calendar.
- Keep operational and revenue measures separated by fact grain.

## Report pages

### 1. Executive Overview
Cards:
- Completed Visits
- Completion Rate
- Cancellation Rate
- No-Show Rate
- Total Billed
- Total Collected
- Outstanding A/R
- Avg Days to Payment

Visuals:
- visits by month
- billed vs collected by month
- cancellations/no-shows by month
- payer A/R ranking

### 2. Clinic Operations
- therapist completed visits
- treatment minutes
- unique patients
- completion/cancellation/no-show rates
- visit type mix
- monthly trend

### 3. Revenue Cycle
- billed vs collected
- outstanding A/R
- average days to payment
- % paid within 30 days
- payer ranking and trend

### 4. Service Mix
- billed charges by service category
- units by service
- appointments with service
- average charge per appointment

### 5. Data Quality / Trust
Show a small quality scorecard:
- duplicate-key failures
- orphan-key failures
- reconciliation difference
- invalid-status rows
- chronology failures

This page is valuable in interviews because it demonstrates that BI trust depends on upstream data engineering.

## Portfolio screenshots
Capture the semantic model plus the Executive Overview, Clinic Operations, Revenue Cycle, and Data Quality pages.
