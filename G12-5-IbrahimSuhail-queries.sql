-- simple 3 adventureworks2014  
-- find the department name of every employee
USE adventureworks2014
GO

SELECT edh.BusinessEntityID
	,edh.DepartmentID
	,d.Name
FROM HumanResources.EmployeeDepartmentHistory AS edh
JOIN HumanResources.Department AS d ON edh.DepartmentID = d.DepartmentID
ORDER BY BusinessEntityID
for json PATH, root('Department')
-- medium 2 adventureworks2014  
-- find all male day employees and their job titles
USE adventureworks2014
GO

SELECT e.BusinessEntityID
	,e.Gender
	,s.Name
	,e.JobTitle
FROM HumanResources.Employee AS e
JOIN HumanResources.EmployeeDepartmentHistory AS dh ON e.BusinessEntityID = dh.BusinessEntityID
JOIN HumanResources.Shift AS s ON dh.ShiftID = s.ShiftID
WHERE Gender = 'm'
	AND Name = 'day'
for json PATH, root('Employee')

-- simple 4 adventureworks2014  
-- for 100 people's addressIds find their address name
USE adventureworks2014
GO

SELECT TOP 100 e.BusinessEntityID
	,e.AddressID
	,e.AddressTypeID
	,a.name
FROM Person.BusinessEntityAddress AS e
JOIN Person.AddressType AS a ON a.AddressTypeid = e.AddressTypeID
ORDER BY e.AddressID
for json PATH, root('Address')

-- simple 5 adventureworks2014  
-- given 100 phone numbers, find the phone number name
USE adventureworks2014
GO

SELECT TOP 100 PhoneNumber
	,name
FROM Person.PersonPhone AS ppp
JOIN Person.PhoneNumberType AS pnt ON ppp.PhoneNumberTypeID = pnt.PhoneNumberTypeID
ORDER BY PhoneNumber
for json PATH, root('Phone Number')

-- medium 1 Northwinds2019TSQLV5  
-- find the average, lowest, and highest score per test
USE Northwinds2019TSQLV5
GO

SELECT s.testid
	,avg(s.TestScore) AS [MEAN SCORE]
	,MIN(S.TestScore) AS [LOWEST SCORE]
	,MAX(TestScore) AS [HIGHEST SCORE]
FROM Stats.Score AS s
JOIN Stats.Test AS t ON s.TestId = t.TestId
GROUP BY S.TestId
for json PATH, root('Test')

-- simple 1 Northwinds2019TSQLV5  
-- find every combination of letters a-d and numbers 1-3
USE Northwinds2019TSQLV5
GO

SELECT *
FROM RelationalCrossJoin.S1
CROSS JOIN RelationalCrossJoin.S2
for json PATH, root('Combinations')


-- simple 2 Northwinds2019TSQLV5
-- find the 20 players with the most homeruns
USE Northwinds2019TSQLV5
GO

SELECT DISTINCT TOP 20 b.nameGiven AS [NAME]
	,a.HomeRun AS [HOMERUNS]
FROM Example.BaseballPlayerBattingStatistics AS a
JOIN Example.ProfessionalBaseballPlayer AS b ON a.playerID = b.playerID
ORDER BY HomeRun DESC
for json PATH, root('Player')

-- medium 2 AdventureWorksdw2014  
-- for each year find the average employee base salary rate 
USE AdventureWorksdw2014
GO

SELECT year(f.OrderDate) AS [OrderYear]
	,avg(e.baserate) AS [AVERAGEEMPLOYEEBASERATE]
FROM FactInternetSales as f
JOIN DimEmployee AS e ON year(OrderDate) = year(HireDate)
GROUP BY year(f.OrderDate)
for json PATH, root('Employee')

--  medium 3 AdventureWorksDW2014  
-- find the total sales amount per state
USE AdventureWorksdw2014
GO

SELECT a.StateProvinceName AS [STATE]
	,sum(b.SalesAmount) AS [TOTAL SALES]
FROM dbo.dimgeography AS a
JOIN FactInternetSales AS b ON a.SalesTerritoryKey = b.SalesTerritoryKey
GROUP BY a.StateProvinceName
for json PATH, root('State')


-- medium 4 AdventureWorksDW2014  
-- find the average freight cost per year
USE AdventureWorksDW2014
GO

SELECT AVG(Freight) AS [AVG FREIGHT COST]
	,YEAR(OrderDate) AS [YEAR]
FROM dbo.dimgeography AS a
JOIN FactInternetSales AS b ON a.SalesTerritoryKey = b.SalesTerritoryKey
GROUP BY YEAR(OrderDate)
for json PATH, root('Freight')


-- medium 5 AdventureWorksDW2014  
-- find the average number of cars owned per customer in 67 cities
USE AdventureWorksdw2014
GO

SELECT TOP 67 b.City
	,avg(a.NumberCarsOwned) AS [AVG_NUM_OF_CARS]
FROM DimCustomer AS a
JOIN DimGeography AS b ON a.GeographyKey = b.GeographyKey
GROUP BY B.City
for json PATH, root('City')

-- medium 6 AdventureWorksDW2014  
-- group each category number by their english names
USE AdventureWorksdw2014
GO

SELECT TOP 23 avg(a.ProductCategoryKey) AS [Product Category Num]
	,b.EnglishProductCategoryName
FROM DimProductsubCategory AS a
JOIN DimProductCategory AS b ON a.ProductCategoryKey = b.ProductCategoryKey
GROUP BY EnglishProductCategoryName
for json PATH, root('Product')

-- medium 7 AdventureWorksDW2014  
-- find the average yearly revenue per 40 cities
USE AdventureWorksdw2014
GO

SELECT TOP 40 AVG(AnnualRevenue) AS [AnnualRevenue]
	,b.City
FROM DimReseller AS a
JOIN DimGeography AS b ON a.GeographyKey = b.GeographyKey
GROUP BY b.City
for json PATH, root('City')

-- medium 8 Northwinds2019TSQLV5  
-- find the average number of homeruns per player weight
USE Northwinds2019TSQLV5
GO

SELECT avg(a.homerun) AS [NUM_OF_HOMERUNS]
	,b.Weight
FROM Example.BaseballPlayerBattingStatistics AS a
JOIN Example.ProfessionalBaseballPlayer AS b ON a.playerID = b.playerID
WHERE b.weight BETWEEN 150
		AND 300
GROUP BY Weight
ORDER BY Weight
for json PATH, root('Homeruns')


-- complex 1 Northwinds2019TSQLV5  
-- find the average number of games played by nationality, and associate each with a number
USE Northwinds2019TSQLV5
GO

SELECT TOP 40 avg(a.GamesPlayed) AS [AVG_GAMES_PLAYED]
	,birthCountry
	,example.nationality(b.birthCountry) AS [nationality]
	,s.Number
FROM Example.BaseballPlayerBattingStatistics AS a
JOIN Example.ProfessionalBaseballPlayer AS b ON a.playerID = b.playerID
LEFT OUTER JOIN RelationalCrossJoin.S2 AS s ON birthCountry >= s.Number
GROUP BY birthCountry
	,s.Number
for json PATH, root('Player')

-- complex 2 AdventureWorksDW2014  
-- FIND THE AVERAGE TAX COST PER PRODUCT, ITS UNITCOST, AND CULTURE
USE AdventureWorksDW2014
GO

SELECT TOP 100 AVG(a.taxamt) AS [AVG_TAX_AMOUNT]
	,b.UnitCost
	,dbo.ucsss(c.CultureName) AS [culture type]
FROM FactInternetSales AS a
JOIN FactProductInventory AS b ON a.ProductKey = b.ProductKey
JOIN dbo.FactAdditionalInternationalProductDescription AS c ON b.ProductKey = c.ProductKey
GROUP BY a.ProductKey
	,b.UnitCost
	,c.CultureName
for json PATH, root('Product')

-- complex 3 AdventureWorksDW2014  
-- find total sales for each department in every organization
USE AdventureWorksDW2014
GO

SELECT sum(a.Amount) AS [TOTAL SALES]
	,a.OrganizationKey
	,b.DepartmentGroupName
	,c.OrganizationName
	,dbo.amttt(DepartmentGroupName) AS [myEvaluation]
FROM FactFinance AS a
JOIN DimDepartmentGroup AS b ON a.DepartmentGroupKey = b.DepartmentGroupKey
JOIN DimOrganization AS c ON a.OrganizationKey = c.OrganizationKey
GROUP BY a.OrganizationKey
	,b.DepartmentGroupName
	,c.OrganizationName
ORDER BY DepartmentGroupName
for json PATH, root('Department')

-- complex 4 AdventureWorksDW2014  
-- find the top 100 product keys, their sale dates, and which regions buy them the most
USE AdventureWorksDW2014
GO

SELECT TOP 100 a.DateKey
	,b.ProductKey
	,avg(c.salesterritorykey) AS [AVG SALE REGION]
	,DBO.RN(avg(c.salesterritorykey)) AS [ROMAN_NUMERAL]
FROM FactFinance AS a
JOIN FactProductInventory AS b ON a.DateKey = b.DateKey
JOIN FactResellerSales AS c ON b.ProductKey = c.ProductKey
GROUP BY a.DateKey
	,b.ProductKey
for json PATH, root('Product')

-- complex 5 AdventureWorksDW2014
-- find the average customer's income for each country, its name in French, and estimated hourly salary
USE AdventureWorksDW2014
GO

SELECT a.SalesTerritoryRegion
	,b.frenchCountryRegionName
	,AVG(c.YearlyIncome) AS [AVG_INCOME_PER_YEAR]
	,dbo.toHour(AVG(c.YearlyIncome)) AS [ESTIMATED HOURLY SALARY]
FROM DimSalesTerritory AS A
JOIN DimGeography AS b ON A.SalesTerritoryKey = b.SalesTerritoryKey
JOIN DimCustomer AS c ON b.GeographyKey = c.GeographyKey
GROUP BY a.SalesTerritoryRegion
	,b.frenchCountryRegionName
for json PATH, root('Customer')

-- complex 6 AdventureWorksDW2014
-- find the lowest sales quotas, the customer who answered the survey about this employee, their email address and domain
USE AdventureWorksDW2014
GO

SELECT TOP 50 min(a.SalesAmountQuota) AS [min_sales_amt_qta]
	,b.CustomerKey
	,c.EmailAddress
	,dbo.dom(c.EmailAddress) AS [DOMAIN]
FROM FactSalesQuota AS a
JOIN FactSurveyResponse AS b ON a.DateKey = b.DateKey
JOIN DimCustomer AS c ON b.CustomerKey = c.CustomerKey
GROUP BY b.CustomerKey
	,c.EmailAddress
for json PATH, root('Customer')

-- complex 7 AdventureWorksDW2014
-- find the oldest customer, the model they ordered, and their ESTIMATED date of birth
USE AdventureWorksDW2014
GO

SELECT TOP 46 MAX(c.Age) AS [OLDEST PERSON]
	,a.Model
	,b.IncomeGroup
	,dbo.edob(MAX(c.Age)) AS [ESTIMATED BIRTHDATE]
FROM dbo.vAssocSeqLineItems AS a
JOIN dbo.vAssocSeqOrders AS b ON a.OrderNumber = b.OrderNumber
JOIN dbo.vDMPrep AS c ON b.OrderNumber = c.OrderNumber
GROUP BY a.Model
	,b.IncomeGroup
for json PATH, root('Customer')
