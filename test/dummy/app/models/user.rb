class User < ActiveRecord::Base

  include Foreman::ThreadSession::UserModel

  def self.admin
    unscoped.find_by_login 'admin'
  end

end
