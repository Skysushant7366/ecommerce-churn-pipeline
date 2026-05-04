Table etl-pipeline-automation:dbt_sushant.stage_01_cleaning

                                     Query                                      
 ------------------------------------------------------------------------------ 
  -- STAGE 1: Data Engineering - Cleaning the Users Table                       
                                                                                
  SELECT                                                                        
    id AS user_id,                                                              
                                                                                
    -- 1. String Manipulation: Cleaning up messy text inputs                    
    TRIM(LOWER(first_name)) AS first_name_clean,                                
    TRIM(LOWER(last_name)) AS last_name_clean,                                  
                                                                                
    -- 2. Handling Nulls: If traffic source is blank, label it 'Unknown'        
    COALESCE(traffic_source, 'Unknown') AS traffic_source_clean,                
                                                                                
    -- 3. Data Type Casting: Extracting just the Date from a complex Timestamp  
    DATE(created_at) AS account_creation_date,                                  
                                                                                
    -- 4. Conditional Logic: Creating demographic cohorts                       
    age,                                                                        
    CASE                                                                        
      WHEN age < 18 THEN 'Under 18'                                             
      WHEN age BETWEEN 18 AND 24 THEN '18-24 (Gen Z)'                           
      WHEN age BETWEEN 25 AND 40 THEN '25-40 (Millennials)'                     
      WHEN age BETWEEN 41 AND 56 THEN '41-56 (Gen X)'                           
      ELSE '57+ (Boomers+)'                                                     
    END AS age_cohort,                                                          
                                                                                
    country,                                                                    
    city                                                                        
                                                                                
  FROM                                                                          
    `bigquery-public-data.thelook_ecommerce.users`                              
  WHERE                                                                         
    -- 5. Basic Quality Control: Ensure we only pull valid records              
    created_at IS NOT NULL;                                                     

