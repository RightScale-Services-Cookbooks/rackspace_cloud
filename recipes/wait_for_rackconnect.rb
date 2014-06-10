	
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

# Need to run this in the compile phase, hence the system call
%x[
  log_file="/var/log/wait_for_rackconnect.log"
  if [ -d "/etc/rackspace" ]; then
    touch /root/.noupdate
    touch /etc/rackspace/.bootstrapped
    touch /etc/rackspace/.noupdates
    
    echo "*** /root/rackconnectuserconfig.log contains:"
    cat /root/rackconnectuserconfig.log

    echo -e "\n\n*** yum processes start:\n"
    ps aux | grep yum | grep -v "grep yum"
    
    rackspace_region="#{node[:rackspace_cloud][:region]}"
    rackspace_region=`sed -r 's/(\\w+).*/\\1/'<<<$rackspace_region | tr '[:upper:]' '[:lower:]'`
    echo "*** rackspace_region=$rackspace_region"

    if [ -z "$rackspace_region" ] ; then 
      echo "*** ERROR: Invalid RackSpace region"
      exit -1
    fi

    region_url="https://$rackspace_region.api.rackconnect.rackspace.com/v1/automation_status?format=text"
    
    #wait until the rackspace post install boot sequence has completed
    STATUS=`curl $region_url`
    echo "*** current status: $STATUS"
    while  [ "$STATUS" != "DEPLOYED" ]; do
      echo '*** waiting for rackspace post install to complete'
      echo "*** current status: $STATUS"
      STATUS=`curl https://ord.api.rackconnect.rackspace.com/v1/automation_status?format=text`
    done
    echo "*** yum processes end:"
    ps aux | grep yum | grep -v "grep yum"
  fi > $log_file 2>&1
]

rightscale_marker :end
