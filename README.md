# 🏥 Healthcare Revenue Cycle Analysis

**SQL analysis identifying billing inefficiencies, denial patterns, and revenue leakage in hospital claims data.**

---

## 📌 Project Overview

Revenue cycle management is one of the most critical — and most challenging — areas in healthcare operations. Claim denials, low collection rates, and unmanaged self-pay accounts cost US hospitals billions of dollars annually.

This project uses SQL to analyze 1,000 hospital claims across 10 US hospitals (2022–2024), uncovering patterns in billing performance, payer behavior, denial root causes, and readmission impact.

---

## 🎯 Business Questions Answered

| # | Question |
|---|----------|
| 1 | What is the overall collection rate and denial rate across all hospitals? |
| 2 | Which payers have the lowest collection rates — and how much revenue is at risk? |
| 3 | Which departments generate the most denied claims? |
| 4 | What are the root causes of denied claims? |
| 5 | Which hospitals perform best in revenue efficiency? |
| 6 | How has revenue trended month over month? |
| 7 | How much revenue is being lost through self-pay patients? |
| 8 | Does length of stay impact collection rates and readmission risk? |
| 9 | Which departments have the highest 30-day readmission rates? |
| 10 | Which high-value denied claims should be prioritized for revenue recovery? |

---

## 📊 Key Findings

### Overview
| Metric | Result |
|--------|--------|
| Total claims analyzed | 1,000 |
| Total billed | $42,009,626 |
| Total collected | $33,128,638 |
| **Average collection rate** | **79.2%** |
| Total denied claims | 174 |
| **Denial rate** | **17.4%** |

> 💡 **$8.8M in billed revenue was not collected** — representing a significant opportunity for revenue recovery.

---

### Payer Performance
| Payer | Collection Rate | Revenue Gap |
|-------|----------------|-------------|
| Blue Cross | 91.3% | $509,398 |
| UnitedHealth | 90.4% | $579,708 |
| Aetna | 88.8% | $704,550 |
| Cigna | 87.8% | $762,204 |
| Medicare | 82.2% | $895,913 |
| Medicaid | 68.0% | $2,011,735 |
| **Self-Pay** | **45.0%** | **$3,417,480** |

> 💡 **Self-Pay alone accounts for 39% of all uncollected revenue** — the single highest risk segment requiring targeted financial counseling and payment plan strategies.

---

### Denial Rate by Department
| Department | Denial Rate | Revenue at Risk |
|------------|-------------|----------------|
| Orthopedics | 22.4% | $1,233,901 |
| Pulmonology | 19.0% | $1,176,592 |
| Oncology | 18.9% | $1,055,543 |
| Emergency | 18.1% | $1,403,860 |
| Neurology | 16.2% | $822,884 |
| Gastroenterology | 14.2% | $768,349 |
| Cardiology | 13.2% | $948,599 |

---

### Top Denial Reasons
| Reason | Occurrences | Revenue at Risk |
|--------|-------------|----------------|
| Missing documentation | 42 | $1,707,473 |
| Patient eligibility | 31 | $1,511,237 |
| Duplicate claim | 37 | $1,416,360 |
| Coding error | 34 | $1,405,369 |
| Prior authorization required | 30 | $1,369,289 |

> 💡 **"Missing documentation" is the #1 denial reason and 100% preventable** — a standardized pre-submission checklist could recover up to $1.7M in at-risk revenue.

---

### Hospital Performance Ranking
| Hospital | State | Type | Collection Rate | Readmission Rate |
|----------|-------|------|----------------|-----------------|
| LA Regional Hospital | CA | Non-Profit | 80.8% | 10.3% |
| Dallas Medical Center | TX | For-Profit | 80.5% | 10.5% |
| Miami Medical Center | FL | For-Profit | 80.2% | 7.3% |
| Seattle Care Hospital | WA | Non-Profit | 79.9% | 9.5% |
| Phoenix Medical | AZ | For-Profit | 78.9% | 13.8% |
| Philadelphia General | PA | Non-Profit | 78.8% | 17.0% |
| General Hospital NYC | NY | Non-Profit | 78.6% | 12.2% |
| Houston Care Center | TX | Government | 78.4% | 6.2% |
| Chicago Health System | IL | Non-Profit | 78.1% | 11.3% |
| San Antonio Health | TX | Government | 77.8% | 7.5% |

> 💡 **Philadelphia General has a 17% readmission rate** — nearly 3x higher than Houston Care Center (6.2%), suggesting significant gaps in discharge planning and post-acute care coordination.

---

### 30-Day Readmission by Department
| Department | Readmission Rate |
|------------|-----------------|
| Pulmonology | 13.1% |
| Orthopedics | 12.7% |
| Emergency | 11.9% |
| Cardiology | 10.5% |
| Oncology | 9.8% |
| Gastroenterology | 8.5% |
| Neurology | 6.8% |

---

## 🛠️ Tools & Technologies

- **SQL** — SQLite (via DB Browser for SQLite)
- **CSV** — dataset storage and exploration
- **Power BI** *(dashboard — coming soon)*

---

## 🗂️ Dataset

| Column | Description |
|--------|-------------|
| `claim_id` | Unique claim identifier |
| `hospital_name` | Hospital name |
| `state / city` | Hospital location |
| `hospital_type` | Non-Profit, For-Profit, or Government |
| `department` | Clinical department |
| `payer` | Insurance payer (Medicare, Medicaid, commercial, Self-Pay) |
| `admission_date` | Date of patient admission |
| `length_of_stay_days` | Number of inpatient days |
| `billed_amount` | Amount billed to payer |
| `collected_amount` | Amount actually collected |
| `collection_rate_pct` | Collected ÷ Billed × 100 |
| `claim_denied` | Whether the claim was denied (Yes/No) |
| `denial_reason` | Root cause of denial (if applicable) |
| `readmitted_30days` | Whether patient was readmitted within 30 days |

> Dataset generated with realistic parameters based on US healthcare industry benchmarks.

---

## 📁 Repository Structure

```
healthcare-revenue-cycle-analysis/
│
├── data/
│   └── hospital_claims.csv       # Main dataset (1,000 claims)
│
├── sql/
│   └── analysis.sql              # 10 queries with full comments
│
└── README.md
```

---

## ▶️ How to Run

1. Download [DB Browser for SQLite](https://sqlitebrowser.org/) (free, no coding required)
2. Open the app → New Database → import `data/hospital_claims.csv`
3. Go to the **Execute SQL** tab
4. Paste any query from `sql/analysis.sql` and click Run

---

## 👩‍💻 About the Author

**Monique Assis** — Healthcare Data Analyst with 10+ years of experience in clinical data, revenue cycle analytics, and BI solutions at one of Brazil's largest hospital networks.

- 🔗 [LinkedIn](https://www.linkedin.com/in/monique-r-assis/)
- 📧 moniquerassis@gmail.com

---

*Dataset is synthetic but modeled on real-world US hospital billing benchmarks.*
