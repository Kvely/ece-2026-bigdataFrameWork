{{ config(severity='warn') }}

-- The first 3 digits of a ZIP code identify a region: the test fails if the ZIP code of a user
-- is outside of the ranges of their state
select
    u.user_id,
    u.state,
    u.zip_code
from {{ ref('stg_users') }} u
where u.zip_code is not null
    and not exists (
        select 1
        from {{ ref('state_zip_prefixes') }} z
        where z.state = u.state
            and cast(left(u.zip_code, 3) as integer) between z.prefix_min and z.prefix_max
    )
