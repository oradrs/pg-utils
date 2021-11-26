-- generates stmt for kill db connections like in 'idle in transaction', from pgAdmin etc.

SELECT CASE
         WHEN state = 'idle in transaction' THEN '* '
       END || ROW_NUMBER() OVER (ORDER BY state,client_addr,application_name) RN
       , 'SELECT pg_cancel_backend(' || pid || ');' cancel_SQL_cmd
       , 'SELECT pg_terminate_backend(' || pid || ');' terminate_SQL_cmd
       , backend_type
       , pid
       , state
       , client_addr
       , application_name
       , datname
FROM pg_stat_activity
WHERE pid <> pg_backend_pid()
AND datname IS NOT NULL
ORDER BY state
         , client_addr
         , application_name;
