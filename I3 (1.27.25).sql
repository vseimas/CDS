WITH TempCRN AS (
    select distinct CRN_KEY
    from REG WITH (NOLOCK)
    where report = '1'
    and season = 'fall' and year = '2024'
    and LEVL_CODE in ('ug', 'uu')
)
, SectionData AS (
select actual_enrollment, crn_key, left(CRSE_NUMBER,3) as CRS_NUM, SCHD_CODE_MEET1,
       case
           when  actual_enrollment >=2 and actual_enrollment < 10 then '1. 2-9'
            when actual_enrollment >=10 and actual_enrollment < 20 then '2. 10-19'
            when actual_enrollment >=20 and actual_enrollment < 30 then '3. 20-29'
            when actual_enrollment >=30 and actual_enrollment < 40 then '4. 30-39'
            when actual_enrollment >=40 and actual_enrollment < 50 then '5. 40-49'
            when actual_enrollment >=50 and actual_enrollment < 100 then '6. 50-99'
            when actual_enrollment >= 100 then '7. 100' END AS Class_Size
from SECT_SUM WITH (NOLOCK)
where actual_enrollment > 1
  and coll_code <> 'lw'
  and (coll_code <> 'dt' or (coll_code = 'dt' and dept_code = 'DHYG'))
  and (coll_code not in ('sp','ph') or (coll_code in ('sp','ph') and dept_code = 'SLPA'))
  --- and schd_code_meet1 in ('1', '5', '6','7')
and term_code_key in ('202452','202481','202484')
and season = 'fall' and year = '2024'
    )
, CleanedData AS (
    select actual_enrollment, crn_key, CRS_NUM, SCHD_CODE_MEET1,Class_Size,
           case
        when CRS_NUM >= '200' and CRN_KEY not in (select CRN_KEY from TempCRN) then 0 else 1 END AS GRADOUT
    from SectionData WITH (NOLOCK)
)

Select Class_Size, sum(case when schd_code_meet1 in ('1', '5', '6','7') then 1 else 0 END) As Sect_count,
sum(case when schd_code_meet1 in ('2', '9') then 1 else 0 END) As SubSect_count
from  CleanedData sd
where GRADOUT = 1
group by Class_Size