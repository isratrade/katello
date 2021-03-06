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

require "katello_test_helper"

module Katello
  class Api::V2::DockerTagsControllerTest < ActionController::TestCase

    def before_suite
      models = ["Organization", "KTEnvironment", "DockerTag", "Repository", "Product", "Provider"]
      services = ["Candlepin", "Pulp", "ElasticSearch"]
      disable_glue_layers(services, models)
      super
    end

    def models
      @repo = Repository.find(katello_repositories(:docker))
      @image = @repo.docker_images.create!({:image_id => "abc123", :katello_uuid => "123"},
                                           :without_protection => true
                                          )
      @tag = @repo.docker_tags.create!(:tag => "wat", :image => @image)
    end

    def setup
      setup_controller_defaults_api
      @request.env['HTTP_ACCEPT'] = 'application/json'
      @request.env['CONTENT_TYPE'] = 'application/json'
      @fake_search_service = @controller.load_search_service(Support::SearchService::FakeSearchService.new)
      models
    end

    def test_index
      get :index, :repository_id => @repo.id
      assert_response :success
      assert_template %w(katello/api/v2/docker_tags/index)

      get :index
      assert_response :success
      assert_template %w(katello/api/v2/docker_tags/index)

      get :index, :organization_id => @repo.organization.id
      assert_response :success
      assert_template %w(katello/api/v2/docker_tags/index)
    end

    def test_show
      get :show, :repository_id => @repo.id, :id => @tag.id

      assert_response :success
      assert_template %w(katello/api/v2/errata/show)
    end
  end
end
