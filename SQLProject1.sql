SELECT * FROM Project1SQL ..CovidDeaths$
WHERE continent IS NOT NULL
ORDER BY 3,4;

SELECT * FROM Project1SQL ..CovidVaccinations$
ORDER BY 3,4;

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'CovidDeaths$' ;


-- Data Used 

SELECT location, date, total_cases,new_cases,total_deaths, population 
FROM Project1SQL ..CovidDeaths$
ORDER BY 1,2

--Total Deaths vs Total Cases 
--Likelihood of Death from each country

SELECT location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 AS death_percent
FROM Project1SQL ..CovidDeaths$
WHERE location like '%states%'
ORDER BY 1,2

-- Survalability of desease 

SELECT location, date, total_deaths,population, ((population - total_deaths)/population)*100 AS sur_percent 
FROM Project1SQL ..CovidDeaths$
WHERE location like '%states%' 
ORDER BY 1,2

-- Looking at the Total Cases vs Population 

SELECT location, date, total_cases,population, (total_cases/population)*100 AS inf_of_population,
(total_deaths/total_cases)*100 AS death_percentage
FROM Project1SQL ..CovidDeaths$
WHERE location like '%states%'
ORDER BY 1,2


-- Highest Infection Rate  by country

SELECT location,population, MAX((total_cases/population)*100) AS inf_of_population
FROM Project1SQL ..CovidDeaths$
GROUP BY population, location
ORDER BY inf_of_population DESC


-- Countries with highest death count per population 

SELECT location, MAX(cast(total_deaths as int)) as total_death_per
FROM Project1SQL ..CovidDeaths$
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY total_death_per DESC

-- Continent Breakdown of Death count

SELECT location, MAX(cast(total_deaths as int)) as total_death_per
FROM Project1SQL ..CovidDeaths$
WHERE continent IS NULL
GROUP BY location
ORDER BY total_death_per DESC

-- showing continents with highest death count 

SELECT continent, MAX(cast(total_deaths as int)) as total_death_per
FROM Project1SQL ..CovidDeaths$
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY total_death_per DESC

-- Global number

SELECT date,SUM(new_cases) as total_cases, SUM(cast(new_deaths AS INT)) as total_deaths,
SUM(cast(new_deaths as int))/SUM(new_cases)*100 as death_percentage
FROM Project1SQL ..CovidDeaths$
--WHERE location like '%states%'
WHERE continent is not null
GROUP BY date
ORDER BY 1,2;


--Covid Vaccinations 
WITH PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(INT,vac.new_vaccinations)) OVER (PARTITION BY dea.Location ORDER BY dea.location, dea.Date) AS RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM Project1SQL..CovidDeaths$ dea
JOIN Project1SQL..CovidVaccinations$ vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100 AS PEPEGA
From PopvsVac


-- tempp table 
DROP TABLE IF EXISTS #percentpopvax
CREATE TABLE #percentpopvax
(continent NVARCHAR(255),location NVARCHAR(255)
,date datetime, population NUMERIC
,new_vaccinations NUMERIC, RollingPeopleVaccinated NUMERIC
)

INSERT INTO #percentpopvax
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(INT,vac.new_vaccinations)) OVER (PARTITION BY dea.Location ORDER BY dea.location, dea.Date) AS RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM Project1SQL..CovidDeaths$ dea
JOIN Project1SQL..CovidVaccinations$ vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL 
--order by 2,3
Select *, (RollingPeopleVaccinated/Population)*100 
From #percentpopvax

--Vizualization for other inputs 

Create View view1 as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From Project1SQL..CovidDeaths$ dea
Join Project1SQL..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
