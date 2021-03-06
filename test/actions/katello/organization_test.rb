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

require 'katello_test_helper'

module ::Actions::Katello::Organization

  class TestBase < ActiveSupport::TestCase
    include Dynflow::Testing
    include Support::Actions::Fixtures
    include FactoryGirl::Syntax::Methods

    let(:action) { create_action action_class }

    let(:organization) do
      build(:katello_organization, :acme_corporation, :with_library)
    end
  end

  class CreateTest < TestBase
    let(:action_class) { ::Actions::Katello::Organization::Create }

    it 'plans' do
      organization.expects(:create_library)
      organization.expects(:create_anonymous_provider)
      organization.expects(:create_redhat_provider)
      organization.expects(:save!)
      action.stubs(:action_subject).with(organization, any_parameters)
      plan_action(action, organization)
      assert_action_planed_with(action,
                                ::Actions::Candlepin::Owner::Create,
                                label:  organization.label,
                                name: organization.name)

      assert_action_planed_with(action,
                                ::Actions::Katello::Environment::LibraryCreate,
                                organization.library)
    end
  end

  class DestroyTest < TestBase
    let(:action_class) { ::Actions::Katello::Organization::Destroy }
    let(:action) { create_action action_class }

    let(:organization) { stub }

    it 'plans' do
      env = stub

      action.stubs(:action_subject).with(organization)
      default_view = stub(:content_view_environments => [])
      library = stub(:destroy! => true)

      organization.expects(:label).returns("ACME_Corporation")
      organization.expects(:validate_destroy).returns([])
      organization.expects(:products).twice.returns([])
      organization.expects(:systems).returns([])
      organization.expects(:activation_keys).returns([])
      organization.expects(:content_views).returns(stub(:non_default => []))
      organization.expects(:default_content_view).twice.returns(default_view)
      organization.expects(:promotion_paths).returns([[env]])
      organization.expects(:providers).returns([])
      organization.expects(:library).returns(library)

      plan_action(action, organization)

      assert_action_planed_with(action,
                                ::Actions::Candlepin::Owner::Destroy,
                                label: "ACME_Corporation")
      assert_action_planed_with(action, ::Actions::Katello::ContentView::Destroy, default_view, :check_ready_to_destroy => false, :organization_destroy => true)
      assert_action_planed_with(action, ::Actions::Katello::Environment::Destroy, env, :skip_repo_destroy => true, :organization_destroy => true)
    end
  end

  class AutoAttachSubscriptionsTest < TestBase
    let(:action_class) { ::Actions::Katello::Organization::AutoAttachSubscriptions }

    it 'plans' do
      action.stubs(:action_subject).with(organization)
      plan_action(action, organization)
      assert_action_planed_with(action,
                                ::Actions::Candlepin::Owner::AutoAttach,
                                label:  organization.label)
    end
  end
end
