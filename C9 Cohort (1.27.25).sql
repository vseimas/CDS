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

select count(PIDM_KEY) as Cohort
    from CHRT WITH (NOLOCK)