Puppet::Type.type(:pingdom_contact).provide(:contact, :parent => :contact_base) do
    update_resource_methods
end