resource "shoreline_notebook" "frequent_redis_sentinel_elections_incident" {
  name       = "frequent_redis_sentinel_elections_incident"
  data       = file("${path.module}/data/frequent_redis_sentinel_elections_incident.json")
  depends_on = [shoreline_action.invoke_update_redis_conf]
}

resource "shoreline_file" "update_redis_conf" {
  name             = "update_redis_conf"
  input_file       = "${path.module}/data/update_redis_conf.sh"
  md5              = filemd5("${path.module}/data/update_redis_conf.sh")
  description      = "Adjust the quorum size or failover timeout settings to better suit the network conditions and workload demands."
  destination_path = "/tmp/update_redis_conf.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_update_redis_conf" {
  name        = "invoke_update_redis_conf"
  description = "Adjust the quorum size or failover timeout settings to better suit the network conditions and workload demands."
  command     = "`chmod +x /tmp/update_redis_conf.sh && /tmp/update_redis_conf.sh`"
  params      = ["NEW_QUORUM_SIZE","NEW_FAILOVER_TIMEOUT","PATH_TO_REDIS_CONF_FILE"]
  file_deps   = ["update_redis_conf"]
  enabled     = true
  depends_on  = [shoreline_file.update_redis_conf]
}

