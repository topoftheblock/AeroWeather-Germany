SELECT 
    predicted_is_delayed,
    predicted_is_delayed_probs
FROM ML.PREDICT(
    MODEL `your_project.aviation.delay_prediction_model`,
    (SELECT 
        'EDDF' AS current_origin, 
        -2.0 AS current_temp_c, 
        45.0 AS previous_arrival_delay, 
        'EDDM' AS previous_origin,
        0.5 AS previous_origin_temp_c,
        8 AS departure_hour,      
        3 AS day_of_week          
    )
);