

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