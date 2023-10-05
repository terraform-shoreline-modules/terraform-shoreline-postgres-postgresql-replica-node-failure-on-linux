
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# PostgreSQL Replica Node Failure on Linux.
---

This incident type refers to the failure of a replica node in a PostgreSQL database system that is running on a Linux-based operating system. A replica node is a copy of the primary database node that is used to provide high availability and fault tolerance. When a replica node fails, it can result in data loss, decreased system performance, and potential downtime for users. This type of incident requires immediate attention from a software engineer to diagnose and resolve the issue as quickly as possible.

### Parameters
```shell
export PATH_TO_PSQL_BINARY="PLACEHOLDER"

export REPLICA_NODE_IP_ADDRESS="PLACEHOLDER"

export PRIMARY_NODE_IP_ADDRESS="PLACEHOLDER"

export PATH_TO_POSTGRESQL_LOG_FILE="PLACEHOLDER"
```

## Debug

### Check if the replica node is up and running
```shell
systemctl status postgresql
```

### Check the logs for any errors or warnings related to the replica node
```shell
journalctl -u postgresql
```

### Check the replication status of the replica node
```shell
${PATH_TO_PSQL_BINARY} -c "SELECT * FROM pg_stat_replication;"
```

### Check the disk space and usage on the replica node
```shell
df -h
```

### Check if the replica node is in sync with the primary node
```shell
${PATH_TO_PSQL_BINARY} -c "SELECT pg_last_xlog_receive_location();"

${PATH_TO_PSQL_BINARY} -c "SELECT pg_last_xlog_replay_location();"
```

## Repair

### Check the network connectivity between the primary and replica nodes. Ensure that there are no network issues such as high packet loss or latency.
```shell
bash

#!/bin/bash



# Get the IP addresses of the primary and replica nodes

PRIMARY_NODE_IP=${PRIMARY_NODE_IP_ADDRESS}

REPLICA_NODE_IP=${REPLICA_NODE_IP_ADDRESS}



# Ping the primary node to check network connectivity

echo "Pinging primary node..."

ping -c 3 $PRIMARY_NODE_IP



# Ping the replica node to check network connectivity

echo "Pinging replica node..."

ping -c 3 $REPLICA_NODE_IP



# Check for any packet loss or latency issues

echo "Checking for packet loss or latency issues..."

ping -c 10 $PRIMARY_NODE_IP | grep "packet loss\|rtt"

ping -c 10 $REPLICA_NODE_IP | grep "packet loss\|rtt"



echo "Network connectivity check complete."


```

### Restart the replica node and monitor the logs for any error messages.
```shell


#!/bin/bash



# Stop PostgreSQL service on replica node

sudo systemctl stop postgresql.service



# Start PostgreSQL service on replica node

sudo systemctl start postgresql.service



# Check logs for any error messages

sudo tail -f ${PATH_TO_POSTGRESQL_LOG_FILE}


```