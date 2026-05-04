Table etl-pipeline-automation:dbt_sushant.stage_03_behavior

                                              Query                                              
 ----------------------------------------------------------------------------------------------- 
  -- STAGE 3: The Senior Analyst - Time Between Purchases                                        
  -- Save this script as "03_customer_behavior.sql"                                              
                                                                                                 
  WITH OrderHistory AS (                                                                         
    -- Step 1: Get every successful order and the date it was placed                             
    SELECT                                                                                       
      user_id,                                                                                   
      order_id,                                                                                  
      DATE(created_at) AS order_date                                                             
    FROM                                                                                         
      `bigquery-public-data.thelook_ecommerce.orders`                                            
    WHERE                                                                                        
      status = 'Complete'                                                                        
  ),                                                                                             
                                                                                                 
  NextOrderTracking AS (                                                                         
    -- Step 2: Use the LEAD() Window Function to peek at the user's next row of data             
    SELECT                                                                                       
      user_id,                                                                                   
      order_id,                                                                                  
      order_date,                                                                                
      LEAD(order_date) OVER(PARTITION BY user_id ORDER BY order_date) AS next_order_date         
    FROM                                                                                         
      OrderHistory                                                                               
  )                                                                                              
                                                                                                 
  -- Step 3: Calculate the exact number of days between those two purchases                      
  SELECT                                                                                         
    user_id,                                                                                     
    order_date AS current_purchase_date,                                                         
    next_order_date,                                                                             
    DATE_DIFF(next_order_date, order_date, DAY) AS days_until_next_purchase                      
  FROM                                                                                           
    NextOrderTracking                                                                            
  WHERE                                                                                          
    next_order_date IS NOT NULL -- Only show customers who actually came back and bought again!  
  ORDER BY                                                                                       
    days_until_next_purchase DESC                                                                
  LIMIT 20;                                                                                      

