Puppet::Type.type(:pingdom_team).provide(:team, :parent => :team_base) do
    accessorize
end