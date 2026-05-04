Table etl-pipeline-automation:dbt_sushant.stage_06_retention

                                                 Query                                                  
 ------------------------------------------------------------------------------------------------------ 
  -- STAGE 6: Cohort Retention Curves                                                                   
  -- Save as "06_cohort_retention.sql"                                                                  
                                                                                                        
  WITH FirstPurchase AS (                                                                               
    -- Step 1: Find the exact month every user made their VERY FIRST purchase                           
    SELECT                                                                                              
      user_id,                                                                                          
      DATE_TRUNC(DATE(MIN(created_at)), MONTH) AS cohort_month                                          
    FROM                                                                                                
      `bigquery-public-data.thelook_ecommerce.orders`                                                   
    WHERE                                                                                               
      status = 'Complete'                                                                               
    GROUP BY                                                                                            
      user_id                                                                                           
  ),                                                                                                    
                                                                                                        
  AllPurchases AS (                                                                                     
    -- Step 2: Grab all purchases and calculate how many months passed since their first order          
    SELECT                                                                                              
      o.user_id,                                                                                        
      f.cohort_month,                                                                                   
      DATE_TRUNC(DATE(o.created_at), MONTH) AS activity_month,                                          
      DATE_DIFF(DATE_TRUNC(DATE(o.created_at), MONTH), f.cohort_month, MONTH) AS month_index            
    FROM                                                                                                
      `bigquery-public-data.thelook_ecommerce.orders` o                                                 
    JOIN                                                                                                
      FirstPurchase f                                                                                   
    ON                                                                                                  
      o.user_id = f.user_id                                                                             
    WHERE                                                                                               
      o.status = 'Complete'                                                                             
  )                                                                                                     
                                                                                                        
  -- Step 3: Count how many unique users from each cohort came back in Month 0, Month 1, Month 2, etc.  
  SELECT                                                                                                
    cohort_month,                                                                                       
    month_index,                                                                                        
    COUNT(DISTINCT user_id) AS active_users                                                             
  FROM                                                                                                  
    AllPurchases                                                                                        
  GROUP BY                                                                                              
    cohort_month, month_index                                                                           
  ORDER BY                                                                                              
    cohort_month DESC, month_index ASC;                                                                 

