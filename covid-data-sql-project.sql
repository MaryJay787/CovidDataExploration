-- Query to view total cases vs. total deaths and aggregated the percentage out of 100. 
SELECT
location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS death_percentage
FROM 
`covid-data-387015.covid_data_exploration.covid_world_deaths` 
WHERE 
continent IS NOT NULL