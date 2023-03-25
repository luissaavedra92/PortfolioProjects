/*
Covid 19 Data Exploration 
The Dataset was retrieved from https://ourworldindata.org/covid-deaths on March 6, 2023
To simplyfy things, the dataset was divided into two tables (one containing information of Deaths and the other of Vaccinations) then imported.
*/


--Checking if everything was imported properly

SELECT *
FROM PortafolioProject.dbo.CovidDeaths
ORDER BY 3, 4

SELECT *
FROM PortafolioProject.dbo.CovidVaccinations
ORDER BY 3, 4

--Exploring Data 

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortafolioProject.dbo.CovidDeaths
ORDER BY 1, 2

SELECT dea.location, dea.date, total_cases, total_deaths, population, vac.people_fully_vaccinated
FROM PortafolioProject.dbo.CovidDeaths dea
JOIN PortafolioProject.dbo.Covidvaccinations vac
ON dea.location = vac.location
WHERE total_deaths IS NOT NULL
ORDER BY 1, 2

--Looking at total cases vs total deaths
--DeathPercentage shows the likelyhood of dying

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM PortafolioProject.dbo.CovidDeaths
WHERE total_deaths IS NOT NULL
ORDER BY 1, 2


SELECT location, YEAR(date) AS year,
       AVG(total_deaths/total_cases)*100 AS avg_death_percentage
FROM PortafolioProject.dbo.CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location, YEAR(date)
ORDER BY 1, 2

-- Looking at Total Cases vs Population
-- PercentageInfected shows what percentage got infected by COVID

SELECT location, date, total_cases, population, (total_cases/population)*100 AS PercentageInfected
FROM PortafolioProject.dbo.CovidDeaths
ORDER BY 1, 2


-- Countries with Highest Infection Rate compared to Population *

SELECT location, date, MAX(total_cases) AS highest_cases, population, MAX((total_cases)/population)*100 AS HighestPercentageInfected
FROM PortafolioProject.dbo.CovidDeaths
GROUP BY location, population, date
ORDER BY HighestPercentageInfected DESC


-- Countries wiith Highest Death Count per Population *

SELECT location, date, MAX(CAST(Total_deaths AS INT)) AS TotalDeathCount
FROM PortafolioProject.dbo.CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location, date
ORDER BY TotalDeathCount DESC


-- Breaking things down by continent

-- Showing continents with the highest death count 

SELECT continent, MAX(CAST(Total_deaths AS int)) AS TotalDeathCount
FROM PortafolioProject.dbo.CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC


-- Global Numbers

SELECT SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS int)) AS total_deaths, SUM(CAST(new_deaths AS int))/SUM(new_cases)*100 AS DeathPercentage
FROM PortafolioProject.dbo.CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1, 2

-- DATA THAT WAS CHOSEN FOR LATER VISUALIZATION
-- All three querys will be saved into tables that will be exported to Tableau
-- The first query calculates the percentage of people fully vaccinated

With PerVac (Continent, Location, Date, Population, people_fully_vaccinated, per_people_fully_vaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, people_fully_vaccinated
,(vac.people_fully_vaccinated/dea.population)*100 as per_people_fully_vaccinated
From PortafolioProject.dbo.CovidDeaths dea
Join PortafolioProject.dbo.Covidvaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
)
Select *
From PerVac
Where people_fully_vaccinated is not null
Order by 2,3

-- This second query calculates the highest percentage of infected persons per country

SELECT location, date, MAX(total_cases) AS highest_cases, population, MAX((total_cases)/population)*100 AS HighestPercentageInfected
FROM PortafolioProject.dbo.CovidDeaths
GROUP BY location, population, date
ORDER BY HighestPercentageInfected DESC


-- This third query calculates the total death count per country *

SELECT location, date, MAX(CAST(Total_deaths AS INT)) AS TotalDeathCount
FROM PortafolioProject.dbo.CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location, date
ORDER BY TotalDeathCount DESC


