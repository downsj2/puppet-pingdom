Puppet::Type.type(:pingdom_contact).provide(:contact, :parent => :contact_base) do
    accessorize
end