

truncate table raw_salesperson

BULK INSERT raw_salesperson
FROM 'C:\Users\snaz-pc\Documents\GitHub\Cebtro_BI\Centro_BI\master\data\sample_salesperson.csv'  --Macintosh(CR) UTF-8
WITH 
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\r',
    TABLOCK
)


truncate table raw_campaign

BULK INSERT raw_campaign
FROM 'C:\Users\snaz-pc\Documents\GitHub\Cebtro_BI\Centro_BI\master\data\sample_campaigns.csv'   --Windows (CR LF) UTF-8
WITH 
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
)

--populate  table

TRUNCATE TABLE campaign;
DELETE FROM  salesperson;


INSERT INTO [dbo].[salesperson]
           ([salesperson_id]
           ,[salesperson_name]
           ,[title]
           ,[sales_manager_id]
           ,[sales_manager_name]
           ,[sales_director_id]
           ,[sales_director_name]
           ,[sales_vp_id]
           ,[sales_vp_name]
           ,[sales_team_id]
           ,[sales_team_name])

SELECT     
            [salesperson_id]
           ,[salesperson_name]
           ,[title]
           ,[sales_manager_id]
           ,[sales_manager_name]
           ,[sales_director_id]
           ,[sales_director_name]
           ,[sales_vp_id]
           ,[sales_vp_name]
           ,[sales_team_id]
           ,[sales_team_name]
FROM dbo.raw_salesperson;



INSERT INTO dbo.campaign
	  ([campaign_id]
      ,[campaign_status]
      ,[campaign_ordered_at]
      ,[next_revision_ordered_at]
      ,[revision_number]
      ,[is_last_ordered_campaign]
      ,[campaign_start_date]
      ,[campaign_end_date]
      ,[salesperson_id]
      ,[gross_revenue]
      ,[net_revenue]
) 
SELECT 
       [campaign_id]
      ,[campaign_status]
      ,[campaign_ordered_at] 
      ,[next_revision_ordered_at] 
      ,[revision_number]
      ,case 
		when [is_last_ordered_campaign]='t' then 1 else 0 end
      ,[campaign_start_date]
      ,[campaign_end_date]
      ,[salesperson_id]
      ,[gross_revenue]
      ,[net_revenue]
  FROM [dbo].[raw_campaign]
GO



