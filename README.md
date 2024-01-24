# Corona Virus (COVID-19) Deaths Analysis

## Table of Contents
-[Project Overview](#Project-Overview)
-[Data Sources](#Data-Sources)
-[Tools](#Tools)




### Project Overview
This data analysis aims to provide insights into the COVID-19 data collected during the period Feb 2020- Apr 2021. By analyzing various aspects of this data, we seek to identify trends, make data-driven recommendations, and gain a deeper understanding of the impact of Coronavirus during this time frame. 

### Data Sources
This analysis comprises a dataset related to the COVID-19 pandemic:[Link to Dataset](https://ourworldindata.org/covid-deaths)

### Tools
- Excel -  Data Cleaning
- SQL Server - Data Analysis

### Data Cleaning/Preparation
In the initial data preparation phase, we performed the follwing tasks
1. Divided the dataset into two Microsoft Excel type datasets: CovidDeaths & CovidVaccinations
2. Data loading and inspection
3. Handling Missing Values
4. Data cleaning and formatting -Changing the data type of some numeric fields from text to numeric.


### Exploratory Data Analysis
EDA involved exploring the COVID-19 dataset to answer key questions, such as:
- Total Cases vs Total Deaths - Shows the likelihood of dying if you contract COVID19 in your country
- Total Cases vs population - Shows what pecentage of the population has Covid-19
- Which countries has the highest infection rate compared to the population
- Which countries has the Highest Death Count Per Population
- Highest Death Count per Population broken down by Continent
- Continent with the highest death count per population
- Global COVID-19 cases
- Global Death Percentages
- Total population vs Vaccinations


  ### Data Analysis
  ```sql
  --Looking at Total Cases vs Total Deaths
	--Shows the likelihood of dying if you contract COVID in your country
  SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
	FROM PortfolioProject..CovidDeaths
	order by 1,2
---
```sql
--Looking at Total Cases vs Population
--Shows what percentage of population has Covid
SELECT location, date, total_cases, population, (total_cases/population) as PercentOfPopulationInfected
	FROM PortfolioProject..CovidDeaths
	where location='Ghana'
	order by 1,2
---
```sql
--Looking at countries with highest infection rate compared to population
SELECT location,population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
 	FROM PortfolioProject..CovidDeaths
	--where location='Ghana'
	GROUP BY location, population 
	order by PercentPopulationInfected desc
---

```sql
--Countries with Highest Death Count Per Population
--select * from PortfolioProject..CovidDeaths
SELECT location, MAX(CAST(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
Order by TotalDeathCount DESC
---

```sql
--Breaking Highest Death Count Per Population by Continent
SELECT continent, MAX(CAST(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
Order by TotalDeathCount DESC
---

```sql
--Showing the continent with the highest death count per population
SELECT continent, MAX(CAST(total_deaths as int))/population as DeathCountPerPopulation
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent, population
Order by DeathCountPerPopulation DESC
---

```sql
--GLOBAL Numbers
SELECT date, SUM(New_Cases) as TotalNewCases, SUM(cast(New_Deaths as int)) as SumOfNewDeaths
	FROM PortfolioProject..CovidDeaths
	--where location='Ghana'
	where continent is not null
	GROUP BY date
	order by 1,2
---

```sql
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
---

```sql
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
---

```sql
--Looking at Total Population vs Vaccinations using CTE
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


### Results/Findings
The analysis results are summarized as follows:



### Recommendations
Based on the analysis, we recommend the following actions


### Limitations
I had to change the data types of some numeric fields from text to numeric because they would have affected numeric calculations.

### References
1.













  

