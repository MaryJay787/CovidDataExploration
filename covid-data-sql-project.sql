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
date, SUM(cast(new_cases AS INT)) AS total_cases, location
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
date, SUM(cast(new_cases AS INT)) AS total_cases, SUM(cast(new_deaths AS INT)) AS total_deaths,
SUM(cast(new_deaths as INT)) / SUM(cast(new_cases AS INT))*100 AS death_percent
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
location, cast(population AS INT) AS pop, MAX(cast(total_deaths AS INT)) AS total_deceased, 
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
location, MAX(cast(total_deaths AS INT)) AS total_deceased, 
FROM
`covid-data-387015.covid_data_exploration.covid_world_deaths`
WHERE 
continent IS NULL
GROUP BY
location
ORDER BY
total_deceased DESC
