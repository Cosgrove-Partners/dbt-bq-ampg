select
    account_group,
    account,
    suffix,
    description,
    date_trunc(parse_date('%m/%d/%Y', report_date), month) as report_date,
    cast(replace(replace(value, '$', ''), ',', '') as float64) as value,
    timestamp,
    realm_id
from {{ source("google_sheets", "profit_loss_ampg") }}
