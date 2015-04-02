name             'rackspace_cloud'
maintainer       'RightScale'
maintainer_email 'support@rightscale.com'
license          'All rights reserved'
description      'Rackspace cloud utilities'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.2'

depends "fog"
depends "marker"

recipe "rackspace_cloud::default"
recipe "rackspace_cloud::wait_for_rackconnect",
  "Wait for the RackConnect automation to avoid a yum install conflict"
  
attribute "rackspace_cloud/region",
  :display_name => "Rackspace Cloud Region",
  :description =>
    "Specify the cloud region or data center being used for this service." +
    " Example: ORD (Chicago)",
  :required => "optional",
  :default => "ORD (Chicago)",
  :choice => ["ORD (Chicago)", "DFW (Dallas/Ft. Worth)", "IAD (Northern Virginia)", "LON (London)", "SYD (Sydney)", "HKG (Hong Kong)"],
  :recipes => [ "rackspace_cloud::wait_for_rackconnect" ]
  
