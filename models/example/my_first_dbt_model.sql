
/*
    Welcome to your first dbt model!
    Did you know that you can also configure models directly within SQL files?
    This will override configurations stated in dbt_project.yml

    Try changing "table" to "view" below
*/

{{ config(
    tags=["weekly"],
    materialized="table"
) }}

WITH base AS (

SELECT
id, 
media_type,
caption,
CASE 
  WHEN caption like '%data%strategy%' THEN 'Data Strategy' 
  WHEN caption like '%data%quality%' THEN 'Data Quality'
ELSE NULL END AS Post_type

FROM `trading-data-378602.instagram_business.media_history` 

), 
insights AS (

SELECT 
id, 
sum(video_photo_reach) AS video_photo_reach,
sum(video_photo_engagement) AS video_photo_eng, 
sum(like_count) AS likes

FROM `trading-data-378602.instagram_business.media_insights` 
GROUP BY 1 
), 

final AS (

SELECT  
Post_type, 
sum(B.video_photo_reach) as video_photo_reach, 
sum(video_photo_eng) as video_photo_engagement, 
sum(likes) as likes   

FROM base AS A 
INNER JOIN 
  insights AS B 

USING(id)

GROUP BY 1 
) 

SELECT * 

FROM final 
WHERE 1=1
AND Post_type IS NOT NULL 





