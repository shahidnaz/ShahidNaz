USE Centro
GO

/*
Assumptions
 
  include all campaign status (pending,live and completed) 

--1 List the Sales Team name, Gross Revenue and Net Revenue of the latest ordered campaigns by Sales Team.
consider left join
*/
SELECT sales_team_name
	,isnull(sum(gross_revenue), 0) gross_revenue
	,isnull(sum(net_revenue), 0) net_revenue
FROM salesperson s
LEFT JOIN campaign c ON c.salesperson_id = s.salesperson_id
	AND c.is_last_ordered_campaign = 1
GROUP BY sales_team_name

--*********************************************************************************************************
/*
 as per given information "margin (percent) = net_revenue / gross_revenue" and "margin (dollar amount) = Margin percent of gross_revenue" 
which means net_revenue = margin dollar amount but, as per given information "net_revenue= gross_revenue - costs - expenses - margin amount" 
which makes "margin amount = gross revenue - net revenue - costs - expenses" but, costs and expenses data is not availabale 
 I assume the cost=0 and expenses=0 which makes "margin amount = gross revenue - net revenue



--List the Sales Team name, Gross Revenue, Net Revenue, and Margin Revenue of the latest ordered campaigns by Sales Team. 

*/
SELECT sales_team_name
	,isnull(sum(gross_revenue), 0) gross_revenue
	,isnull(sum(net_revenue), 0) net_revenue
	,isnull(sum(gross_revenue - net_revenue), 0) margin_amount
FROM salesperson s
LEFT JOIN campaign c ON c.salesperson_id = s.salesperson_id
	AND c.is_last_ordered_campaign = 1
GROUP BY sales_team_name

--****************************************************************************************************************
-- List all Sales Person names from the salesperson table with his/her Gross Revenue, Net Revenue, and Margin Revenue of the latest ordered campaigns.
SELECT salesperson_name
	,isnull(sum(gross_revenue), 0) gross_revenue
	,isnull(sum(net_revenue), 0) net_revenue
	,isnull(sum(gross_revenue - net_revenue), 0) margin_amount
FROM salesperson s
LEFT JOIN campaign c ON c.salesperson_id = s.salesperson_id
	AND c.is_last_ordered_campaign = 1
GROUP BY salesperson_name

--*********************************************************************************************************************
-- List the Sales Persons name who had more than 3 Campaigns assigned to them.
SELECT s.salesperson_name
FROM campaign c
JOIN salesperson s ON c.salesperson_id = s.salesperson_id
	AND c.is_last_ordered_campaign = 1
GROUP BY s.salesperson_name
HAVING count(DISTINCT campaign_id) > 3

--**************************************************************************************************************************
--Latest ordered data not int the statment but, I assume only lastest ordered campaigns otherwise we will have double count
-- List the top 5 sellers in 2015 based on the Net Revenue.

SELECT *
FROM (
	SELECT salesperson_name
		,total_net_revenue
		,rank() OVER (
			ORDER BY total_net_revenue DESC
			) seller_rank
	FROM (
		SELECT s.salesperson_name
			,sum((c.net_revenue / TOTAL_COMPAIGN_MONTHS) * MONTHS_2015) total_net_revenue
		FROM salesperson s
		JOIN (
			SELECT DATEDIFF(MONTH, campaign_start_date, campaign_end_date) + 1 TOTAL_COMPAIGN_MONTHS
				,CASE 
					WHEN campaign_start_date < '2015-01-01'
						AND campaign_end_date < '2016-01-01'
						THEN DATEDIFF(MONTH, '2015-01-01', campaign_end_date) + 1
					WHEN campaign_start_date > '2014-12-31'
						AND campaign_end_date > '2015-12-31'
						THEN DATEDIFF(MONTH, campaign_start_date, '2015-12-31') + 1
					WHEN campaign_start_date > '2014-12-31'
						AND campaign_end_date < '2016-01-01'
						THEN DATEDIFF(MONTH, campaign_start_date, campaign_end_date) + 1
					END MONTHS_2015
				,campaign_id
				,net_revenue
				,salesperson_id
			FROM campaign c
			WHERE (
					year(campaign_start_date) <= 2015
					AND year(campaign_end_date) >= 2015
					)
				AND c.is_last_ordered_campaign = 1
			) c ON s.salesperson_id = c.salesperson_id
		GROUP BY s.salesperson_name
		) fo
	) foo
WHERE seller_rank <= 5

--***************************************************************************************************************************
--Latest ordered data not in the statment but, I assume only lastest ordered campaigns otherwise we will have double count	
-- List the Top Seller in each Sales Team who exceeded $100,000 Gross Revenue.
SELECT sales_team_name
	,salesperson_name
FROM (
	SELECT s.sales_team_name
		,s.salesperson_name
		,sum(c.gross_revenue) gross_revenue
		,row_number() OVER (
			PARTITION BY s.sales_team_name ORDER BY sum(c.gross_revenue) DESC
			) rn
	FROM campaign c
	JOIN salesperson s ON c.salesperson_id = s.salesperson_id
		AND c.is_last_ordered_campaign = 1
	GROUP BY s.sales_team_name
		,s.salesperson_name
	HAVING sum(c.gross_revenue) > 100000
	) foo
WHERE rn = 1

--********************************************************************************************************************************
-- List the Year, Quarter, Month, Sales team name, Sales Person name, Gross Revenue, Net Revenue and Margin Revenue of the latest ordered campaigns by Year
--, Quarter, Month, Sales Team, and Sales Person. The Year, Quarter and Month are based on the Plan Ordered At of the lasted ordered campaigns.
SELECT year(campaign_ordered_at) year
	,datepart(QUARTER, campaign_ordered_at) QUARTER
	,month(campaign_ordered_at) month
	,sales_team_name
	,salesperson_name
	,sum(gross_revenue) gross_revenue
	,sum(net_revenue) net_revenue
	,sum(gross_revenue - net_revenue) margin_amount
FROM campaign c
JOIN salesperson s ON c.salesperson_id = s.salesperson_id
	AND c.is_last_ordered_campaign = 1
GROUP BY year(campaign_ordered_at)
	,datepart(QUARTER, campaign_ordered_at)
	,month(campaign_ordered_at)
	,sales_team_name
	,salesperson_name

--*************************************************************************************************************************************
-- List the Sales team name, Sales Manager name, Gross Revenue and Net Revenue of the latest ordered campaigns by Sales team and Sales Manager.
SELECT s.sales_team_name
	,isnull(m.sales_manager_name, s.salesperson_name) sales_manager_name
	,isnull(sum(gross_revenue), 0) gross_revenue
	,isnull(sum(net_revenue), 0) net_revenue
	,isnull(sum(gross_revenue - net_revenue), 0) margin_amount
FROM salesperson s
LEFT JOIN campaign c ON c.salesperson_id = s.salesperson_id
	AND c.is_last_ordered_campaign = 1
LEFT JOIN salesperson m ON s.sales_manager_id = m.salesperson_id
GROUP BY s.sales_team_name
	,isnull(m.sales_manager_name, s.salesperson_name)

--*********************************************************************************************************************************************
-- List the Sales VP name, Sales VP Gross Revenue, Sales VP Net Revenue, Sales Director Name, Sales Director Gross Revenue, Sales Director Net Revenue, Sales Manager name, 
--Sales Manager Gross Revenue, Sales Manager Net Revenue of the latest ordered campaigns. The Gross Revenue 
--and Net revenue should include all the revenue numbers from all salespeople who report to them.
--assumptions: if salesperson doesn't have sales manager then he/she own manager, same rule apply on director and vp


SELECT [sales_vp_name]
	,sum(gross_revenue) OVER (PARTITION BY [sales_vp_name]) VP_gross_revenue
	,sum(net_revenue) OVER (PARTITION BY [sales_vp_name]) VP_net_revenue
	,sum(margin_amount) OVER (PARTITION BY [sales_vp_name]) VP_margin_amount
	,[sales_director_name]
	,sum(gross_revenue) OVER (PARTITION BY [sales_director_name]) director_gross_revenue
	,sum(net_revenue) OVER (PARTITION BY [sales_director_name]) director_net_revenue
	,sum(margin_amount) OVER (PARTITION BY [sales_director_name]) director_margin_amount
	,[sales_manager_name]
	,gross_revenue manager_gross_revenue
	,net_revenue manager_net_revenue
	,margin_amount manager_margin_amount
FROM (
	SELECT isnull([sales_manager_name], salesperson_name) [sales_manager_name]
		,isnull([sales_director_name], salesperson_name) [sales_director_name]
		,isnull([sales_vp_name], salesperson_name) [sales_vp_name]
		,isnull(sum(gross_revenue), 0) gross_revenue
		,isnull(sum(net_revenue), 0) net_revenue
		,isnull(sum(gross_revenue - net_revenue), 0) margin_amount
	FROM salesperson s
	LEFT JOIN campaign c ON c.salesperson_id = s.salesperson_id
		AND c.is_last_ordered_campaign = 1
	GROUP BY isnull([sales_manager_name], salesperson_name)
		,isnull([sales_director_name], salesperson_name)
		,isnull([sales_vp_name], salesperson_name)
	) fo
ORDER BY [sales_vp_name]
	,[sales_director_name]
	,[sales_manager_name]
