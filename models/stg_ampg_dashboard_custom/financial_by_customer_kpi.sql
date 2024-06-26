with
    raw_data as (
        select *
        from
            {{ source("google_sheets", "financial_by_customer_ampg") }} unpivot (
                value for month in (
                    january,
                    february,
                    march,
                    april,
                    may,
                    june,
                    july,
                    august,
                    september,
                    october,
                    november,
                    december
                )
            )
    )
select
    trim(customer) as customer,
    trim(metric) as metric,
    year,
    month,
    parse_date(
        '%Y %b %e', cast(year as string) || ' ' || left(month, 3) || ' 01'
    ) as month_date,
    value
from raw_data
