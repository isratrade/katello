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
  module Validators
    class ContentViewPuppetModuleValidator < ActiveModel::Validator

      def validate(record)
        if record.name.blank? && record.author.blank? && record.uuid.blank?
          invalid_parameters = _("Invalid puppet module parameters specified.  Either 'uuid' or 'name' and 'author' must be specified.")
          record.errors[:base] << invalid_parameters
          return
        end

        if record.name && record.author
          # validate that a puppet module exists with this name+author
          unless PuppetModule.exists?(:name => record.name, :author => record.author,
                                      :repoids => record.content_view.puppet_repos.map(&:pulp_id))

            invalid_parameters = _("Puppet Module with name='%{name}' and author='%{author}' does not exist") %
                { :name => record.name, :author => record.author }

            record.errors[:base] << invalid_parameters
          end
        end
      end

    end
  end
end
