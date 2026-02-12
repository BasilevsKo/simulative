with ds as(
	select b.card --запрашиваем номер карты как идентификатор пользователя
			,(select
				max(b.datetime::date)+1 
				from bonuscheques b ) - max(b.datetime::date) as recency --считаем время с последней покупки
			,count(*) as frequency  --считаем частоту покупок за весь период
			,sum(b.summ_with_disc ) as monetary --считаем сумму покупок за весь период
	from bonuscheques b 
	where LENGTH(b.card)= 13 --отсекаем неопределенные дисконтные карты
	group by b.card  
order by frequency desc
)
select *, 
    		case --присваиваем статус по дате последнего посещения
    			when recency<=(
    			                select PERCENTILE_DISC(0.2)within group (order by recency) from ds) then 1
    			when recency<=
    			               (select PERCENTILE_DISC(0.35)within group (order by recency) from ds) then 2
    			else 3
    		end as r ,
    		case   -- присваиваем статус по частоте посещения за период
    			when frequency >=
    			                (select PERCENTILE_DISC(0.2)within group (order by frequency) from ds) then 1
    			when frequency >=
    			                (select PERCENTILE_DISC(0.35)within group (order by frequency) from ds) then 2
    			else 3
    		end as f,
    		case   -- присваиваем статус по итоговой сумме покупок за период
    			when monetary >= 
    			               (select PERCENTILE_DISC(0.2)within group (order by monetary) from ds) then 1
    			when monetary >= 
    			               (select PERCENTILE_DISC(0.35)within group (order by monetary) from ds) then 2
    			else 3
    		end as m
  from ds
  order by ds.monetary  

