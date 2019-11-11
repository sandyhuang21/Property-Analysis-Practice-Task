--a.	Display a list of all property names and their property id¡¯s for Owner Id: 1426. 
SELECT TOP (1000) 	
	  p.[Name] as PropertyName
       ,[PropertyId]
	   ,[OwnerId]     
	 
  FROM [Keys].[dbo].[OwnerProperty] op
  inner join  dbo.Property p
  on p.id= op.PropertyId
  where OwnerId =1426


--b.	Display the current home value for each property in question a). 
SELECT   
		p.[Name] as PropertyName
       ,op.[PropertyId]
	   ,[OwnerId]   
	   ,pv.[Value] 

FROM   OwnerProperty op INNER JOIN
       Property p ON op.PropertyId = p.Id INNER JOIN
       PropertyHomeValue pv ON p.Id = pv.PropertyId

Where OwnerId=1426 AND pv.IsActive=1


--c.	For each property in question a), return the following:  
--i.	Using rental payment amount, rental payment frequency, tenant start date and tenant end date to write a query that returns the sum of all payments from start date to end date. 
SELECT 
	
	op.PropertyId
	,PaymentAmount

	,IIF(tp.PaymentFrequencyId=1,tp.PaymentAmount*DATEDIFF(week,tp.StartDate,tp.EndDate),
	IIF(tp.PaymentFrequencyId=2,tp.PaymentAmount*(DATEDIFF(week, tp.StartDate,tp.EndDate)/2),
	tp.PaymentAmount*(DATEDIFF(month, tp.StartDate,tp.EndDate)+1))) as SumPayment

FROM [dbo].[TenantProperty] tp
Inner Join 
[Keys].[dbo].[OwnerProperty] op
On tp.PropertyId=op.PropertyId

where OwnerId =1426


--ii.	Display the yield. 
SELECT 
	
	op.PropertyId
	,PaymentAmount
	,pv.Value

	,(IIF(tp.PaymentFrequencyId=1,tp.PaymentAmount*DATEDIFF(week,tp.StartDate,tp.EndDate),
	IIF(tp.PaymentFrequencyId=2,tp.PaymentAmount*(DATEDIFF(week, tp.StartDate,tp.EndDate)/2),
	tp.PaymentAmount*(DATEDIFF(month, tp.StartDate,tp.EndDate)+1))) )/pv.[Value]*100 as Yield
FROM [dbo].[TenantProperty] tp
Inner Join 
[Keys].[dbo].[OwnerProperty] op
On tp.PropertyId=op.PropertyId
Inner Join PropertyHomeValue pv
on op.PropertyId= pv.PropertyId

where OwnerId =1426 and pv.IsActive=1



--d.	Display all the jobs available in the marketplace (jobs that owners have advertised for service suppliers). 
SELECT 
		j.[Id]
      ,[ProviderId]
      ,[PropertyId]
      ,[OwnerId]
      ,[PaymentAmount]
      ,[JobStartDate]
      ,[JobEndDate]
      ,[JobDescription]
      ,[JobStatusId]
      ,[UpdatedBy]
      ,[CreatedOn]
      ,[CreatedBy]
      ,[UpdatedOn]
      ,[MaxBudget]
      ,[PercentDone]
      ,[Note]
      ,[AcceptedQuote]
      ,[OwnerUpdate]
      ,[ServiceUpdate]
      ,[JobRequestId]

 FROM [Keys].[dbo].[Job] j Inner Join
 [dbo].[ServiceProviderJobStatus] ss On j.JobStatusId = ss.Id

 Where j.JobStatusId=1 and LOWER(JobDescription) LIKE '%service%'



--e.	Display all property names, current tenants first and last names and rental payments per week/ fortnight/month for the properties in question a). 


SELECT TOP (1000) 	
	p.[Name] as PropertyName     
	,FirstName
	,LastName
	,PaymentAmount
	,pf.[Name] as Frequency
	 
FROM [Keys].[dbo].[OwnerProperty] op
inner join  dbo.Property p
on p.id= op.PropertyId

Inner Join [dbo].[TenantProperty] tp
On tp.PropertyId=op.PropertyId
Inner Join dbo.Person per 
on tp.TenantId= per.Id
Inner Join [dbo].[TenantPaymentFrequencies]pf
On pf.Id = tp.PaymentFrequencyId

where OwnerId =1426
