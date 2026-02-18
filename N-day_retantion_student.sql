with sub as(
	select 
		u.id,
		to_char(u.date_joined, 'YYYY-MM') cohort,
		extract(days from ue.entry_at - u.date_joined)  ddif
	from userentry ue
	join users u on u.id=ue.user_id 
	where u.date_joined::date>='2022-01-01'
)
select cohort, 
	round(count(distinct case when ddif = 0 then id end)*100.0/count(distinct case when ddif = 0 then id end), 2) as "0 (%)",
	round(count(distinct case when ddif = 1 then id end)*100.0/count(distinct case when ddif = 0 then id end), 2) as "1 (%)",
	round(count(distinct case when ddif = 3 then id end)*100.0/count(distinct case when ddif = 0 then id end), 2) as "3 (%)",
	round(count(distinct case when ddif = 7 then id end)*100.0/count(distinct case when ddif = 0 then id end), 2) as "7 (%)",
	round(count(distinct case when ddif = 14 then id end)*100.0/count(distinct case when ddif = 0 then id end), 2) as "14 (%)",
	round(count(distinct case when ddif = 30 then id end)*100.0/count(distinct case when ddif = 0 then id end), 2) as "30 (%)",
	round(count(distinct case when ddif = 60 then id end)*100.0/count(distinct case when ddif = 0 then id end), 2) as "60 (%)",
	round(count(distinct case when ddif = 90 then id end)*100.0/count(distinct case when ddif = 0 then id end), 2) as "90 (%)"
	from sub 
group by cohort