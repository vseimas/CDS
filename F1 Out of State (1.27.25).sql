--- FTFY Enrolled by Residency 
select
    case
        when region in ('Northern CA','Southern CA','Local Market') then 'In-State'
        when region in ('Eastern US', 'Western US') then 'Out-of-State'
        when region = 'International' then 'International'
        when region = 'Missing' or region is null then 'Missing' END AS Residency,
    count(id) As Enrolled,
	sum (case
		when region in ('Northern CA','Southern CA','Local Market','Eastern US', 'Western US', 'Missing' ) then 1 else 0 END) AS PartTotal
from enr WITH (NOLOCK)
where report = '1'
and season = 'fall' and year = '2024'
and styp_code = 'n' and uopi_status in ('not uopi', 'integrated accelerator')
group by 
    case
        when region in ('Northern CA','Southern CA','Local Market') then 'In-State'
        when region in ('Eastern US', 'Western US') then 'Out-of-State'
        when region = 'International' then 'International'
        when region = 'Missing' or region is null then 'Missing' END 

--- FTFY Enrolled by Residency TOTAL
--- ParTotal for calculation percentage on CD F1
select
    count(id) As Enrolled,
	sum (case
		when region in ('Northern CA','Southern CA','Local Market','Eastern US', 'Western US', 'Missing' ) then 1 else 0 END) AS PartTotal
from enr WITH (NOLOCK)
where report = '1'
and season = 'fall' and year = '2024'
and styp_code = 'n' and uopi_status in ('not uopi', 'integrated accelerator')


--- UG Enrolled by Residency
select
    case
        when region in ('Northern CA','Southern CA','Local Market') then 'In-State'
        when region in ('Eastern US', 'Western US') then 'Out-of-State'
        when region = 'International' then 'International'
        when region = 'Missing' or region is null then 'Missing' END AS Residency,
    count(id) As Enrolled,
	sum (case
		when region in ('Northern CA','Southern CA','Local Market','Eastern US', 'Western US', 'Missing' ) then 1 else 0 END) AS PartTotal
from enr WITH (NOLOCK)
where report = '1'
and season = 'fall' and year = '2024'
and level = 'ug'
group by 
    case
        when region in ('Northern CA','Southern CA','Local Market') then 'In-State'
        when region in ('Eastern US', 'Western US') then 'Out-of-State'
        when region = 'International' then 'International'
        when region = 'Missing' or region is null then 'Missing' END 

--- UGs Enrolled by Residency TOTAL
--- ParTotal for calculation percentage on CD F1
select
    count(id) As Enrolled,
	sum (case
		when region in ('Northern CA','Southern CA','Local Market','Eastern US', 'Western US', 'Missing' ) then 1 else 0 END) AS PartTotal
from enr WITH (NOLOCK)
where report = '1'
and season = 'fall' and year = '2024'
and level = 'ug'