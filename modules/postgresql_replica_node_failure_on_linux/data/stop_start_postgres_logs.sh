

#!/bin/bash



# Stop PostgreSQL service on replica node

sudo systemctl stop postgresql.service



# Start PostgreSQL service on replica node

sudo systemctl start postgresql.service



# Check logs for any error messages

sudo tail -f ${PATH_TO_POSTGRESQL_LOG_FILE}