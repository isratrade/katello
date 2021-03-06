object @taxonomy

extends "api/v2/taxonomies/show"

attributes :task_id, :label, :description, :service_levels,
  :service_level, :system_info_keys, :distributor_info_keys, :default_info,
  :owner_details, :redhat_repository_url, :redhat_docker_registry_url

node :default_content_view_id do |org|
  org.default_content_view.id
end

node :library_id do |org|
  org.library.id
end
