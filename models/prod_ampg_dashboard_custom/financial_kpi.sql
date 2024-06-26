with
    raw_data as (
        select
            'Product' as record_type,
            a.product_type as record,
            a.metric,
            a.year,
            a.month,
            a.month_date as record_date,
            a.value as record_value,
            lag(a.value) over (
                partition by a.product_type, a.metric order by a.month_date
            ) as previous_record_value
        from {{ ref("financial_by_product_kpi") }} a
        union all
        select
            'Customer' as record_type,
            a.customer as record,
            a.metric,
            a.year,
            a.month,
            a.month_date as record_date,
            a.value as record_value,
            lag(a.value) over (
                partition by a.customer, a.metric order by a.month_date
            ) as previous_record_value
        from {{ ref("financial_by_customer_kpi") }} a
    )
select
    a.*,
    a.record_value - a.previous_record_value as difference_from_previous,
    case
        when a.previous_record_value is null or a.previous_record_value = 0
        then null
        else (a.record_value - a.previous_record_value) / a.previous_record_value
    end as mom_growth
from raw_data a
