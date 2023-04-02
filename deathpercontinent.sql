-- using CTE

with popvsvac (continent, location, date, population, new_vaccination,poepleVaccinated)
as 
(
select cd.continent, cd.location, cd.date, cd.population,cv.new_vaccinations,
SUM(new_vaccinations) OVER (partition by cd.location order by cd.location, cd.date) 
as peopleVaccinated 
from CovidDeaths cd 
join CovidVaccinations cv
on cd.location = cv.location 
where cd.continent is not null
)
select *, (peopleVaccinated/population)*100
from popvsvac

-- adding new column 

ALTER TABLE covidvaccinations 
ADD new_vaccinations int

-- Looking at total population vs vaccinations 

select cd.continent, cd.location, cd.date, cd.population,cv.new_vaccinations,
SUM(new_vaccinations) OVER (partition by cd.location order by cd.locations, cd.date) 
as peopleVaccinated 
top cd.location 500
from CovidDeaths cd 
join CovidVaccinations cv
on cd.location = cv.location 
where cd.continent is not null 
order by 2,3 


-- creating views for future visualisation 

create view HighestDeathPerContinent 
as
select continent, MAX(total_deaths) as totalDeathCount 
from coviddeaths 
where continent is not null
group by continent 
--order by totalDeathCount desc


-- lets break things down by continent 
-- showing continents  with highest death counts 

select continent, MAX(total_deaths) as totalDeathCount
from coviddeaths 
where continent is not null
group by continent 
order by totalDeathCount desc

