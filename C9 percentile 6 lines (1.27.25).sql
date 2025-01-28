WITH CHRT AS (select a.pidm_key, a.id, a.TERM_CODE_KEY, cast(b.IRSV as decimal) as IRSV, cast(b.IRSM as decimal) as IRSM, cast(b.IRSM as decimal)+cast(b.IRSV as decimal) SATT,
       cast(b.TEST_SCORE6 AS INT) AS act_composite, HIGH_SCHOOL_REPORTED_GPA, cast(HIGH_SCHOOL_REPORTED_GPA AS DECIMAL) AS HSGPA,
     case when exists (select 1
                from SORTEST s WITH (NOLOCK)
                where s.SORTEST_TESC_CODE = 'a01'
                and a.pidm_key = s.SORTEST_PIDM
                and s.SORTEST_TEST_SCORE =
                    ( Select max(i.sortest_test_score)
                                from SORTEST i WITH (NOLOCK)
                                where i.SORTEST_TESC_CODE = 'a01' and i.sortest_pidm = s.SORTEST_PIDM) )
                  then (SELECT Top 1 s.SORTEST_TEST_SCORE
              FROM SORTEST s WITH (NOLOCK)
              WHERE s.SORTEST_TESC_CODE = 'a01'
                AND s.SORTEST_PIDM = a.pidm_key
                AND s.SORTEST_TEST_SCORE = (
                    SELECT MAX(i.SORTEST_TEST_SCORE)
                    FROM SORTEST i WITH (NOLOCK)
                    WHERE i.SORTEST_TESC_CODE = 'a01'
                      AND i.SORTEST_PIDM = s.SORTEST_PIDM
                ) )
               ELSE Null END AS ACT_ENG,
    case when exists (select 1
                from SORTEST s WITH (NOLOCK)
                where s.SORTEST_TESC_CODE = 'a02'
                and a.pidm_key = s.SORTEST_PIDM
                and s.SORTEST_TEST_SCORE =
                    ( Select max(i.sortest_test_score)
                                from SORTEST i WITH (NOLOCK)
                                where i.SORTEST_TESC_CODE = 'a02' and i.sortest_pidm = s.SORTEST_PIDM) )
                  then (SELECT Top 1 s.SORTEST_TEST_SCORE
              FROM SORTEST s WITH (NOLOCK)
              WHERE s.SORTEST_TESC_CODE = 'a02'
                AND s.SORTEST_PIDM = a.pidm_key
                AND s.SORTEST_TEST_SCORE = (
                    SELECT MAX(i.SORTEST_TEST_SCORE)
                    FROM SORTEST i WITH (NOLOCK)
                    WHERE i.SORTEST_TESC_CODE = 'a02'
                      AND i.SORTEST_PIDM = s.SORTEST_PIDM
                ) )
               ELSE Null END AS ACT_MATH
from enr a WITH (NOLOCK)
    left join adm b on a.id = b.id
where report = '1'
and a.season = 'fall' and a.year = '2024'
and a.styp_code = 'n'
and a.UOPI_status in ('not UOPI','integrated accelerator')
and b.season = 'fall' and b.year = '2024' )

, SCR_RANGES AS (select *,
                        case
                            when (IRSV is not null or IRSM is not null) and (act_eng is not null or act_math is not null) then 'Both'
							when (IRSV is not null or IRSM is not null) then 'SAT'
                            when (act_eng is not null or act_math is not null) then 'ACT'
                            else NULL END                                      as Test_Score,
                        case
                            when IRSV >= 700 then '700-800'
                            when IRSV >= 600 and IRSV < 700 then '600-699'
                            when IRSV >= 500 and IRSV < 600 then '500-599'
                            when IRSV >= 400 and IRSV < 500 then '400-499'
                            when IRSV >= 300 and IRSV < 400 then '300-399'
                            when IRSV >= 200 and IRSV < 300 then '200-299' END AS SATV_Range,
                        case
                            when IRSM >= 700 then '700-800'
                            when IRSM >= 600 and IRSM < 700 then '600-699'
                            when IRSM >= 500 and IRSM < 600 then '500-599'
                            when IRSM >= 400 and IRSM < 500 then '400-499'
                            when IRSM >= 300 and IRSM < 400 then '300-399'
                            when IRSM >= 200 and IRSM < 300 then '200-299' END AS SATM_Range,
                        case
                            when SATT >= 1400 then '1400-1600'
                            when SATT >= 1200 and SATT < 1400 then '1200-1399'
                            when SATT >= 1000 and SATT < 1200 then '1000-1199'
                            when SATT >= 800 and SATT < 1000 then '800-999'
                            when SATT >= 600 and SATT < 800 then '600-799'
                            when SATT >= 400 and SATT < 600 then '400-599' END AS SACOMP_Range,
                        case
                            when act_eng >= 30 then '30-36'
                            when act_eng >= 24 and act_eng < 30 then '24-29'
                            when act_eng >= 18 and act_eng < 24 then '18-23'
                            when act_eng >= 12 and act_eng < 18 then '12-17'
                            when act_eng >= 6 and act_eng < 12 then '6-11'
                            when act_eng < 6 then 'Below 6' END                As ACTE_Range,
                        case
                            when act_math >= 30 then '30-36'
                            when act_math >= 24 and act_math < 30 then '24-29'
                            when act_math >= 18 and act_math < 24 then '18-23'
                            when act_math >= 12 and act_math < 18 then '12-17'
                            when act_math >= 6 and act_math < 12 then '6-11'
                            when act_math < 6 then 'Below 6' END               As ACTM_Range,
                        case
                            when act_composite >= 30 then '30-36'
                            when act_composite >= 24 and act_composite < 30 then '24-29'
                            when act_composite >= 18 and act_composite < 24 then '18-23'
                            when act_composite >= 12 and act_composite < 18 then '12-17'
                            when act_composite >= 6 and act_composite < 12 then '6-11'
                            when act_composite < 6 then 'Below 6' END          As ACTCOMP_Range,
                        case
                            when cast(HIGH_SCHOOL_REPORTED_GPA AS Decimal(5, 2)) >= 4.0 then '4.0'
                            when cast(HIGH_SCHOOL_REPORTED_GPA AS Decimal(5, 2)) >= 3.75 and
                                 cast(HIGH_SCHOOL_REPORTED_GPA AS Decimal(5, 2)) <= 3.99 then '3.75-3.99'
                            when cast(HIGH_SCHOOL_REPORTED_GPA AS Decimal(5, 2)) >= 3.50 and
                                 cast(HIGH_SCHOOL_REPORTED_GPA AS Decimal(5, 2)) <= 3.74 then '3.50-3.74'
                            when cast(HIGH_SCHOOL_REPORTED_GPA AS Decimal(5, 2)) >= 3.25 and
                                 cast(HIGH_SCHOOL_REPORTED_GPA AS Decimal(5, 2)) <= 3.49 then '3.25-3.49'
                            when cast(HIGH_SCHOOL_REPORTED_GPA AS Decimal(5, 2)) >= 3.00 and
                                 cast(HIGH_SCHOOL_REPORTED_GPA AS Decimal(5, 2)) <= 3.24 then '3.00-3.24'
                            when cast(HIGH_SCHOOL_REPORTED_GPA AS Decimal(5, 2)) >= 2.50 and
                                 cast(HIGH_SCHOOL_REPORTED_GPA AS Decimal(5, 2)) <= 2.99 then '2.50-2.99'
                            when cast(HIGH_SCHOOL_REPORTED_GPA AS Decimal(5, 2)) >= 2.0 and
                                 cast(HIGH_SCHOOL_REPORTED_GPA AS Decimal(5, 2)) <= 2.49 then '2.0-2.49'
                            when cast(HIGH_SCHOOL_REPORTED_GPA AS Decimal(5, 2)) >= 1.0 and
                                 cast(HIGH_SCHOOL_REPORTED_GPA AS Decimal(5, 2)) <= 1.99 then '1.0-1.99'
                            when cast(HIGH_SCHOOL_REPORTED_GPA AS Decimal(5, 2)) < 1.0 then '<1.0'
                            END                                                as GPA_Range
                 from CHRT WITH (NOLOCK))

,SATRW AS (select
round(PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY IRSV) OVER (PARTITION BY TERM_CODE_KEY),0) AS PERC25,
round(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY IRSV) OVER (PARTITION BY TERM_CODE_KEY),0) AS PERC50,
round(PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY IRSV) OVER (PARTITION BY TERM_CODE_KEY),0)  AS PERC75
    from SCR_RANGES  WITH (NOLOCK)
    where Test_Score in ('SAT', 'Both') )

,SATMH AS (select
round(PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY IRSM) OVER (PARTITION BY TERM_CODE_KEY),0) AS PERC25,
round(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY IRSM) OVER (PARTITION BY TERM_CODE_KEY),0) AS PERC50,
round(PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY IRSM) OVER (PARTITION BY TERM_CODE_KEY),0)  AS PERC75
    from SCR_RANGES  WITH (NOLOCK)
    where Test_Score in ('SAT', 'Both') )

,SATCO AS (select
round(PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY SATT) OVER (PARTITION BY TERM_CODE_KEY),0) AS PERC25,
round(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY SATT) OVER (PARTITION BY TERM_CODE_KEY),0) AS PERC50,
round(PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY SATT) OVER (PARTITION BY TERM_CODE_KEY),0)  AS PERC75
    from SCR_RANGES  WITH (NOLOCK) 
    where Test_Score in ('SAT', 'Both') )

,ACTENG AS (select
round(PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY cast(ACT_ENG as int)) OVER (PARTITION BY TERM_CODE_KEY),0) AS PERC25,
round(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY cast(ACT_ENG as int)) OVER (PARTITION BY TERM_CODE_KEY),0) AS PERC50,
round(PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY cast(ACT_ENG as int)) OVER (PARTITION BY TERM_CODE_KEY),0)  AS PERC75
    from SCR_RANGES  WITH (NOLOCK)
    where Test_Score in ('ACT', 'Both') )

,ACTMTH AS (select
round(PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY cast(act_math as int)) OVER (PARTITION BY TERM_CODE_KEY),0) AS PERC25,
round(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY cast(act_math as int)) OVER (PARTITION BY TERM_CODE_KEY),0) AS PERC50,
round(PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY cast(act_math as int)) OVER (PARTITION BY TERM_CODE_KEY),0)  AS PERC75
    from SCR_RANGES  WITH (NOLOCK)
    where Test_Score in ('ACT', 'Both') )

,ACTCOMP AS (select
round(PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY cast(act_composite as int)) OVER (PARTITION BY TERM_CODE_KEY),0) AS PERC25,
round(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY cast(act_composite as int)) OVER (PARTITION BY TERM_CODE_KEY),0) AS PERC50,
round(PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY cast(act_composite as int)) OVER (PARTITION BY TERM_CODE_KEY),0)  AS PERC75
    from SCR_RANGES  WITH (NOLOCK)
    where Test_Score in ('ACT', 'Both') )


select 'SAT Composite' as Test_Score,
       PERC25, PERC50, PERC75, count(*) as SUBM
from SATCO  WITH (NOLOCK)
group by PERC25, PERC50, PERC75

UNION ALL

select 'SAT English' as Test_Score,
       PERC25, PERC50, PERC75, count(*) as SUBM
from SATRW  WITH (NOLOCK)
group by PERC25, PERC50, PERC75

UNION ALL

select 'SAT Math' as Test_Score,
       PERC25, PERC50, PERC75, count(*) as SUBM
from SATMH  WITH (NOLOCK)
group by PERC25, PERC50, PERC75

UNION ALL

select 'ACT Composite' as Test_Score,
       PERC25, PERC50, PERC75, count(*) as SUBM
from ACTCOMP  WITH (NOLOCK)
group by PERC25, PERC50, PERC75

UNION ALL

select 'ACT Math' as Test_Score,
       PERC25, PERC50, PERC75, count(*) as SUBM
from ACTMTH  WITH (NOLOCK)
group by PERC25, PERC50, PERC75


UNION ALL

select 'ACT English' as Test_Score,
       PERC25, PERC50, PERC75, count(*) as SUBM
from ACTENG  WITH (NOLOCK)
group by PERC25, PERC50, PERC75