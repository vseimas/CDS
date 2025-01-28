select count(id) as cohort,
sum (case retrn_2yr when 1 then 1 else 0 END) as Ret,
FORMAT((SUM(CASE retrn_2yr when 1 then 1 else 0 END) * 100.0) / NULLIF(count(id), 0), '0.##') AS Perc
from archive.dbo.RETENTION_First_Year_2024_10_22_CENSUS WITH (NOLOCK)
where season = 'fall' and year = '2023'