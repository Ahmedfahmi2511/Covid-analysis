--prepare Data before using it
alter table CovidDeaths
alter column total_cases float;

alter table CovidDeaths
alter column total_deaths float;

alter table CovidDeaths
alter column new_cases float;

alter table CovidDeaths
alter column population float;



--Data we are going to use 
  create view  covid_data as 
  select continent,location,date,total_cases,new_cases,total_deaths,population
  from CovidDeaths;
  
--Looking at Total cases vs population
--shows what percenatage who got covid
select location,date,population,total_cases,(total_cases /nullif(population,0))*100  as avg_covid
from covid_data
order by 1,2;

--looking at countries with highest infaction rate compared with population
select location,population,max(total_cases) as Highestinfation,max((total_cases /nullif(population,0))*100 )  as percent_pop_infacted
from covid_data
group by location,population
order by percent_pop_infacted desc ;

--Showing countries with highest death count per population

select location,max(total_deaths) as totaldeath_count
from covid_data
where continent <> ''
group by location
order by totaldeath_count desc

--Lets break things down by continent 

select continent,max(total_deaths) as totaldeath_count
from covid_data
where continent <> ''
group by continent
order by totaldeath_count desc

--Globel Numbers

select date, sum(new_cases) as total_cases, sum(cast(new_deaths as int )) as total_deaths , (sum(cast(new_deaths as int )) / nullif(sum(new_cases),0) )*100 deathpercentage
from CovidDeaths
where continent <> ''
group by date
order by 1,2;

--Looking at total population vs vaccination
create view pop_vaccinated as
select d.continent,d.location,d.date,d.population,v.new_vaccinations,
 sum(cast(v.new_vaccinations as int ) ) over (partition by d.location order by d.location,d.date) as Rolling_pop_vac  

from CovidDeaths as d
join covidvac as v
on d.location = v.location and d.date = v.date
where d.continent <> ''
--order by 2,3



