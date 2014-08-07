module Katello
  class OperatingsystemsControllerTest < ::OperatingsystemsControllerTest

    test 'available_kickstart_repo' do
      kickstart_url_hash = {:name => 'content source name',
                            :path => 'http://content_source.path'
                           }
      ::Redhat.any_instance.stubs(:kickstart_repo).returns(kickstart_url_hash)
      operatingsystem_id = operatingsystems(:redhat).id
      architecture_id = architectures(:x86_64).id
      environment_id = ::Environment.first.id
      content_source_id = SmartProxy.first.id
      query_params = {
        :operatingsystem_id => operatingsystem_id,
        :architecture_id    => architecture_id,
        :environment_id     => environment_id,
        :content_source_id  => content_source_id
      }
      get :available_kickstart_repo, query_params, set_session_user
      assert_response :success
    end

  end
end
