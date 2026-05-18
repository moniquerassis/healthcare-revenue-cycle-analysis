-- ============================================================
-- HEALTHCARE REVENUE CYCLE ANALYSIS
-- Author: Monique Assis | github.com/monique-assis
-- Dataset: Hospital Claims Data (1,000 records | 2022–2024)
-- Tool: SQLite / PostgreSQL / MySQL compatible
-- ============================================================


-- ============================================================
-- 1. OVERVIEW: Total revenue metrics
-- ============================================================
SELECT
    COUNT(*)                                        AS total_claims,
    ROUND(SUM(billed_amount), 2)                   AS total_billed,
    ROUND(SUM(collected_amount), 2)                AS total_collected,
    ROUND(AVG(collection_rate_pct), 1)             AS avg_collection_rate_pct,
    COUNT(CASE WHEN claim_denied = 'Yes' THEN 1 END) AS total_denials,
    ROUND(
        COUNT(CASE WHEN claim_denied = 'Yes' THEN 1 END) * 100.0 / COUNT(*), 1
    )                                               AS denial_rate_pct
FROM hospital_claims;


-- ============================================================
-- 2. COLLECTION RATE BY PAYER
-- Which payers pay the most — and who leaves revenue on the table?
-- ============================================================
SELECT
    payer,
    COUNT(*)                                AS total_claims,
    ROUND(SUM(billed_amount), 2)           AS total_billed,
    ROUND(SUM(collected_amount), 2)        AS total_collected,
    ROUND(AVG(collection_rate_pct), 1)     AS avg_collection_rate_pct,
    ROUND(SUM(billed_amount - collected_amount), 2) AS revenue_gap
FROM hospital_claims
GROUP BY payer
ORDER BY avg_collection_rate_pct DESC;


-- ============================================================
-- 3. DENIAL RATE BY DEPARTMENT
-- Which departments generate the most denied claims?
-- ============================================================
SELECT
    department,
    COUNT(*)                                                        AS total_claims,
    COUNT(CASE WHEN claim_denied = 'Yes' THEN 1 END)               AS denied_claims,
    ROUND(
        COUNT(CASE WHEN claim_denied = 'Yes' THEN 1 END) * 100.0 / COUNT(*), 1
    )                                                               AS denial_rate_pct,
    ROUND(
        SUM(CASE WHEN claim_denied = 'Yes' THEN billed_amount ELSE 0 END), 2
    )                                                               AS denied_revenue_at_risk
FROM hospital_claims
GROUP BY department
ORDER BY denial_rate_pct DESC;


-- ============================================================
-- 4. TOP DENIAL REASONS
-- Root cause analysis of claim denials
-- ============================================================
SELECT
    denial_reason,
    COUNT(*)                                AS occurrences,
    ROUND(SUM(billed_amount), 2)           AS revenue_at_risk,
    ROUND(AVG(billed_amount), 2)           AS avg_claim_value
FROM hospital_claims
WHERE claim_denied = 'Yes'
GROUP BY denial_reason
ORDER BY revenue_at_risk DESC;


-- ============================================================
-- 5. HOSPITAL PERFORMANCE RANKING
-- Revenue efficiency by hospital
-- ============================================================
SELECT
    hospital_name,
    state,
    hospital_type,
    COUNT(*)                                AS total_claims,
    ROUND(SUM(billed_amount), 2)           AS total_billed,
    ROUND(SUM(collected_amount), 2)        AS total_collected,
    ROUND(AVG(collection_rate_pct), 1)     AS avg_collection_rate_pct,
    ROUND(AVG(length_of_stay_days), 1)     AS avg_length_of_stay,
    ROUND(
        COUNT(CASE WHEN readmitted_30days = 'Yes' THEN 1 END) * 100.0 / COUNT(*), 1
    )                                       AS readmission_rate_pct
FROM hospital_claims
GROUP BY hospital_id, hospital_name, state, hospital_type
ORDER BY avg_collection_rate_pct DESC;


-- ============================================================
-- 6. MONTHLY REVENUE TREND
-- Tracking billing and collection over time
-- ============================================================
SELECT
    SUBSTR(admission_date, 1, 7)           AS year_month,
    COUNT(*)                               AS total_claims,
    ROUND(SUM(billed_amount), 2)          AS total_billed,
    ROUND(SUM(collected_amount), 2)       AS total_collected,
    ROUND(AVG(collection_rate_pct), 1)    AS avg_collection_rate_pct
FROM hospital_claims
GROUP BY year_month
ORDER BY year_month;


-- ============================================================
-- 7. SELF-PAY RISK ANALYSIS
-- Self-pay patients represent the highest revenue leakage risk
-- ============================================================
SELECT
    hospital_name,
    COUNT(*)                                        AS self_pay_claims,
    ROUND(SUM(billed_amount), 2)                   AS total_billed,
    ROUND(SUM(collected_amount), 2)                AS total_collected,
    ROUND(SUM(billed_amount - collected_amount), 2) AS uncollected_revenue,
    ROUND(AVG(collection_rate_pct), 1)             AS avg_collection_rate_pct
FROM hospital_claims
WHERE payer = 'Self-Pay'
GROUP BY hospital_id, hospital_name
ORDER BY uncollected_revenue DESC;


-- ============================================================
-- 8. LENGTH OF STAY vs REVENUE IMPACT
-- Do longer stays generate proportionally more revenue?
-- ============================================================
SELECT
    CASE
        WHEN length_of_stay_days = 1       THEN '1 day'
        WHEN length_of_stay_days <= 3      THEN '2–3 days'
        WHEN length_of_stay_days <= 7      THEN '4–7 days'
        WHEN length_of_stay_days <= 14     THEN '8–14 days'
        ELSE '15+ days'
    END                                     AS los_bucket,
    COUNT(*)                               AS total_claims,
    ROUND(AVG(billed_amount), 2)          AS avg_billed,
    ROUND(AVG(collected_amount), 2)       AS avg_collected,
    ROUND(AVG(collection_rate_pct), 1)   AS avg_collection_rate_pct,
    ROUND(
        COUNT(CASE WHEN readmitted_30days = 'Yes' THEN 1 END) * 100.0 / COUNT(*), 1
    )                                      AS readmission_rate_pct
FROM hospital_claims
GROUP BY los_bucket
ORDER BY MIN(length_of_stay_days);


-- ============================================================
-- 9. READMISSION ANALYSIS BY DEPARTMENT
-- High readmission = quality and cost flag
-- ============================================================
SELECT
    department,
    COUNT(*)                                                            AS total_claims,
    COUNT(CASE WHEN readmitted_30days = 'Yes' THEN 1 END)              AS readmissions,
    ROUND(
        COUNT(CASE WHEN readmitted_30days = 'Yes' THEN 1 END) * 100.0 / COUNT(*), 1
    )                                                                   AS readmission_rate_pct,
    ROUND(AVG(CASE WHEN readmitted_30days = 'Yes' THEN billed_amount END), 2) AS avg_readmit_cost
FROM hospital_claims
GROUP BY department
ORDER BY readmission_rate_pct DESC;


-- ============================================================
-- 10. EXECUTIVE SUMMARY: HIGH-IMPACT OPPORTUNITIES
-- Claims denied + self-pay + high revenue = priority for recovery
-- ============================================================
SELECT
    claim_id,
    hospital_name,
    department,
    payer,
    billed_amount,
    collected_amount,
    ROUND(billed_amount - collected_amount, 2)  AS revenue_gap,
    denial_reason,
    readmitted_30days
FROM hospital_claims
WHERE
    claim_denied = 'Yes'
    AND billed_amount > 20000
ORDER BY revenue_gap DESC
LIMIT 20;
