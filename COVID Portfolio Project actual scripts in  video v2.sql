select * from EmployeeDemographics
select top 5 * from EmployeeDemographics
select MAX(Age) from EmployeeDemographics

select DISTINCT(Gender) from EmployeeDemographics

select LastName as LastName 
from EmployeeDemographics 


select * 
from EmployeeDemographics
where Firstname='Jim'

select * 
from EmployeeDemographics
where Age>=30


SELECT * 
FROM EmployeeDemographics
WHERE Lastname LIKE '%S%'

SELECT * 
FROM EmployeeDemographics
WHERE Lastname LIKE 'S%O%'


USE AlexTheAnalyst

SELECT * 
FROM EmployeeDemographics
WHERE Lastname LIKE 'S%O%'

SELECT *
FROM EmployeeDemographics
WHERE Firstname IN ('Jim', 'Kevin')


SELECT * FROM EmployeeDemographics

SELECT Gender, Age, COUNT(Gender) AS CountOfGender
FROM EmployeeDemographics
GROUP BY Gender, Age



SELECT Gender, COUNT(Gender) AS CountOfGender
FROM EmployeeDemographics
WHERE Age > 31
GROUP BY Gender
ORDER BY CountOfGender DESC



/*INTERMEDIATE SQL
Inner Joins, Full/Left/RIght Outer Joins
*/
SELECT *
FROM AlexTheAnalyst.dbo.EmployeeDemographics

SELECT *
FROM AlexTheAnalyst.dbo.EmployeeSalary

-----------------------------
SELECT *
FROM AlexTheAnalyst.dbo.EmployeeDemographics ED
INNER JOIN AlexTheAnalyst.dbo.EmployeeSalary ES
ON ED.EmployeeID=ES.EmployeeID


SELECT *
FROM AlexTheAnalyst.dbo.EmployeeDemographics ED
INNER JOIN AlexTheAnalyst.dbo.EmployeeSalary ES
ON ED.EmployeeID=ES.EmployeeID

SELECT *
FROM AlexTheAnalyst.dbo.EmployeeDemographics ED
FULL OUTER JOIN AlexTheAnalyst.dbo.EmployeeSalary ES
ON ED.EmployeeID=ES.EmployeeID

SELECT *
FROM AlexTheAnalyst.dbo.EmployeeDemographics ED
LEFT OUTER JOIN AlexTheAnalyst.dbo.EmployeeSalary ES
ON ED.EmployeeID=ES.EmployeeID


SELECT *
FROM AlexTheAnalyst.dbo.EmployeeDemographics ED
RIGHT OUTER JOIN AlexTheAnalyst.dbo.EmployeeSalary ES
ON ED.EmployeeID=ES.EmployeeID


/*UNION, UNION ALL*/
SELECT *
FROM AlexTheAnalyst.dbo.EmployeeDemographics

SELECT * 
FROM AlexTheAnalyst.dbo.WareHouseEmployeeDemographics


SELECT *
FROM AlexTheAnalyst.dbo.EmployeeDemographics ED
FULL OUTER JOIN AlexTheAnalyst.dbo.WareHouseEmployeeDemographics WED
ON ED.EmployeeID=WED.EmployeeID

--UNION Removed Duplicates
SELECT *
FROM AlexTheAnalyst.dbo.EmployeeDemographics
UNION
SELECT * 
FROM AlexTheAnalyst.dbo.WareHouseEmployeeDemographics

--UNION ALL Keeps Duplicates
SELECT *
FROM AlexTheAnalyst.dbo.EmployeeDemographics
UNION ALL
SELECT * 
FROM AlexTheAnalyst.dbo.WareHouseEmployeeDemographics
ORDER BY EmployeeID

SELECT *
FROM AlexTheAnalyst.dbo.EmployeeDemographics
SELECT *
FROM AlexTheAnalyst.dbo.EmployeeSalary

--Same Number of Columns and Data Types Match
SELECT EmployeeID, Firstname, Age
FROM AlexTheAnalyst.dbo.EmployeeDemographics
UNION
SELECT EmployeeID, JobTitle, Salary
FROM AlexTheAnalyst.dbo.EmployeeSalary


--CASE Statement
SELECT Firstname, Lastname, Age,
CASE
	WHEN Age>30 THEN 'Old'
	WHEN Age BETWEEN 27 AND 30 THEN 'Young'
	ELSE 'Baby'
END
FROM AlexTheAnalyst.dbo.EmployeeDemographics
WHERE Age IS NOT NULL
ORDER BY Age



SELECT Firstname, Lastname, JobTitle, Salary,
CASE
	WHEN JobTitle='SalesMan' THEN Salary+(Salary*0.10)
	WHEN JobTitle='Accountant' THEN Salary+(Salary*0.05)
	WHEN JobTitle='HR' THEN Salary+(Salary*0.000001)
	ELSE Salary+(Salary*0.03)
END AS SalaryAFterRaise
FROM AlexTheAnalyst.dbo.EmployeeDemographics ED
JOIN AlexTheAnalyst.dbo.EmployeeSalary ES
ON ED.EmployeeID=ES.EmployeeID


--HAVING Clause
SELECT JobTitle, COUNT(JobTitle) AS CountOfJobTitle
FROM AlexTheAnalyst.dbo.EmployeeDemographics ED
JOIN AlexTheAnalyst.dbo.EmployeeSalary ES
ON ED.EmployeeID=ES.EmployeeID
GROUP BY JobTitle
HAVING COUNT(JobTitle)>1



SELECT JobTitle, AVG(Salary) AS AverageSalary
FROM AlexTheAnalyst.dbo.EmployeeDemographics ED
JOIN AlexTheAnalyst.dbo.EmployeeSalary ES
ON ED.EmployeeID=ES.EmployeeID
GROUP BY JobTitle
HAVING AVG(Salary)>45000
ORDER BY AVG(Salary)


---UPDATING & DELETING DATA
SELECT *
FROM AlexTheAnalyst.dbo.EmployeeDemographics


UPDATE AlexTheAnalyst.dbo.EmployeeDemographics
SET EmployeeID=1012
WHERE Firstname='Holly' AND Lastname='Flax'


UPDATE AlexTheAnalyst.dbo.EmployeeDemographics
SET Age=31, Gender='Female'
WHERE Firstname='Holly' AND Lastname='Flax'


DELETE FROM AlexTheAnalyst.dbo.EmployeeDemographics
WHERE EmployeeID=1005

--Safeguard. Run this first to make sure of what you're about to delete
SELECT * FROM AlexTheAnalyst.dbo.EmployeeDemographics
WHERE EmployeeID=1005



---PARTITION BY
---Group By reduces the number of rows but Partition By divides the results set into partitions, using the windows function.
SELECT *
FROM AlexTheAnalyst.dbo.EmployeeDemographics

SELECT *
FROM AlexTheAnalyst.dbo.EmployeeSalary
-----------------------------------------------
--PARTITION BY
SELECT Firstname, Lastname, Gender, Salary,
COUNT(Gender) OVER (PARTITION BY  Gender) AS TotalGender
FROM AlexTheAnalyst.dbo.EmployeeDemographics ED
JOIN AlexTheAnalyst.dbo.EmployeeSalary ES
ON ED.EmployeeID=ES.EmployeeID

--GROUP BY
SELECT Firstname, Lastname, Gender, Salary, COUNT(Gender) AS TotalGender
FROM AlexTheAnalyst.dbo.EmployeeDemographics ED
JOIN AlexTheAnalyst.dbo.EmployeeSalary ES
ON ED.EmployeeID=ES.EmployeeID
GROUP BY Firstname, Lastname, Gender, Salary


--CTEs
WITH CTE_Employee as
(SELECT Firstname, Lastname, Gender, Salary,
COUNT(Gender) OVER (PARTITION BY Gender) as TotalGender,
AVG(Salary) OVER (PARTITION By Gender) as AvgSalary
FROM AlexTheAnalyst..EmployeeDemographics ED
JOIN AlexTheAnalyst..EmployeeSalary ES
ON Ed.EmployeeID=ES.EmployeeID
WHERE Salary>45000
)
SELECT * FROM CTE_Employee


---TEMP TABLES
--Can be hit multiple times unlike CTEs and Subqueries. Begin Temptable with #

CREATE TABLE #temp_Employee (
    EmployeeID int,
    JobTitle varchar(100),
    Salary int
);

Select * from #temp_Employee

INSERT INTO #temp_Employee VALUES (
'1001', 'HR', '45000'
)

INSERT INTO #temp_Employee
SELECT *
FROM AlexTheAnalyst..EmployeeSalary

----------------------------------

DROP TABLE IF EXISTS #Temp_Employee2
CREATE TABLE #Temp_Employee2 (
JobTitle varchar(50),
EmployeesPerJob int,
AvgAge int,
AvgSalary int
)

--select * from #Temp_Employee2

INSERT INTO #Temp_Employee2
SELECT JobTitle, COUNT(JobTitle), AVG(Age), AVG(Salary)
FROM AlexTheAnalyst..EmployeeDemographics ED
JOIN AlexTheAnalyst..EmployeeSalary ES
ON ED.EmployeeID=ES.EmployeeID
GROUP BY JobTitle

---STRING FUNCTIONS - TRIM, LTRIM, RTRIM, REPLACE, SUBSTRING, UPPER LOWER

DROP TABLE EmployeeErrors
CREATE TABLE EmployeeErrors(
EmployeeID varchar(50)
,Firstname varchar(50)
,Lastname nvarchar(50)
)

--select * from EmployeeErrors
INSERT INTO EmployeeErrors VALUES
('1001 ', 'Jimbo', 'Halbert')
,(' 1002', 'Pamela', 'Beasely')
,('1005', 'TOby', 'Flenderson- Fired')


--select * from EmployeeErrors

--Using TRIM, LTRIM, RTRIM
SELECT EmployeeID, TRIM(EmployeeID) AS IDTRIM
FROm EmployeeErrors

SELECT EmployeeID, LTRIM(EmployeeID) AS IDTRIM
FROm EmployeeErrors

SELECT EmployeeID, RTRIM(EmployeeID) AS IDTRIM
FROm EmployeeErrors


--Using REPLACE

--select * from EmployeeErrors
SELECT LastName, REPLACE(LastName, '- Fired', ' ' ) as LastNameFixed
FROm EmployeeErrors



--Using Substring
--select * from EmployeeErrors
SELECT SUBSTRING(Firstname, 3,3)
FROM EmployeeErrors

--FUZZY MATCHING
--select * from AlexTheAnalyst..EmployeeErrors
--select * from AlexTheAnalyst..EmployeeDemographics 
SELECT er.Firstname, SUBSTRING(er.Firstname,1,3),ed.Firstname, SUBSTRING(ed.Firstname,1,3)
FROM AlexTheAnalyst..EmployeeErrors er
JOIN AlexTheAnalyst..EmployeeDemographics ed
ON SUBSTRING(er.Firstname,1,3)=SUBSTRING(ed.Firstname,1,3)


--Using UPPER & LOWER
SELECT Lastname, REPLACE(LastName, '- Fired', '') LastNameFixed
FROM EmployeeErrors

SELECT Lastname, REPLACE(LastName, '- Fired', '') LastNameFixed
FROM EmployeeErrors

SELECT Firstname, LOWER(FirstName) AS LowerCase
FROm EmployeeErrors


---STORED PROCEDURES
--Group of Procedures stored in the database
CREATE PROCEDURE Test4
   AS
Select * from AlexTheAnalyst..EmployeeDemographics

EXEC Test4
-----------------------

CREATE PROCEDURE Temp_Employee AS 
DROP TABLE IF EXISTS #Temp_Employee2
CREATE TABLE #Temp_Employee2 (
JobTitle varchar(50),
EmployeesPerJob int,
AvgAge int,
AvgSalary int
)

INSERT INTO #Temp_Employee2
SELECT JobTitle, COUNT(JobTitle), AVG(Age), AVG(Salary)
FROM AlexTheAnalyst..EmployeeDemographics ED
JOIN AlexTheAnalyst..EmployeeSalary ES
ON ED.EmployeeID=ES.EmployeeID
GROUP BY JobTitle

Select * From #Temp_Employee2

EXEC Temp_Employee


------------------------
--ALTER PROCEDURE    --RIGHT CLICK and modify 
ALTER PROCEDURE [dbo].[Temp_Employee]
AS
DROP TABLE IF EXISTS #Temp_Employee
CREATE TABLE #Temp_Employee (
JobTitle varchar(50),
EmployeesPerJob int,
AvgAge int,
AvgSalary int
)

INSERT INTO #Temp_Employee
SELECT JobTitle, COUNT(JobTitle), AVG(Age), AVG(Salary)
FROM AlexTheAnalyst..EmployeeDemographics ED
JOIN AlexTheAnalyst..EmployeeSalary ES
ON ED.EmployeeID=ES.EmployeeID
GROUP BY JobTitle

Select * From #Temp_Employee




--SUBQUERIES
SELECT *
FROM AlexTheAnalyst..EmployeeSalary

--Subquery in Select
SELECT EmployeeID, Salary, (Select AVG(Salary) from EmployeeSalary) as AllAvgSalary
FROM EmployeeSalary

--How to do it with Partition By
SELECT EmployeeID, Salary, AVG(Salary) OVER () as AvgSalary
FROM EmployeeSalary

---Why Group By Doesn't work
SELECT EmployeeID, Salary, AVG(Salary) as AvgSalary
FROM EmployeeSalary
GROUP BY EmployeeID, Salary
Order By 1,2


--Subquery in FROM 
--Subquery tends to be slow compared to a temp_table or CTE
--Every subquery MUST have a Alias

Select *
From (Select EmployeeID, Salary, AVG(Salary) over () as AllAvgSalary 
		From EmployeeSalary) as a
----------------------

Select a.EmployeeID, AllAvgSalary
From (Select EmployeeID, Salary, AVG(Salary) over () as AllAvgSalary 
		From EmployeeSalary) as a


--Subquery in Where 
select EmployeeID, JobTitle, Salary
from EmployeeSalary
Where EmployeeID in (
		Select EmployeeID 
		From EmployeeDemographics
		where Age>30)
	
-----------------------------------------------------------
--Copy Table from One Database to Another
SELECT * INTO PortfolioProject.dbo.CovidVaccinations    --destination database
FROM AlexTheAnalyst.dbo.CovidVaccinations$         ---source destination

--PROJECT - Data Analyst Portfolio Project|SQL Data Exploration |Project				

	USE PortfolioProject;
	
	SELECT * FROM PortfolioProject.dbo.CovidDeaths
	SELECT * FROM PortfolioProject.dbo.CovidVaccinations

	SELECT * FROM PortfolioProject.dbo.CovidDeaths
	ORDER BY 3,4

	SELECT * FROM PortfolioProject.dbo.CovidVaccinations
	ORDER BY 3,4


	--Select the data that we're going to be using
	 
	SELECT location, date,total_cases, new_cases, total_deaths, population
	FROM PortfolioProject..CovidDeaths
	order by 1,2

	--Looking at Total Cases vs Total Deaths
	--SHows the likelihood of dying if you contract COVID in your country
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
	FROM PortfolioProject..CovidDeaths
	order by 1,2


	SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
	FROM PortfolioProject..CovidDeaths
	where location='Ghana'
	order by 1,2


--Looking at Total Cases vs Population
--Shows what percentage of population has Covid
SELECT location, date, total_cases, population, (total_cases/population) as PercentOfPopulationInfected
	FROM PortfolioProject..CovidDeaths
	where location='Ghana'
	order by 1,2


--Looking at countries with highest infection rate compared to population
SELECT location,population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
 	FROM PortfolioProject..CovidDeaths
	--where location='Ghana'
	GROUP BY location, population 
	order by PercentPopulationInfected desc



--Countries with Highest Death Count Per Population
--select * from PortfolioProject..CovidDeaths
SELECT location, MAX(CAST(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
Order by TotalDeathCount DESC 


--LET's BREAK THINGS DOWN BY CONTINENT
SELECT continent, MAX(CAST(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
Order by TotalDeathCount DESC 
----------------------------------

SELECT location, MAX(CAST(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent IS NULL
GROUP BY location
Order by TotalDeathCount DESC 


--Showing the continent with the highest death count per population
SELECT continent, MAX(CAST(total_deaths as int))/population as DeathCountPerPopulation
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent, population
Order by DeathCountPerPopulation DESC 


--GLOBAL Numbers
SELECT date, SUM(New_Cases) as TotalNewCases, SUM(cast(New_Deaths as int)) as SumOfNewDeaths
	FROM PortfolioProject..CovidDeaths
	--where location='Ghana'
	where continent is not null
	GROUP BY date
	order by 1,2	

--GLOBAL Death Percentage
SELECT date, 
		SUM(New_Cases) as TotalCases, 
		SUM(cast(New_Deaths as int)) as TotalDeaths,
		SUM(cast(New_Deaths as int))/SUM(New_Cases)*100 as DeathPercentage
	FROM PortfolioProject..CovidDeaths
	--where location='Ghana'
	where continent is not null
	GROUP BY date
	order by 1,2	

---------------------------
SELECT  
		SUM(New_Cases) as TotalCases, 
		SUM(cast(New_Deaths as int)) as TotalDeaths,
		SUM(cast(New_Deaths as int))/SUM(New_Cases)*100 as DeathPercentage
	FROM PortfolioProject..CovidDeaths
	--where location='Ghana'
	where continent is not null
	--GROUP BY date
	order by 1,2
	

------------------------------------
--Looking at Total Population vs Vaccinations
select 
	 dea.continent
	 ,dea.location
	,dea.date
	,dea.population
	,vac.new_vaccinations
	,SUM(cast(vac.new_vaccinations as int)) OVER (PARTITION BY dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location=vac.location 
where dea.continent is not null
AND dea.date=vac.date
order by 2,3

-------------------------------------
select 
	 dea.continent
	 ,dea.location
	,dea.date
	,dea.population
	,vac.new_vaccinations
	,SUM(cast(vac.new_vaccinations as int)) OVER (PARTITION BY dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
	,RollingPeopleVaccinated/population*100    ---You cannot use a colujmn you just created as another column.
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location=vac.location 
where dea.continent is not null
AND dea.date=vac.date
order by 2,3


----Hence use CTE, since you cannot use a column you just created for another column
WITH PopvsVac (Continent, location, Date, Population, new_vaccinations,RollingPeopleVaccinated) as 
(
select 
	 dea.continent
	 ,dea.location
	,dea.date
	,dea.population
	,vac.new_vaccinations
	,SUM(cast(vac.new_vaccinations as int)) OVER (PARTITION BY dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location=vac.location 
where dea.continent is not null
AND dea.date=vac.date
--order by 2,3
)
select *,(RollingPeopleVaccinated/Population)*100 from PopvsVac



--TEMP TABLE
DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(Continent nvarchar(255),
location nvarchar(255),
Date datetime,
Population	numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)

insert into #PercentPopulationVaccinated
select 
	 dea.continent
	 ,dea.location
	,dea.date
	,dea.population
	,vac.new_vaccinations
	,SUM(cast(vac.new_vaccinations as int)) OVER (PARTITION BY dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location=vac.location 
where dea.continent is not null
AND dea.date=vac.date
--order by 2,3

select *, (RollingPeopleVaccinated/Population)*100
from #PercentPopulationVaccinated.


--VIEW
--Creating View to store data for for later visualizations

create view PercentPopulationVaccinated as 
select 
	 dea.continent
	 ,dea.location
	,dea.date
	,dea.population
	,vac.new_vaccinations
	,SUM(cast(vac.new_vaccinations as int)) OVER (PARTITION BY dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location=vac.location 
where dea.continent is not null
AND dea.date=vac.date
--order by 2,3

select * 
from PercentPopulationVaccinated     --View