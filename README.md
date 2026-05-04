# 🚀 Enterprise E-Commerce ML & Analytics Pipeline
**Architected by: Sushant Kumar Yadav**

## 📊 Executive Dashboard (Looker Studio)
*(Replace this text with your Looker screenshot later!)*

## 🏗️ 1. Project Overview & Architecture
This project is an end-to-end implementation of the **Modern Data Stack**. It demonstrates a complete data lifecycle—from raw warehouse ingestion to advanced statistical modeling, executive BI, and automated production deployment.

### Tech Stack
*   **Data Warehousing:** Google BigQuery (Project: `etl-pipeline-automation`)
*   **Transformation:** dbt (Data Build Tool) & 7-Stage SQL Pipeline
*   **Analytics:** Looker Studio Growth & Retention Command Center ($10.76M Revenue)
*   **AI/ML Engine:** Google Colab (XGBoost, K-Means Clustering, Apriori Algorithm)
*   **MLOps:** GCP Compute Engine (Linux VM) with automated Cron job scheduling

---

## 🛠️ 2. Phase 1: The 7-Stage SQL Transformation Pipeline
I architected a modular SQL system in BigQuery to transform raw data into high-value insights.

*   **Stage 1: Data Engineering (Messy_Data_cleaning)** – Cleaned raw strings with `TRIM(LOWER())` and created generational age cohorts (Gen Z, Millennials, etc.).
*   **Stage 2: Core Revenue Analytics (Revenue_By_cohort)** – Aggregated **$10.76M in Revenue** across global markets, identifying China and the USA as high-volume leaders.
*   **Stage 3: Behavioral Intelligence (Customer_Behaviour_Time)** – Used `LEAD()` window functions to calculate the "Inter-purchase Interval," measuring the exact days between customer transactions.
*   **Stage 4: ML Feature Engineering (Feature_Engineering)** – Built a flattened table with 3 predictive features (LTV, Recency, Frequency) and a binary target label for returns.
*   **Stage 5: Market Basket Analysis (Product_affinity_paired)** – Used a SQL self-join to uncover product co-purchase patterns, like the link between Maternity and Intimates.
*   **Stage 6: Cohort Retention (Cohort_retention)** – Built monthly retention heatmaps tracking customer loyalty from Oct 2025 acquisition waves.
*   **Stage 7: UX Funnel Analytics (Funnel_and_turnaround_time)** – Calculated "Turnaround Time" in minutes between adding to cart and completing a purchase.

---

## 🧠 3. Phase 2: Advanced AI & Statistical Analysis
I executed deep-dive analytics in **Google Colab** to provide predictive capabilities to the business.

### Association Rule Mining (Apriori)
*   **Discovery:** Identified a **1.3x Lift** for Intimates categories among Maternity shoppers.
*   **Metric Focus:** Analyzed `Support`, `Confidence`, and `Lift` to rank cross-sell opportunities.

### Customer Persona Segmentation (K-Means Clustering)
*   **Clustering Logic:** Applied 3D RFM modeling to segment 79K customers into 4 personas.
*   **Key Persona:** Cluster 1 represents "True VIPs" with an average LTV of $615 and frequent purchase habits.

### Churn Prediction (XGBoost Classifier)
*   **Optimization:** Utilized `GridSearchCV` to find the absolute best settings: `{'learning_rate': 0.01, 'max_depth': 3, 'n_estimators': 100}`.
*   **Performance:** Achieved a **Weighted F1-Score of 0.83** with a **95% Recall** for the churner class.
*   **Explainability:** Used **SHAP Values** to prove that `account_age_days` is the #1 predictor of whether a customer will leave.

---

## ⚙️ 4. Phase 3: MLOps & Production Automation
The final "Champion" model was deployed to a **Google Cloud VM** for autonomous operation.

*   **Automation:** A **Linux Cron Job** triggers the `batch_predict.py` worker every morning at **7:30 AM**.
*   **Management Portal:** A professional **Streamlit** dashboard featuring:
    *   **Ad-Hoc Lookup:** Instant churn risk analysis for individual customers.
    *   **Bulk Processing:** A tool for managers to grade thousands of customers via CSV upload for immediate marketing re-engagement.
