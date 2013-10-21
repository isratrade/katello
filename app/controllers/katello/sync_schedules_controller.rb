#
# Copyright 2013 Red Hat, Inc.
#
# This software is licensed to you under the GNU General Public
# License as published by the Free Software Foundation; either version
# 2 of the License (GPLv2) or (at your option) any later version.
# There is NO WARRANTY for this software, express or implied,
# including the implied warranties of MERCHANTABILITY,
# NON-INFRINGEMENT, or FITNESS FOR A PARTICULAR PURPOSE. You should
# have received a copy of GPLv2 along with this software; if not, see
# http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.

module Katello
class SyncSchedulesController < Katello::ApplicationController

  before_filter :find_products, :only => [:apply]
  before_filter :authorize

  def section_id
    'contents'
  end

  def rules
    {
      :index => lambda{current_organization && Provider.any_readable?(current_organization)},
      :apply => lambda{current_organization && current_organization.syncable?}
    }
  end

  def index

    @organization = current_organization
    rproducts = @organization.library.products.readable(@organization).reject { |p| p.repos(@organization.library).empty? }
    @products = rproducts.sort { |p1, p2| p1.name <=> p2.name }

    @plans = SyncPlan.where(:organization_id => current_organization.id)

    @products_options = { :title => _('Select Products to schedule'),
                          :col => %w(name plan_name),
                          :col_titles => [_('Name'), _('Plan Name')],
                          :create => _('Plan'),
                          :create_label => _('+ New Plan'),
                          :name => _('product'),
                          :enable_create => false}

    @plans_options = { :title => _('Select Plans to apply to selected Products'),
                       :col => %w(name interval),
                       :col_titles => [_('Name'), _('Interval')],
                       :create => _('Plan'),
                       :create_label => _('+ New Plan'),
                       :name => _('plan'),
                       :hover_text_cb => :hover_format,
                       :enable_create => false,
                       :single_select => true}
  end

  def apply
    data = JSON.parse(params[:data]).with_indifferent_access
    if data[:plans].present?
      # TODO: it receives only one plan, but it collects many. Only the last one is assigned, see [1]
      selected_plans    = data[:plans].collect { |i| i.to_i }
      selected_products = data[:products].collect { |i| i.to_i }
      plans             = SyncPlan.where(:id => selected_plans)
      products          = Product.where(:id => selected_products)
      products.each do |prod|
        if plans.empty?
          prod.sync_plan = nil
        else
          plans.each do |plan|
            prod.sync_plan = plan # TODO: [1]
          end
        end
        prod.save!
      end
      notify.success _("Sync Plans applied successfully.")
    else
      notify.error _("There must be at least one plan selected")
    end
    redirect_to(:controller => :sync_schedules, :action => :index)
  end

  private

  def find_products
    data = JSON.parse(params[:data]).with_indifferent_access
    @products = Product.find(data[:products])
  rescue ActiveRecord::RecordNotFound
    execute_after_filters
    notify.error _("There must be at least one product selected")
    redirect_to(:controller => :sync_schedules, :action => :index)
  end

end
end
