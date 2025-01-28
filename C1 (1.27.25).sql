--- FTFY Applicants by gender
select gender,
       count(id) AS Applied
from adm WITH (NOLOCK)
where season = 'fall' and year = '2023'
and styp_code = 'n' and uopi_status in ('not uopi', 'integrated accelerator')
and apst_code in ('c','d')
group by gender
order by
    case GENDER
    when 'M' then 1
    when 'F' then 2
    when 'N' then 3
    else 4
    end

--- FTFY Admits by gender
select gender,
       count(id) AS Admitted
from adm WITH (NOLOCK)
where season = 'fall' and year = '2023'
and styp_code = 'n' and uopi_status in ('not uopi', 'integrated accelerator')
and apdc_code1 in ('A1', 'AC', 'AI', 'C2', 'CC', 'CO', 'FL', 'NC', 'TF')
group by gender
order by
    case GENDER
    when 'M' then 1
    when 'F' then 2
    when 'N' then 3
    else 4
    end


--FTFY Enrollees by status and gender
select FT_pt, gender,
       count(id)enrolled
from enr WITH (NOLOCK)
where report = '1'
and season = 'fall' and year = '2023'
and styp_code = 'n' and uopi_status in ('not uopi', 'integrated accelerator')
group by ft_pt, gender
order by
    case
    when FT_PT = 'FT' and gender = 'M' then 1
    when FT_PT = 'PT' and gender = 'M' then 2
    when FT_PT = 'FT' and gender = 'F' then 3
    when FT_PT = 'PT' and gender = 'F' then 4
    when FT_PT = 'FT' and gender = 'N' then 5
    when FT_PT = 'PT' and gender = 'N' then 6
    else 7
    end

--UG Enrollees by status
select COUNT(id) AS Enrolled, FT_PT
from enr WITH (NOLOCK)
where report = '1'
and season = 'fall' and year = '2024'
and level = 'ug'
group by FT_PT


--Applicants by Residency
select
    case
        when region in ('Northern CA','Southern CA','Local Market') then 'In-State'
        when region in ('Eastern US', 'Western US') then 'Out-of-State'
        when region = 'International' then 'International'
        when region = 'Missing' or region is null then 'Missing' END AS Residency,
    count(id)applied
from adm WITH (NOLOCK )
where season = 'fall' and year = '2023'
and styp_code = 'n' and uopi_status in ('not uopi', 'integrated accelerator')
and apst_code in ('c','d')
group by
    case
        when region in ('Northern CA','Southern CA','Local Market') then 'In-State'
        when region in ('Eastern US', 'Western US') then 'Out-of-State'
        when region = 'International' then 'International'
        when region = 'Missing' or region is null then 'Missing' END

--Admits by Residency
select
       case
        when region in ('Northern CA','Southern CA','Local Market') then 'In-State'
        when region in ('Eastern US', 'Western US') then 'Out-of-State'
        when region = 'International' then 'International'
        when region = 'Missing' or region is null then 'Missing' END AS Residency,
    count(id) As Admitted
from adm WITH (NOLOCK )
where season = 'fall' and year = '2023'
and styp_code = 'n' and uopi_status in ('not uopi', 'integrated accelerator')
and apdc_code1 in ('A1', 'AC', 'AI', 'C2', 'CC', 'CO', 'FL', 'NC', 'TF')
group by
    case
        when region in ('Northern CA','Southern CA','Local Market') then 'In-State'
        when region in ('Eastern US', 'Western US') then 'Out-of-State'
        when region = 'International' then 'International'
        when region = 'Missing' or region is null then 'Missing' END


--- Enrolled by Residency
select
    case
        when region in ('Northern CA','Southern CA','Local Market') then 'In-State'
        when region in ('Eastern US', 'Western US') then 'Out-of-State'
        when region = 'International' then 'International'
        when region = 'Missing' or region is null then 'Missing' END AS Residency,
    count(id) As Enrolled
from enr WITH (NOLOCK)
where report = '1'
and season = 'fall' and year = '2022'
and styp_code = 'n' and uopi_status in ('not uopi', 'integrated accelerator')
group by
    case
        when region in ('Northern CA','Southern CA','Local Market') then 'In-State'
        when region in ('Eastern US', 'Western US') then 'Out-of-State'
        when region = 'International' then 'International'
        when region = 'Missing' or region is null then 'Missing' END

