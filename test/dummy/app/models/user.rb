class User < ActiveRecord::Base

  def self.admin
    unscoped.find_by_login 'admin'
  end

end
