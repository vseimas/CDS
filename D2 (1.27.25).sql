--- cds D2

-- Transfer Applicants by gender
select gender,
       count(id) AS Applied
from adm WITH (NOLOCK)
where season = 'fall' and year = '2024'
and styp_code = 't' and LEVL_CODE = 'ug' and uopi_status in ('not uopi', 'integrated accelerator')
and apst_code in ('c','d')
group by gender
order by
    case GENDER
    when 'M' then 1
    when 'F' then 2
    when 'N' then 3
    else 4
    end

--- Transfer Admits by gender
select gender,
       count(id) AS Admitted
from adm WITH (NOLOCK)
where season = 'fall' and year = '2024'
and styp_code = 't' and LEVL_CODE = 'ug' and uopi_status in ('not uopi', 'integrated accelerator')
and apdc_code1 in ('A1', 'AC', 'AI', 'C2', 'CC', 'CO', 'FL', 'NC', 'TF')
group by gender
order by
    case GENDER
    when 'M' then 1
    when 'F' then 2
    when 'N' then 3
    else 4
    end


--Transfer Enrollees by gender
select gender,
       count(id)enrolled
from enr WITH (NOLOCK)
where report = '1'
and season = 'fall' and year = '2024'
and styp_code = 't' and LEVL_CODE = 'ug' and uopi_status in ('not uopi', 'integrated accelerator')
group by  gender
order by
    case
    when gender = 'M' then 1
    when gender = 'F' then 2
    when  gender = 'N' then 3
    else 4
    end