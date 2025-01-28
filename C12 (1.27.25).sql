WITH GPAAVG AS (
select a.id, cast(b.high_school_reported_gpa as decimal (7,2)) AS high_school_reported_gpa
from enr a WITH (NOLOCK)
left join adm b on a.id = b.id
where report = '1'
and a.styp_code = 'n'
and a.UOPI_status in ('not UOPI', 'integrated accelerator')
and a.season = 'fall' and a.year = '2024'
and b.season = 'fall' and b. year = '2024'
)

select count(*) as Cohort,
       count (case when high_school_reported_gpa is not null then id END) AS GPA_SUB,
      format( avg(HIGH_SCHOOL_REPORTED_GPA), '0.00') AS AVG_GPA,
format ((count (case when high_school_reported_gpa is not null then id END) *100.00) / count(*), '0.00') AS PERC_SUB
    from GPAAVG WITH (NOLOCK)