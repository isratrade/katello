# encoding: UTF-8
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

module Katello
  class OperatingsystemExtensionsTest < ActiveSupport::TestCase

    def self.before_suite
      models = ["User"]
      disable_glue_layers(["Candlepin", "Pulp", "ElasticSearch"], models, true)
    end

    def setup
      User.current = User.find(users(:admin))
      @my_distro = OpenStruct.new(:name => 'RedHat', :family => 'Red Hat Enterprise Linux', :version => '9.0')

      @config_template = ConfigTemplate.find(config_templates(:pxe_default))
      @config_template.name = 'Katello Kickstart Default for RHEL'
      @config_template.save

      @ptable = Ptable.find(ptables(:one))
      @ptable.name = 'RedHat default'
      @ptable.save
    end

    def test_find_or_create_operating_system
      assert_nil Operatingsystem.where(:name => @my_distro.name).first
      refute_nil Operatingsystem.find_or_create_operating_system(@my_distro)
    end

    def test_create_operating_system
      assert_nil Operatingsystem.where(:name => @my_distro.name).first

      os = Operatingsystem.create_operating_system(@my_distro.name, '9', '0')

      refute_nil os
      assert_equal os.name, @my_distro.name
      assert_equal os.major, '9'
      assert_equal os.minor, '0'
      assert os.ptables.include?(@ptable)
      assert @config_template.operatingsystems.include?(Operatingsystem.find(os.id))
    end

    def test_construct_name
      assert_equal Operatingsystem.construct_name('Red Hat Enterprise Linux'), 'RedHat'
      assert_equal Operatingsystem.construct_name('My Custom Linux'), 'My_Custom_Linux'
    end
  end
end
