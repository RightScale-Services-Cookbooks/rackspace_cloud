#
# Cookbook Name:: rackspace_cloud
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

rightscale_marker :begin

touch /root/.noupdate
touch /etc/rackspace/.bootstrapped
touch /etc/rackspace/.noupdates
 
#causing yum lock issue #2
#chkconfig --del yum-cron
#rm -rf /etc/cron.daily/yum.cron
#rm -rf /var/lock/subsys/yum-cron
 
#wait until the rackspace post install boot sequence has completed
STATUS=`curl https://ord.api.rackconnect.rackspace.com/v1/automation_status?format=text`
while  [ "$STATUS" != "DEPLOYED" ]; do
   echo " waiting for rackspace post install to complete"
   echo "current status: $STATUS"
   STATUS=`curl https://ord.api.rackconnect.rackspace.com/v1/automation_status?format=text`
   sleep 5
done

rightscale_marker :end
