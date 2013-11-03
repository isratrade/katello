object @resource => :repository_set

attribute :enabled? => :enabled

glue :content do
  extends 'katello/api/v2/common/identifier'
  attributes :type, :updated, :vendor, :gpgUrl, :contentUrl
end


