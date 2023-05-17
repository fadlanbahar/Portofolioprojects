#Covid Deaths
select location, `date`, total_cases , new_cases , total_deaths ,population 
from covid.owid_covid_data ocd 
order by 1,2

#looking at total cases vs total deaths
select location, `date`, total_cases , total_deaths ,(total_deaths/total_cases)*100 as DeathPercentage
from covid.owid_covid_data ocd
where location like '%states'
order by 1,2

# looking at total cases vs population
# shows what percentage of population got covid
select location, `date`,population,total_cases , (total_deaths/population)*100 as PopulationPercentageinfection
from covid.owid_covid_data ocd
where location like '%states'
order by 1,2

#looking at countries with highest infection rate compared to population
select location , population , max(total_cases) as HighestInfectioncount, max(total_cases/population)*100 as  PercentPopulationInfected
from covid.owid_covid_data ocd
group by location, population 
order by PercentPopulationInfected desc

#showing country with highest death count per population
select location , max(total_deaths) as TotalDeathCount
from covid.owid_covid_data ocd 
where continent is not null
group by 1 
order by 2 desc


#Lets breaking down by continent 
#show continents with the highest death count per population
select continent  , max(total_deaths) as TotalDeathCount
from covid.owid_covid_data ocd 
where continent is not NULL
group by 1 
order by 2 desc

#global numbers
select `date` , sum(new_cases) as TotalCases, sum(new_deaths) as TotalDeaths, (sum(new_deaths)/sum(new_cases))*100  as DeathPercentage
from covid.owid_covid_data ocd 
where continent is not null 
group by `date` 
order by 1,2

#looking for all cases
select sum(new_cases) as TotalCases, sum(new_deaths) as TotalDeaths, (sum(new_deaths)/sum(new_cases))*100  as DeathPercentage
from covid.owid_covid_data ocd 
where continent is not null 
order by 1,2

#COVID VACCINATION

#looking at total population vs vaccination

select continent, location , `date` , population ,new_vaccinations,
	sum(new_vaccinations) over(partition by location order by location, `date`) as RollingPeopleVaccinated
from covid.owid_covid_data ocd 
where continent is not null
order by 1,2,3

#using CTE
with PopvsVac (continent, location,`date`,population,new_vaccinations, RollingPeopleVaccinated)
as(
select continent, location , `date` , population ,new_vaccinations,
	sum(new_vaccinations) over(partition by location order by location, `date`) as RollingPeopleVaccinated
from covid.owid_covid_data ocd 
where continent is not null
order by 1,2,3
)
select *, (RollingPeopleVaccinated/population)*100
from PopvsVac

#Temp Table
drop table if exits
create table#Percent Population Vaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccination numeric,
RollingPeopleVaccinated numeric
)

insert into 
select continent, location , `date` , population ,new_vaccinations,
	sum(new_vaccinations) over(partition by location order by location, `date`) as RollingPeopleVaccinated
from covid.owid_covid_data ocd 
where continent is not null

select *, (RollingPeopleVaccinated/population)*100
from PopvsVac


#CREATING VIEW TO STORE DATA FOR LATER VISUALIZATIONS

create view PercentPopulationVaccinated as
select continent , location , `date` , population , new_vaccinations,
sum(new_vaccinations) over(partition by location order by location, `date`) as RollingPeopleVaccinated
from covid.owid_covid_data ocd 
where continent is not null 



select*
from covid.percentpopulationvaccinated p 


