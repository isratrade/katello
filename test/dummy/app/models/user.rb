class User < ActiveRecord::Base

  def self.current
    Thread.current[:user]
  end

  def self.current=(o)
    unless (o.nil? || o.is_a?(self) || o.class.name == 'RSpec::Mocks::Mock')
      raise(ArgumentError, "Unable to set current User, expected class '#{self}', got #{o.inspect}")
    end
    if o.is_a?(::User)
      debug = ["Setting current user thread-local variable to", o.firstname, o.lastname]
      Rails.logger.debug debug.join(" ")
    end
    Thread.current[:user] = o
  end

  def self.admin
    unscoped.find_by_login 'admin'
  end

end
