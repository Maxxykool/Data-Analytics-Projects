-- We would be analysing data on COVID_DEATHS and VACCINATION globally since the first report 
--of COVID 19 in Wuhan China on 31st December 2019.  
-- First we create a table for Covid_deaths and import the data.
SELECT * FROM covid_deaths order by 3,4

SELECT * FROM covid_vaccination order by 3,4

SELECT location, date, total_cases, new_cases, total_deaths, population 
FROM covid_deaths
Order by 1,2

-- First we would look at the total_case and total_deaths which shows the likelyhood of
--dying if you contract COVID in your country
SELECT location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM covid_deaths

--Looking at the total_cases vs population which shows what percentage of the population has goten COVID
--p.s I am focused on Nigeria. 

SELECT location, date, total_cases,total_deaths, population, (total_cases/population)*100 AS PopulationPercentage
FROM covid_deaths
--where location like '%Nig%'
ORDER BY location

--looking at countries with highest infection rate compared to the population and showing the percentage 
--of population infected

SELECT location, population, MAX(total_cases) AS HigestinfectionCount, 
MAX(total_cases/population)*100 AS PercentpopulationInfected
FROM covid_deaths
--WHERE location like '%Nig%'
GROUP BY population, location
ORDER BY PercentpopulationInfected DESC

--showing countries with higest deathcount per population 

SELECT location, population, MAX(total_deaths) AS Totaldeathcount 
FROM covid_deaths
WHERE continent is not null
GROUP BY location, population
ORDER BY Totaldeathcount DESC

--Showing same result as above by continent i.e continents with the highest deathcount

SELECT continent, MAX(total_deaths) AS Totaldeathcount 
FROM covid_deaths
WHERE continent is not null
GROUP BY continent
ORDER BY Totaldeathcount DESC

--Global analysis

--Global Death percentage 
SELECT date, sum(new_cases)AS total_cases, Sum(new_deaths) AS total_deaths, 
Sum(new_cases)/SUM(new_deaths)*100 AS deathPercentage
FROM covid_deaths
where continent is not null
Group by date
ORDER BY 1,2

--Global vaccination percentage
CREATE VIEW vacper AS
SELECT vaccins.date, vaccins.location, SUM(total_vaccinations), SUM(new_vaccinations) AS Sumvac, deaths.population,
SUM(new_vaccinations)/(deaths.population)*100 As Percent_vaccinated 
FROM covid_vaccination vaccins
Join covid_deaths deaths
ON vaccins.location = deaths.location
--WHERE continent is not null 
GROUP BY vaccins.date, vaccins.location, deaths.population
ORDER BY 1,2

SELECT * FROM vacper 
WHERE Percent_vaccinated is not null


--Looking at both tables i.e. Coviddeaths and covidvacination 
SELECT *
FROM covid_deaths deaths
Join covid_vaccination vaccin
ON deaths.location = vaccin.location
and deaths.date = vaccin.date

--looking at total population vs vaccination to create a column that shows  
--daily vaccination progress.

SELECT deaths.continent, deaths.location, deaths.date, deaths.population, vaccin.new_vaccinations,
SUM(vaccin.new_vaccinations) over (partition by deaths.location ORDER BY deaths.location,
								  deaths.date) AS Rolling_vaccination
FROM covid_deaths deaths
Join covid_vaccination vaccin
ON deaths.location = vaccin.location
and deaths.date = vaccin.date
where deaths.continent is not null
ORDER by 2,3

--Running the same querry as above with the use of CTE
WITH popvsvac (continent, location, date, population, new_vaccination, Rolling_vaccination)
AS
(SELECT deaths.continent, deaths.location, deaths.date, deaths.population, vaccin.new_vaccinations,
SUM(vaccin.new_vaccinations) over (partition by deaths.location ORDER BY deaths.location,
								  deaths.date) AS Rolling_vaccination
FROM covid_deaths deaths
Join covid_vaccination vaccin
ON deaths.location = vaccin.location
and deaths.date = vaccin.date
where deaths.continent is not null
 SELECT *, (Rolling_vaccination/population)* 100
 FROM popvsvac
 -- Showing daily vaccination progress by percentage
 SELECT *, (Rolling_vaccination/population)* 100
 FROM popvsvac

 
--One could also run the same querry above with Use of temp. views 

 CREATE VIEW popvsvac AS
SELECT deaths.continent, deaths.location, deaths.date, deaths.population, vaccin.new_vaccinations,
SUM(vaccin.new_vaccinations) over (partition by deaths.location ORDER BY deaths.location,
								  deaths.date) AS Rolling_vaccination
FROM covid_deaths deaths
Join covid_vaccination vaccin
ON deaths.location = vaccin.location
and deaths.date = vaccin.date
where deaths.continent is not null
--ORDER by 2,3 
 SELECT *, (Rolling_vaccination/population)* 100
 FROM popvsvac


