\pset pager off

SELECT (clock_timestamp() - pg_stat_activity.xact_start) AS ts_age, pg_stat_activity.state, (clock_timestamp() - pg_stat_activity.query_start) as query_age, (clock_timestamp() - state_change) as change_age, pg_stat_activity.datname, pg_stat_activity.pid, pg_stat_activity.usename, coalesce(wait_event_type = 'Lock', 'f') waiting, pg_stat_activity.client_addr, pg_stat_activity.client_port, pg_stat_activity.query
FROM pg_stat_activity
WHERE
((clock_timestamp() - pg_stat_activity.xact_start > '00:00:00.1'::interval) OR (clock_timestamp() - pg_stat_activity.query_start > '00:00:00.1'::interval and state IN  ('idle in transaction (aborted)', 'idle in transaction' ) ))
and pg_stat_activity.pid<>pg_backend_pid()
ORDER BY coalesce(pg_stat_activity.xact_start, pg_stat_activity.query_start);

-- ------------------------------------------

-- state wise details
select state, client_addr, application_name, count(*) from pg_stat_activity group by state, client_addr, application_name order by 2, 1;

-- ------------------------------------------

-- -- get cmd to cancel SQL / terminate process - for long running / hanging session
-- WHERE clause is same as above
\echo 
\echo -- get cmd to cancel SQL / terminate process - for long running / hanging session
SELECT row_number() over() RN, q.*
FROM (
    SELECT 
        'SELECT pg_cancel_backend(' ||  pid || ');' cancel_SQL_cmd,
        'SELECT pg_terminate_backend(' ||  pid || ');' terminate_SQL_cmd,
        substr(query, 1, 50) query,
        (clock_timestamp() - pg_stat_activity.query_start) as query_age,
        datname,
        application_name,
        client_addr
    FROM pg_stat_activity
    WHERE
((clock_timestamp() - pg_stat_activity.xact_start > '00:00:00.1'::interval) OR (clock_timestamp() - pg_stat_activity.query_start > '00:00:00.1'::interval and state IN  ('idle in transaction (aborted)', 'idle in transaction' ) ))
    and pg_stat_activity.pid<>pg_backend_pid()
    ORDER BY coalesce(pg_stat_activity.xact_start, pg_stat_activity.query_start)
    ) q;

-- ------------------------------------------

SELECT clock_timestamp();

\pset pager on
