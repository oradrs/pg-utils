
-- which tables don't have stats
select schemaname, relname, last_analyze from pg_stat_all_tables where last_analyze is null order by schemaname, relname;

-- run vacuum for whole DB
\echo
\echo *** Run cmd : VACUUM (verbose, analyze, parallel 4 );
\echo