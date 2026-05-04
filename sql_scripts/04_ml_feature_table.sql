Table etl-pipeline-automation:dbt_sushant.stage_04_features

                                        Query                                         
 ------------------------------------------------------------------------------------ 
  -- STAGE 4: ML Data Architect - Feature Engineering for Random Forest               
  -- Save this script as "04_ml_feature_table.sql"                                    
                                                                                      
  SELECT                                                                              
    u.id AS user_id,                                                                  
    u.country,                                                                        
                                                                                      
    -- Feature 1: Total volume (How many things have they ever bought?)               
    COUNT(oi.id) AS total_items_purchased,                                            
                                                                                      
    -- Feature 2: Monetary Value (How much money have they spent in their lifetime?)  
    ROUND(SUM(oi.sale_price), 2) AS lifetime_value,                                   
                                                                                      
    -- Feature 3: Account Age (How long have they been a customer?)                   
    DATE_DIFF(CURRENT_DATE(), DATE(u.created_at), DAY) AS account_age_days,           
                                                                                      
    -- TARGET VARIABLE: Has this customer ever returned an item? (1 = Yes, 0 = No)    
    -- This is the exact column your Random Forest model will try to predict!         
    MAX(CASE WHEN oi.status = 'Returned' THEN 1 ELSE 0 END) AS has_returned_item      
                                                                                      
  FROM                                                                                
    `bigquery-public-data.thelook_ecommerce.users` u                                  
  JOIN                                                                                
    `bigquery-public-data.thelook_ecommerce.order_items` oi                           
  ON                                                                                  
    u.id = oi.user_id                                                                 
  GROUP BY                                                                            
    u.id, u.country, u.created_at                                                     
  ORDER BY                                                                            
    lifetime_value DESC                                                               
  LIMIT 100;                                                                          

