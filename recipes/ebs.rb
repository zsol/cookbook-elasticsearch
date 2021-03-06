[Chef::Recipe, Chef::Resource].each { |l| l.send :include, ::Extensions }

# Install the Fog gem dependencies
#
value_for_platform(
  'default' => %w|libxslt1-dev libxml2-dev|
).each do |pkg|
  package(pkg) { action :nothing }.run_action(:upgrade)
end

# Install the Fog gem for Chef run
#
chef_gem("fog") { action :install }

# Create EBS for each device with proper configuration
#
# See the `attributes/data` file for instructions.
#
node.elasticsearch[:data][:devices].each do |device, params|
  if params[:ebs] && !params[:ebs].keys.empty?
    create_ebs device, params
  end
end
