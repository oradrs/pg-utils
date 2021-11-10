-- get current pid, etc
SELECT pg_backend_pid() pid, current_database,  inet_client_addr my_ip,  inet_client_port my_port;
