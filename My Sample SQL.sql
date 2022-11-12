--My Sample Query for report generation 1

Main Query
(
with calc as 
(
	select  
	to_char(pt.posting_date,'Mon-yyyy') as posting_date,
	to_char(pt.posting_date,'mm') as order_date,
	ag.description as agency_name,
	sum(pt.amount) as amount 
	FROM 
	ptragency_payment_transaction pt
	inner join ptragency ag on ag.id = pt.agency_id
	where pt.posting_date between date_trunc('year',current_date) + interval '-12 month' and date_trunc('year',current_date) + interval '-1 day'
	group by pt.posting_date, ag.description
	order by order_date 
)
select 
c.posting_date as month,
c.agency_name as sbw, --month
sum(coalesce(c.amount,0)) as paytotal
from calc c
group by c.posting_date,c.order_date,c.agency_name
order by c.order_date
)
union all
(
	select 
	'Sept 2021' as month,
	'CCR Networks Sdn Bhd' as sbw,
	3000::numeric
)
union all
(
	select 
	'Sept 2021' as month,
	'Sunshine' as sbw,
	5000::numeric
)	
union all
(
	select 
	'Sept 2021' as month,
	'TKC' as sbw,
	8000::numeric
)	
union all
(
	select 
	'Sept 2021' as month,
	'BCD' as sbw,
	8000::numeric
)
union all
(
	select 
	'Sept 2021' as month,
	'NNA' as sbw,
	8000::numeric
)
union all
(
	select 
	'Sept 2021' as month,
	'GGG' as sbw,
	3000::numeric
)
union all
(
	select 
	'Sept 2021' as month,
	'CCC' as sbw,
	5000::numeric
)	
union all
(
	select 
	'Sept 2021' as month,
	'AAA' as sbw,
	8000::numeric
)	
union all
(
	select 
	'Sept 2021' as month,
	'EEE' as sbw,
	8000::numeric
)
union all
(
	select 
	'Sept 2021' as month,
	'QQQ' as sbw,
	8000::numeric
)
union all
(
	select 
	'Oct 2021' as month,
	'CCR Networks Sdn Bhd' as sbw,
	3000::numeric
)
union all
(
	select 
	'Oct 2021' as month,
	'Sunshine' as sbw,
	5000::numeric
)	
union all
(
	select 
	'Oct 2021' as month,
	'TKC' as sbw,
	8000::numeric
)


----------------------------------------------------------------------
Sum Query
select 
total.month as month,
sum(total.paytotal) as sumPayTotal
from
(
	(
		with calc as 
		(
			select  
			to_char(pt.posting_date,'Mon-yyyy') as posting_date,
			to_char(pt.posting_date,'mm') as order_date,
			ag.description as agency_name,
			sum(pt.amount) as amount 
			FROM 
			ptragency_payment_transaction pt
			inner join ptragency ag on ag.id = pt.agency_id
			where pt.posting_date between date_trunc('year',current_date) + interval '-12 month' and date_trunc('year',current_date) + interval '-1 day'
			group by pt.posting_date, ag.description
			order by order_date 
		)
		select 
		c.posting_date as month,
		c.agency_name as sbw, --month
		sum(coalesce(c.amount,0)) as paytotal
		from calc c
		group by c.posting_date,c.order_date,c.agency_name
		order by c.order_date
		)
		union all
		(
			select 
			'Sept 2021' as month,
			'CCR Networks Sdn Bhd' as sbw,
			3000::numeric
		)
		union all
		(
			select 
			'Sept 2021' as month,
			'Sunshine' as sbw,
			5000::numeric
		)	
		union all
		(
			select 
			'Sept 2021' as month,
			'TKC' as sbw,
			8000::numeric
		)	
		union all
		(
			select 
			'Sept 2021' as month,
			'BCD' as sbw,
			8000::numeric
		)
		union all
		(
			select 
			'Sept 2021' as month,
			'NNA' as sbw,
			8000::numeric
		)
		union all
		(
			select 
			'Sept 2021' as month,
			'GGG' as sbw,
			3000::numeric
		)
		union all
		(
			select 
			'Sept 2021' as month,
			'CCC' as sbw,
			5000::numeric
		)	
		union all
		(
			select 
			'Sept 2021' as month,
			'AAA' as sbw,
			8000::numeric
		)	
		union all
		(
			select 
			'Sept 2021' as month,
			'EEE' as sbw,
			8000::numeric
		)
		union all
		(
			select 
			'Sept 2021' as month,
			'QQQ' as sbw,
			8000::numeric
		)
		union all
		(
			select 
			'Oct 2021' as month,
			'CCR Networks Sdn Bhd' as sbw,
			3000::numeric
		)
		union all
		(
			select 
			'Oct 2021' as month,
			'Sunshine' as sbw,
			5000::numeric
		)	
		union all
		(
			select 
			'Oct 2021' as month,
			'TKC' as sbw,
			8000::numeric
		)
) as total
group by total.month


--My Sample Query for report generation 2

--Main Product Query
with result as 
(
	select 
	case 
	when ptc.code in ('PF') then 1
	when ptc.code in ('HF') then 2
	when ptc.code in ('MF') then 3
	when ptc.code in ('IPS') then 4
	when ptc.code in ('AF') then 5
	when ptc.code in ('OTH') then 6
	end as order_prd, 
	date_trunc('month',rs.effective_date)::date as month,
	ptc.description as product_type_category,
	sum(rs.sum_total_arrears) as paytotal
	FROM 
	ks_daily_report_summary rs
	inner join kshostref_product_type_category ptc on ptc.id = rs.product_type_category_id
	where 
	ptc.code in ('AF', 'HF', 'MF', 'IPS', 'PF', 'OTH')
	and rs.effective_date between date_trunc('month',current_date) + interval '- 12 month' and date_trunc('month',current_date) + interval ' 1 month - 1 day'
	group by rs.effective_date, ptc.code, ptc.description
	order by rs.effective_date, ptc.description
)
select 
result.order_prd,
result.month,
'' as product_sub_category,
INITCAP(result.product_type_category) as product_category,
sum(result.paytotal) as paytotal,
sum(result.payTotal) filter (where date_trunc('year',result.month) >= date_trunc('year',current_date)) as ytdtotal
from result
group by result.month, result.order_prd, result.product_type_category
order by result.month

------------------------------------------------------------

--Sub-Query - Product Detail for Personal Financing

with result as
(
	select 
	date_trunc('month',prof.profile_date)::date as month,
	case
	when UPPER(sub.description) like '%AWAM%' then 1
	when UPPER(sub.description) like '%PINTAR%' then 2
	when UPPER(sub.description) like '%SWASTA%' then 3
	else 4
	end as order_prod,
	case
	when UPPER(sub.description) like '%AWAM%' then INITCAP('ASLAH AWAM')
	when UPPER(sub.description) like '%PINTAR%' then INITCAP('ASLAH PINTAR')
	when UPPER(sub.description) like '%SWASTA%' then INITCAP('ASLAH SWASTA')
	else INITCAP('ASLAH LAIN - LAIN')
	end as product_type,
	prof.mtd_payment_received as paytotal
	from
	ptr24month_profile prof
	inner join kshostref_product_type pt on pt.id = prof.product_type_id
	left join ksref_product_type_sub_category sub on sub.id = pt.product_type_sub_category_id 
	where 
	pt.product_type_category_id = 1
	and prof.profile_date between date_trunc('month',current_date) + interval '- 12 month' and date_trunc('month',current_date) + interval ' 1 month - 1 day'
	order by order_prod
)
select 
result.order_prod,
result.month,
result.product_type as product_sub_category,
'Personal Financing' as product_category,
sum(result.paytotal) as paytotal,
sum(result.payTotal) filter (where date_trunc('year',result.month) >= date_trunc('year',current_date)) as ytdtotal
from result
group by result.order_prod, result.month, result.product_type
order by result.order_prod
