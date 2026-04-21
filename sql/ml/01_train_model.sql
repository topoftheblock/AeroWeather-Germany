CREATE OR REPLACE MODEL `your_project.aviation.delay_prediction_model`
OPTIONS(
  model_type='BOOSTED_TREE_CLASSIFIER',  
  input_label_cols=['is_delayed'],       
  data_split_method='AUTO_SPLIT'         
) AS 
SELECT
  IF(current_departure_delay > 15, 1, 0) AS is_delayed,
  current_origin,
  current_temp_c,
  previous_arrival_delay,
  previous_origin,
  previous_origin_temp_c,
  EXTRACT(HOUR FROM actual_departure) AS departure_hour,
  EXTRACT(DAYOFWEEK FROM actual_departure) AS day_of_week
FROM `your_project.aviation.fct_cascading_delays` 
WHERE previous_arrival_delay IS NOT NULL;