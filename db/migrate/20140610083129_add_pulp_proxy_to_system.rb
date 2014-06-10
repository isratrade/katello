class AddPulpProxyToSystem < ActiveRecord::Migration
  def change
    add_column :hosts, :pulp_proxy_id, :integer
  end
end
