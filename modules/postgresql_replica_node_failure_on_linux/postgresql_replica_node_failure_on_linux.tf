resource "shoreline_notebook" "postgresql_replica_node_failure_on_linux" {
  name       = "postgresql_replica_node_failure_on_linux"
  data       = file("${path.module}/data/postgresql_replica_node_failure_on_linux.json")
  depends_on = [shoreline_action.invoke_pg_last_xlog_location,shoreline_action.invoke_network_connectivity_check,shoreline_action.invoke_stop_start_postgres_logs]
}

resource "shoreline_file" "pg_last_xlog_location" {
  name             = "pg_last_xlog_location"
  input_file       = "${path.module}/data/pg_last_xlog_location.sh"
  md5              = filemd5("${path.module}/data/pg_last_xlog_location.sh")
  description      = "Check if the replica node is in sync with the primary node"
  destination_path = "/agent/scripts/pg_last_xlog_location.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "network_connectivity_check" {
  name             = "network_connectivity_check"
  input_file       = "${path.module}/data/network_connectivity_check.sh"
  md5              = filemd5("${path.module}/data/network_connectivity_check.sh")
  description      = "Check the network connectivity between the primary and replica nodes. Ensure that there are no network issues such as high packet loss or latency."
  destination_path = "/agent/scripts/network_connectivity_check.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "stop_start_postgres_logs" {
  name             = "stop_start_postgres_logs"
  input_file       = "${path.module}/data/stop_start_postgres_logs.sh"
  md5              = filemd5("${path.module}/data/stop_start_postgres_logs.sh")
  description      = "Restart the replica node and monitor the logs for any error messages."
  destination_path = "/agent/scripts/stop_start_postgres_logs.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_pg_last_xlog_location" {
  name        = "invoke_pg_last_xlog_location"
  description = "Check if the replica node is in sync with the primary node"
  command     = "`chmod +x /agent/scripts/pg_last_xlog_location.sh && /agent/scripts/pg_last_xlog_location.sh`"
  params      = ["PATH_TO_PSQL_BINARY"]
  file_deps   = ["pg_last_xlog_location"]
  enabled     = true
  depends_on  = [shoreline_file.pg_last_xlog_location]
}

resource "shoreline_action" "invoke_network_connectivity_check" {
  name        = "invoke_network_connectivity_check"
  description = "Check the network connectivity between the primary and replica nodes. Ensure that there are no network issues such as high packet loss or latency."
  command     = "`chmod +x /agent/scripts/network_connectivity_check.sh && /agent/scripts/network_connectivity_check.sh`"
  params      = ["PRIMARY_NODE_IP_ADDRESS","REPLICA_NODE_IP_ADDRESS"]
  file_deps   = ["network_connectivity_check"]
  enabled     = true
  depends_on  = [shoreline_file.network_connectivity_check]
}

resource "shoreline_action" "invoke_stop_start_postgres_logs" {
  name        = "invoke_stop_start_postgres_logs"
  description = "Restart the replica node and monitor the logs for any error messages."
  command     = "`chmod +x /agent/scripts/stop_start_postgres_logs.sh && /agent/scripts/stop_start_postgres_logs.sh`"
  params      = ["PATH_TO_POSTGRESQL_LOG_FILE"]
  file_deps   = ["stop_start_postgres_logs"]
  enabled     = true
  depends_on  = [shoreline_file.stop_start_postgres_logs]
}

