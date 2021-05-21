Select *
From Database1..covid_deaths
Where continent is not null
Order By 3,4

--Select *
--From Database1..covid_vaccinations
--Order By 3,4

--Select Location, date, total_cases, total_deaths, new_cases, new_deaths
--From Database1..covid_deaths
--Order By 1,2

--Looking at total_cases vs total_deaths

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 As Death_percentage
From Database1..covid_deaths
Where Location like '%states%'
Order By 1,2

--Looking at total_cases vs population

Select Location, date, total_cases, Population, (total_cases/Population)*100 As casesoverpop
From Database1..covid_deaths
Where continent is not null
--Where Location like '%states%'
Order By 1,2

Select Location,total_cases, Max(total_cases) as Highest_infected
From Database1..covid_deaths
Group By Location, total_cases
Order By Highest_infected Desc

Select Location,Population, Max(total_cases) as Highest_infected, Max(total_cases/Population)*100 as percpopInfected
From Database1..covid_deaths
Group By Location, Population
Order By 1,2

Select Location,Population, Max(total_cases) as Highest_infected, Max(total_cases/Population)*100 as percpopInfected
From Database1..covid_deaths
Group By Location, Population
Order By percpopInfected Desc

Select Location, Max(Cast(Total_deaths as int)) as TotalDeathsCount
From Database1..covid_deaths
Where continent is not null
Group By Location
Order By TotalDeathsCount Desc

--Showing continent with deaths values per population
Select continent, Max(Cast(Total_deaths as int)) as TotalDeathsCount
From Database1..covid_deaths
Where continent is not null
Group By continent
Order By TotalDeathsCount Desc

--Globle Numbers
--Total Deaths, cases

Select SUM(new_cases) as total_cases, SUM(CAST(new_deaths as INT)) as total_deaths, SUM(CAST(new_deaths as INT))/SUM(New_Cases)*100 as DeathPercentage 
From Database1..covid_deaths
--Where Location like '%states%'
Where continent is not null
--Group By date
Order By 1,2

Select *
From Database1..covid_deaths dea
join Database1..covid_vaccinations vac
     on dea.Location = vac.Location
	and dea.date = vac.date

--Total_population vs vaccinations
--USE CET
with POPvsVAC (Continent, location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.Location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From Database1..covid_deaths dea
join Database1..covid_vaccinations vac
     on dea.location = vac.location
	  and dea.date = vac.date
Where dea.continent is not null
	
--Order By 2,3
)
Select * ,(RollingPeopleVaccinated/Population)*100
From POPvsVAC


--TEMP_table

Drop Table if exists #PercentpopulationVaccinated 
Create Table #PercentpopulationVaccinated
(
continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccination numeric,
RollingPeopleVaccinated numeric
)
Insert into #PercentpopulationVaccinated
Select dea.continent, dea.Location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From Database1..covid_deaths dea
join Database1..covid_vaccinations vac
     on dea.location = vac.location
	  and dea.date = vac.date
Where dea.continent is not null
	
Select * ,(RollingPeopleVaccinated/Population)*100
From #PercentpopulationVaccinated


--creating the view to store data for later visualization

create view PercentpopulationVaccinated as
Select dea.continent, dea.Location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From Database1..covid_deaths dea
join Database1..covid_vaccinations vac
     on dea.location = vac.location
	  and dea.date = vac.date
Where dea.continent is not null
--Order By 2,3

Select * 
From PercentpopulationVaccinated









