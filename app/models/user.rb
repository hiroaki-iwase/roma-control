class User
  include ActiveModel::Model

  def initialize(params = nil)
  end

  def self.authenticate(username, password)
    proc = Proc.new{|user_list|
      if user_info = user_list.find{|user| user[:username] == username && Digest::SHA1.hexdigest(user[:password]) == password }
        return user_info
      end
    }

    proc.call(ConfigGui::ROOT_USER)
    proc.call(ConfigGui::NORMAL_USER)

    false
  end
end
