#
# Cookbook Name:: rackspace_cloud
# Recipe:: default
#
# Copyright 2014, RightScale
#
# All rights reserved - Do Not Redistribute
#

rightscale_marker :begin

system('
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
')

rightscale_marker :end
