WITH CDS_B AS (select id,
                      ft_pt,
                      styp_code,
                      level,
                      levl_code,
                      degc_code,
                      clas_code,
                      gender,
                      ethnic_code,
                      ethn_code,
                      case
                          when gender = 'M' then 'Men'
                          when gender = 'F' then 'Women'
                          when gender = 'N' or gender is null then 'Another Gender' END AS GEN,
                      case ethnic_code
                          when 'F' then '1. Nonresidents'
                          when 'H' then '2. Hispanic/Latino'
                          when 'B' then '3. Black or African American/ non-Hispanic'
                          when 'W' then '4. White/ non-Hispanic'
                          when 'N' then '5. American Indian or Alaska Native/ non-Hispanic'
                          when 'S' then '6. Asian/ non-Hispanic'
                          when 'P' then '7. Native Hawaiian or other Pacific Islander/ non-Hispanic'
                          when 'M' then '8. Two or more races/ non-Hispanic'
                          when 'U' then '9. Race and/or ethnicity unknown' END          AS Ethnicity,
                      case level
                          when 'UG' then 'UG'
                          when 'GR' then 'GR'
                          when 'PR' then 'GR' END                                       AS LevelRpt,
                      case
                          when styp_code = 'n' then 1
                          else 0 END                                                    AS firsttime_ug,
                      case
                          when styp_code <> 'n' and clas_code = 'FR' and levl_code = 'ug' then 1
                          else 0 END                                                    AS other_firsttime,
                      case
                          when styp_code <> 'n' and clas_code <> 'FR' and levl_code = 'ug' then 1
                          else 0 END                                                    AS other_ug,
                      case
                          when levl_code = 'uu' then 1
                          else 0 END                                                    AS nondeg_ug,
                      case
                          when styp_code in ('g', 'p') then 1
                          else 0 END                                                    AS firsttime_gr,
                      case
                          when styp_code not in ('g', 'p') and levl_code in ('gr', 'pr', 'lw') then 1
                          else 0 END                                                    AS other_gr,
                      case
                          when levl_code in ('gu', 'pu') then 1
                          else 0 END                                                    AS nondeg_gr
               from enr
               where report = '1'
                 and season = 'fall'
                 and year = '2024')

select GEN, count(id) as Students
    FROM CDS_B WITH (NOLOCK)
group by GEN
order by
    case GEN
    when 'Men' then 1
    when 'Women' then 2
    when 'Another Gender' then 3 END