--- Age 25Over for FTFY
select
    sum (case when age >= 25 then 1 else 0 END) AS '25 and older',
    sum (case when age < 25 then 1 else 0 END) AS 'under 25',
     FORMAT((SUM(CASE when age >= 25 then 1 else 0 END) * 100.0) / NULLIF(count(id), 0), '0.##') AS Over_Perc,
    count(id) As Enrolled
from enr (NOLOCK)
where report = '1'
and season = 'fall' and year = '2024'
and styp_code = 'n' and uopi_status in ('not uopi', 'integrated accelerator')

--- Average ages for FULL-TIME FTFY
select
      count(id) As Enrolled, avg(age) Avg_Age
from enr (NOLOCK)
where report = '1'
and season = 'fall' and year = '2024'
and styp_code = 'n' and uopi_status in ('not uopi', 'integrated accelerator')
and FT_pt = 'FT'

--- Average ages for ALL FTFY
select
      count(id) As Enrolled, avg(age) Avg_Age
from enr (NOLOCK)
where report = '1'
and season = 'fall' and year = '2024'
and styp_code = 'n' and uopi_status in ('not uopi', 'integrated accelerator')



--- Age 25 and Over for UGs
select
    sum (case when age >= 25 then 1 else 0 END) AS '25 and older',
    sum (case when age < 25 then 1 else 0 END) AS 'under 25',
     FORMAT((SUM(CASE when age >= 25 then 1 else 0 END) * 100.0) / NULLIF(count(id), 0), '0.##') AS Over_Perc,
    count(id) As Enrolled
from enr (NOLOCK)
where report = '1'
and season = 'fall' and year = '2024'
and level = 'ug'

--- Average ages for FULL-TIME UGs
select
    count(id) As Enrolled, avg(age) AS AVG_AGE
from enr (NOLOCK)
where report = '1'
and season = 'fall' and year = '2024'
and level = 'ug'
and FT_pt = 'FT'

--- Average ages for ALL UGs
select
    count(id) As Enrolled, avg(age) AS AVG_AGE
from enr WITH (NOLOCK)
where report = '1'
and season = 'fall' and year = '2024'
and level = 'ug'