require File.expand_path(File.join(File.dirname(__FILE__), 'check_base.rb'))

Puppet::Type.type(:pingdom_check).provide(:ping, :parent => :check_base) do
    accessorize
end