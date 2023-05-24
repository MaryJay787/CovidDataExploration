-- Query to view total cases vs. total deaths and aggregated the percentage of the two. 
SELECT
location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS death_percentage
FROM 
`covid-data-387015.covid_data_exploration.covid_world_deaths` 
WHERE 
continent IS NOT NULL

-- Query to view total cases vs. population and calculated the percentage of the two. 
SELECT 
location, date, total_cases, population, (total_cases/population)*100 AS contracted_pop_percent
FROM
`covid-data-387015.covid_data_exploration.covid_world_deaths`
WHERE 
location = 'United States' 
ORDER BY
1,2

-- Global day-to-day reported numbers.
SELECT
date, SUM(CAST(new_cases AS INT)) AS total_cases, location
FROM 
`covid-data-387015.covid_data_exploration.covid_world_deaths`
WHERE 
continent IS NOT NULL
AND 
new_cases <> 0
GROUP BY
date, location
ORDER BY
1,2

-- Global daily deaths and new cases 
SELECT
date, SUM(CAST(new_cases AS INT)) AS total_cases, SUM(CAST(new_deaths AS INT)) AS total_deaths,
SUM(CAST(new_deaths as INT)) / SUM(CAST(new_cases AS INT))*100 AS death_percent
FROM 
`covid-data-387015.covid_data_exploration.covid_world_deaths`
WHERE 
continent IS NOT NULL
AND new_cases <> 0
AND new_deaths <> 0
GROUP BY
date
ORDER BY
1,2

-- Maximum number of deceased grouped by continent and population.
SELECT
location, CAST(population AS INT) AS pop, MAX(CAST(total_deaths AS INT)) AS total_deceased, 
FROM
`covid-data-387015.covid_data_exploration.covid_world_deaths`
WHERE 
continent IS NOT NULL
GROUP BY
location, population
ORDER BY
total_deceased DESC

-- Highest deceased records by continent.
-- Alternate is not and is null too view more accurate results.
SELECT
location, MAX(CAST(total_deaths AS INT)) AS total_deceased, 
FROM
`covid-data-387015.covid_data_exploration.covid_world_deaths`
WHERE 
continent IS NULL
GROUP BY
location
ORDER BY
total_deceased DESC

-- Queried highest rates of infection while isolating null locations. 
SELECT
location, CAST(population AS INT) AS population, MAX(CAST(total_cases AS INT)) AS highest_infection_count, MAX((total_cases/population))*100 AS percent_pop_infected
FROM
`covid-data-387015.covid_data_exploration.covid_world_deaths`
WHERE 
location NOT IN ('World', 'High income', 'Low income', 'Lower middle income', 'Upper middle income', 'Macao', 'Northern Cyprus', 'Taiwan', 'North Korea', 'Hong Kong', 'Turkmenistan', 'Western Sahara', 'England', 'Northern Ireland', 'Scotland', 'Wales')
GROUP BY
location, population
ORDER BY
 percent_pop_infected DESC
 
-- Joining two tables on location and date
SELECT 
deaths.continent, deaths.location, deaths.date, deaths.population, vaccs.new_vaccinations
FROM 
`covid-data-387015.covid_data_exploration.covid_world_deaths` deaths
JOIN 
`covid-data-387015.covid_data_exploration.covid_world_vaccinations` vaccs
  ON deaths.location = vaccs.location
  AND deaths.date = vaccs.date
WHERE deaths.continent IS NOT NULL
ORDER BY 
1, 2, 3

-- Look at total population vs vaccinations
SELECT 
dea.continent, dea.location, dea.date, dea.population, vacs.new_vaccinations, SUM(CAST(vacs.new_vaccinations AS INT)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS people_vaccinated_count, (new_vaccinations/dea.population)*100 AS percent_of_people_vaccinated
FROM 
`covid-data-387015.covid_data_exploration.covid_world_deaths` dea
JOIN 
`covid-data-387015.covid_data_exploration.covid_world_vaccinations` vacs
  ON dea.location = vacs.location
  AND dea.date = vacs.date
WHERE dea.continent IS NOT NULL
ORDER BY 2, 3

-- Percent of population infected vs. total number of cases 
SELECT
location, CAST(population AS INT) AS population, date, MAX(CAST(total_cases AS INT)) AS highest_infection_count, MAX(total_cases/population)*100 AS percent_population_infected
FROM
`covid-data-387015.covid_data_exploration.covid_world_deaths`
GROUP BY
location, population, date
ORDER BY
percent_population_infected DESC

-- Current total deaths and cases in the world 
SELECT
location, MAX(CAST(new_cases AS INT)) AS total_cases, MAX(cast(total_deaths AS INT)) AS total_deceased, 
FROM
`covid-data-387015.covid_data_exploration.covid_world_deaths`
WHERE 
location = 'World'
GROUP BY
location

-- Queried death count by location
SELECT
location, SUM(CAST(new_deaths AS INT)) AS total_death_count
FROM
`covid-data-387015.covid_data_exploration.covid_world_deaths`
WHERE 
continent IS NULL
AND location NOT IN ('World', 'European Union', 'International', 'Low income', 'Lower middle income', 'Upper middle income', 'High income')
GROUP BY
location
ORDER BY 
total_death_count

-- Looking at total cases and deaths according to income brackets
SELECT 
location, population, SUM(CAST(total_cases AS INT)) AS total_cases, SUM(CAST(total_deaths AS INT)) AS total_deaths
FROM
`covid-data-387015.covid_data_exploration.covid_world_deaths`
WHERE
continent IS NULL
AND location NOT IN ('Asia', 'World', 'Africa', 'Europe', 'North America', 'European Union', 'South America', 'Oceania')
GROUP BY
location, population
ORDER BY 
4 DESC