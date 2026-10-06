-- Reconciliation suite. Every query should return zero failing rows or a zero difference.

-- 1. Invoice fact preserves invoice grain.
SELECT 'invoice_fact_grain' AS test_name,
       COUNT(*) - COUNT(DISTINCT invoice_id) AS failing_rows
FROM `portfolio_healthcare.core.fact_invoice`;

-- 2. Source billed dollars reconcile to invoice fact.
SELECT 'invoice_billed_reconciliation' AS test_name,
       ROUND((SELECT SUM(total_amount) FROM `portfolio_healthcare.staging.stg_invoice`) -
             (SELECT SUM(billed_amount) FROM `portfolio_healthcare.core.fact_invoice`), 2) AS difference;

-- 3. Source payments reconcile to invoice fact.
SELECT 'payment_reconciliation' AS test_name,
       ROUND((SELECT SUM(payment_amount) FROM `portfolio_healthcare.staging.stg_payment`) -
             (SELECT SUM(collected_amount) FROM `portfolio_healthcare.core.fact_invoice`), 2) AS difference;

-- 4. Service fact preserves appointment-service grain.
SELECT 'service_fact_grain' AS test_name,
       (SELECT COUNT(*) FROM `portfolio_healthcare.staging.stg_appointment_service`) -
       (SELECT COUNT(*) FROM `portfolio_healthcare.core.fact_clinic_service`) AS difference;

-- 5. No negative outstanding balances.
SELECT 'negative_outstanding_balance' AS test_name, COUNT(*) AS failing_rows
FROM `portfolio_healthcare.core.fact_invoice`
WHERE outstanding_amount < 0;

-- 6. No negative payment latency.
SELECT 'negative_days_to_payment' AS test_name, COUNT(*) AS failing_rows
FROM `portfolio_healthcare.core.fact_invoice`
WHERE days_to_first_payment < 0;

-- 7. Payer mart reconciles to invoice fact.
SELECT 'payer_mart_billed_reconciliation' AS test_name,
       ROUND((SELECT SUM(billed_amount) FROM `portfolio_healthcare.core.fact_invoice`) -
             (SELECT SUM(total_billed_amount) FROM `portfolio_healthcare.marts.mart_billing_payer_monthly`), 2) AS difference;
