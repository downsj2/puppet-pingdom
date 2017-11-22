require File.expand_path(File.join(File.dirname(__FILE__), 'check.rb'))

Puppet::Type.type(:pingdom_check).provide(:ping, :parent => :check) do
    accessorize
end