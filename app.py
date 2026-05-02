import streamlit as st
import joblib
import pandas as pd

# Load the Champion Engine
model_path = '/content/drive/MyDrive/Ecommerce Pipeline April2026/xgboost_churn_champion.joblib'
model = joblib.load(model_path)

# ==========================================
# TOOL 1: SINGLE CUSTOMER LOOKUP (UPGRADED)
# ==========================================
st.title("🚀 Customer Churn Predictor (Pro Version)")
st.write("Enter a single customer's details below to see their exact risk profile.")

account_age = st.slider("Account Age (Days)", min_value=0, max_value=2000, value=150)
total_items = st.number_input("Total Items Purchased", min_value=0, value=5)
lifetime_value = st.number_input("Lifetime Value ($)", min_value=0.0, value=250.0)
has_returned = st.selectbox("Has Returned an Item?", options=[0, 1], format_func=lambda x: "Yes (1)" if x == 1 else "No (0)")

if st.button("Predict Single Customer"):
    input_data = pd.DataFrame({
        'total_items_purchased': [total_items],
        'lifetime_value': [lifetime_value],
        'account_age_days': [account_age],
        'has_returned_item': [has_returned]
    })

    # 🔥 THE UPGRADE: We use predict_proba() instead of predict()
    # This returns an array like [0.15, 0.85] (15% chance to stay, 85% chance to churn)
    probabilities = model.predict_proba(input_data)[0]

    # We grab the second number (Index 1), which is the exact probability of churning
    churn_risk = probabilities[1]

    st.markdown("---")
    st.subheader("🔮 AI Risk Assessment")

    # Create a beautiful visual metric and progress bar
    st.metric(label="Churn Probability", value=f"{churn_risk * 100:.1f}%")
    st.progress(float(churn_risk))

    # Dynamic business advice based on exact thresholds
    if churn_risk > 0.75:
        st.error("⚠️ CRITICAL RISK: Over 75% chance of churn. Manager intervention required!")
    elif churn_risk > 0.40:
        st.warning("⚠️ MEDIUM RISK: Customer is wavering. Send a targeted email discount.")
    else:
        st.success("✅ SAFE: This customer is highly engaged.")

# ==========================================
# TOOL 2: BULK UPLOAD (UPGRADED)
# ==========================================
st.markdown("---")
st.header("📁 Bulk Prediction (For Managers)")
st.write("Upload a CSV file to grade thousands of customers simultaneously.")

uploaded_file = st.file_uploader("Upload your Customer CSV", type=["csv"])

if uploaded_file is not None:
    bulk_data = pd.read_csv(uploaded_file)
    required_columns = ['total_items_purchased', 'lifetime_value', 'account_age_days', 'has_returned_item']

    if all(col in bulk_data.columns for col in required_columns):
        st.success("File uploaded! AI is processing probabilities...")

        # Get the standard Yes/No predictions
        predictions = model.predict(bulk_data[required_columns])

        # 🔥 THE UPGRADE: Get the exact percentages for every single row
        probabilities_bulk = model.predict_proba(bulk_data[required_columns])[:, 1]

        # Attach BOTH columns to the manager's spreadsheet
        bulk_data['Churn_Verdict'] = predictions
        bulk_data['Exact_Risk_Percentage'] = (probabilities_bulk * 100).round(2).astype(str) + '%'

        st.write("Preview of Advanced Scored Data:")
        st.dataframe(bulk_data.head())

        csv_export = bulk_data.to_csv(index=False).encode('utf-8')
        st.download_button(
            label="⬇️ Download Advanced Spreadsheet",
            data=csv_export,
            file_name="advanced_churn_data.csv",
            mime="text/csv",
        )
    else:
        st.error(f"Error: Your CSV must contain these exact columns: {required_columns}")
