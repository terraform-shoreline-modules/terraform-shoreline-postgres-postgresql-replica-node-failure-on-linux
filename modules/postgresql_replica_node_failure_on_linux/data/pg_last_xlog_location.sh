${PATH_TO_PSQL_BINARY} -c "SELECT pg_last_xlog_receive_location();"

${PATH_TO_PSQL_BINARY} -c "SELECT pg_last_xlog_replay_location();"