#
# Cookbook Name:: rackspace_cloud
# Recipe:: default
#
# Copyright 2014, RightScale
#
# All rights reserved - Do Not Redistribute
#

log "wait_for_rackspace logs are found in /var/log/wait_for_rackspace.log"

# Need to run this in the compile phase, hence the system call
%x[
  if [ -e /etc/rackspace/pre.chef.d/disable_rba.sh ]; then
    mv /etc/rackspace/pre.chef.d/disable_rba.sh /tmp
  fi
  log_file="/var/log/wait_for_rackspace.log"
  if [ -d "/etc/rackspace" ]; then
    touch /root/.noupdate
    touch /etc/rackspace/.bootstrapped
    touch /etc/rackspace/.noupdates

    echo "*** /root/rackconnectuserconfig.log contains:"
    cat /root/rackconnectuserconfig.log
  fi >> $log_file 2>&1

  # check if the server is set to be rackconnected
  if expr "$(xenstore-read vm-data/provider_data/roles)" : ".*rack_connect.*" 2>&1 >/dev/null; then
    # wait until the rackspace post install boot sequence has completed
    checkstatus(){ xenstore-read vm-data/user-metadata/rackconnect_automation_status;}
    STATUS=$(checkstatus)
    echo "*** current rackconnect status: $STATUS"
    while  [ "$STATUS" != '"DEPLOYED"' ] || [ "$STATUS" != '"UNPROCESSABLE"' ]; do
      echo '*** waiting for rackconnect post boot scripts to complete'
      echo "*** current status: $STATUS"
      sleep 10
      STATUS=$(checkstatus)
    done
    echo '*** waiting for rackconnect post boot scripts to complete'
    echo "*** current status: $STATUS"
  fi >> $log_file 2>&1

  # check if the server is managed operations
  if expr "$(xenstore-read vm-data/provider_data/roles)" : ".*rax_managed.*" 2>&1 >/dev/null; then
    # check for rax_service_level_automation
    checkstatus(){ xenstore-read vm-data/user-metadata/rax_service_level_automation;}
    STATUS=$(checkstatus)
    echo "*** current managed status: $STATUS"
    while [ "$STATUS" != '"Complete"' ] && [ "$STATUS" != '"Build Error"' ]; do
      echo '*** waiting for rackspace post install to complete'
      echo "*** current status: $STATUS"
      sleep 10
      STATUS=$(checkstatus)
    done
    echo '*** waiting for rackspace post install to complete'
    echo "*** current status: $STATUS"
  fi >> $log_file 2>&1
]
