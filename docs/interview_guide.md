# Interview Guide

## 30-second project explanation
“I originally designed a healthcare dimensional warehouse in graduate school for an outpatient physical-therapy operation. I rebuilt that concept as a portfolio analytics-engineering project using synthetic data and a BigQuery-style layered architecture. I created staging models, dimensions, separate service and invoice facts, business-facing operations and revenue-cycle marts, reconciliation tests, and a Power BI semantic model. One of the biggest improvements was separating invoice measures from the service-grain fact so financial values could not be double counted.”

## Technical questions to be ready for
### Why a star schema?
It creates predictable business definitions, reduces repetitive joins for BI, improves usability, and makes measure grain explicit.

### Why two facts?
A service occurs at appointment-service grain while an invoice occurs at invoice grain. Combining invoice dollars with multiple service rows duplicates financial measures. Separate facts preserve additivity.

### Why marts if a warehouse already exists?
The warehouse is reusable/governed. Marts package role-specific metrics and reduce query complexity and inappropriate attribute exposure for self-service users.

### How did you validate the pipeline?
Key uniqueness, referential integrity, accepted values, chronology, row-count/grain tests, source-to-fact dollar reconciliation, payment reconciliation, and mart-to-fact reconciliation.

### Why partition and cluster in BigQuery?
Partitioning reduces scanned data for date-filtered analytics; clustering improves pruning for common high-cardinality filter/join keys such as payer, therapist, and service.

### How is this related to your work experience?
The portfolio implementation is synthetic and independent. It builds on healthcare analytics experience at HonorHealth, SQL/warehouse workflows at Quad, and the dimensional-modeling foundation from graduate coursework.
