Puppet::Type.type(:pingdom_contact).provide(:contact, :parent => :contact_base) do

    def countrycode
        number = @contact.fetch('cellphone', :absent)
        number.split('-')[0] if number.respond_to? :split
    end

    accessorize
end