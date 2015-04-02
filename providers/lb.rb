def get_loadbalancer_id(fog_connection,loadbalancer_name)
  return loadbalancer_id
end

def get_node_id(fog_connection, node_name)
  return node_id
end

action :connect do
  require 'fog'
  auth_info={}
  options={}
  fog_connection=Fog::RackSpace::LoadBalancers.new(auth_info)
  loadbalancer_id=get_loadbalancer_id(fog_connection, @new_resource.loadbalancer_name)
  fog_connection.create_node(loadbalancer_id, address, port, condition, options)
end

action :disconnect do
  require 'fog'
  auth_info={}
  fog_connection=Fog::RackSpace::LoadBalancers.new(auth_info)
  loadbalancer_id=get_loadbalancer_id(fog_connection, @new_resource.loadbalancer_name)
  node_id=get_node_id(fog_connection, node_name)
  fog_connection.delete_node(loadbalancer_id, node_id)
end
