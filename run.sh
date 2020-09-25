#!/bin/bash
echo "Initializing config"

mkdir -p /data/{hls,videos}
echo "Starting server"
/usr/local/nginx/sbin/nginx -g "daemon off;"

