-- In this Table information about Covid Cases and Deaths

select *
From CovidDeath.dbo.CovidDeath

--Delete Continent Where is NULL

DELETE FROM CovidDeath.dbo.CovidDeath
Where continent IS NULL;

-- Select Important Columns
-- Data Exploration

Select location, date, new_cases, total_cases, total_deaths, population
from CovidDeath.dbo.CovidDeath
order by 1,2

-- How Much Percentage of Total Death on Total Cases
-- Death Percentage

Select location, date, total_cases, total_deaths, DeathPct = CAST(total_deaths as float) / CAST(total_cases as float)*100
From CovidDeath.dbo.CovidDeath
Where location like '%India%'
-- Using Like We are Search Country Name
order by 1,2

-- How Much Percentage of Total cases vs Population
-- Population Percentage

Select location, date, total_cases, population, PopulationPct = CAST(total_cases as float) / CAST(population as float)*100
from CovidDeath.dbo.CovidDeath
Where location like '%India%'
order by 1,2

-- Total Cases of Covid in India is 3.17% Population of India

--In Which Country is Highest Covid Cases Infected Percentage
--In Which Country is Highest Covid Deaths Infected Percentage

Select location, population, Max(total_cases) As Highest_Cases,
Highest_Case_Percentage_Infected = CAST((MAX(total_cases)) as float) / CAST(population as float) *100,
Max(total_deaths) as Highest_Deaths,
Highest_Death_Percentage_Infected = CAST((MAX(total_deaths)) as float) / CAST(population as float) *100
From CovidDeath.dbo.CovidDeath
group by location, population
order by Highest_Case_Percentage_Infected DESC

-- In Cyprus 73.75% Population Infect of Covid Cases
-- In Peru 0.64 % Population Dead in Covid

-- Day Wise Total No. of New Cases and Deaths

Select date, Sum(new_cases) as Total_Cases_per_day, sum(new_deaths) as Total_Deathes_per_day
from CovidDeath.dbo.CovidDeath
Group By date	
order by date asc

-- In Which Day Highest Percentage Death Ratio 

SELECT date,SUM(new_cases) AS Total_Cases_per_day,SUM(new_deaths) AS Total_Deaths_per_day,
CASE 
	WHEN SUM(new_cases) != 0 
	THEN (CAST(SUM(new_deaths) AS Float)) / CAST(SUM(new_cases) AS FLOAT)* 100 
	ELSE 0 
END AS Death_PCT_per_day
FROM CovidDeath.dbo.CovidDeath
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY Death_PCT_per_day DESC;

-- In this Table inforamtion about Vaccine

select *
From CovidDeath.dbo.CovidVaccination

--Join Two tables Covid Death Info with Covid Vaccination

Select *
From CovidDeath.dbo.CovidDeath as cd
Join CovidDeath.dbo.CovidVaccination as cv
 on cd.date = cv.date and cd.location = cv.location

-- looking New Vaccination Data

Select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations
From CovidDeath.dbo.CovidDeath as cd
Join CovidDeath.dbo.CovidVaccination as cv
 on cd.date = cv.date and cd.location = cv.location
 Order by location asc

-- Rolling up Count of New Vaccination 

Select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
Sum(Convert(bigint,cv.new_vaccinations)) OVER (PARTITION BY cd.Location order by cd.location,cd.date) as Total_Vaccinations
From CovidDeath.dbo.CovidDeath as cd
Join CovidDeath.dbo.CovidVaccination as cv
on cd.date = cv.date and cd.location = cv.location
Order by 2,3

-- How many Percentage vaccination completed in which location using CTE

With popvsvac (continent,location,date,population,new_vaccinations, Total_vaccinations)
as
(
Select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
Sum(Convert(bigint,cv.new_vaccinations)) OVER (PARTITION BY cd.Location order by cd.location,cd.date) as Total_Vaccinations
From CovidDeath.dbo.CovidDeath as cd
Join CovidDeath.dbo.CovidVaccination as cv
on cd.date = cv.date and cd.location = cv.location
)
Select *, (Cast(Total_vaccinations as float)) / (Cast(population as float))*100 as Completed_PCT_Vaccinations
from popvsvac

-- How many Percentage vaccination completed in which location using TEMP TABLE

DROP TABLE if EXISTS #Complete_PCT_Vaccinations

CREATE TABLE #Complete_PCT_Vaccinations
(continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
New_vaccinations numeric,
Total_vaccinations numeric)

INSERT INTO #Complete_PCT_Vaccinations
Select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
Sum(Convert(bigint,cv.new_vaccinations)) OVER (PARTITION BY cd.Location order by cd.location,cd.date) as Total_Vaccinations
From CovidDeath.dbo.CovidDeath as cd
Join CovidDeath.dbo.CovidVaccination as cv
on cd.date = cv.date and cd.location = cv.location

Select *, (Cast(Total_vaccinations as float)) / (Cast(population as float))*100 as Completed_PCT_Vaccinations
from #Complete_PCT_Vaccinations

--Creating View to store data for later visulization

Create View Complete_PCT_Vaccinations as 
Select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
Sum(Convert(bigint,cv.new_vaccinations)) OVER (PARTITION BY cd.Location order by cd.location,cd.date) as Total_Vaccinations
From CovidDeath.dbo.CovidDeath as cd
Join CovidDeath.dbo.CovidVaccination as cv
on cd.date = cv.date and cd.location = cv.location

--Drop Views

DROP VIEW Complete_PCT_Vaccinations