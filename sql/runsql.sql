-- template to run SQL, set param for session, env. etc
-- ------------------------------------------


\timing on
\set ECHO all

-- ------------------------------------------
-- capture o/p
\o run_sp.log

\conninfo

-- set parameters for execution, psql etc.
-- 	set enable_nestloop = off;
-- 	set random_page_cost = 100;
-- 	set statement_timeout=60000;

-- 	\pset pager off

-- to disable autocommit
-- \set AUTOCOMMIT off

-- to check current status of autocommit
-- \echo :AUTOCOMMIT

-- get current pid, etc
SELECT pg_backend_pid() pid, current_database,  inet_client_addr,  inet_client_port;

-- ------------------------------------------

\qecho 'Testing : <SQL cmd>'
\qecho

BEGIN;

-- SELECT clock_timestamp() t1;
call schema.spname('arg1','arg2','cur1');
-- OR invoke sql file
-- \i qry.sql

-- SELECT clock_timestamp() t2;
FETCH ALL IN cur1;
-- FETCH 5 in IN cur1;

COMMIT;
-- SELECT clock_timestamp() t3;

\o
