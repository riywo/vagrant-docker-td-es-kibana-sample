#!/bin/bash

cat << EOF > /etc/td-agent/td-agent.conf
<source>
  type forward
</source>

<match **>
  type elasticsearch
  logstash_format true
  index_name fluentd
  type_name fluentd
  flush_interval 3 # For testing
  host $ES_PORT_9200_TCP_ADDR
  port $ES_PORT_9200_TCP_PORT
</match>
EOF

/etc/init.d/td-agent start
tail -n 10000 -f /var/log/td-agent/td-agent.log
