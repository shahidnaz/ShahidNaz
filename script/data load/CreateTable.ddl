use centro
go

--Notes: these are raw table to just copy data from file to database without any changes.
--			these table doens't have primary key or any constratint 

IF OBJECT_ID('dbo.raw_salesperson', 'U') IS NOT NULL 
  DROP TABLE dbo.raw_salesperson;

IF OBJECT_ID('dbo.raw_campaign', 'U') IS NOT NULL 
  DROP TABLE dbo.raw_campaign;

IF OBJECT_ID('dbo.campaign', 'U') IS NOT NULL 
  DROP TABLE dbo.campaign;

IF OBJECT_ID('dbo.salesperson', 'U') IS NOT NULL 
  DROP TABLE dbo.salesperson;

CREATE TABLE raw_salesperson
(
salesperson_id		int,
salesperson_name	varchar(200),
title				varchar(200),
sales_manager_id	int,
sales_manager_name	varchar(200),
sales_director_id	int,
sales_director_name	varchar(200),
sales_vp_id			int,
sales_vp_name		varchar(200),
sales_team_id		int,
sales_team_name		varchar(200)
)



CREATE TABLE raw_campaign
(
campaign_id					varchar(200),
campaign_status				varchar(15),
campaign_ordered_at			datetime,
next_revision_ordered_at	datetime,
revision_number				int,
is_last_ordered_campaign	varchar(1),
campaign_start_date			date,
campaign_end_date			date,
salesperson_id				int,
gross_revenue				money, 
net_revenue					money
)




CREATE TABLE salesperson
(
salesperson_id		int,
salesperson_name	varchar(200),
title				varchar(200),
sales_manager_id	int,
sales_manager_name	varchar(200),
sales_director_id	int,
sales_director_name	varchar(200),
sales_vp_id			int,
sales_vp_name		varchar(200),
sales_team_id		int,
sales_team_name		varchar(200)
CONSTRAINT [PK_salesperson_salesperson_id] PRIMARY KEY CLUSTERED 
(
salesperson_id
)
) ON [PRIMARY]




CREATE TABLE campaign
(
record_id					int identity(1,1),
campaign_id					varchar(200),
campaign_status				varchar(15),
campaign_ordered_at			datetime,
next_revision_ordered_at	datetime,
revision_number				int,
is_last_ordered_campaign	bit,
campaign_start_date			date,
campaign_end_date			date,
salesperson_id				int,
gross_revenue				money, 
net_revenue					money

CONSTRAINT [PK_campaign_record_id] PRIMARY KEY CLUSTERED 
(
record_id
)
) ON [PRIMARY]

ALTER TABLE [dbo].[campaign]  WITH CHECK ADD  CONSTRAINT [FK_salesperson_salesperson_id] FOREIGN KEY([salesperson_id])
REFERENCES [dbo].salesperson ([salesperson_id])
GO

