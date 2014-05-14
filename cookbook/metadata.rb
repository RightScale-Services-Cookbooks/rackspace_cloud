name             'rackspace_cloud'
maintainer       'RightScale'
maintainer_email 'support@rightscale.com'
license          'All rights reserved'
description      'Rackspace cloud utilities'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

recipe "rackspace_cloud::wait_for_rackconnect",
  "Wait for the RackConnect automation to avoid yum install conflict"
