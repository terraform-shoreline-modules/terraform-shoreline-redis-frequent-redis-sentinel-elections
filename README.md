
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Frequent Redis Sentinel Elections Incident
---

This incident type refers to a situation where Redis Sentinel, a high-availability solution for Redis, experiences frequent elections. Elections happen when a new Sentinel is elected as the leader, responsible for managing Redis instances. Frequent elections can be a sign of network instability or misconfiguration, which can result in downtime or reduced performance. It is important to investigate the root cause of the frequent elections and take prompt action to prevent service disruption.

### Parameters
```shell
export SENTINEL_PORT="PLACEHOLDER"

export SENTINEL_HOST="PLACEHOLDER"

export MASTER_NAME="PLACEHOLDER"

export REDIS_INSTANCE_HOST="PLACEHOLDER"

export REDIS_INSTANCE_PORT="PLACEHOLDER"

export NEW_QUORUM_SIZE="PLACEHOLDER"

export NEW_FAILOVER_TIMEOUT="PLACEHOLDER"

export PATH_TO_REDIS_CONF_FILE="PLACEHOLDER"
```

## Debug

### Check if Redis Sentinel is running
```shell
systemctl status redis-sentinel
```

### Check the current leader Sentinel
```shell
redis-cli -h ${SENTINEL_HOST} -p ${SENTINEL_PORT} SENTINEL get-master-addr-by-name ${MASTER_NAME}
```

### Check the Sentinel log for election events
```shell
journalctl -u redis-sentinel | grep "Elected leader"
```

### Check the network connectivity between Sentinels and Redis instances
```shell
ping ${REDIS_INSTANCE_HOST}
```

### Check the Redis instance log for connection errors
```shell
journalctl -u redis | grep "connection refused"
```

### Check the Redis instance configuration for Sentinel settings
```shell
redis-cli -h ${REDIS_INSTANCE_HOST} -p ${REDIS_INSTANCE_PORT} CONFIG GET sentinel
```

## Repair

### Adjust the quorum size or failover timeout settings to better suit the network conditions and workload demands.
```shell


#!/bin/bash



# Define variables

REDIS_CONF=${PATH_TO_REDIS_CONF_FILE}

QUORUM_SIZE=${NEW_QUORUM_SIZE}

FAILOVER_TIMEOUT=${NEW_FAILOVER_TIMEOUT}



# Backup the original configuration file

cp $REDIS_CONF $REDIS_CONF.bak



# Update the quorum size and failover timeout settings

sed -i "s/^quorum .*/quorum $QUORUM_SIZE/" $REDIS_CONF

sed -i "s/^failover-timeout .*/failover-timeout $FAILOVER_TIMEOUT/" $REDIS_CONF



# Restart Redis Sentinel to apply the changes

systemctl restart redis-sentinel



echo "Quorum size and failover timeout settings have been updated successfully."


```