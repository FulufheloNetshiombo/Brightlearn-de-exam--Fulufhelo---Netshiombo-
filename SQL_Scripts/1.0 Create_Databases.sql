SELECT *
  FROM [stg_brightlearn_sales].[dbo].[BrightLearn_Raw_Data]
  group by sku
  having count(*) > 1;
