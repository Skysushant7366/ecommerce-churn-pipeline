Table etl-pipeline-automation:dbt_sushant.stage_07_funnel

                                           Query                                           
 ----------------------------------------------------------------------------------------- 
  -- STAGE 7: User-Level Funnel & Turnaround Time                                          
  -- Save as "07_web_turnaround_funnel.sql"                                                
                                                                                           
  WITH SessionTimeline AS (                                                                
    -- Step 1: Capture the exact timestamp of their FIRST click for each step              
    SELECT                                                                                 
      session_id,                                                                          
      user_id,                                                                             
      MIN(CASE WHEN event_type = 'product' THEN created_at END) AS viewed_item_time,       
      MIN(CASE WHEN event_type = 'cart' THEN created_at END) AS added_to_cart_time,        
      MIN(CASE WHEN event_type = 'purchase' THEN created_at END) AS checkout_time          
    FROM                                                                                   
      `bigquery-public-data.thelook_ecommerce.events`                                      
    GROUP BY                                                                               
      session_id, user_id                                                                  
  )                                                                                        
                                                                                           
  -- Step 2: Display the separate columns and calculate the Turnaround                     
  SELECT                                                                                   
    session_id,                                                                            
    user_id,                                                                               
                                                                                           
    -- The separate timestamp columns you asked for                                        
    viewed_item_time,                                                                      
    added_to_cart_time,                                                                    
    checkout_time,                                                                         
                                                                                           
    -- The Turnaround Analytics (Measuring the gap in MINUTES)                             
    TIMESTAMP_DIFF(added_to_cart_time, viewed_item_time, MINUTE) AS mins_view_to_cart,     
    TIMESTAMP_DIFF(checkout_time, added_to_cart_time, MINUTE) AS mins_cart_to_checkout,    
    TIMESTAMP_DIFF(checkout_time, viewed_item_time, MINUTE) AS total_mins_start_to_finish  
                                                                                           
  FROM                                                                                     
    SessionTimeline                                                                        
  -- Filter out people who just went to the homepage and left instantly                    
  WHERE                                                                                    
    viewed_item_time IS NOT NULL                                                           
  ORDER BY                                                                                 
    checkout_time DESC                                                                     
  LIMIT 100;                                                                               

