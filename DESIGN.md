Summary:

I used SQL SERVER to complete the task because SQL SERVER was installed on my laptop. Solution can deploy on any other database platform with minor changes.

Assumptions:

-Include all campaign status (Pending, Live and Completed)

- Only use latest revision campaign to calculate measures (gross revenue, net revenue & etc.)

-Margin amount calculation 
	As per given information “Margin (percent) = net revenue / gross revenue” and “Margin (dollar)=margin percent * gross revenue” which means “net revenue = margin dollar amount”.
	But there is another following calculation for margin dollar amount also given
    "net_revenue= gross_revenue - costs - expenses - margin amount"  which is equal to "margin amount = gross revenue - net revenue - costs - expenses" but, costs and expenses data is not available.
	I assume the cost=0 and expenses=0 which makes "margin amount = gross revenue - net revenue which I am going to use.

-Salesperson table management hierarchy
    A lot salesperson’s doesn’t have and sales manager assume they are their own manager if they       
    do not have manager, same applies on director and vp
    
Solution:
	
1. Provide a script in a `scripts/` directory to load the CSV data into database table(s) of your own design.
    Please  find two scrips in following folder 'script\data load'	


2. Provide SQL scripts in a `scripts/` directory to achieve the following: 
    Please  find 'Challenge questions.sql' script in following folder '\script\Challenge'


3. (BONUS ARCHITECTURE QUESTION) Provide a prose answer (on the order of a few paragraphs) in your `DESIGN.md` file for the following:
    - Imagine this problem scaled up to a large business working with terabytes to petabytes of information.  Would your solution be different?  What kinds of performance issues would you consider?  What overall architectural concerns would you have?  How might you structure a team around this kind of work?  Be creative!
		
	Would your solution be different?
		Yes. 
		Since we want to optimize reporting speed, we should consider the following:
			- Denormalizations for (frequently joined columns) 
			- Normalizations (to remove long strings)
			- Aggregations (by person-year, person-month)
			- Create additional table which keep only latest ordered campaign data (along with main campaign table)

	What kinds of performance issues would you consider?
		-Load time 
			- Every load required update/ rebuild aggregations
            - Every load also required updating latest ordered campaign data

	What overall architectural concerns would you have?
		-Impact on users
            If we have leverage to create new dataset on every load then we can use build database and replace the existing dataset, in the case we have minimum impact on user. But if, we have very large dataset and not able to create new set same time then data consistency and user impact is my big concerns. 

	How might you structure a team around this kind of work?
		-Following will be my team structure
			-Data Architect / Team lead 
			- Database developer / Software engineer 
			- QA 
			- Analyst / project manager 
