require File.expand_path(File.join(File.dirname(__FILE__), '.', 'user_base.rb'))

Puppet::Type.type(:pingdom_user).provide(:user, :parent => :user_base) do
    accessorize
end