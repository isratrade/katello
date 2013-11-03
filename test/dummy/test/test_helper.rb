require 'rubygems'
require 'spork'
# $LOAD_PATH required for testdrb party of spork-minitest
$LOAD_PATH << "test"

#Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.

  ENV["RAILS_ENV"] = "test"
  require File.expand_path('../../config/environment', __FILE__)
  require 'rails/test_help'
  require "minitest/autorun"
  require 'capybara/rails'
  require 'factory_girl_rails'

  # Turn of Apipie validation for tests
  Apipie.configuration.validate = false

  # To prevent Postgres' errors "permission denied: "RI_ConstraintTrigger"
  if ActiveRecord::Base.connection.adapter_name == 'PostgreSQL'
    ActiveRecord::Migration.execute "SET CONSTRAINTS ALL DEFERRED;"
  end

  class ActiveSupport::TestCase
    # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
    # Note: You'll currently still have to declare fixtures explicitly in integration tests
    # -- they do not yet inherit this setting
    fixtures :all
    set_fixture_class({ :hosts => Host::Base })
    set_fixture_class :nics => Nic::BMC

    # for backwards compatibility to between Minitest syntax
    alias_method :assert_not,       :refute
    alias_method :assert_no_match,  :refute_match
    alias_method :assert_not_nil,   :refute_nil
    alias_method :assert_not_equal, :refute_equal
    alias_method :assert_raise,     :assert_raises
    class <<self
      alias_method :test,  :it
    end

    # Add more helper methods to be used by all tests here...
    def logger
      Rails.logger
    end

    class MiniTest::Unit::TestCase
      include RR::Adapters::MiniTest
    end

    def set_session_user
      SETTINGS[:login] ? {:user => User.admin.id, :expires_at => 5.minutes.from_now} : {}
    end

    def as_user user
      saved_user   = User.current
      User.current = users(user)
      result = yield
      User.current = saved_user
      result
    end

    def as_admin &block
      as_user :admin, &block
    end

    def setup_users
      User.current = users :admin
      user = User.find_by_login("one")
      @request.session[:user] = user.id
      @request.session[:expires_at] = 5.minutes.from_now
      user.roles = [Role.find_by_name('Anonymous'), Role.find_by_name('Viewer')]
      user.save!
    end

    def setup_user operation, type=""
      @one = users(:one)
      as_admin do
        role = Role.find_or_create_by_name :name => "#{operation}_#{type}"
        role.permissions = ["#{operation}_#{type}".to_sym]
        @one.roles = [role]
        @one.save!
      end
      User.current = @one
    end

    def unattended?
      SETTINGS[:unattended].nil? or SETTINGS[:unattended]
    end

    def self.disable_orchestration
      #This disables the DNS/DHCP orchestration
      Host.any_instance.stubs(:boot_server).returns("boot_server")
      Resolv::DNS.any_instance.stubs(:getname).returns("foo.fqdn")
      Resolv::DNS.any_instance.stubs(:getaddress).returns("127.0.0.1")
      Net::DNS::ARecord.any_instance.stubs(:conflicts).returns([])
      Net::DNS::ARecord.any_instance.stubs(:conflicting?).returns(false)
      Net::DNS::PTRRecord.any_instance.stubs(:conflicting?).returns(false)
      Net::DNS::PTRRecord.any_instance.stubs(:conflicts).returns([])
      Net::DHCP::Record.any_instance.stubs(:create).returns(true)
      Net::DHCP::SparcRecord.any_instance.stubs(:create).returns(true)
      Net::DHCP::Record.any_instance.stubs(:conflicting?).returns(false)
      ProxyAPI::Puppet.any_instance.stubs(:environments).returns(["production"])
      ProxyAPI::DHCP.any_instance.stubs(:unused_ip).returns('127.0.0.1')
    end

    def disable_orchestration
      ActiveSupport::TestCase.disable_orchestration
    end
  end

  class ActionView::TestCase
    helper Rails.application.routes.url_helpers
  end

#end

#Spork.each_run do
  # This code will be run each time you run your specs.
  class ActionController::TestCase
    setup :setup_set_script_name, :set_api_user, :reset_setting_cache

    def reset_setting_cache
      Setting.cache.clear
    end

    def setup_set_script_name
      @request.env["SCRIPT_NAME"] = @controller.config.relative_url_root
    end

    def set_api_user
      return unless self.class.to_s[/api/i]
      @request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(users(:apiadmin).login, "secret")
    end
  end

#end