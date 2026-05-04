Table etl-pipeline-automation:dbt_sushant.stage_02_revenue

                                        Query                                        
 ----------------------------------------------------------------------------------- 
  -- STAGE 2: The Core Analyst - Revenue by Demographic                              
  -- Save this script in your portfolio as "02_revenue_by_cohort.sql"                
                                                                                     
  WITH CleanedUsers AS (                                                             
    -- This is your exact code from Stage 1, acting as our clean foundation!         
    SELECT                                                                           
      id AS user_id,                                                                 
      CASE                                                                           
        WHEN age < 18 THEN 'Under 18'                                                
        WHEN age BETWEEN 18 AND 24 THEN '18-24 (Gen Z)'                              
        WHEN age BETWEEN 25 AND 40 THEN '25-40 (Millennials)'                        
        WHEN age BETWEEN 41 AND 56 THEN '41-56 (Gen X)'                              
        ELSE '57+ (Boomers+)'                                                        
      END AS age_cohort,                                                             
      country                                                                        
    FROM                                                                             
      `bigquery-public-data.thelook_ecommerce.users`                                 
    WHERE                                                                            
      created_at IS NOT NULL                                                         
  )                                                                                  
                                                                                     
  -- Now, we join our clean users to the money they spent                            
  SELECT                                                                             
    cu.age_cohort,                                                                   
    cu.country,                                                                      
    COUNT(DISTINCT oi.order_id) AS total_orders_placed,                              
    ROUND(SUM(oi.sale_price), 2) AS total_revenue_generated                          
  FROM                                                                               
    CleanedUsers cu                                                                  
  JOIN                                                                               
    `bigquery-public-data.thelook_ecommerce.order_items` oi                          
  ON                                                                                 
    cu.user_id = oi.user_id                                                          
  WHERE                                                                              
    oi.status = 'Complete' -- Crucial: We only count orders that actually finished!  
  GROUP BY                                                                           
    cu.age_cohort,                                                                   
    cu.country                                                                       
  ORDER BY                                                                           
    total_revenue_generated DESC                                                     
  LIMIT 20;                                                                          

