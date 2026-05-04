Table etl-pipeline-automation:dbt_sushant.stage_05_affinity

                                                  Query                                                  
 ------------------------------------------------------------------------------------------------------- 
  -- STAGE 5: Market Basket Analysis (Product Affinity)                                                  
  -- Save as "05_market_basket_recommendations.sql"                                                      
                                                                                                         
  WITH CartItems AS (                                                                                    
    -- Step 1: Get every order and the names of the products inside them                                 
    SELECT                                                                                               
      oi.order_id,                                                                                       
      oi.product_id,                                                                                     
      p.category,                                                                                        
      p.name AS product_name                                                                             
    FROM                                                                                                 
      `bigquery-public-data.thelook_ecommerce.order_items` oi                                            
    JOIN                                                                                                 
      `bigquery-public-data.thelook_ecommerce.products` p                                                
    ON                                                                                                   
      oi.product_id = p.id                                                                               
    WHERE                                                                                                
      oi.status NOT IN ('Cancelled', 'Returned')                                                         
  )                                                                                                      
                                                                                                         
  -- Step 2: The Self-Join (Joining the cart to itself to find pairs)                                    
  SELECT                                                                                                 
    a.category AS category_1,                                                                            
    a.product_name AS product_1,                                                                         
    b.category AS category_2,                                                                            
    b.product_name AS product_2,                                                                         
    COUNT(DISTINCT a.order_id) AS times_bought_together                                                  
  FROM                                                                                                   
    CartItems a                                                                                          
  JOIN                                                                                                   
    CartItems b                                                                                          
  ON                                                                                                     
    a.order_id = b.order_id                                                                              
    AND a.product_id < b.product_id -- This prevents mirroring (e.g., matching Hat+Shirt and Shirt+Hat)  
  GROUP BY                                                                                               
    category_1, product_1, category_2, product_2                                                         
  ORDER BY                                                                                               
    times_bought_together DESC                                                                           
  LIMIT 10;                                                                                              

