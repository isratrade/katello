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
  module Authorization::Distributor
    extend ActiveSupport::Concern

    def readable?
      environment.distributors_readable?
    end

    def editable?
      environment.distributors_editable?
    end

    def deletable?
      environment.distributors_deletable?
    end

    module ClassMethods

      def readable(org)
        fail "scope requires an organization" if org.nil?
        if org.distributors_readable?
          where(:environment_id => org.kt_environment_ids) #list all distributors in an org
        else #just list for environments the user can access
          where("distributors.environment_id in (#{KTEnvironment.distributors_readable(org).select(:id).to_sql})")
        end
      end

      def any_readable?(org)
        org.distributors_readable? ||
            KTEnvironment.distributors_readable(org).count > 0
      end

      # TODO: these two functions are somewhat poorly written and need to be redone
      def any_deletable?(env, org)
        if env
          env.distributors_deletable?
        else
          org.distributors_deletable?
        end
      end

      def registerable?(env, org)
        (env || org).distributors_registerable?
      end
    end

  end
end
