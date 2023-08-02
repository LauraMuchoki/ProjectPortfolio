select * 
from PortfolioProjects..CovidDeaths
order by 3,4

select location, date, total_cases,new_cases, cast(total_deaths as int) as TotalDeaths, population
from PortfolioProjects..CovidDeaths
order by 1,2

select * from PortfolioProjects..CovidVaccinations

select location, date, total_cases,new_cases, total_deaths, population
from PortfolioProjects..CovidDeaths
order by 3,4

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProjects..CovidDeaths
where location like '% Africa%'
order by 1,2

--Looking at Total Cases vs Population
-- Shows what percentage of population got Covid

select location, date, Population, total_cases,  (total_cases/Population)*100 as PopulationPercentageInfected
from PortfolioProjects..CovidDeaths
where location like '%Africa%'
order by 1,2

select location, Population, MAX(total_cases)as HighestInfectionCount,  MAX((total_cases/Population))*100 as PopulationPercentageInfected
from PortfolioProjects..CovidDeaths
--where location like '%Africa%'
group by location, Population
order by PopulationPercentageInfected desc

--Showing Counties with Highest Death count per Population.

select location, MAX (CAST (total_deaths as int)) as TotalDeathCount
from PortfolioProjects..CovidDeaths
where continent is not null
group by location 
order by TotalDeathCount  desc

--LETS BREAK THINGS DOWN BY CONTINENT
--Showing the continents with the highest death count per population

select continent, MAX (CAST (total_deaths as int)) as TotalDeathCount
from PortfolioProjects..CovidDeaths
where continent is not null
group by continent 
order by TotalDeathCount  desc

-- GLOBAL NUMBERS

select  date, sum(new_cases)as total_cases, sum(cast(new_deaths as int))as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage 
from PortfolioProjects..CovidDeaths
--where location like '%Africa%'
where continent is not null
group by date
order by 1,2

--Showing total global cases, Deaths and DeathPercentage.

select  sum(new_cases)as total_cases, sum(cast(new_deaths as int))as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage 
from PortfolioProjects..CovidDeaths
--where location like '%Africa%'
where continent is not null
--group by date
order by 1,2

--Looking at Total population vs Vaccination

select *
From PortfolioProjects..CovidDeaths dea
Join PortfolioProjects..CovidVaccinations vac
on dea.location= vac.location
and dea.date= vac.date


select dea.continent, dea.location, dea.date,dea.population, cast(vac.new_vaccinations as bigint)
From PortfolioProjects..CovidDeaths dea
Join PortfolioProjects..CovidVaccinations vac
on dea.location= vac.location
and dea.date= vac.date
where dea.continent is not null
order by 1,2,3

select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations,
sum(convert(int, vac.new_vaccinations)) over (partition by dea.location 
order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProjects..CovidDeaths dea
Join PortfolioProjects..CovidVaccinations vac
on dea.location= vac.location
and dea.date= vac.date
where dea.continent is not null
order by 1,2,3


--USING CTEs

with PopvsVac( continent,location,date,population,new_vaccinations,RollingPeopleVaccinated)
 as (
select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations,
sum(convert(int, vac.new_vaccinations)) over (partition by dea.location 
order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProjects..CovidDeaths dea
Join PortfolioProjects..CovidVaccinations vac
on dea.location= vac.location
and dea.date= vac.date
where dea.continent is not null

)
 select*, (RollingPeopleVaccinated/Population)*100 as RollingPercentage
 from PopvsVac


--USING TEMP TABLE

Create table #PercentagePopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

INSERT INTO #PercentagePopulationVaccinated

select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations,
sum(convert(int, vac.new_vaccinations)) over (partition by dea.location 
order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProjects..CovidDeaths dea
Join PortfolioProjects..CovidVaccinations vac
on dea.location= vac.location
and dea.date= vac.date
where dea.continent is not null

 select*, (RollingPeopleVaccinated/Population)*100 as RollingPercentage
 from #PercentagePopulationVaccinated


 --MAKING CHANGES TO THE TEMP TABLE

 Drop Table if Exists #PercentagePopulationVaccinated
 Create table #PercentagePopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

INSERT INTO #PercentagePopulationVaccinated

select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations,
sum(convert(int, vac.new_vaccinations)) over (partition by dea.location 
order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProjects..CovidDeaths dea
Join PortfolioProjects..CovidVaccinations vac
on dea.location= vac.location
and dea.date= vac.date
--where dea.continent is not null

 select*, (RollingPeopleVaccinated/Population)*100 as RollingPercentage
 from #PercentagePopulationVaccinated

 
 --CREATING VIEW TO STORE DATA FOR LATER VISUALIZATION
 --Drop view if exists PercentagePopulationVaccinated
 create view PercentagePopulationVaccinated as
 select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations,
sum(convert(int, vac.new_vaccinations)) over (partition by dea.location 
order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProjects..CovidDeaths dea
Join PortfolioProjects..CovidVaccinations vac
on dea.location= vac.location
and dea.date= vac.date
where dea.continent is not null

select * 
from PercentagePopulationVaccinated


















 
 



