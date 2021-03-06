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
  module Authorization::ActivationKey
    extend ActiveSupport::Concern

    include Authorizable
    include Katello::Authorization

    def readable?
      authorized?(:view_activation_keys)
    end

    def editable?
      authorized?(:edit_activation_keys)
    end

    def deletable?
      authorized?(:destroy_activation_keys)
    end

    module ClassMethods
      def readable
        authorized(:view_activation_keys)
      end

      def editable
        authorized(:edit_activation_keys)
      end

      def any_editable?
        editable.count > 0
      end

      def all_editable?(content_view, environments)
        key_query = ActivationKey.where(:content_view_id => content_view, :environment_id => environments)
        key_query.count == key_query.editable.count
      end
    end

  end
end
