-- Showing tables
USE PortfolioProject
SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES
SELECT name AS table_name FROM sys.tables
SELECT COUNT(*) AS number_of_tables FROM sys.tables

-- General Query
SELECT * FROM PortfolioProject..CovidDeaths ORDER BY 3,4
SELECT * FROM PortfolioProject.dbo.CovidVaccinations ORDER BY 3, 4

--listing all tables
--SELECT COLUMN_NAME, DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'PortfolioProject' AND TABLE_NAME = 'CovidDeaths'
SELECT COLUMN_NAME, DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='CovidDeaths'


--Select the data that we are going to be using (do it based off location and date)
SELECT location, date, total_cases, new_cases, total_deaths, population FROM PortfolioProject..CovidDeaths ORDER BY 1, 2


-- Alter table to change data types
USE PortfolioProject
ALTER TABLE CovidDeaths
ALTER COLUMN total_cases INT


USE PortfolioProject
ALTER TABLE CovidDeaths
ALTER COLUMN total_deaths INT

-- Confirmation
SELECT COLUMN_NAME, DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='CovidDeaths'

-- Looking at the Total Cases vs Total Deaths
-- Shows the likelihood of dieing if you contract covid in your country
SELECT
location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage 
FROM PortfolioProject..CovidDeaths
WHERE location='Kenya'
--WHERE location LIKE '%state%'
-- WHERE (total_deaths/total_cases)*100 > 0
ORDER BY 1, 2


-- Looking at the total cases vs population
-- Shows what Percentage of population has got covid
SELECT location, date, total_cases, population, (total_cases/population)*100 AS InfectedPercentage
FROM PortfolioProject..CovidDeaths
WHERE location='Kenya' AND continent is not null
ORDER BY 1, 2

--Looking at countries with highest infection rate compared to population
SELECT location, population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population))*100 AS PercentPopInfected
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
GROUP BY population, location
ORDER BY PercentPopInfected DESC

-- Showing the countries with the highest death count per population
SELECT location, MAX(cast(total_deaths as int)) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
GROUP BY location
ORDER BY TotalDeathCount DESC

-- We realise that we are having continents as countries
-- Under the general query when the continent is null it has been filled in as a country too
SELECT * FROM PortfolioProject..CovidDeaths
WHERE continent is not null
ORDER BY 3, 4

-- BREAKING THINGS DOWN BY CONTINENT
SELECT continent, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount DESC

-- The correct numbers
SELECT location, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent is null
GROUP BY location
ORDER BY TotalDeathCount DESC

-- GLOBAL NUMBERS
-- On each day the total across the world
SELECT date, 
SUM(new_cases) AS NewInfections, 
SUM(cast(new_deaths AS INT)) AS NewDeaths, 
SUM(cast(new_deaths AS INT))/SUM(new_cases)*100 AS DeathPercetange
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1, 2

-- Overall cases and deaths across the world
SELECT 
SUM(new_cases) AS NewInfections, 
SUM(cast(new_deaths AS INT)) AS NewDeaths, 
SUM(cast(new_deaths AS INT))/SUM(new_cases)*100 AS DeathPercetange
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1, 2


-- COVID VACCINATONS
SELECT COLUMN_NAME, DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='CovidVaccinations'
SELECT * FROM PortfolioProject..CovidVaccinations