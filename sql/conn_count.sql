-- Purpose : to get connection # for max, normal, superuser, used
-- source : https://stackoverflow.com/questions/48619772/how-to-get-client-machine-name-ip-address-connecting-to-postgresql-server

select max_conn, used, (used * 100) / max_conn pct_used, res_for_super, (max_conn - used - res_for_super) res_for_normal 
from (
  select count(*) used from pg_stat_activity
) t1,
(select setting::int res_for_super 
 from pg_settings 
 where name=$$superuser_reserved_connections$$
) t2,
(select setting::int max_conn 
 from pg_settings 
 where name=$$max_connections$$) t3;
