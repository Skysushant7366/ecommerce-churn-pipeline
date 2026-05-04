from google.cloud import bigquery
import pandas as pd
import joblib

print("🌙 Night Shift Pipeline: REAL DATA MODE...")

# 1. Load the Champion Model
print("🧠 Loading XGBoost Champion Model...")
model_path = 'xgboost_churn_champion.joblib'
model = joblib.load(model_path)

# 2. Extract Data using a SQL JOIN
client = bigquery.Client()

# This query bridges your two tables using user_id
sql_query = """
    SELECT 
        f.user_id, 
        f.total_items_purchased, 
        f.lifetime_value, 
        f.account_age_days, 
        f.has_returned_item
    FROM `etl-pipeline-automation.dbt_sushant.06_feature_engineering` AS f
    INNER JOIN `etl-pipeline-automation.dbt_sushant.07_customer_behaviour` AS b
        ON f.user_id = b.user_id
    WHERE b.current_purchase_date = '2019-05-03' 
"""

print("📊 Joining tables and pulling data from BigQuery...")
df = client.query(sql_query).to_dataframe()

if df.empty:
    print("💤 No customers found for this date. Check your table names.")
else:
    # 3. Predict Churn Risk
    print(f"🔮 Running AI Predictions for {len(df)} customers...")
    features = df[['total_items_purchased', 'lifetime_value', 'account_age_days', 'has_returned_item']]
    
    # Probabilities for the 'Churn' class
    df['churn_probability'] = model.predict_proba(features)[:, 1]
    df['risk_level'] = df['churn_probability'].apply(lambda x: 'High Risk' if x > 0.50 else 'Safe')

    # 4. Save results for the Dashboard
    df.to_csv('todays_churn_risks.csv', index=False)
    print("✅ Pipeline Complete! 'todays_churn_risks.csv' generated.")
