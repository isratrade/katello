# rubocop:disable AccessModifierIndentation
#
# Copyright 2014 Red Hat, Inc.
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
  module Concerns
    module RedhatExtensions
      extend ActiveSupport::Concern

      included do
        alias_method_chain :medium_uri, :content_uri
      end

      def medium_uri_with_content_uri host, url = nil
        if url.nil? && (full_path = kickstart_repo(host).try(:full_path))
          URI.parse(full_path)
        else
          medium_uri_without_content_uri(host, url)
        end
      end

      module ClassMethods
        def find_or_create_operating_system(distribution)
          major, minor = distribution.version.split('.')

          os = Operatingsystem.where(:name => 'RedHat', :major => major, :minor => minor).first
          os = create_operating_system('RedHat', major, minor) unless os

          return os
        end

        def create_operating_system(name, major, minor)
          params = {
              'name' => name,
              'major' => major.to_s,
              'minor' => minor.to_s,
              'family' => 'Redhat'
          }

          provisioning_template_name = if name == 'RedHat'
                                         'Katello Kickstart Default for RHEL'
                                       else
                                         'Katello Kickstart Default'
                                       end

          templates_to_add = [ConfigTemplate.find_by_name(provisioning_template_name),
                              ConfigTemplate.find_by_name('Kickstart default PXElinux')].compact

          params['os_default_templates_attributes'] = templates_to_add.map do |template|
            {
                "config_template_id" => template.id,
                "template_kind_id" => template.template_kind.id,
            }
          end

          if ptable = Ptable.find_by_name('RedHat default')
            params['ptable_ids'] = [ptable.id]
          end

          os = Operatingsystem.create!(params)

          templates_to_add.each do |template|
            template.operatingsystems << os
            template.save!
          end

          return os
        end
      end

      private

      def kickstart_repo host
        ### TODO ###
      end

    end
  end
end
