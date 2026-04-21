-- 1. Create the Machine Learning Model
CREATE OR REPLACE MODEL `your_project.aviation.delay_prediction_model`
OPTIONS(
  model_type='BOOSTED_TREE_CLASSIFIER',  -- Uses XGBoost under the hood
  input_label_cols=['is_delayed'],       -- The column we want to predict
  data_split_method='AUTO_SPLIT'         -- Automatically handles Train/Test splitting
) AS 

-- 2. Define the Training Data
SELECT
  -- THE TARGET (What we are trying to predict: 1 for Yes, 0 for No)
  IF(current_departure_delay > 15, 1, 0) AS is_delayed,
  
  -- THE FEATURES (The data the model will learn from)
  current_origin,
  current_temp_c,
  previous_arrival_delay,
  previous_origin,
  previous_origin_temp_c,
  
  -- Feature Engineering: Extracting time-based patterns
  EXTRACT(HOUR FROM actual_departure) AS departure_hour,
  EXTRACT(DAYOFWEEK FROM actual_departure) AS day_of_week
  
FROM `your_project.aviation.fct_cascading_delays` -- Referencing the final table we built
WHERE previous_arrival_delay IS NOT NULL;