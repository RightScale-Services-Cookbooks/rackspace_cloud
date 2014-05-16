	
#
# Cookbook Name:: rackspace_cloud
# Recipe:: default
#
# Copyright 2014, RightScale
#
# All rights reserved - Do Not Redistribute
#

rightscale_marker :begin

log "wait_for_rackconnect logs are found in /var/log/wait_for_rackconnect.log"

system('
  log_file="/var/log/wait_for_rackconnect.log"
  if [ -d "/etc/rackspace" ]; then
    touch /root/.noupdate
    touch /etc/rackspace/.bootstrapped
    touch /etc/rackspace/.noupdates

    #wait until the rackspace post install boot sequence has completed
    STATUS=`curl https://ord.api.rackconnect.rackspace.com/v1/automation_status?format=text`
    while  [ "$STATUS" != "DEPLOYED" ]; do
      echo " waiting for rackspace post install to complete"
      echo "current status: $STATUS"
      STATUS=`curl https://ord.api.rackconnect.rackspace.com/v1/automation_status?format=text`
      sleep 5
    done
  fi > $log_file 2>&1
')

rightscale_marker :end
