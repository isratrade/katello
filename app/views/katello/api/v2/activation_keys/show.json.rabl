object @resource

attributes :id, :name, :description, :unlimited_content_hosts

extends 'katello/api/v2/common/org_reference'

attributes :content_view, :content_view_id
child :environment => :environment do
  attributes :name, :id
end
attributes :environment_id

attributes :usage_count, :user_id, :max_content_hosts, :system_template_id, :release_version,
           :service_level

child :products => :products do |_product|
  attributes :id, :name
end

node :permissions do |activation_key|
  {
    :view_activation_keys => activation_key.readable?,
    :edit_activation_keys => activation_key.editable?,
    :destroy_activation_keys => activation_key.deletable?
  }
end

child :host_collections => :host_collections do
  attributes :id
  attributes :name
end

attributes :content_overrides

extends 'katello/api/v2/common/timestamps'
