WITH Cohort AS (select pidm_key,
                       degc_code,
                       grad_4yr,
                       case grad_4yr when 1 then 0 ELSE grad_5yr END                   AS grad_5,
                       case when grad_4yr = 1 or grad_5yr = 1 then 0 ELSE grad_6yr END AS grad_6

                from archive.dbo.RETENTION_First_Year_2024_10_22_CENSUS WITH (NOLOCK)
                where season = 'fall'
                  and year = '2018' --Update to current reporting cohort
)
,PELL AS (  select c.pidm_key,
                 degc_code,
                 grad_4yr,
                 grad_5,
                 grad_6,
                 case when exists
                    (Select 1
                     from core.dbo.AR_AWARD_DETAIL_BY_YEAR_1819 as a --- Update to match the current reporting cohort
                     where  a.PIDM_KEY = c.PIDM_KEY and a.FUND_CODE_KEY = 'PEll'and a.AWARD_ACCEPT_AMOUNT > 0  ) then 1 else 0 END As PLL
          from Cohort AS c WITH (NOLOCK)
             )
,FORD AS (select c.pidm_key,
                 degc_code,
                 grad_4yr,
                 grad_5,
                 grad_6,
                 PLL,
                 case
                     when exists
                              (Select 1
                               from core.dbo.AR_AWARD_DETAIL_BY_YEAR_1819 as a --- Update to match the current reporting cohort
                               where a.PIDM_KEY = c.PIDM_KEY
                                 and a.FUND_CODE_KEY = 'FORD' and a.AWARD_ACCEPT_AMOUNT > 0 ) and PLL = 0 then 1
                     else 0 END As FRD
          from PELL AS c WITH (NOLOCK)
          )

,NONPF AS (select c.pidm_key,
                degc_code,
                grad_4yr,
                grad_5,
                grad_6,
                PLL,
                FRD,
                case
                    when PLL = 0 and FRD = 0 then 1
                    END As NON
         from FORD as C WITH (NOLOCK)
         )

,AIDCAT AS (SELECT pidm_key,
                   degc_code,
                   grad_4yr,
                   grad_5,
                   grad_6,
                   PLL,
                   FRD,
                   Non,
                   case
                       when PLL = 1 then '1. Recipients of a Federal Pell Grant'
                       when FRD = 1 then '2. Recipients of a Subsidized Stafford Loan who did not receive a Pell Grant'
                       when Non = 1
                           then '3. Students who did not receive either a Pell Grant or a subsidized Stafford Loan' END AS Aid_Cat
            FROM NONPF  WITH (NOLOCK))

select Aid_Cat, count(pidm_key) as Cohort, sum(cast(grad_4yr as decimal)) AS Grad_4Yr,
       sum(cast(grad_5 as decimal)) AS Grad_5r,
       sum(cast(grad_6 as decimal)) AS Grad_6Yr,
      ( sum(cast(grad_4yr as decimal)) +    sum(cast(grad_5 as decimal)) +   sum(cast(grad_6 as decimal)) ) AS Within_6Yrs
from AIDCAT WITH (NOLOCK)
group by Aid_Cat

