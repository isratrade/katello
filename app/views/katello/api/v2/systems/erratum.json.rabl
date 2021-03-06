attributes :title, :version, :description, :status, :id, :errata_id
attributes :reboot_suggested, :updated, :issued, :release, :solution

node :packages do |e|
  e.packages.pluck(:nvrea).sort
end

attributes :errata_type => :type

node :available do |e|
  @available_errata_ids.include?(e.id) if @available_errata_ids
end
